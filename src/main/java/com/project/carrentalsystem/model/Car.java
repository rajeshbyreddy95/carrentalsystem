package com.project.carrentalsystem.model;

import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;

@Entity
@Table(name = "cars")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Car implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String brand;
    
    @Column(nullable = false)
    private String model;
    
    @Column(nullable = false)
    private String category; // SUV, Sedan, Hatchback, Luxury, etc.
    
    @Column(nullable = false)
    private String transmission; // Automatic, Manual
    
    @Column(nullable = false)
    private Integer seats;
    
    @Column(nullable = false)
    private String fuelType; // Petrol, Diesel, Electric, Hybrid
    
    @Column(nullable = false)
    private Double pricePerDay;
    
    @Column(length = 1000)
    private String description;
    
    @Column(nullable = false)
    private String imageUrl; // OCI Storage URL
    
    @Column(nullable = false)
    private String registrationNumber;
    
    @Column(nullable = false)
    private Integer year;
    
    @Column(nullable = false)
    private String color;
    
    @Column(nullable = false)
    @Builder.Default
    private Boolean available = true;
    
    @Column(nullable = false)
    private String location; // City/Branch where car is available
    
    @Builder.Default
    private Double rating = 0.0;
    
    @Builder.Default
    private Integer totalBookings = 0;
    
    @Column(name = "created_at")
    private Long createdAt;
    
    @Column(name = "updated_at")
    private Long updatedAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = System.currentTimeMillis();
        updatedAt = System.currentTimeMillis();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = System.currentTimeMillis();
    }
}
