package com.project.carrentalsystem.service;

import com.project.carrentalsystem.model.Booking;
import com.project.carrentalsystem.model.Car;
import com.project.carrentalsystem.repository.BookingRepository;
import com.project.carrentalsystem.repository.CarRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
@RequiredArgsConstructor
@Slf4j
public class BookingService {

    private final BookingRepository bookingRepository;
    private final CarRepository carRepository;

    // Create new booking (existing method)
    @Transactional
    @CacheEvict(value = {"allBookings", "bookingsByUser", "bookingsByCar", "userBookingsWithDetails"}, allEntries = true)
    public String createBooking(Booking booking) {
        try {
            // Check if car exists and is available
            Optional<Car> carOpt = carRepository.findById(booking.getCarId());
            if (carOpt.isEmpty()) {
                return "Car not found";
            }

            Car car = carOpt.get();
            if (!car.getAvailable()) {
                return "Car is not available";
            }

            // Set initial status
            booking.setStatus("PENDING");
            booking.setPaymentStatus("PENDING");

            // Save booking
            bookingRepository.save(booking);

            // Update car availability and booking count
            car.setAvailable(false);
            car.setTotalBookings(car.getTotalBookings() + 1);
            carRepository.save(car);

            log.info("✅ Booking created successfully for user: {}", booking.getUserEmail());
            return "Booking created successfully";

        } catch (Exception e) {
            log.error("❌ Error creating booking: {}", e.getMessage());
            return "Failed to create booking: " + e.getMessage();
        }
    }

    // Create booking from payment data (new method for API)
    @Transactional
    @CacheEvict(value = {"allBookings", "bookingsByUser", "bookingsByCar", "userBookingsWithDetails"}, allEntries = true)
    public Map<String, Object> createBooking(Map<String, Object> bookingData) {
        Map<String, Object> response = new HashMap<>();
        try {
            Long carId = ((Number) bookingData.get("carId")).longValue();
            String userId = (String) bookingData.get("userId");
            String pickupDate = (String) bookingData.get("pickupDate");
            String dropoffDate = (String) bookingData.get("dropoffDate");
            String paymentId = (String) bookingData.get("paymentId");
            String totalAmount = (String) bookingData.get("totalAmount");

            // Check if car exists and is available
            Optional<Car> carOpt = carRepository.findById(carId);
            if (carOpt.isEmpty()) {
                response.put("success", false);
                response.put("message", "Car not found");
                return response;
            }

            Car car = carOpt.get();
            if (!car.getAvailable()) {
                response.put("success", false);
                response.put("message", "Car is not available");
                return response;
            }

            // Calculate total days
            LocalDate pickup = LocalDate.parse(pickupDate);
            LocalDate dropoff = LocalDate.parse(dropoffDate);
            int totalDays = (int) java.time.temporal.ChronoUnit.DAYS.between(pickup, dropoff);
            
            if (totalDays <= 0) {
                response.put("success", false);
                response.put("message", "Invalid date range");
                return response;
            }

            // Create booking
            Booking booking = new Booking();
            booking.setCarId(carId);
            booking.setUserEmail(userId);
            booking.setPickupDate(pickupDate);
            booking.setDropoffDate(dropoffDate);
            booking.setTotalDays(totalDays);
            booking.setTotalCost(Double.parseDouble(totalAmount));
            booking.setStatus("CONFIRMED");
            booking.setPaymentStatus("PAID");
            booking.setTransactionId(paymentId);
            booking.setPickupLocation(car.getLocation());
            booking.setDropoffLocation(car.getLocation());

            // Save booking
            Booking savedBooking = bookingRepository.save(booking);

            // Update car availability and booking count
            car.setAvailable(false);
            car.setTotalBookings(car.getTotalBookings() + 1);
            carRepository.save(car);

            log.info("✅ Booking created successfully - ID: {}, Car: {}, User: {}", savedBooking.getId(), carId, userId);
            
            response.put("success", true);
            response.put("message", "Booking created successfully");
            response.put("bookingId", savedBooking.getId());
            response.put("paymentId", paymentId);
            
            return response;

        } catch (Exception e) {
            log.error("❌ Error creating booking: {}", e.getMessage());
            response.put("success", false);
            response.put("message", "Failed to create booking: " + e.getMessage());
            return response;
        }
    }

    // Get all bookings - Cached for 5 minutes
    @Cacheable(value = "allBookings", unless = "#result == null || #result.isEmpty()")
    public List<Booking> getAllBookings() {
        log.info("📡 Fetching all bookings from database...");
        return bookingRepository.findAll();
    }

    // Get bookings by user email - Cached for 5 minutes
    @Cacheable(value = "bookingsByUser", key = "#userEmail", unless = "#result == null || #result.isEmpty()")
    public List<Booking> getBookingsByUser(String userEmail) {
        log.info("📡 Fetching bookings for user: {} from database...", userEmail);
        return bookingRepository.findByUserEmail(userEmail);
    }

    // Get bookings by car ID - Cached for 5 minutes
    @Cacheable(value = "bookingsByCar", key = "#carId", unless = "#result == null || #result.isEmpty()")
    public List<Booking> getBookingsByCar(Long carId) {
        log.info("📡 Fetching bookings for car ID: {} from database...", carId);
        return bookingRepository.findByCarId(carId);
    }

