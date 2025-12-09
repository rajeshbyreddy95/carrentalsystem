#!/bin/bash

###############################################################################
# Car Rental System - Production Startup Script
# This script handles all necessary checks and deployment steps
###############################################################################

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="docker-compose.prod.yml"
ENV_FILE=".env.prod"
LOG_FILE="$SCRIPT_DIR/deployment.log"

###############################################################################
# Logging Functions
###############################################################################

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

###############################################################################
# Pre-flight Checks
###############################################################################

check_prerequisites() {
    log_info "Performing pre-flight checks..."
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed"
        exit 1
    fi
    log_success "Docker found: $(docker --version)"
    
    # Check Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        log_error "Docker Compose is not installed"
        exit 1
    fi
    log_success "Docker Compose found: $(docker-compose --version)"
    
    # Check if docker daemon is running
    if ! docker info > /dev/null 2>&1; then
        log_error "Docker daemon is not running"
        exit 1
    fi
    log_success "Docker daemon is running"
    
    # Check environment file
    if [ ! -f "$ENV_FILE" ]; then
        log_error "Environment file $ENV_FILE not found"
        log_info "Please copy .env.prod.example to $ENV_FILE and configure it"
        exit 1
    fi
    log_success "Environment file found"
    
    # Check compose file
    if [ ! -f "$COMPOSE_FILE" ]; then
        log_error "Docker Compose file $COMPOSE_FILE not found"
        exit 1
    fi
    log_success "Docker Compose file found"
    
    # Check SSL certificates
    if [ ! -f "certs/cert.pem" ] || [ ! -f "certs/key.pem" ]; then
        log_warning "SSL certificates not found in certs/ directory"
        log_info "Please ensure SSL certificates are set up"
        log_info "See PRODUCTION_DEPLOYMENT.md for SSL setup instructions"
    else
        log_success "SSL certificates found"
    fi
}

###############################################################################
# Security Checks
###############################################################################

security_checks() {
    log_info "Running security checks..."
    
    # Check environment file permissions
    if [ "$(stat -f%A "$ENV_FILE" 2>/dev/null || stat -c%a "$ENV_FILE")" != "600" ]; then
        log_warning "Environment file permissions are not 600"
        log_info "Setting secure permissions..."
        chmod 600 "$ENV_FILE"
    fi
    log_success "Environment file has secure permissions"
    
    # Verify critical environment variables
    source "$ENV_FILE"
    
    if [ -z "$MYSQL_ROOT_PASSWORD" ] || [ "$MYSQL_ROOT_PASSWORD" = "change_this_secure_root_password" ]; then
        log_error "MYSQL_ROOT_PASSWORD not configured securely"
        exit 1
    fi
    
    if [ -z "$RAZORPAY_KEY_ID" ] || [ "$RAZORPAY_KEY_ID" = "rzp_live_your_production_key" ]; then
        log_error "RAZORPAY_KEY_ID not configured"
        exit 1
    fi
    
    if [ -z "$SPRING_MAIL_USERNAME" ] || [ "$SPRING_MAIL_USERNAME" = "your-email@gmail.com" ]; then
        log_error "SPRING_MAIL_USERNAME not configured"
        exit 1
    fi
    
    log_success "All critical environment variables are configured"
}

###############################################################################
# System Resources Check
###############################################################################

check_system_resources() {
    log_info "Checking system resources..."
    
    # Check available memory
    AVAILABLE_MEM=$(free -h | awk '/^Mem:/ {print $7}')
    log_info "Available memory: $AVAILABLE_MEM"
    
    # Check disk space
    AVAILABLE_DISK=$(df -h "$SCRIPT_DIR" | awk 'NR==2 {print $4}')
    log_info "Available disk space: $AVAILABLE_DISK"
    
    # Check CPU count
    CPU_COUNT=$(nproc)
    log_info "CPU cores: $CPU_COUNT"
}

###############################################################################
# Build Application
###############################################################################

build_application() {
    log_info "Building application image..."
    
    if docker build -t carrentalsystem:prod-$(date +%s) .; then
        log_success "Application image built successfully"
        docker tag carrentalsystem:prod-$(date +%s) carrentalsystem:prod-latest
    else
        log_error "Failed to build application image"
        exit 1
    fi
}

###############################################################################
# Initialize Database
###############################################################################

init_database() {
    log_info "Initializing database..."
    
    # Start MySQL service only
    docker-compose -f "$COMPOSE_FILE" up -d mysql
    
    # Wait for MySQL to be healthy
    log_info "Waiting for MySQL to be ready..."
    RETRY=0
    MAX_RETRIES=30
    
    while [ $RETRY -lt $MAX_RETRIES ]; do
        if docker-compose -f "$COMPOSE_FILE" exec -T mysql mysqladmin ping -h localhost > /dev/null 2>&1; then
            log_success "MySQL is ready"
            break
        fi
        RETRY=$((RETRY + 1))
        sleep 2
    done
    
    if [ $RETRY -eq $MAX_RETRIES ]; then
        log_error "MySQL failed to start within timeout"
        docker-compose -f "$COMPOSE_FILE" logs mysql
        exit 1
    fi
}

