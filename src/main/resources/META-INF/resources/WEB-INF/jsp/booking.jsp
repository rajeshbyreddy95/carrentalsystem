<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Car Details & Booking | Car Rental System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #3b82f6;
            --primary-dark: #1e40af;
            --secondary: #10b981;
            --danger: #ef4444;
            --text-light: #f3f4f6;
            --text-dark: #1f2937;
        }
        body {
            transition: background-color 0.3s ease, color 0.3s ease;
        }
        body.dark-mode {
            background-color: #111827;
            color: #f3f4f6;
        }
        .star-rating {
            color: #fbbf24;
            display: inline-flex;
        }
        .booking-form-section {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        body.dark-mode .booking-form-section {
            background: #1f2937;
        }
        .car-image-container {
            background: #e5e7eb;
            border-radius: 12px;
            overflow: hidden;
            height: 350px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        body.dark-mode .car-image-container {
            background: #374151;
        }
        .spec-item {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 0;
        }
        .price-display {
            font-size: 32px;
            font-weight: bold;
            color: #10b981;
        }
        .btn-book {
            background: linear-gradient(135deg, #3b82f6 0%, #1e40af 100%);
            color: white;
            padding: 12px 32px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-weight: 600;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .btn-book:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(59, 130, 246, 0.3);
        }
        .btn-book:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }
        .spinner {
            display: inline-block;
            width: 16px;
            height: 16px;
            border: 2px solid #f3f4f6;
            border-top: 2px solid #3b82f6;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-right: 8px;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body class="bg-gray-50" onload="initPage()">
    <!-- Navigation Header -->
    <nav class="bg-white shadow-sm sticky top-0 z-50">
        <div class="dark-mode hidden" style="display: none;"></div>
        <div class="max-w-7xl mx-auto px-4 py-4 flex items-center justify-between">
            <div class="flex items-center gap-2">
                <i class="fas fa-car text-blue-600 text-2xl"></i>
                <span class="font-bold text-xl text-gray-800">CarRental</span>
            </div>
            <div class="flex items-center gap-4 ml-auto">
                <button onclick="toggleDarkMode()" class="p-2 rounded-lg hover:bg-gray-200 transition">
                    <i id="theme-icon" class="fas fa-moon text-gray-600"></i>
                </button>
                <button id="profile-toggle" class="p-2 rounded-lg hover:bg-gray-200 transition hidden">
                    <i class="fas fa-user-circle text-gray-600 text-2xl"></i>
                </button>
                <button id="hamburger-toggle" class="md:hidden p-2 rounded-lg hover:bg-gray-200 transition text-3xl text-gray-600">
                    <i class="fas fa-bars"></i>
                </button>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="max-w-6xl mx-auto px-4 py-8">
        <c:choose>
            <c:when test="${not empty car}">
                <!-- Breadcrumb -->
                <div class="mb-6 flex items-center gap-2 text-gray-600">
                    <a href="/" class="hover:text-blue-600">Home</a>
                    <span>&gt;</span>
                    <span>Car Details</span>
                </div>

                <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                    <!-- Car Details Column -->
                    <div class="lg:col-span-2">
                        <!-- Car Image -->
                        <div class="car-image-container mb-6">
                            <c:choose>
                                <c:when test="${not empty car.imageUrl}">
                                    <img src="${car.imageUrl}" alt="${car.brand} ${car.model}" class="w-full h-full object-cover">
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center text-gray-500">
                                        <i class="fas fa-car text-6xl mb-4"></i>
                                        <p>No image available</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Car Basic Info -->
                        <div class="booking-form-section mb-6">
                            <div class="flex items-start justify-between mb-4">
                                <div>
                                    <h1 class="text-3xl font-bold mb-2">${car.brand} ${car.model}</h1>
                                    <p class="text-gray-600 dark:text-gray-400">${car.category} • ${car.transmission}</p>
                                </div>
                                <div class="text-right">
                                    <div class="star-rating">
                                        <i id="rating-stars" class="fas fa-star"></i>
                                        <span class="text-gray-600 dark:text-gray-400 ml-2">(4.5/5)</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Availability Status -->
                            <div class="mb-4 p-3 rounded-lg" id="availability-status">
                                <c:choose>
                                    <c:when test="${car.available}">
                                        <span class="text-green-600"><i class="fas fa-check-circle"></i> Available for booking</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-red-600"><i class="fas fa-times-circle"></i> Not available</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Car Specifications -->
                            <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
                                <div class="spec-item">
                                    <i class="fas fa-users text-blue-600"></i>
                                    <div>
                                        <p class="text-xs text-gray-600 dark:text-gray-400">Seats</p>
                                        <p class="font-semibold">${car.seats}</p>
                                    </div>
                                </div>
                                <div class="spec-item">
                                    <i class="fas fa-gas-pump text-blue-600"></i>
                                    <div>
                                        <p class="text-xs text-gray-600 dark:text-gray-400">Transmission</p>
                                        <p class="font-semibold">${car.transmission}</p>
                                    </div>
                                </div>
                                <div class="spec-item">
                                    <i class="fas fa-location-dot text-blue-600"></i>
                                    <div>
                                        <p class="text-xs text-gray-600 dark:text-gray-400">Location</p>
                                        <p class="font-semibold">${car.location}</p>
                                    </div>
                                </div>
                                <div class="spec-item">
                                    <i class="fas fa-calendar text-blue-600"></i>
                                    <div>
                                        <p class="text-xs text-gray-600 dark:text-gray-400">License Plate</p>
                                        <p class="font-semibold">${car.registrationNumber}</p>
                                    </div>
                                </div>
                                <div class="spec-item">
                                    <i class="fas fa-layer-group text-blue-600"></i>
                                    <div>
                                        <p class="text-xs text-gray-600 dark:text-gray-400">Category</p>
                                        <p class="font-semibold">${car.category}</p>
                                    </div>
                                </div>
                                <div class="spec-item">
                                    <i class="fas fa-tag text-blue-600"></i>
                                    <div>
                                        <p class="text-xs text-gray-600 dark:text-gray-400">ID</p>
                                        <p class="font-semibold">${car.id}</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Car Description -->
                        <div class="booking-form-section">
                            <h2 class="text-xl font-bold mb-4">Description</h2>
                            <p class="text-gray-700 dark:text-gray-300 leading-relaxed">${empty car.description ? 'Premium quality car with all modern amenities for comfortable travel.' : car.description}</p>
                        </div>
                    </div>

                    <!-- Booking Form Column -->
                    <div class="lg:col-span-1">
                        <div class="booking-form-section sticky top-20">
                            <!-- Price Display -->
                            <div class="mb-6 pb-6 border-b border-gray-200 dark:border-gray-600">
                                <p class="text-gray-600 dark:text-gray-400 mb-2">Price per day</p>
                                <div class="price-display">₹${car.pricePerDay}</div>
                            </div>

                            <!-- Booking Form -->
                            <form id="booking-form" onsubmit="handleBookingSubmit(event)">
                                <div class="mb-4">
                                    <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                                        Pickup Date
                                    </label>
                                    <input type="date" id="pickup-date" required class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white">
                                </div>

                                <div class="mb-4">
                                    <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                                        Return Date
                                    </label>
                                    <input type="date" id="return-date" required class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white">
                                </div>

                                <div class="mb-4">
                                    <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                                        Pickup Location
                                    </label>
                                    <input type="text" id="pickup-location" value="${car.location}" required class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white">
                                </div>

                                <div class="mb-4">
                                    <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                                        Return Location
                                    </label>
                                    <input type="text" id="return-location" value="${car.location}" required class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white">
                                </div>

                                <div class="mb-6 p-3 bg-blue-50 dark:bg-blue-900 rounded-lg">
                                    <div class="flex justify-between mb-2">
                                        <span class="text-gray-700 dark:text-gray-300">Daily Rate:</span>
                                        <span id="daily-rate">₹${car.pricePerDay}</span>
                                    </div>
                                    <div class="flex justify-between mb-2">
                                        <span class="text-gray-700 dark:text-gray-300">Days:</span>
                                        <span id="rental-days">0</span>
                                    </div>
                                    <div class="flex justify-between font-bold text-lg border-t border-blue-200 dark:border-blue-700 pt-2">
                                        <span class="text-gray-700 dark:text-gray-300">Total:</span>
                                        <span id="total-cost">₹0</span>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                                        Special Requests (Optional)
                                    </label>
                                    <textarea id="special-requests" rows="3" placeholder="Any special requirements..." class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white"></textarea>
                                </div>

                                <button type="submit" class="btn-book w-full" id="book-btn">
                                    <i class="fas fa-lock"></i> Proceed to Booking
                                </button>
                            </form>

                            <div id="login-prompt" class="mt-4 p-4 bg-yellow-50 dark:bg-yellow-900 rounded-lg hidden">
                                <p class="text-yellow-800 dark:text-yellow-200 mb-3">Please login to book this car</p>
                                <a href="/login" class="block w-full text-center bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition">
                                    Go to Login
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Error State -->
                <div class="max-w-md mx-auto mt-12 text-center">
                    <div class="mb-6">
                        <i class="fas fa-exclamation-circle text-6xl text-red-500"></i>
                    </div>
                    <h2 class="text-2xl font-bold text-gray-800 dark:text-white mb-4">Car Not Found</h2>
                    <p class="text-gray-600 dark:text-gray-400 mb-6">
                        The car you're looking for doesn't exist or has been removed.
                    </p>
                    <a href="/" class="inline-block bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition">
                        Back to Home
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Mobile Menu (if needed for consistency) -->
    <div id="mobile-menu" class="fixed inset-0 bg-black/50 hidden md:hidden z-40 top-16"></div>

    <script>
        const CAR_PRICE = '<c:out value="${not empty car ? car.pricePerDay : 0}" />';
        const CAR_ID = '<c:out value="${not empty car ? car.id : 0}" />';

        function initPage() {
            checkUserSession();
            setupDateHandlers();
            applyDarkMode();
        }

        function setupDateHandlers() {
            const pickupDateInput = document.getElementById('pickup-date');
            const returnDateInput = document.getElementById('return-date');

            pickupDateInput.addEventListener('change', calculateCost);
            returnDateInput.addEventListener('change', calculateCost);

            // Set minimum date to today
            const today = new Date().toISOString().split('T')[0];
            pickupDateInput.min = today;
            returnDateInput.min = today;
        }

        function calculateCost() {
            const pickupDate = new Date(document.getElementById('pickup-date').value);
            const returnDate = new Date(document.getElementById('return-date').value);

            if (pickupDate && returnDate && pickupDate < returnDate) {
                const days = Math.ceil((returnDate - pickupDate) / (1000 * 60 * 60 * 24));
                const totalCost = days * CAR_PRICE;

                document.getElementById('rental-days').textContent = days;
                document.getElementById('total-cost').textContent = '₹' + totalCost.toLocaleString();
            } else {
                document.getElementById('rental-days').textContent = '0';
                document.getElementById('total-cost').textContent = '₹0';
            }
        }

        function checkUserSession() {
            const userSession = localStorage.getItem('userSession');
            const bookingForm = document.getElementById('booking-form');
            const loginPrompt = document.getElementById('login-prompt');
            const profileToggle = document.getElementById('profile-toggle');

            if (userSession) {
                if (bookingForm) bookingForm.style.display = 'block';
                if (loginPrompt) loginPrompt.style.display = 'none';
                if (profileToggle) profileToggle.style.display = 'block';
            } else {
                if (bookingForm) bookingForm.style.display = 'none';
                if (loginPrompt) loginPrompt.style.display = 'block';
                if (profileToggle) profileToggle.style.display = 'none';
            }
        }

        function handleBookingSubmit(event) {
            event.preventDefault();

            const userSession = localStorage.getItem('userSession');
            if (!userSession) {
                alert('Please login to complete the booking');
                window.location.href = '/login';
                return;
            }

            const pickupDate = document.getElementById('pickup-date').value;
            const returnDate = document.getElementById('return-date').value;
            const pickupLocation = document.getElementById('pickup-location').value;
            const returnLocation = document.getElementById('return-location').value;
            const specialRequests = document.getElementById('special-requests').value;

            if (!pickupDate || !returnDate) {
                alert('Please select both pickup and return dates');
                return;
            }

            const booking = {
                carId: CAR_ID,
                userEmail: JSON.parse(userSession).email,
                pickupDate,
                dropoffDate: returnDate,
                pickupLocation,
                dropoffLocation: returnLocation,
                totalDays: Math.ceil((new Date(returnDate) - new Date(pickupDate)) / (1000 * 60 * 60 * 24)),
                totalCost: parseInt(document.getElementById('total-cost').textContent.replace('₹', '').replace(/,/g, '')),
                specialRequests
            };

            const button = document.getElementById('book-btn');
            button.disabled = true;
            button.innerHTML = '<span class="spinner"></span>Processing booking...';

            fetch('/api/bookings/create', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams(booking)
            })
            .then(response => response.text())
            .then(result => {
                alert('Booking confirmed! ' + result);
                window.location.href = '/profile';
            })
            .catch(error => {
                console.error('Booking error:', error);
                alert('Failed to complete booking. Please try again.');
                button.disabled = false;
                button.innerHTML = '<i class="fas fa-lock"></i> Proceed to Booking';
            });
        }

        function toggleDarkMode() {
            const body = document.body;
            body.classList.toggle('dark-mode');
            localStorage.setItem('darkMode', body.classList.contains('dark-mode'));
            updateThemeIcon();
        }

        function updateThemeIcon() {
            const icon = document.getElementById('theme-icon');
            if (document.body.classList.contains('dark-mode')) {
                icon.className = 'fas fa-sun text-yellow-400';
            } else {
                icon.className = 'fas fa-moon text-gray-600';
            }
        }

        function applyDarkMode() {
            if (localStorage.getItem('darkMode') === 'true') {
                document.body.classList.add('dark-mode');
                updateThemeIcon();
            }
        }
    </script>
</body>
</html>
