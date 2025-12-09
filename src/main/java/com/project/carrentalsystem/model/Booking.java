package com.project.carrentalsystem.model;

import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;

@Entity
@Table(name = "bookings")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Booking implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String userEmail;
    
    @Column(nullable = false)
    private Long carId;
    
    @Column(nullable = false)
    private String pickupDate;
    
    @Column(nullable = false)
    private String dropoffDate;
    
    @Column(nullable = false)
    private Integer totalDays;
    
    @Column(nullable = false)
    private Double totalCost;
    
    @Column(nullable = false)
    private String status; // PENDING, CONFIRMED, ACTIVE, COMPLETED, CANCELLED
    
    @Column(nullable = false)
    private String pickupLocation;
    
    @Column(nullable = false)
    private String dropoffLocation;
    
    private String specialRequests;
    
    @Column(nullable = false)
    private String paymentStatus; // PENDING, PAID, REFUNDED
    
    private String paymentMethod;
    
    private String transactionId;
    
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
