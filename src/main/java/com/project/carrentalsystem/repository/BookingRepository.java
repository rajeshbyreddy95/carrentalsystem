package com.project.carrentalsystem.repository;

import com.project.carrentalsystem.model.Booking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Long> {
    
    List<Booking> findByUserEmail(String userEmail);
    
    List<Booking> findByCarId(Long carId);
    
    List<Booking> findByStatus(String status);
    
    List<Booking> findByUserEmailAndStatus(String userEmail, String status);
    
    List<Booking> findByPaymentStatus(String paymentStatus);
}
