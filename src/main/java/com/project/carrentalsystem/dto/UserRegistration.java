package com.project.carrentalsystem.dto;


import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

@Data
public class UserRegistration {

    private String fullName;
    private String email;
    private String mobileNumber;
    private String panNumber;
    private String aadhaarNumber;

    private MultipartFile drivingLicense;   // uploaded file
    private MultipartFile aadhaarPhoto;     // uploaded file

    private String password;
    private String confirmPassword;
}
