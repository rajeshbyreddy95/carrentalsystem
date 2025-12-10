<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Cars - DriveHub Car Rental</title>
    
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    colors: {
                        primary: '#2563eb',
                        secondary: '#1e40af',
                    }
                }
            }
        }
    </script>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Sora:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Razorpay -->
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    
    <style>
        * { font-family: 'Sora', 'Poppins', sans-serif; }
        h1, h2, h3, h4, h5, h6 { font-family: 'Poppins', serif; font-weight: 700; }
        .card-hover { transition: all 0.3s ease; }
        .card-hover:hover { transform: translateY(-8px); box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1); }
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.4); }
        .modal.active { display: flex; }
        .modal-content { background-color: white; margin: auto; padding: 2rem; border-radius: 1rem; width: 90%; max-width: 600px; max-height: 90vh; overflow-y: auto; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); }
        .close-modal { float: right; font-size: 2rem; font-weight: bold; color: #999; cursor: pointer; }
        .close-modal:hover { color: #000; }
    </style>
</head>
<body class="bg-gray-50 dark:bg-gray-900">
    
    <!-- Navigation -->
    <nav class="bg-white dark:bg-gray-800 shadow sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4 flex justify-between items-center">
            <a href="/" class="flex items-center gap-2">
                <i class="fas fa-car text-blue-600 text-2xl"></i>
                <span class="text-xl font-bold text-gray-900 dark:text-white">DriveHub</span>
            </a>
            <div class="flex items-center gap-4">
                <a href="/" class="text-gray-700 dark:text-gray-300 hover:text-blue-600">Home</a>
                <button onclick="scrollToTop()" class="text-gray-700 dark:text-gray-300 hover:text-blue-600">Back to Top</button>
                <a href="/" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg">Home</a>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <div class="bg-gradient-to-r from-blue-600 to-blue-800 text-white py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <h1 class="text-5xl font-bold mb-4">Our Complete Fleet</h1>
            <p class="text-xl">Browse and book from our extensive selection of premium vehicles</p>
        </div>
    </div>

    <!-- Filter Section -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
            <div>
                <label class="block text-sm font-semibold mb-2">Category</label>
                <select id="categoryFilter" onchange="filterCars()" class="w-full px-4 py-2 border rounded-lg dark:bg-gray-700 dark:border-gray-600 dark:text-white">
                    <option value="">All Categories</option>
                    <option value="SUV">SUV</option>
                    <option value="Sedan">Sedan</option>
                    <option value="Hatchback">Hatchback</option>
                    <option value="Luxury">Luxury</option>
                    <option value="Sports">Sports</option>
                </select>
            </div>
            
            <div>
                <label class="block text-sm font-semibold mb-2">Transmission</label>
                <select id="transmissionFilter" onchange="filterCars()" class="w-full px-4 py-2 border rounded-lg dark:bg-gray-700 dark:border-gray-600 dark:text-white">
                    <option value="">All Types</option>
                    <option value="Automatic">Automatic</option>
                    <option value="Manual">Manual</option>
                </select>
            </div>
            
            <div>
                <label class="block text-sm font-semibold mb-2">Price Range</label>
                <select id="priceFilter" onchange="filterCars()" class="w-full px-4 py-2 border rounded-lg dark:bg-gray-700 dark:border-gray-600 dark:text-white">
                    <option value="">All Prices</option>
                    <option value="0-3000">₹0 - ₹3,000</option>
                    <option value="3000-6000">₹3,000 - ₹6,000</option>
                    <option value="6000-9000">₹6,000 - ₹9,000</option>
                    <option value="9000-99999">₹9,000+</option>
                </select>
            </div>
            
            <div>
                <label class="block text-sm font-semibold mb-2">Availability</label>
                <select id="availabilityFilter" onchange="filterCars()" class="w-full px-4 py-2 border rounded-lg dark:bg-gray-700 dark:border-gray-600 dark:text-white">
                    <option value="">All Cars</option>
                    <option value="available">Available Only</option>
                </select>
            </div>
        </div>
    </div>

    <!-- Cars Grid -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-12">
        <div id="carsContainer" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 2rem;">
            <div style="grid-column: 1 / -1; text-align: center; padding: 3rem 0;">
                <i class="fas fa-spinner fa-spin text-4xl text-blue-600 mb-4" style="display: block; margin-bottom: 1rem;"></i>
                <p class="text-gray-600 dark:text-gray-400">Loading vehicles...</p>
            </div>
        </div>
    </div>

    <!-- Booking Modal - Step 1: Car Details -->
    <div id="bookingModal" class="modal">
        <div class="modal-content">
            <span class="close-modal" onclick="closeBookingModal()">&times;</span>
            <h2 style="margin-top: 0; color: #111; font-size: 1.875rem; margin-bottom: 1.5rem;">Book Your Car</h2>
            
            <div id="step1Content">
                <div style="background: #f3f4f6; border-radius: 1rem; padding: 1.5rem; margin-bottom: 1.5rem;">
                    <img id="modalCarImage" src="" alt="Car" style="width: 100%; height: 250px; object-fit: cover; border-radius: 0.5rem; margin-bottom: 1rem;">
                    <h3 id="modalCarName" style="font-size: 1.5rem; color: #111; margin: 0.5rem 0;"></h3>
                    <p id="modalCarLocation" style="color: #666; margin: 0.5rem 0;"></p>
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 1rem;">
                        <div>
                            <span style="font-size: 1.5rem; font-weight: bold; color: #2563eb;">₹<span id="modalCarPrice"></span></span>
                            <span style="color: #666; margin-left: 0.5rem;">/day</span>
                        </div>
                        <div style="color: #fbbf24;">
                            <i class="fas fa-star"></i>
                            <span id="modalCarRating" style="color: #666; margin-left: 0.25rem;"></span>
                        </div>
                    </div>
                </div>
                
                <div style="margin-bottom: 1.5rem;">
                    <label style="display: block; font-weight: bold; margin-bottom: 0.5rem;">Pick-up Date</label>
                    <input type="date" id="pickupDate" style="width: 100%; padding: 0.75rem; border: 1px solid #ddd; border-radius: 0.5rem; font-size: 1rem;">
                </div>
                
                <div style="margin-bottom: 1.5rem;">
                    <label style="display: block; font-weight: bold; margin-bottom: 0.5rem;">Drop-off Date</label>
                    <input type="date" id="dropoffDate" style="width: 100%; padding: 0.75rem; border: 1px solid #ddd; border-radius: 0.5rem; font-size: 1rem;">
                </div>
                
                <div style="background: #fff3cd; border: 1px solid #ffc107; border-radius: 0.5rem; padding: 1rem; margin-bottom: 1.5rem; display: flex; gap: 0.75rem;">
                    <i class="fas fa-info-circle" style="color: #856404; margin-top: 0.25rem;"></i>
                    <span style="color: #856404;">Hurry up! Limited cars available. Book now and keep your journey plan safe!</span>
                </div>
                
                <button onclick="proceedToPayment()" style="width: 100%; background: linear-gradient(to right, #2563eb, #1d4ed8); color: white; font-weight: bold; padding: 0.875rem 1rem; border-radius: 0.75rem; border: none; font-size: 1rem; cursor: pointer;">
                    <i class="fas fa-arrow-right"></i> Next: Review & Pay
                </button>
            </div>
            
            <!-- Step 2: Payment Review -->
            <div id="step2Content" style="display: none;">
                <div style="background: #f3f4f6; border-radius: 1rem; padding: 1.5rem; margin-bottom: 1.5rem;">
                    <h3 style="color: #111; margin: 0 0 1rem 0;">Booking Summary</h3>
                    <div style="background: white; border-radius: 0.5rem; padding: 1rem; margin-bottom: 1rem;">
                        <div style="display: flex; justify-content: space-between; margin-bottom: 0.75rem;">
                            <span style="color: #666;">Car:</span>
                            <span id="summaryCarName" style="font-weight: bold; color: #111;"></span>
                        </div>
                        <div style="display: flex; justify-content: space-between; margin-bottom: 0.75rem;">
                            <span style="color: #666;">Pick-up:</span>
                            <span id="summaryPickup" style="font-weight: bold; color: #111;"></span>
                        </div>
                        <div style="display: flex; justify-content: space-between; margin-bottom: 0.75rem;">
                            <span style="color: #666;">Drop-off:</span>
                            <span id="summaryDropoff" style="font-weight: bold; color: #111;"></span>
                        </div>
                        <div style="display: flex; justify-content: space-between; margin-bottom: 0.75rem;">
                            <span style="color: #666;">Days:</span>
                            <span id="summaryDays" style="font-weight: bold; color: #111;"></span>
                        </div>
                        <hr style="border: none; border-top: 1px solid #ddd; margin: 1rem 0;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span style="font-size: 1.125rem; font-weight: bold; color: #111;">Total Amount:</span>
                            <span style="font-size: 1.875rem; font-weight: bold; color: #2563eb;">₹<span id="summaryTotal"></span></span>
                        </div>
                    </div>
                </div>
                
                <div style="background: #fff3cd; border: 1px solid #ffc107; border-radius: 0.5rem; padding: 1rem; margin-bottom: 1.5rem; display: flex; gap: 0.75rem;">
                    <i class="fas fa-lock" style="color: #856404; margin-top: 0.25rem;"></i>
                    <span style="color: #856404;">Keep your journey plan safe - Secure payment with Razorpay</span>
                </div>
                
                <div style="display: flex; gap: 1rem;">
                    <button onclick="goBackToStep1()" style="flex: 1; background: #6b7280; color: white; font-weight: bold; padding: 0.875rem 1rem; border-radius: 0.75rem; border: none; font-size: 1rem; cursor: pointer;">
                        <i class="fas fa-arrow-left"></i> Back
                    </button>
                    <button onclick="processPayment()" style="flex: 1; background: linear-gradient(to right, #10b981, #059669); color: white; font-weight: bold; padding: 0.875rem 1rem; border-radius: 0.75rem; border: none; font-size: 1rem; cursor: pointer;">
                        <i class="fas fa-credit-card"></i> Pay Now
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-gray-900 text-gray-400 py-12 mt-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <p>&copy; 2025 DriveHub. All rights reserved.</p>
        </div>
    </footer>

    <script>
        let allCars = [];
        let currentBookingCar = null;
        let RAZORPAY_KEY = '';

        // Fetch Razorpay key from server on page load
        async function loadRazorpayKey() {
            try {
                const response = await fetch('/api/config/razorpay-key');
                const data = await response.json();
                RAZORPAY_KEY = data.keyId;
            } catch (error) {
                console.error('Failed to load Razorpay key');
            }
        }

        // Check if user is admin
        function isAdmin() {
            const session = localStorage.getItem('userSession');
            if (!session) return false;
            try {
                const parsed = JSON.parse(session);
                return parsed.role === 'ADMIN';
            } catch (e) {
                return false;
            }
        }

        // Load cars from API
        async function loadCars() {
            try {
                const response = await fetch('/api/admin/cars');
                
                if (!response.ok) {
                    throw new Error('API returned status: ' + response.status);
                }
                
                const text = await response.text();
                allCars = JSON.parse(text);
                console.log('Cars loaded:', allCars.length);
                
                if (!Array.isArray(allCars)) {
                    console.error('API response is not an array:', allCars);
                    allCars = [];
                }
                
                displayCars(allCars);
            } catch (error) {
                console.error('Error loading cars:', error);
                document.getElementById('carsContainer').innerHTML = '<div style="grid-column: 1 / -1; text-align: center; padding: 3rem 0;"><div style="color: #dc2626;"><p style="font-size: 1.125rem; font-weight: bold; margin: 0 0 0.5rem 0;">Failed to load cars</p><p style="font-size: 0.875rem;">' + error.message + '</p></div></div>';
            }
        }

        // Display cars
        function displayCars(cars) {
            const container = document.getElementById('carsContainer');
            console.log('displayCars called with', cars.length, 'cars');
            
            if (!cars || cars.length === 0) {
                container.innerHTML = '<div style="grid-column: 1 / -1; text-align: center; padding: 3rem 0;"><p style="color: #999;">No cars found matching your filters</p></div>';
                return;
            }
            
            let html = '';
            const admin = isAdmin();
            
            cars.forEach((car, index) => {
                const carName = car.brand + ' ' + car.model;
                const placeholderUrl = 'https://via.placeholder.com/400x300?text=' + encodeURIComponent(carName);
                const imageUrl = car.imageUrl && car.imageUrl.trim() ? car.imageUrl : placeholderUrl;
                const availabilityBg = car.available ? '#10b981' : '#ef4444';
                const availabilityText = car.available ? 'Available' : 'Rented';
                const priceDisplay = Math.round(car.pricePerDay);
                const ratingDisplay = car.rating > 0 ? car.rating.toFixed(1) : 'N/A';
                
                let buttonHtml = '';
                if (admin) {
                    buttonHtml = '<button onclick="editCar(' + car.id + ')" style="width: 100%; background: linear-gradient(to right, #f59e0b, #d97706); color: white; font-weight: bold; padding: 0.75rem 1rem; border-radius: 0.75rem; transition: all 0.2s ease; border: none; display: flex; align-items: center; justify-content: center; gap: 0.5rem; cursor: pointer;" onmouseover="this.style.transform=\'translateY(-2px)\';" onmouseout="this.style.transform=\'translateY(0)\';"><i class="fas fa-edit"></i>Edit Car</button>';
                } else {
                    const buttonBg = car.available ? 'linear-gradient(to right, #2563eb, #1d4ed8)' : '#9ca3af';
                    const buttonText = car.available ? 'Book Now' : 'Not Available';
                    const buttonOnClick = car.available ? 'onclick="openBookingModal(' + car.id + ')"' : 'disabled';
                    buttonHtml = '<button ' + buttonOnClick + ' style="width: 100%; background: ' + buttonBg + '; color: white; font-weight: bold; padding: 0.75rem 1rem; border-radius: 0.75rem; transition: all 0.2s ease; border: none; display: flex; align-items: center; justify-content: center; gap: 0.5rem; cursor: ' + (car.available ? 'pointer' : 'not-allowed') + ';" onmouseover="if(' + car.available + ') this.style.transform=\'translateY(-2px)\';" onmouseout="this.style.transform=\'translateY(0)\';"><i class="fas fa-calendar-check"></i>' + buttonText + '</button>';
                }

                html += '<div style="background: white; border-radius: 1rem; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.1); border: 1px solid #e5e7eb; transition: all 0.3s ease;">' +
                    '<div style="position: relative; overflow: hidden; height: 12rem; background: #e5e7eb;">' +
                    '<img src="' + imageUrl + '" alt="' + carName + '" style="width: 100%; height: 100%; object-fit: cover; transition: transform 0.3s ease;" loading="lazy" onerror="this.src=\'' + placeholderUrl + '\'">' +
                    '<div style="position: absolute; top: 1rem; right: 1rem; background: ' + availabilityBg + '; color: white; border-radius: 9999px; padding: 0.25rem 1rem; font-size: 0.875rem; font-weight: bold;">' +
                    availabilityText +
                    '</div>' +
                    '</div>' +
                    '<div style="padding: 1.5rem;">' +
                    '<h3 style="font-size: 1.5rem; font-weight: bold; color: #111; margin: 0 0 0.5rem 0;">' + carName + '</h3>' +
                    '<div style="display: flex; flex-wrap: wrap; gap: 0.5rem; margin-bottom: 1rem; font-size: 0.875rem;">' +
                    '<span style="background: #dbeafe; color: #1e40af; padding: 0.25rem 0.75rem; border-radius: 9999px;">' +
                    car.category +
                    '</span>' +
                    '<span style="color: #666;">' + car.seats + ' Seats</span>' +
                    '<span style="color: #666;">' + car.transmission + '</span>' +
                    '</div>' +
                    '<p style="font-size: 0.875rem; color: #666; margin: 0 0 1rem 0;">' + car.location + '</p>' +
                    '<div style="border-top: 1px solid #e5e7eb; padding-top: 1rem; margin-bottom: 1rem;">' +
                    '<div style="display: flex; justify-content: space-between; align-items: center;">' +
                    '<div>' +
                    '<span style="font-size: 1.875rem; font-weight: 900; color: #2563eb;">₹' + priceDisplay + '</span>' +
                    '<span style="font-size: 0.875rem; color: #666; margin-left: 0.5rem;">/day</span>' +
                    '</div>' +
                    '<div style="display: flex; align-items: center; color: #fbbf24;">' +
                    '<i class="fas fa-star"></i>' +
                    '<span style="color: #666; margin-left: 0.25rem;">' + ratingDisplay + '</span>' +
                    '</div>' +
                    '</div>' +
                    '</div>' +
                    buttonHtml +
                    '</div>' +
                    '</div>';
            });
            
            container.innerHTML = html;
        }

        // Filter cars
        function filterCars() {
            const category = document.getElementById('categoryFilter').value;
            const transmission = document.getElementById('transmissionFilter').value;
            const priceRange = document.getElementById('priceFilter').value;
            const availability = document.getElementById('availabilityFilter').value;

            let filtered = allCars;

            if (category) filtered = filtered.filter(c => c.category === category);
            if (transmission) filtered = filtered.filter(c => c.transmission === transmission);
            if (availability === 'available') filtered = filtered.filter(c => c.available);

            if (priceRange) {
                const [min, max] = priceRange.split('-').map(Number);
                filtered = filtered.filter(c => c.pricePerDay >= min && c.pricePerDay <= max);
            }

            displayCars(filtered);
        }

        // Edit car (admin)
        function editCar(carId) {
            alert('Edit car feature coming soon! Car ID: ' + carId);
            // TODO: Redirect to edit page or open edit modal
        }

        // Open booking modal
        function openBookingModal(carId) {
            const session = localStorage.getItem('userSession');
            if (!session) {
                window.location.href = '/login';
                return;
            }
            
            currentBookingCar = allCars.find(c => c.id === carId);
            if (!currentBookingCar) return;
            
            const carName = currentBookingCar.brand + ' ' + currentBookingCar.model;
            const priceDisplay = Math.round(currentBookingCar.pricePerDay);
            const ratingDisplay = currentBookingCar.rating > 0 ? currentBookingCar.rating.toFixed(1) : 'N/A';
            
            document.getElementById('modalCarImage').src = currentBookingCar.imageUrl || 'https://via.placeholder.com/400x300?text=' + encodeURIComponent(carName);
            document.getElementById('modalCarName').innerText = carName;
            document.getElementById('modalCarLocation').innerText = '📍 ' + currentBookingCar.location;
            document.getElementById('modalCarPrice').innerText = priceDisplay;
            document.getElementById('modalCarRating').innerText = ratingDisplay;
            
            document.getElementById('pickupDate').min = new Date().toISOString().split('T')[0];
            document.getElementById('pickupDate').value = new Date().toISOString().split('T')[0];
            document.getElementById('dropoffDate').min = new Date(Date.now() + 86400000).toISOString().split('T')[0];
            document.getElementById('dropoffDate').value = new Date(Date.now() + 86400000).toISOString().split('T')[0];
            
            document.getElementById('step1Content').style.display = 'block';
            document.getElementById('step2Content').style.display = 'none';
            document.getElementById('bookingModal').classList.add('active');
        }

        // Close booking modal
        function closeBookingModal() {
            document.getElementById('bookingModal').classList.remove('active');
            currentBookingCar = null;
        }

        // Proceed to payment
        function proceedToPayment() {
            const pickupDate = document.getElementById('pickupDate').value;
            const dropoffDate = document.getElementById('dropoffDate').value;
            
            if (!pickupDate || !dropoffDate) {
                alert('Please select both pick-up and drop-off dates');
                return;
            }
            
            if (new Date(pickupDate) >= new Date(dropoffDate)) {
                alert('Drop-off date must be after pick-up date');
                return;
            }
            
            const pickup = new Date(pickupDate);
            const dropoff = new Date(dropoffDate);
            const days = Math.ceil((dropoff - pickup) / (1000 * 60 * 60 * 24));
            const pricePerDay = Math.round(currentBookingCar.pricePerDay);
            const totalAmount = days * pricePerDay;
            
            document.getElementById('summaryCarName').innerText = currentBookingCar.brand + ' ' + currentBookingCar.model;
            document.getElementById('summaryPickup').innerText = new Date(pickupDate).toLocaleDateString();
            document.getElementById('summaryDropoff').innerText = new Date(dropoffDate).toLocaleDateString();
            document.getElementById('summaryDays').innerText = days + ' day(s)';
            document.getElementById('summaryTotal').innerText = totalAmount;
            
            document.getElementById('step1Content').style.display = 'none';
            document.getElementById('step2Content').style.display = 'block';
        }

        // Go back to step 1
        function goBackToStep1() {
            document.getElementById('step1Content').style.display = 'block';
            document.getElementById('step2Content').style.display = 'none';
        }

        // Process payment with Razorpay
        function processPayment() {
            const pickupDate = document.getElementById('pickupDate').value;
            const dropoffDate = document.getElementById('dropoffDate').value;
            const pickup = new Date(pickupDate);
            const dropoff = new Date(dropoffDate);
            const days = Math.ceil((dropoff - pickup) / (1000 * 60 * 60 * 24));
            const pricePerDay = Math.round(currentBookingCar.pricePerDay);
            const totalAmount = days * pricePerDay;
            const amountInPaise = totalAmount * 100;
            
            const options = {
                key: RAZORPAY_KEY,
                amount: amountInPaise,
                currency: 'INR',
                name: 'DriveHub Car Rental',
                description: currentBookingCar.brand + ' ' + currentBookingCar.model + ' - ' + days + ' day(s)',
                image: 'https://via.placeholder.com/100?text=DriveHub',
                handler: function(response) {
                    createBooking(response.razorpay_payment_id);
                },
                prefill: {
                    email: JSON.parse(localStorage.getItem('userSession')).email || '',
                    name: JSON.parse(localStorage.getItem('userSession')).email || ''
                },
                theme: {
                    color: '#2563eb'
                },
                modal: {
                    ondismiss: function() {
                        alert('Payment cancelled');
                    }
                }
            };
            
            const razorpay = new Razorpay(options);
            razorpay.open();
        }

        // Create booking after payment
        function createBooking(paymentId) {
            const pickupDate = document.getElementById('pickupDate').value;
            const dropoffDate = document.getElementById('dropoffDate').value;
            const session = JSON.parse(localStorage.getItem('userSession'));
            
            const bookingData = {
                carId: currentBookingCar.id,
                userId: session.email,
                pickupDate: pickupDate,
                dropoffDate: dropoffDate,
                paymentId: paymentId,
                totalAmount: document.getElementById('summaryTotal').innerText
            };
            
            fetch('/api/user/booking/create', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(bookingData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Booking confirmed! Payment ID: ' + paymentId);
                    closeBookingModal();
                    loadCars();
                } else {
                    alert('Booking creation failed: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error creating booking');
            });
        }

        // Scroll to top
        function scrollToTop() {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('bookingModal');
            if (event.target === modal) {
                closeBookingModal();
            }
        }

        // Initialize
        window.addEventListener('DOMContentLoaded', async () => {
            await loadRazorpayKey();
            loadCars();
        });
    </script>
</body>
</html>
