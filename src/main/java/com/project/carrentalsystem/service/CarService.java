package com.project.carrentalsystem.service;

import com.project.carrentalsystem.model.Car;
import com.project.carrentalsystem.repository.CarRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class CarService {

    private final CarRepository carRepository;
    private final OciStorageService ociStorageService;

    // Add new car
    @Transactional
    @CacheEvict(value = {"allCars", "availableCars", "carsByLocation"}, allEntries = true)
    public String addCar(Car car, MultipartFile carImage) {
        try {
            // Check if registration number already exists
            if (carRepository.findByRegistrationNumber(car.getRegistrationNumber()).isPresent()) {
                return "Registration number already exists";
            }

            // Upload car image to OCI
            if (carImage != null && !carImage.isEmpty()) {
                String imageUrl = ociStorageService.uploadFile(
                    carImage, 
                    "cars/" + car.getRegistrationNumber()
                );
                car.setImageUrl(imageUrl);
            } else {
                return "Car image is required";
            }

            // Save car
            carRepository.save(car);
            log.info("✅ Car added successfully: {} {}", car.getBrand(), car.getModel());
            return "Car added successfully";

        } catch (Exception e) {
            log.error("❌ Error adding car: {}", e.getMessage());
            return "Failed to add car: " + e.getMessage();
        }
    }

    // Get all cars - Cached for 5 minutes
    @Cacheable(value = "allCars", unless = "#result == null || #result.isEmpty()")
    public List<Car> getAllCars() {
        log.info("📡 Fetching all cars from database...");
        return carRepository.findAll();
    }

    // Get available cars - Cached for 5 minutes
    @Cacheable(value = "availableCars", unless = "#result == null || #result.isEmpty()")
    public List<Car> getAvailableCars() {
        log.info("📡 Fetching available cars from database...");
        return carRepository.findByAvailableTrue();
    }

    // Get car by ID - Cached for 5 minutes
    @Cacheable(value = "carById", key = "#id", unless = "#result == null || #result.isEmpty()")
    public Optional<Car> getCarById(Long id) {
        log.info("📡 Fetching car with ID {} from database...", id);
        return carRepository.findById(id);
    }

    // Get cars by category - Cached for 5 minutes
    @Cacheable(value = "carsByCategory", key = "#category", unless = "#result == null || #result.isEmpty()")
    public List<Car> getCarsByCategory(String category) {
        log.info("📡 Fetching cars by category: {} from database...", category);
        return carRepository.findByCategory(category);
    }

    // Get cars by location - Cached for 5 minutes
    @Cacheable(value = "carsByLocation", key = "#location", unless = "#result == null || #result.isEmpty()")
    public List<Car> getCarsByLocation(String location) {
        log.info("📡 Fetching cars by location: {} from database...", location);
        return carRepository.findByLocation(location);
    }

    // Update car
    @Transactional
    @CacheEvict(value = {"allCars", "availableCars", "carById", "carsByCategory", "carsByLocation"}, allEntries = true)
    public String updateCar(Long id, Car updatedCar, MultipartFile carImage) {
        try {
            Optional<Car> existingCar = carRepository.findById(id);
            if (existingCar.isEmpty()) {
                return "Car not found";
            }

            Car car = existingCar.get();
            
            // Update fields
            car.setBrand(updatedCar.getBrand());
            car.setModel(updatedCar.getModel());
            car.setCategory(updatedCar.getCategory());
            car.setTransmission(updatedCar.getTransmission());
            car.setSeats(updatedCar.getSeats());
            car.setFuelType(updatedCar.getFuelType());
            car.setPricePerDay(updatedCar.getPricePerDay());
            car.setDescription(updatedCar.getDescription());
            car.setYear(updatedCar.getYear());
            car.setColor(updatedCar.getColor());
            car.setAvailable(updatedCar.getAvailable());
            car.setLocation(updatedCar.getLocation());

            // Update image if new one is provided
            if (carImage != null && !carImage.isEmpty()) {
                // Delete old image
                ociStorageService.deleteFile(car.getImageUrl());
                
                // Upload new image
                String imageUrl = ociStorageService.uploadFile(
                    carImage, 
                    "cars/" + car.getRegistrationNumber()
                );
                car.setImageUrl(imageUrl);
            }

            carRepository.save(car);
            log.info("✅ Car updated successfully: {} {}", car.getBrand(), car.getModel());
            return "Car updated successfully";

        } catch (Exception e) {
            log.error("❌ Error updating car: {}", e.getMessage());
            return "Failed to update car: " + e.getMessage();
        }
    }

    // Delete car
    @Transactional
    @CacheEvict(value = {"allCars", "availableCars", "carById", "carsByCategory", "carsByLocation"}, allEntries = true)
    public String deleteCar(Long id) {
        try {
            Optional<Car> car = carRepository.findById(id);
            if (car.isEmpty()) {
                return "Car not found";
            }

            // Delete car image from OCI
            ociStorageService.deleteFile(car.get().getImageUrl());

            carRepository.deleteById(id);
            log.info("✅ Car deleted successfully: {} {}", car.get().getBrand(), car.get().getModel());
            return "Car deleted successfully";

        } catch (Exception e) {
            log.error("❌ Error deleting car: {}", e.getMessage());
            return "Failed to delete car: " + e.getMessage();
        }
    }

    // Toggle car availability
    @Transactional
    @CacheEvict(value = {"allCars", "availableCars", "carById"}, allEntries = true)
    public String toggleAvailability(Long id) {
        try {
            Optional<Car> carOpt = carRepository.findById(id);
            if (carOpt.isEmpty()) {
                return "Car not found";
            }

            Car car = carOpt.get();
            car.setAvailable(!car.getAvailable());
            carRepository.save(car);
            log.info("✅ Car availability updated: {} {}", car.getBrand(), car.getModel());
            return "Car availability updated";

        } catch (Exception e) {
            log.error("❌ Error updating availability: {}", e.getMessage());
            return "Failed to update availability: " + e.getMessage();
        }
    }

    // Save car (used for demo data)
    public Car saveCar(Car car) {
        return carRepository.save(car);
    }

    // Search cars based on filters
    public List<Car> searchCars(String pickupLocation, String dropoffLocation, 
                                String pickupDate, String returnDate, String carType) {
        try {
            // Get available cars as the base
            List<Car> cars = getAvailableCars();

            // Filter by location if provided
            if (pickupLocation != null && !pickupLocation.isEmpty()) {
                cars = cars.stream()
                        .filter(car -> car.getLocation() != null && 
                                car.getLocation().toLowerCase().contains(pickupLocation.toLowerCase()))
                        .toList();
            }

            // Filter by category/car type if provided
            if (carType != null && !carType.isEmpty()) {
                String categoryMap = mapCarTypeToCategory(carType);
                if (categoryMap != null && !categoryMap.isEmpty()) {
                    String finalCategoryMap = categoryMap;
                    cars = cars.stream()
                            .filter(car -> car.getCategory() != null && 
                                    car.getCategory().equalsIgnoreCase(finalCategoryMap))
                            .toList();
                }
            }

            log.info("✅ Search completed: Found {} cars", cars.size());
            return cars;

        } catch (Exception e) {
            log.error("❌ Error searching cars: {}", e.getMessage());
            return List.of();
        }
    }

    // Map user-friendly car type to database category
    private String mapCarTypeToCategory(String carType) {
        return switch (carType.toLowerCase()) {
            case "economy" -> "Hatchback";
            case "premium" -> "Sedan";
            case "suv" -> "SUV";
            case "luxury" -> "Luxury";
            case "electric" -> "Electric";
            case "van" -> "Van";
            default -> null;
        };
    }
}
