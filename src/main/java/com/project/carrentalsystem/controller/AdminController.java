package com.project.carrentalsystem.controller;

import com.project.carrentalsystem.dto.UserResponse;
import com.project.carrentalsystem.model.Car;
import com.project.carrentalsystem.model.User;
import com.project.carrentalsystem.repository.UserRepository;
import com.project.carrentalsystem.service.CarService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
public class AdminController {

    private final CarService carService;
    private final UserRepository userRepository;

    /**
     * Serve admin dashboard page
     */
    @GetMapping("/admin/dashboard")
    public String adminDashboard() {
        return "admin-dashboard";
    }

    // ==================== CAR MANAGEMENT API ENDPOINTS ====================

    /**
     * Add new car
     */
    @PostMapping("/api/admin/cars/add")
    @ResponseBody
    public String addCar(
            @RequestParam String brand,
            @RequestParam String model,
            @RequestParam String category,
            @RequestParam String transmission,
            @RequestParam(required = false, defaultValue = "5") Integer seats,
            @RequestParam(required = false, defaultValue = "Petrol") String fuelType,
            @RequestParam Double pricePerDay,
            @RequestParam String description,
            @RequestParam String registrationNumber,
            @RequestParam(required = false, defaultValue = "2024") Integer year,
            @RequestParam(required = false, defaultValue = "White") String color,
            @RequestParam String location,
            @RequestParam MultipartFile carImage) {
        
        Car car = Car.builder()
                .brand(brand)
                .model(model)
                .category(category)
                .transmission(transmission)
                .seats(seats)
                .fuelType(fuelType)
                .pricePerDay(pricePerDay)
                .description(description)
                .registrationNumber(registrationNumber)
                .year(year)
                .color(color)
                .location(location)
                .build();

        return carService.addCar(car, carImage);
    }

    /**
     * Get all cars
     */
    @GetMapping("/api/admin/cars")
    @ResponseBody
    public List<Car> getAllCars() {
        return carService.getAllCars();
    }

    /**
     * Get car by ID
     */
    @GetMapping("/api/admin/cars/{id}")
    @ResponseBody
    public Object getCarById(@PathVariable Long id) {
        return carService.getCarById(id).orElse(null);
    }

    /**
     * Update car
     */
    @PostMapping("/api/admin/cars/update/{id}")
    @ResponseBody
    public String updateCar(
            @PathVariable Long id,
            @RequestParam String brand,
            @RequestParam String model,
            @RequestParam String category,
            @RequestParam String transmission,
            @RequestParam Integer seats,
            @RequestParam String fuelType,
            @RequestParam Double pricePerDay,
            @RequestParam String description,
            @RequestParam Integer year,
            @RequestParam String color,
            @RequestParam String location,
            @RequestParam Boolean available,
            @RequestParam(required = false) MultipartFile carImage) {
        
        Car car = Car.builder()
                .brand(brand)
                .model(model)
                .category(category)
                .transmission(transmission)
                .seats(seats)
                .fuelType(fuelType)
                .pricePerDay(pricePerDay)
                .description(description)
                .year(year)
                .color(color)
                .location(location)
                .available(available)
                .build();

        return carService.updateCar(id, car, carImage);
    }

    /**
     * Delete car
     */
    @DeleteMapping("/api/admin/cars/delete/{id}")
    @ResponseBody
    public String deleteCar(@PathVariable Long id) {
        return carService.deleteCar(id);
    }

    /**
     * Toggle car availability
     */
    @PostMapping("/api/admin/cars/toggle-availability/{id}")
    @ResponseBody
    public String toggleAvailability(@PathVariable Long id) {
        return carService.toggleAvailability(id);
    }

    // ==================== USER MANAGEMENT API ENDPOINTS ====================

