package com.project.carrentalsystem.service;

import com.project.carrentalsystem.dto.UserRegistration;
import com.project.carrentalsystem.dto.UserResponse;
import com.project.carrentalsystem.model.OtpVerification;
import com.project.carrentalsystem.model.User;
import com.project.carrentalsystem.repository.OtpRepository;
import com.project.carrentalsystem.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.Optional;
import java.util.Random;

@Service
@RequiredArgsConstructor
@Slf4j
public class UserService {

    private final UserRepository userRepository;
    private final OtpRepository otpRepository;
    private final EmailService emailService;
    private final OciStorageService ociStorageService;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    // STEP 1: SEND OTP
    @Transactional
    public String sendOtp(UserRegistration dto) {

        // Check required fields
        if (dto.getFullName() == null || dto.getEmail() == null || dto.getPassword() == null)
            return "All fields are required";

        // Check duplicates
        if (userRepository.existsByEmail(dto.getEmail()))
            return "Email already registered";
        if (userRepository.existsByMobileNumber(dto.getMobileNumber()))
            return "Mobile number already in use";
        if (userRepository.existsByPanNumber(dto.getPanNumber()))
            return "PAN number already in use";
        if (userRepository.existsByAadhaarNumber(dto.getAadhaarNumber()))
            return "Aadhaar number already in use";

        // Check password match
        if (!dto.getPassword().equals(dto.getConfirmPassword()))
            return "Passwords do not match";

        // Generate OTP
        String otp = String.valueOf(new Random().nextInt(900000) + 100000);
        long expiry = Instant.now().toEpochMilli() + (5 * 60 * 1000); // valid 5 min

        // Save OTP - clear old OTPs first
        try {
            otpRepository.deleteByEmail(dto.getEmail());
        } catch (Exception e) {
            System.out.println("Warning: Could not delete old OTP: " + e.getMessage());
        }
        
        otpRepository.save(
                OtpVerification.builder()
                        .email(dto.getEmail())
                        .otp(otp)
                        .expiryTime(expiry)
                        .build()
        );

        // Send OTP Email
        emailService.sendOtp(dto.getEmail(), otp);

        return "OTP sent successfully";
    }

    // STEP 2: VERIFY OTP AND REGISTER USER
    @Transactional
    @CacheEvict(value = "userByEmail", allEntries = true)
    public String verifyOtpAndRegister(UserRegistration dto, String enteredOtp) {

        Optional<OtpVerification> otpData = otpRepository.findByEmail(dto.getEmail());
        if (otpData.isEmpty())
            return "OTP not found. Please request again.";

        OtpVerification savedOtp = otpData.get();

        if (!savedOtp.getOtp().equals(enteredOtp))
            return "Invalid OTP";

        if (Instant.now().toEpochMilli() > savedOtp.getExpiryTime())
            return "OTP expired";

        // Save user temporarily to get ID for file uploads
        User tempUser = User.builder()
                .fullName(dto.getFullName())
                .email(dto.getEmail())
                .mobileNumber(dto.getMobileNumber())
                .panNumber(dto.getPanNumber())
                .aadhaarNumber(dto.getAadhaarNumber())
                .password(passwordEncoder.encode(dto.getPassword()))
                .build();
        
        User savedUser = userRepository.save(tempUser);
        String licenseUrl = null;
        String aadhaarUrl = null;

        // Upload files to OCI Storage
        try {
            if (dto.getDrivingLicense() != null && !dto.getDrivingLicense().isEmpty()) {
                licenseUrl = ociStorageService.uploadFile(dto.getDrivingLicense(), "driving_license", savedUser.getId());
                System.out.println("✅ Driving License uploaded: " + licenseUrl);
            }
            
            if (dto.getAadhaarPhoto() != null && !dto.getAadhaarPhoto().isEmpty()) {
                aadhaarUrl = ociStorageService.uploadFile(dto.getAadhaarPhoto(), "aadhaar_photo", savedUser.getId());
                System.out.println("✅ Aadhaar Photo uploaded: " + aadhaarUrl);
            }
        } catch (Exception e) {
            System.out.println("⚠️ Warning: File upload failed: " + e.getMessage());
            // Continue even if file upload fails
        }

        // Update user with file URLs
        if (licenseUrl != null) {
            savedUser.setDrivingLicenseUrl(licenseUrl);
        }
        if (aadhaarUrl != null) {
            savedUser.setAadhaarPhotoUrl(aadhaarUrl);
        }
        
        userRepository.save(savedUser);
        
        try {
            otpRepository.deleteByEmail(dto.getEmail());
        } catch (Exception e) {
            System.out.println("Warning: Could not delete OTP after registration: " + e.getMessage());
        }

        return "Registration successful!";
    }

    // LOGIN
    public String login(String email, String password) {
        // Check for admin credentials
        if (email.equals("admin@driverhub.com") && password.equals("123456")) {
            return "ADMIN_LOGIN_SUCCESS";
        }

        Optional<User> user = userRepository.findByEmail(email);

        if (user.isEmpty())
            return "Invalid email";

        if (!passwordEncoder.matches(password, user.get().getPassword()))
            return "Invalid password";

        return "Login successful";
    }

    // GET USER BY EMAIL - Cached for 5 minutes
    @Cacheable(value = "userByEmail", key = "#email", unless = "#result == null")
    public UserResponse getUserByEmail(String email) {
        log.info("📡 Fetching user details for email: {} from database...", email);
        // Return admin user object for admin email
        if (email.equals("admin@driverhub.com")) {
            return UserResponse.builder()
                    .id(0L)
                    .fullName("Admin")
                    .email("admin@driverhub.com")
                    .mobileNumber("0000000000")
                    .role("ADMIN")
                    .build();
        }
        
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isEmpty()) {
            return null;
        }
        
        User user = userOpt.get();
        return UserResponse.builder()
                .id(user.getId())
                .fullName(user.getFullName())
                .email(user.getEmail())
                .mobileNumber(user.getMobileNumber())
                .panNumber(user.getPanNumber())
                .aadhaarNumber(user.getAadhaarNumber())
                .role(user.getRole())
                .drivingLicenseUrl(user.getDrivingLicenseUrl())
                .aadhaarPhotoUrl(user.getAadhaarPhotoUrl())
                .build();
    }
}