    // Get user bookings with car details (for API) - Cached for 5 minutes
    @Cacheable(value = "userBookingsWithDetails", key = "#email", unless = "#result == null || #result.isEmpty()")
    public List<Map<String, Object>> getUserBookings(String email) {
        log.info("📡 Fetching bookings with details for user: {} from database...", email);
        try {
            List<Booking> bookings = bookingRepository.findByUserEmail(email);
            List<Map<String, Object>> result = new ArrayList<>();
            
            for (Booking booking : bookings) {
                Optional<Car> carOpt = carRepository.findById(booking.getCarId());
                if (carOpt.isPresent()) {
                    Car car = carOpt.get();
                    Map<String, Object> bookingData = new HashMap<>();
                    
                    bookingData.put("id", booking.getId());
                    bookingData.put("carName", car.getBrand() + " " + car.getModel());
                    bookingData.put("carCategory", car.getCategory());
                    bookingData.put("carTransmission", car.getTransmission());
                    bookingData.put("carSeats", car.getSeats());
                    bookingData.put("carImage", car.getImageUrl());
                    bookingData.put("pickupDate", booking.getPickupDate());
                    bookingData.put("dropoffDate", booking.getDropoffDate());
                    bookingData.put("totalDays", booking.getTotalDays());
                    bookingData.put("totalCost", booking.getTotalCost());
                    bookingData.put("status", booking.getStatus());
                    bookingData.put("paymentStatus", booking.getPaymentStatus());
                    bookingData.put("transactionId", booking.getTransactionId());
                    bookingData.put("pickupLocation", booking.getPickupLocation());
                    bookingData.put("dropoffLocation", booking.getDropoffLocation());
                    bookingData.put("createdAt", booking.getCreatedAt());
                    
                    result.add(bookingData);
                }
            }
            
            log.info("✅ Retrieved {} bookings for user: {}", result.size(), email);
            return result;
        } catch (Exception e) {
            log.error("❌ Error fetching user bookings: {}", e.getMessage());
            return new ArrayList<>();
        }
    }

    // Get booking by ID - Cached for 5 minutes
    @Cacheable(value = "bookingById", key = "#id", unless = "#result == null || #result.isEmpty()")
    public Optional<Booking> getBookingById(Long id) {
        log.info("📡 Fetching booking with ID: {} from database...", id);
        return bookingRepository.findById(id);
    }

    // Update booking status
    @Transactional
    @CacheEvict(value = {"allBookings", "bookingsByUser", "bookingsByCar", "bookingById", "userBookingsWithDetails"}, allEntries = true)
    public String updateBookingStatus(Long id, String status) {
        try {
            Optional<Booking> bookingOpt = bookingRepository.findById(id);
            if (bookingOpt.isEmpty()) {
                return "Booking not found";
            }

            Booking booking = bookingOpt.get();
            String oldStatus = booking.getStatus();
            booking.setStatus(status);
            bookingRepository.save(booking);

            // If booking is cancelled or completed, make car available again
            if (status.equals("CANCELLED") || status.equals("COMPLETED")) {
                Optional<Car> carOpt = carRepository.findById(booking.getCarId());
                if (carOpt.isPresent()) {
                    Car car = carOpt.get();
                    car.setAvailable(true);
                    carRepository.save(car);
                }
            }

            log.info("✅ Booking status updated from {} to {}", oldStatus, status);
            return "Booking status updated successfully";

        } catch (Exception e) {
            log.error("❌ Error updating booking status: {}", e.getMessage());
            return "Failed to update booking status: " + e.getMessage();
        }
    }

    // Update payment status
    @Transactional
    @CacheEvict(value = {"allBookings", "bookingsByUser", "bookingsByCar", "bookingById", "userBookingsWithDetails"}, allEntries = true)
    public String updatePaymentStatus(Long id, String paymentStatus, String transactionId) {
        try {
            Optional<Booking> bookingOpt = bookingRepository.findById(id);
            if (bookingOpt.isEmpty()) {
                return "Booking not found";
            }

            Booking booking = bookingOpt.get();
            booking.setPaymentStatus(paymentStatus);
            booking.setTransactionId(transactionId);
            
            // If payment is successful, confirm the booking
            if (paymentStatus.equals("PAID")) {
                booking.setStatus("CONFIRMED");
            }
            
            bookingRepository.save(booking);

            log.info("✅ Payment status updated to: {}", paymentStatus);
            return "Payment status updated successfully";

        } catch (Exception e) {
            log.error("❌ Error updating payment status: {}", e.getMessage());
            return "Failed to update payment status: " + e.getMessage();
        }
    }

    // Cancel booking
    @Transactional
    public String cancelBooking(Long id) {
        return updateBookingStatus(id, "CANCELLED");
    }

    // Delete booking
    @Transactional
    @CacheEvict(value = {"allBookings", "bookingsByUser", "bookingsByCar", "bookingById", "userBookingsWithDetails"}, allEntries = true)
    public String deleteBooking(Long id) {
        try {
            Optional<Booking> booking = bookingRepository.findById(id);
            if (booking.isEmpty()) {
                return "Booking not found";
            }

            // Make car available again
            Optional<Car> carOpt = carRepository.findById(booking.get().getCarId());
            if (carOpt.isPresent()) {
                Car car = carOpt.get();
                car.setAvailable(true);
                carRepository.save(car);
            }

            bookingRepository.deleteById(id);
            log.info("✅ Booking deleted successfully");
            return "Booking deleted successfully";

        } catch (Exception e) {
            log.error("❌ Error deleting booking: {}", e.getMessage());
            return "Failed to delete booking: " + e.getMessage();
        }
    }
}
