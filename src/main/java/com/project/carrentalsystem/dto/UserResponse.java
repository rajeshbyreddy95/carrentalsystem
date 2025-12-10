package com.project.carrentalsystem.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserResponse implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private Long id;
    private String fullName;
    private String email;
    private String mobileNumber;
    private String panNumber;
    private String aadhaarNumber;
    private String role;
    private String drivingLicenseUrl;
    private String aadhaarPhotoUrl;
}
