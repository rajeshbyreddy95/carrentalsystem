package com.project.carrentalsystem.config;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO for tracking Redis cache statistics
 * Helps monitor caching performance
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CacheStatistics {
    private String cacheName;
    private long size;
    private long hits;
    private long misses;
    private double hitRate;
    private long avgResponseTimeMs;
    private String lastUpdated;
    
    /**
     * Calculate and return cache effectiveness percentage
     */
    public double getEffectivenessPercentage() {
        if ((hits + misses) == 0) return 0;
        return (hits * 100.0) / (hits + misses);
    }
}
