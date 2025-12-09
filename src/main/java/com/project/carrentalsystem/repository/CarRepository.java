package com.project.carrentalsystem.repository;

import com.project.carrentalsystem.model.Car;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CarRepository extends JpaRepository<Car, Long> {
    
    List<Car> findByAvailableTrue();
    
    List<Car> findByCategory(String category);
    
    List<Car> findByLocation(String location);
    
    Optional<Car> findByRegistrationNumber(String registrationNumber);
    
    List<Car> findByBrandContainingIgnoreCase(String brand);
    
    List<Car> findByModelContainingIgnoreCase(String model);
}
