package com.project.carrentalsystem.model;

import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;

@Entity
@Table(name = "users")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User implements Serializable {
    
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String fullName;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false, unique = true, length = 10)
    private String panNumber;

    @Column(nullable = false, unique = true, length = 12)
    private String aadhaarNumber;

    @Column(nullable = false, unique = true, length = 10)
    private String mobileNumber;   // <-- Added mobile number

    // OCI Object Storage URLs or object names
    private String drivingLicenseUrl;

    private String aadhaarPhotoUrl;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false)
    @Builder.Default
    private String role = "USER"; // USER or ADMIN

    // Not stored in DB – only for validation during registration
    @Transient
    private String confirmPassword;
}
