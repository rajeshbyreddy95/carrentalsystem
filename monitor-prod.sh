#!/bin/bash

###############################################################################
# Car Rental System - Monitoring & Health Check Script
# Monitors Docker containers, system resources, and application health
###############################################################################

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Configuration
COMPOSE_FILE="docker-compose.prod.yml"
ALERT_EMAIL="${ALERT_EMAIL:-admin@example.com}"
LOG_FILE="monitoring.log"
CHECK_INTERVAL=${CHECK_INTERVAL:-60}  # seconds

###############################################################################
# Logging Functions
###############################################################################

log_info() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1" | tee -a "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}[⚠]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1" | tee -a "$LOG_FILE"
}

###############################################################################
# Alert Functions
###############################################################################

send_alert() {
    local subject=$1
    local message=$2
    
    # Log alert
    log_error "ALERT: $subject - $message"
    
    # Send email if configured (requires mail command)
    if command -v mail &> /dev/null && [ -n "$ALERT_EMAIL" ]; then
        echo "$message" | mail -s "[ALERT] $subject" "$ALERT_EMAIL"
    fi
}

###############################################################################
# Docker Container Checks
###############################################################################

check_docker_containers() {
    log_info "Checking Docker containers..."
    
    local status=$(docker-compose -f "$COMPOSE_FILE" ps --quiet)
    
    if [ -z "$status" ]; then
        log_error "No containers are running"
        send_alert "Docker Containers" "No containers running"
        return 1
    fi
    
    # Check each service
    local services=("mysql" "app" "nginx")
    
    for service in "${services[@]}"; do
        if docker-compose -f "$COMPOSE_FILE" ps "$service" | grep -q "Up"; then
            log_success "Service '$service' is running"
        else
            log_error "Service '$service' is not running"
            send_alert "Docker Service" "Service $service is not running"
            return 1
        fi
    done
    
    return 0
}

###############################################################################
# Container Health Checks
###############################################################################

check_container_health() {
    log_info "Checking container health..."
    
    # MySQL health
    if docker-compose -f "$COMPOSE_FILE" exec -T mysql mysqladmin ping -h localhost > /dev/null 2>&1; then
        log_success "MySQL is responding"
    else
        log_error "MySQL is not responding"
        send_alert "MySQL Health" "MySQL is not responding"
        return 1
    fi
    
    # Application health via curl
    if curl -sf http://localhost:8080/actuator/health > /dev/null 2>&1; then
        log_success "Application is healthy"
    else
        log_error "Application health check failed"
        send_alert "Application Health" "Health endpoint unreachable"
        return 1
    fi
    
    return 0
}

###############################################################################
# Resource Usage Monitoring
###############################################################################

check_resource_usage() {
    log_info "Checking resource usage..."
    
    # Memory check
    local memory_usage=$(docker stats --no-stream --format "{{.MemPerc}}" | grep -o '[0-9]*\.[0-9]*' | head -1)
    log_info "Memory usage: ${memory_usage}%"
    
    if (( $(echo "$memory_usage > 80" | bc -l) )); then
        log_warning "High memory usage detected: ${memory_usage}%"
        send_alert "Resource Usage" "Memory usage is ${memory_usage}%"
    fi
    
    # CPU check
    local cpu_usage=$(docker stats --no-stream --format "{{.CPUPerc}}" | grep -o '[0-9]*\.[0-9]*' | head -1)
    log_info "CPU usage: ${cpu_usage}%"
    
    if (( $(echo "$cpu_usage > 80" | bc -l) )); then
        log_warning "High CPU usage detected: ${cpu_usage}%"
        send_alert "Resource Usage" "CPU usage is ${cpu_usage}%"
    fi
    
    # Disk check
    local disk_usage=$(df "$PWD" | awk 'NR==2 {print $5}' | grep -o '[0-9]*')
    log_info "Disk usage: ${disk_usage}%"
    
    if [ "$disk_usage" -gt 85 ]; then
        log_warning "High disk usage detected: ${disk_usage}%"
        send_alert "Resource Usage" "Disk usage is ${disk_usage}%"
    fi
}

