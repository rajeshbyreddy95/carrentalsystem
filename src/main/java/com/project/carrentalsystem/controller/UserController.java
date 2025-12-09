package com.project.carrentalsystem.controller;

import com.project.carrentalsystem.dto.UserRegistration;
import com.project.carrentalsystem.service.UserService;
import com.project.carrentalsystem.service.BookingService;
import com.project.carrentalsystem.service.CarService;
import com.project.carrentalsystem.config.RazorpayConfig;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.Map;
import java.util.HashMap;

@Controller
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final BookingService bookingService;
    private final CarService carService;
    private final RazorpayConfig razorpayConfig;

    // ==================== VIEW ENDPOINTS ====================
    
    /**
     * Serve home page with hero section, booking form, featured cars, etc.
     */
    @GetMapping("/")
    public String home(Model model) {
        // Fetch all cars from database and pass to home page
        model.addAttribute("cars", carService.getAllCars());
        return "home";
    }

    /**
     * Serve login page
     */
    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    /**
     * Serve registration page
     */
    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    /**
     * Serve profile page (user/admin)
     */
    @GetMapping("/profile")
    public String profilePage() {
        return "profile";
    }

    /**
     * Serve all cars page
     */
    @GetMapping("/cars")
    public String carsPage() {
        return "cars";
    }

    // ==================== API ENDPOINTS ====================

    /**
     * STEP 1: Send OTP for registration
     */
    @PostMapping("/api/user/register")
    @ResponseBody
    public String register(@ModelAttribute UserRegistration dto) {
        return userService.sendOtp(dto);
    }

    /**
     * STEP 2: Verify OTP & register user
     */
    @PostMapping("/api/user/verify-otp")
    @ResponseBody
    public String verifyOtp(
            @RequestParam String email,
            @RequestParam String otp,
            @ModelAttribute UserRegistration dto) {
        return userService.verifyOtpAndRegister(dto, otp);
    }

    /**
     * LOGIN: Authenticate user with email and password
     */
    @PostMapping("/api/user/login")
    @ResponseBody
    public String login(
            @RequestParam String email,
            @RequestParam String password) {
        return userService.login(email, password);
    }

    /**
     * GET USER DETAILS: Fetch user details by email
     */
    @GetMapping("/api/user/details")
    @ResponseBody
    public Object getUserDetails(@RequestParam String email) {
        return userService.getUserByEmail(email);
    }

    /**
     * CREATE BOOKING: Create a new booking after payment
     */
    @PostMapping("/api/user/booking/create")
    @ResponseBody
    public Map<String, Object> createBooking(@RequestBody Map<String, Object> bookingData) {
        return bookingService.createBooking(bookingData);
    }

    /**
     * GET USER BOOKINGS: Fetch all bookings for the logged-in user
     */
    @GetMapping("/api/user/bookings")
    @ResponseBody
    public Object getUserBookings(@RequestParam String email) {
        return bookingService.getUserBookings(email);
    }

    /**
     * SEARCH CARS: Search available cars based on filters
     */
    @GetMapping("/api/cars/search")
    @ResponseBody
    public Object searchCars(
            @RequestParam(required = false) String pickupLocation,
            @RequestParam(required = false) String dropoffLocation,
            @RequestParam(required = false) String pickupDate,
            @RequestParam(required = false) String returnDate,
            @RequestParam(required = false) String carType) {
        
        return carService.searchCars(pickupLocation, dropoffLocation, pickupDate, returnDate, carType);
    }

    /**
     * GET RAZORPAY KEY: Serve Razorpay public key to frontend
     * Only exposes the public key, not the secret
     */
    @GetMapping("/api/config/razorpay-key")
    @ResponseBody
    public Map<String, String> getRazorpayKey() {
        Map<String, String> response = new HashMap<>();
        response.put("keyId", razorpayConfig.getKeyId());
        return response;
    }
}
