package com.project.carrentalsystem.config;

import lombok.Getter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * Configuration class for Razorpay payment gateway
 * Reads credentials from application.properties for security
 */
@Component
@Getter
public class RazorpayConfig {
    
    @Value("${razorpay.key-id}")
    private String keyId;
    
    @Value("${razorpay.key-secret}")
    private String keySecret;
}