###############################################################################
# Deploy Application
###############################################################################

deploy_application() {
    log_info "Deploying application..."
    
    # Start all services
    if docker-compose -f "$COMPOSE_FILE" up -d; then
        log_success "Services started successfully"
    else
        log_error "Failed to start services"
        exit 1
    fi
}

###############################################################################
# Health Checks
###############################################################################

health_checks() {
    log_info "Running health checks..."
    
    # Wait for services to be healthy
    RETRY=0
    MAX_RETRIES=30
    
    log_info "Waiting for application to be healthy..."
    
    while [ $RETRY -lt $MAX_RETRIES ]; do
        if docker-compose -f "$COMPOSE_FILE" ps app | grep -q "Up"; then
            log_success "Application is running"
            break
        fi
        RETRY=$((RETRY + 1))
        sleep 2
    done
    
    if [ $RETRY -eq $MAX_RETRIES ]; then
        log_error "Application failed to start within timeout"
        docker-compose -f "$COMPOSE_FILE" logs app
        exit 1
    fi
    
    # Check application endpoint
    log_info "Testing application endpoint..."
    RETRY=0
    while [ $RETRY -lt 10 ]; do
        if curl -sf http://localhost:8080/ > /dev/null; then
            log_success "Application endpoint is responding"
            break
        fi
        RETRY=$((RETRY + 1))
        sleep 2
    done
    
    if [ $RETRY -eq 10 ]; then
        log_warning "Application endpoint did not respond in time"
    fi
}

###############################################################################
# Verify Deployment
###############################################################################

verify_deployment() {
    log_info "Verifying deployment..."
    
    echo -e "\n${BLUE}=== Container Status ===${NC}"
    docker-compose -f "$COMPOSE_FILE" ps
    
    echo -e "\n${BLUE}=== Resource Usage ===${NC}"
    docker stats --no-stream
    
    echo -e "\n${BLUE}=== Application Logs (Last 20 lines) ===${NC}"
    docker-compose -f "$COMPOSE_FILE" logs --tail=20 app
}

###############################################################################
# Backup Before Deployment
###############################################################################

backup_before_deployment() {
    log_info "Creating backup before deployment..."
    
    BACKUP_DIR="$SCRIPT_DIR/backups"
    mkdir -p "$BACKUP_DIR"
    
    BACKUP_FILE="$BACKUP_DIR/pre-deployment-$(date +%Y%m%d_%H%M%S).sql"
    
    # Check if existing database exists
    if docker ps | grep -q "carrentalsystem-db"; then
        log_info "Backing up existing database..."
        source "$ENV_FILE"
        
        if docker exec carrentalsystem-db-prod mysqldump \
            -u carrentalsystem_user \
            -p"$MYSQL_PASSWORD" \
            carrentalsystem > "$BACKUP_FILE" 2>/dev/null; then
            gzip "$BACKUP_FILE"
            log_success "Database backed up: ${BACKUP_FILE}.gz"
        else
            log_warning "Could not backup existing database (may not exist yet)"
        fi
    fi
}

###############################################################################
# Cleanup Failed Deployments
###############################################################################

cleanup_failed_deployment() {
    log_error "Deployment failed. Attempting cleanup..."
    
    log_info "Stopping services..."
    docker-compose -f "$COMPOSE_FILE" down || true
    
    log_info "Please review logs at: $LOG_FILE"
    exit 1
}

###############################################################################
# Main Execution
###############################################################################

main() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║     Car Rental System - Production Deployment             ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}\n"
    
    # Set error trap
    trap cleanup_failed_deployment ERR
    
    log_info "Deployment started at $(date)"
    
    # Run checks
    check_prerequisites
    security_checks
    check_system_resources
    
    # Backup
    backup_before_deployment
    
    # Build and Deploy
    build_application
    init_database
    deploy_application
    
    # Verify
    health_checks
    verify_deployment
    
    echo -e "\n${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║     Deployment Completed Successfully!                    ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}\n"
    
    log_info "Application is ready at https://your-domain.com"
    log_info "Deployment logs saved to: $LOG_FILE"
    
    echo -e "${BLUE}Next Steps:${NC}"
    echo "1. Configure your domain in nginx.conf"
    echo "2. Test the application: curl -k https://your-domain.com"
    echo "3. Monitor logs: docker-compose -f $COMPOSE_FILE logs -f app"
    echo "4. See PRODUCTION_DEPLOYMENT.md for more information"
}

# Run main function
main "$@"