###############################################################################
# Application Metrics
###############################################################################

check_application_metrics() {
    log_info "Checking application metrics..."
    
    # JVM Memory
    local jvm_memory=$(curl -s http://localhost:8080/actuator/metrics/jvm.memory.used | grep -o '"value":[0-9]*' | grep -o '[0-9]*' | head -1)
    if [ -n "$jvm_memory" ]; then
        local jvm_memory_mb=$((jvm_memory / 1048576))
        log_info "JVM Memory used: ${jvm_memory_mb}MB"
    fi
    
    # Database connections
    local db_connections=$(curl -s http://localhost:8080/actuator/metrics/sql.init | grep -o '"value":[0-9]*' | grep -o '[0-9]*' | head -1)
    if [ -n "$db_connections" ]; then
        log_info "Database connections: $db_connections"
    fi
    
    # HTTP requests
    local http_requests=$(curl -s http://localhost:8080/actuator/metrics/http.server.requests | grep -o '"value":[0-9]*' | grep -o '[0-9]*' | head -1)
    if [ -n "$http_requests" ]; then
        log_info "Total HTTP requests: $http_requests"
    fi
}

###############################################################################
# Database Connectivity
###############################################################################

check_database_connectivity() {
    log_info "Checking database connectivity..."
    
    source .env.prod 2>/dev/null || log_warning "Could not load .env.prod"
    
    # Check if database can be accessed
    if docker exec carrentalsystem-db-prod mysql -u carrentalsystem_user -p"${MYSQL_PASSWORD}" -e "SELECT 1" > /dev/null 2>&1; then
        log_success "Database is accessible"
        
        # Check table count
        local table_count=$(docker exec carrentalsystem-db-prod mysql -u carrentalsystem_user -p"${MYSQL_PASSWORD}" -D carrentalsystem -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='carrentalsystem'" -s -N)
        log_info "Number of tables in database: $table_count"
    else
        log_error "Cannot connect to database"
        send_alert "Database Connectivity" "Cannot connect to database"
        return 1
    fi
    
    return 0
}

###############################################################################
# Log File Analysis
###############################################################################

check_error_logs() {
    log_info "Analyzing error logs..."
    
    # Check application logs for errors
    local error_count=$(docker-compose -f "$COMPOSE_FILE" logs --tail=100 app 2>/dev/null | grep -ci "ERROR\|EXCEPTION" || echo 0)
    
    if [ "$error_count" -gt 5 ]; then
        log_warning "Found $error_count error messages in recent logs"
        send_alert "Application Logs" "Found $error_count errors in recent logs"
        
        # Show last error
        local last_error=$(docker-compose -f "$COMPOSE_FILE" logs --tail=100 app 2>/dev/null | grep -i "ERROR\|EXCEPTION" | tail -1)
        log_info "Last error: $last_error"
    else
        log_success "No significant errors in logs ($error_count found)"
    fi
}

###############################################################################
# Port Availability
###############################################################################

check_port_availability() {
    log_info "Checking port availability..."
    
    local ports=("80" "443" "8080" "3306")
    
    for port in "${ports[@]}"; do
        if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
            log_success "Port $port is in use"
        else
            log_warning "Port $port is not in use or not listening"
        fi
    done
}

###############################################################################
# SSL Certificate Check
###############################################################################

check_ssl_certificate() {
    log_info "Checking SSL certificate..."
    
    if [ -f "certs/cert.pem" ]; then
        local expiry_date=$(openssl x509 -in certs/cert.pem -noout -enddate | cut -d= -f2)
        log_info "SSL certificate expiry: $expiry_date"
        
        local expiry_epoch=$(date -d "$expiry_date" +%s 2>/dev/null || date -j -f "%b %d %T %Y %Z" "$expiry_date" +%s)
        local current_epoch=$(date +%s)
        local days_remaining=$(( (expiry_epoch - current_epoch) / 86400 ))
        
        if [ "$days_remaining" -lt 30 ]; then
            log_warning "SSL certificate expires in $days_remaining days"
            send_alert "SSL Certificate" "Certificate expires in $days_remaining days"
        elif [ "$days_remaining" -lt 0 ]; then
            log_error "SSL certificate has expired!"
            send_alert "SSL Certificate" "Certificate has expired"
        else
            log_success "SSL certificate is valid ($days_remaining days remaining)"
        fi
    else
        log_warning "SSL certificate not found"
    fi
}

###############################################################################
# Network Connectivity
###############################################################################

check_network_connectivity() {
    log_info "Checking network connectivity..."
    
    # Check internet connectivity
    if ping -c 1 8.8.8.8 > /dev/null 2>&1; then
        log_success "Internet connectivity is OK"
    else
        log_warning "Cannot reach external network (8.8.8.8)"
    fi
    
    # Check DNS
    if nslookup google.com > /dev/null 2>&1; then
        log_success "DNS is working"
    else
        log_warning "DNS is not working"
    fi
}

###############################################################################
# Backup Status
###############################################################################

check_backup_status() {
    log_info "Checking backup status..."
    
    local backup_dir="backups"
    
    if [ -d "$backup_dir" ]; then
        local latest_backup=$(ls -t "$backup_dir"/*.sql.gz 2>/dev/null | head -1)
        
        if [ -n "$latest_backup" ]; then
            local backup_age_seconds=$(($(date +%s) - $(stat -f%m "$latest_backup" 2>/dev/null || stat -c%Y "$latest_backup")))
            local backup_age_hours=$((backup_age_seconds / 3600))
            
            if [ "$backup_age_hours" -lt 24 ]; then
                log_success "Recent backup found: $latest_backup ($backup_age_hours hours old)"
            else
                log_warning "Latest backup is $backup_age_hours hours old"
                send_alert "Backup Status" "Latest backup is $backup_age_hours hours old"
            fi
        else
            log_warning "No backups found in $backup_dir"
        fi
    else
        log_warning "Backup directory not found"
    fi
}

###############################################################################
# Generate Report
###############################################################################

generate_report() {
    echo -e "\n${MAGENTA}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║           Car Rental System - Health Report               ║"
    echo "║                 $(date +'%Y-%m-%d %H:%M:%S')                   ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}\n"
    
    echo -e "${BLUE}Container Status:${NC}"
    docker-compose -f "$COMPOSE_FILE" ps
    
    echo -e "\n${BLUE}Resource Usage:${NC}"
    docker stats --no-stream
    
    echo -e "\n${BLUE}Recent Errors:${NC}"
    docker-compose -f "$COMPOSE_FILE" logs --tail=5 app 2>/dev/null | grep -i "ERROR\|EXCEPTION" || echo "No recent errors found"
    
    echo -e "\n${BLUE}Disk Space:${NC}"
    df -h "$PWD"
}

###############################################################################
# Main Continuous Monitoring
###############################################################################

continuous_monitoring() {
    log_info "Starting continuous monitoring (check every ${CHECK_INTERVAL}s)"
    
    while true; do
        echo -e "\n${MAGENTA}=== Health Check at $(date +'%Y-%m-%d %H:%M:%S') ===${NC}"
        
        check_docker_containers
        check_container_health
        check_resource_usage
        check_application_metrics
        check_database_connectivity
        check_error_logs
        check_port_availability
        check_ssl_certificate
        check_network_connectivity
        check_backup_status
        
        log_info "Health check completed. Waiting ${CHECK_INTERVAL}s until next check..."
        sleep "$CHECK_INTERVAL"
    done
}

###############################################################################
# One-time Health Check
###############################################################################

one_time_check() {
    log_info "Running one-time health check..."
    
    check_docker_containers
    check_container_health
    check_resource_usage
    check_application_metrics
    check_database_connectivity
    check_error_logs
    check_port_availability
    check_ssl_certificate
    check_network_connectivity
    check_backup_status
    
    generate_report
}

###############################################################################
# Main Entry Point
###############################################################################

main() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║   Car Rental System - Monitoring & Health Check           ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}\n"
    
    case "${1:-once}" in
        continuous|monitor|-c)
            continuous_monitoring
            ;;
        once|check|*)
            one_time_check
            ;;
    esac
}

# Run main function
main "$@"