    /**
     * Get all users
     */
    @GetMapping("/api/admin/users")
    @ResponseBody
    public List<UserResponse> getAllUsers() {
        return userRepository.findAll().stream()
                .map(user -> UserResponse.builder()
                        .id(user.getId())
                        .fullName(user.getFullName())
                        .email(user.getEmail())
                        .mobileNumber(user.getMobileNumber())
                        .panNumber(user.getPanNumber())
                        .aadhaarNumber(user.getAadhaarNumber())
                        .role(user.getRole())
                        .drivingLicenseUrl(user.getDrivingLicenseUrl())
                        .aadhaarPhotoUrl(user.getAadhaarPhotoUrl())
                        .build())
                .collect(Collectors.toList());
    }

    /**
     * Initialize demo cars (for testing)
     */
    @PostMapping("/api/admin/demo/init-cars")
    @ResponseBody
    public String initDemoCars() {
        try {
            // Check if cars already exist
            List<Car> existingCars = carService.getAllCars();
            if (!existingCars.isEmpty()) {
                return "Demo cars already exist. Total: " + existingCars.size();
            }

            // Create demo cars with placeholder URLs
            Car[] demoCars = {
                Car.builder()
                    .brand("Toyota")
                    .model("Fortuner")
                    .category("SUV")
                    .transmission("Automatic")
                    .seats(7)
                    .fuelType("Diesel")
                    .pricePerDay(5500.0)
                    .description("Spacious 7-seater SUV perfect for family trips")
                    .registrationNumber("DL01AB1234")
                    .year(2023)
                    .color("Black")
                    .location("Delhi")
                    .imageUrl("https://via.placeholder.com/400x300?text=Toyota+Fortuner")
                    .available(true)
                    .build(),
                Car.builder()
                    .brand("Maruti")
                    .model("Swift")
                    .category("Hatchback")
                    .transmission("Automatic")
                    .seats(5)
                    .fuelType("Petrol")
                    .pricePerDay(2500.0)
                    .description("Compact and efficient city car")
                    .registrationNumber("DL02AB5678")
                    .year(2023)
                    .color("Silver")
                    .location("Delhi")
                    .imageUrl("https://via.placeholder.com/400x300?text=Maruti+Swift")
                    .available(true)
                    .build(),
                Car.builder()
                    .brand("Honda")
                    .model("City")
                    .category("Sedan")
                    .transmission("Manual")
                    .seats(5)
                    .fuelType("Petrol")
                    .pricePerDay(3500.0)
                    .description("Stylish sedan with great fuel efficiency")
                    .registrationNumber("DL03AB9012")
                    .year(2022)
                    .color("White")
                    .location("Delhi")
                    .imageUrl("https://via.placeholder.com/400x300?text=Honda+City")
                    .available(true)
                    .build(),
                Car.builder()
                    .brand("BMW")
                    .model("3 Series")
                    .category("Luxury")
                    .transmission("Automatic")
                    .seats(5)
                    .fuelType("Diesel")
                    .pricePerDay(8500.0)
                    .description("Premium luxury sedan with advanced features")
                    .registrationNumber("DL04AB3456")
                    .year(2023)
                    .color("Blue")
                    .location("Delhi")
                    .imageUrl("https://via.placeholder.com/400x300?text=BMW+3+Series")
                    .available(true)
                    .build(),
                Car.builder()
                    .brand("Hyundai")
                    .model("Creta")
                    .category("SUV")
                    .transmission("Automatic")
                    .seats(5)
                    .fuelType("Petrol")
                    .pricePerDay(4200.0)
                    .description("Modern SUV with all modern amenities")
                    .registrationNumber("DL05AB7890")
                    .year(2023)
                    .color("Red")
                    .location("Delhi")
                    .imageUrl("https://via.placeholder.com/400x300?text=Hyundai+Creta")
                    .available(true)
                    .build()
            };

            // Save all demo cars
            for (Car car : demoCars) {
                carService.saveCar(car);
            }

            return "Demo cars initialized successfully! Added " + demoCars.length + " cars.";
        } catch (Exception e) {
            return "Error initializing demo cars: " + e.getMessage();
        }
    }
}
