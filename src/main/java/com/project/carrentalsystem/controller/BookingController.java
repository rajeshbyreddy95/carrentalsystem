package com.project.carrentalsystem.controller;

import com.project.carrentalsystem.model.Booking;
import com.project.carrentalsystem.service.BookingService;
import com.project.carrentalsystem.service.CarService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class BookingController {

    private final BookingService bookingService;
    private final CarService carService;

    // ==================== PAGE MAPPINGS ====================

    /**
     * Display car booking page with details
     */
    @GetMapping("/booking")
    public String bookingPage(@RequestParam(required = false) Long carId, Model model) {
        if (carId != null) {
            carService.getCarById(carId).ifPresent(car -> model.addAttribute("car", car));
        }
        return "booking";
    }

    // ==================== BOOKING API ENDPOINTS ====================

    /**
     * Create new booking
     */
    @PostMapping("/api/bookings/create")
    @ResponseBody
    public String createBooking(
            @RequestParam String userEmail,
            @RequestParam Long carId,
            @RequestParam String pickupDate,
            @RequestParam String dropoffDate,
            @RequestParam Integer totalDays,
            @RequestParam Double totalCost,
            @RequestParam String pickupLocation,
            @RequestParam String dropoffLocation,
            @RequestParam(required = false) String specialRequests) {
        
        Booking booking = Booking.builder()
                .userEmail(userEmail)
                .carId(carId)
                .pickupDate(pickupDate)
                .dropoffDate(dropoffDate)
                .totalDays(totalDays)
                .totalCost(totalCost)
                .pickupLocation(pickupLocation)
                .dropoffLocation(dropoffLocation)
                .specialRequests(specialRequests)
                .build();

        return bookingService.createBooking(booking);
    }

    /**
     * Get all bookings (admin)
     */
    @GetMapping("/api/admin/bookings")
    @ResponseBody
    public List<Booking> getAllBookings() {
        return bookingService.getAllBookings();
    }

    /**
     * Get bookings by user email
     */
    @GetMapping("/api/bookings/user")
    @ResponseBody
    public List<Booking> getBookingsByUser(@RequestParam String email) {
        return bookingService.getBookingsByUser(email);
    }

    /**
     * Get booking by ID
     */
    @GetMapping("/api/bookings/{id}")
    @ResponseBody
    public Object getBookingById(@PathVariable Long id) {
        return bookingService.getBookingById(id).orElse(null);
    }

    /**
     * Update booking status
     */
    @PostMapping("/api/bookings/update-status/{id}")
    @ResponseBody
    public String updateBookingStatus(
            @PathVariable Long id,
            @RequestParam String status) {
        return bookingService.updateBookingStatus(id, status);
    }

    /**
     * Cancel booking
     */
    @PostMapping("/api/bookings/cancel/{id}")
    @ResponseBody
    public String cancelBooking(@PathVariable Long id) {
        return bookingService.cancelBooking(id);
    }

    /**
     * Get all available cars
     */
    @GetMapping("/api/cars/available")
    @ResponseBody
    public Object getAvailableCars() {
        return carService.getAvailableCars();
    }

    /**
     * Get all cars (for display)
     */
    @GetMapping("/api/cars")
    @ResponseBody
    public List<Object> getAllCars() {
        return List.of(carService.getAllCars());
    }
}
