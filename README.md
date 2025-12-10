# 🚗 DriveHub - Car Rental System

A full-stack car rental platform built with **Spring Boot** and **JSP**, featuring user authentication, OTP verification, booking management, payment integration with Razorpay, and cloud deployment on AWS.

**🌐 Live Demo**: [http://ec2-98-92-39-200.compute-1.amazonaws.com:8080/](http://ec2-98-92-39-200.compute-1.amazonaws.com:8080/)

---

## 🌟 Project Overview

**DriveHub** is a production-ready car rental application that allows users to:
- Browse and search available cars
- Register with email OTP verification  
- Book cars with date selection
- Make payments through Razorpay
- Manage bookings and profile
- Admin dashboard for car and booking management

The application uses **AWS RDS** for database, **Redis (Upstash)** for caching, **AWS S3** for image storage, and is deployed on **AWS EC2**.

---

## 🛠️ Technology Stack

### Backend
- **Java 17**
- **Spring Boot 3.2.2** (WAR packaging)
- **Spring MVC** with JSP views
- **Spring Data JPA** with Hibernate
- **Spring Security** (for password encryption)
- **Spring Mail** (Gmail SMTP for OTP)

### Frontend
- **JSP (JavaServer Pages)**
- **Tailwind CSS** - Responsive design
- **Font Awesome** - Icons
- **JavaScript** - Client-side interactions

### Database & Cache
- **MySQL 8.0** - AWS RDS
- **Redis** - Upstash (for caching)

### Cloud Services
- **AWS EC2** - Application hosting
- **AWS RDS** - MySQL database
- **AWS S3** - Car image storage
- **Upstash Redis** - Cache layer

### Payment Gateway
- **Razorpay** - Payment processing

---

## 📁 Project Structure

```
carrentalsystem/
├── src/main/
│   ├── java/com/project/carrentalsystem/
│   │   ├── CarrentalsystemApplication.java
│   │   ├── controller/
│   │   │   ├── UserController.java
│   │   │   ├── AdminController.java
│   │   │   └── BookingController.java
│   │   ├── service/
│   │   │   ├── UserService.java
│   │   │   ├── CarService.java
│   │   │   ├── BookingService.java
│   │   │   ├── EmailService.java
│   │   │   └── S3StorageService.java
│   │   ├── repository/
│   │   │   ├── UserRepository.java
│   │   │   ├── CarRepository.java
│   │   │   ├── BookingRepository.java
│   │   │   └── OtpRepository.java
│   │   ├── model/
│   │   │   ├── User.java
│   │   │   ├── Car.java
│   │   │   ├── Booking.java
│   │   │   └── OtpVerification.java
│   │   ├── config/
│   │   │   ├── WebConfig.java
│   │   │   ├── RedisConfig.java
│   │   │   ├── RazorpayConfig.java
│   │   │   └── CacheStatistics.java
│   │   └── dto/
│   │       ├── UserRegistration.java
│   │       └── UserResponse.java
│   └── resources/
│       ├── application.properties
│       └── META-INF/resources/WEB-INF/jsp/
│           ├── home.jsp
│           ├── login.jsp
│           ├── register.jsp
│           ├── profile.jsp
│           ├── cars.jsp
│           ├── booking.jsp
│           └── admin-dashboard.jsp
├── pom.xml
├── Dockerfile
├── docker-compose.yml
└── README.md
```

---

## ✨ Key Features

### User Features
- 🔐 **User Registration** with email OTP verification
- 🔑 **Login/Logout** with session management
- 🚗 **Browse Cars** with search and filter
- 📅 **Book Cars** with date selection
- 💳 **Payment Integration** via Razorpay
- 👤 **User Profile** with booking history
- 📧 **Email Notifications** for bookings and OTPs

### Admin Features
- 📊 **Admin Dashboard** with statistics
- ➕ **Add/Edit/Delete Cars** with image upload to S3
- 📋 **Manage Bookings** - view all bookings
- 👥 **User Management**
- 📈 **Analytics** - total bookings, revenue, etc.

### Technical Features
- ⚡ **Redis Caching** for improved performance
- 🔒 **Secure Password Storage** with BCrypt
- 📱 **Responsive Design** - works on all devices
- 🎨 **Modern UI** with Tailwind CSS
- 🌐 **RESTful APIs** for frontend-backend communication
- 🚀 **Cloud Deployment** on AWS EC2

---

## 🚀 Quick Start

### Prerequisites
- Java 17 or higher
- Maven 3.6+
- MySQL 8.0
- AWS Account (for RDS, S3, EC2)
- Redis (Upstash account)
- Razorpay Account

### Local Development

1. **Clone the repository**
```bash
git clone https://github.com/rajeshbyreddy95/carrentalsystem.git
cd carrentalsystem
```

2. **Configure application.properties**
```properties
# Database
spring.datasource.url=jdbc:mysql://localhost:3306/carrentalsystem
spring.datasource.username=your_username
spring.datasource.password=your_password

# Email (Gmail)
spring.mail.username=your_email@gmail.com
spring.mail.password=your_app_password

# Redis
spring.data.redis.url=rediss://your-redis-url

# AWS S3
aws.s3.access-key=your_access_key
aws.s3.secret-key=your_secret_key
aws.s3.bucket-name=your_bucket_name

# Razorpay
razorpay.key-id=your_razorpay_key
razorpay.key-secret=your_razorpay_secret
```

3. **Build and run**
```bash
./mvnw clean package -DskipTests
java -jar target/carrentalsystem-0.0.1-SNAPSHOT.war
```

4. **Access the application**
```
http://localhost:8080/
```

---

## 🌐 Deployment on AWS EC2

### Build for Production
```bash
./mvnw clean package -DskipTests
```

### Deploy to EC2
```bash
scp -i your-key.pem target/carrentalsystem-0.0.1-SNAPSHOT.war ubuntu@your-ec2-ip:/home/ubuntu/
```

### Run on EC2
```bash
ssh -i your-key.pem ubuntu@your-ec2-ip
pkill -f carrentalsystem
java -jar /home/ubuntu/carrentalsystem-0.0.1-SNAPSHOT.war &
```

---

## 📡 API Endpoints

### User APIs
- `POST /api/user/register` - Send OTP for registration
- `POST /api/user/verify-otp` - Verify OTP and create account
- `POST /api/user/login` - User login
- `GET /api/user/details?email={email}` - Get user details
- `GET /api/user/bookings?email={email}` - Get user bookings

### Car APIs
- `GET /api/cars/search` - Search available cars
- `GET /api/cars` - Get all cars (Admin)
- `POST /api/cars` - Add new car (Admin)
- `PUT /api/cars/{id}` - Update car (Admin)
- `DELETE /api/cars/{id}` - Delete car (Admin)

### Booking APIs
- `POST /api/user/booking/create` - Create new booking
- `GET /api/bookings` - Get all bookings (Admin)

### Config APIs
- `GET /api/config/razorpay-key` - Get Razorpay public key

---

## 🗂️ Database Schema

### Users Table
```sql
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(20) DEFAULT 'USER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### Cars Table
```sql
CREATE TABLE cars (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    brand VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    transmission VARCHAR(20),
    seats INT,
    fuel_type VARCHAR(20),
    price_per_day DECIMAL(10,2),
    description TEXT,
    image_url VARCHAR(500),
    registration_number VARCHAR(50) UNIQUE,
    year INT,
    color VARCHAR(50),
    available BOOLEAN DEFAULT TRUE,
    location VARCHAR(255),
    rating DECIMAL(3,2) DEFAULT 0.0,
    total_bookings INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### Bookings Table
```sql
CREATE TABLE bookings (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    car_id BIGINT NOT NULL,
    pickup_date DATE NOT NULL,
    return_date DATE NOT NULL,
    pickup_location VARCHAR(255),
    dropoff_location VARCHAR(255),
    total_days INT,
    total_amount DECIMAL(10,2),
    payment_id VARCHAR(255),
    payment_status VARCHAR(50) DEFAULT 'PENDING',
    booking_status VARCHAR(50) DEFAULT 'CONFIRMED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (car_id) REFERENCES cars(id)
);
```

### OTP Verification Table
```sql
CREATE TABLE otp_verification (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL,
    otp VARCHAR(6) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    verified BOOLEAN DEFAULT FALSE
);
```

---

## 🎨 Application Pages

1. **Home Page** - Hero section, featured cars, search form
2. **Login Page** - User authentication
3. **Register Page** - Two-step registration with OTP
4. **Profile Page** - User dashboard with booking history
5. **Cars Page** - Browse all available cars
6. **Booking Page** - Car booking with payment
7. **Admin Dashboard** - Manage cars, bookings, users

---

## 🔧 Configuration

The application is configured through `application.properties`:

```properties
# Server
server.port=8080

# Database
spring.datasource.url=jdbc:mysql://your-rds-endpoint:3306/carrentalsystem
spring.jpa.hibernate.ddl-auto=update

# JSP Views
spring.mvc.view.prefix=/WEB-INF/jsp/
spring.mvc.view.suffix=.jsp

# Redis Cache
spring.data.redis.url=rediss://your-redis-url
spring.cache.type=redis

# Email
spring.mail.host=smtp.gmail.com
spring.mail.port=587

# File Upload
spring.servlet.multipart.max-file-size=50MB
spring.servlet.multipart.max-request-size=50MB
```

---

## 🐛 Troubleshooting

### JSP 404 Error
**Issue**: Getting 404 when accessing root path `/`  
**Solution**: 
1. Ensure packaging is `<packaging>war</packaging>` in pom.xml
2. Application must extend `SpringBootServletInitializer`
3. JSP files must be in `src/main/resources/META-INF/resources/WEB-INF/jsp/`
4. Configure `WebConfig` with `@EnableWebMvc` and `InternalResourceViewResolver`

### Application Shuts Down Immediately
**Issue**: Application starts but shuts down immediately on EC2  
**Solution**: Make sure Tomcat is not marked as `<scope>provided</scope>` for standalone WAR execution

### Redis Connection Issues
**Issue**: Cannot connect to Redis  
**Solution**: Use `rediss://` (with SSL) for Upstash Redis URLs

---

## 📚 Key Maven Dependencies

```xml
<!-- Spring Boot Web -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>

<!-- JSP Support -->
<dependency>
    <groupId>org.apache.tomcat.embed</groupId>
    <artifactId>tomcat-embed-jasper</artifactId>
</dependency>
<dependency>
    <groupId>jakarta.servlet.jsp.jstl</groupId>
    <artifactId>jakarta.servlet.jsp.jstl-api</artifactId>
</dependency>

<!-- Spring Data JPA -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>

<!-- MySQL Driver -->
<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
</dependency>

<!-- Redis -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>

<!-- AWS S3 SDK -->
<dependency>
    <groupId>software.amazon.awssdk</groupId>
    <artifactId>s3</artifactId>
</dependency>

<!-- Email -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-mail</artifactId>
</dependency>
```

---

## 👨‍💻 Development Team

**Developer**: Rajesh Byreddy  
**GitHub**: [@rajeshbyreddy95](https://github.com/rajeshbyreddy95)  
**Repository**: [carrentalsystem](https://github.com/rajeshbyreddy95/carrentalsystem)

---

## 📄 License

This project is for educational purposes.

---

## 🎉 Acknowledgments

- Spring Boot Documentation
- Tailwind CSS for beautiful styling
- Font Awesome for icons
- AWS for cloud infrastructure
- Razorpay for payment integration

---

**Ready to drive?** 🚗💨 Start the engine with `java -jar target/carrentalsystem-0.0.1-SNAPSHOT.war`
