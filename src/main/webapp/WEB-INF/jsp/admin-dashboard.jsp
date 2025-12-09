<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - DriveHub</title>
    
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class'
        }
    </script>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        body { font-family: 'Poppins', sans-serif; }
    </style>
</head>
<body class="bg-gray-50">
    
    <!-- Navigation -->
    <nav class="bg-white shadow-lg sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-4 py-3 flex justify-between items-center">
            <div class="flex items-center gap-3">
                <i class="fas fa-car text-blue-600 text-2xl"></i>
                <h1 class="text-xl font-bold text-gray-900">DriveHub Admin</h1>
            </div>
            <div class="flex items-center gap-4">
                <span class="text-gray-600">Admin</span>
                <button onclick="logout()" class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg">
                    <i class="fas fa-sign-out-alt mr-2"></i>Logout
                </button>
            </div>
        </div>
    </nav>

    <!-- Admin Profile Section -->
    <div class="max-w-7xl mx-auto p-6">
        <div class="bg-white rounded-lg shadow p-6 mb-8">
            <div class="flex items-center justify-between">
                <div class="flex items-center gap-4">
                    <div class="w-16 h-16 bg-blue-600 rounded-full flex items-center justify-center">
                        <i class="fas fa-user text-white text-2xl"></i>
                    </div>
                    <div>
                        <h2 class="text-2xl font-bold">Administrator</h2>
                        <p class="text-gray-600">admin@driverhub.com</p>
                        <p class="text-gray-600">0000000000</p>
                    </div>
                </div>
                <div class="text-right">
                    <p class="text-2xl font-bold text-blue-600" id="totalUsers">0</p>
                    <p class="text-gray-600">Total Users</p>
                </div>
            </div>
        </div>
        
        <!-- Dashboard Overview Stats -->
        <div class="bg-white rounded-lg shadow p-8 mb-8">
            <h3 class="text-2xl font-bold mb-6">Dashboard Overview</h3>
            <div class="grid grid-cols-2 md:grid-cols-5 gap-6">
                <div class="text-center">
                    <p class="text-4xl font-bold text-blue-600" id="statTotalBookings">0</p>
                    <p class="text-gray-600 text-sm mt-2">Total Bookings</p>
                </div>
                <div class="text-center">
                    <p class="text-4xl font-bold text-green-600" id="statCompletedBookings">0</p>
                    <p class="text-gray-600 text-sm mt-2">Completed Bookings</p>
                </div>
                <div class="text-center">
                    <p class="text-4xl font-bold text-purple-600" id="statActiveBookings">0</p>
                    <p class="text-gray-600 text-sm mt-2">Active Bookings</p>
                </div>
                <div class="text-center">
                    <p class="text-4xl font-bold text-orange-600" id="statTotalVehicles">0</p>
                    <p class="text-gray-600 text-sm mt-2">Vehicles</p>
                </div>
                <div class="text-center">
                    <p class="text-4xl font-bold text-red-600" id="statRevenue">₹0L</p>
                    <p class="text-gray-600 text-sm mt-2">Revenue</p>
                </div>
            </div>
        </div>

        <!-- Detailed Stats Cards -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
            <div class="bg-white rounded-lg shadow p-6 border-l-4 border-blue-600">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-gray-600 text-sm">Active Bookings</p>
                        <p class="text-3xl font-bold text-blue-600" id="activeBookingsCard">0</p>
                        <p class="text-green-600 text-xs mt-2" id="activeBookingsChange">+0% from last week</p>
                    </div>
                    <i class="fas fa-spinner text-blue-600 text-3xl"></i>
                </div>
            </div>
            
            <div class="bg-white rounded-lg shadow p-6 border-l-4 border-green-600">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-gray-600 text-sm">Completed Bookings</p>
                        <p class="text-3xl font-bold text-green-600" id="completedBookingsCard">0</p>
                        <p class="text-green-600 text-xs mt-2" id="completedBookingsChange">+0% from last month</p>
                    </div>
                    <i class="fas fa-check-circle text-green-600 text-3xl"></i>
                </div>
            </div>
            
            <div class="bg-white rounded-lg shadow p-6 border-l-4 border-purple-600">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-gray-600 text-sm">Monthly Revenue</p>
                        <p class="text-3xl font-bold text-purple-600" id="monthlyRevenue">₹0L</p>
                        <p class="text-green-600 text-xs mt-2" id="revenueChange">+0% from last month</p>
                    </div>
                    <i class="fas fa-chart-line text-purple-600 text-3xl"></i>
                </div>
            </div>
            
            <div class="bg-white rounded-lg shadow p-6 border-l-4 border-orange-600">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-gray-600 text-sm">New Users</p>
                        <p class="text-3xl font-bold text-orange-600" id="newUsersCard">0</p>
                        <p class="text-green-600 text-xs mt-2" id="newUsersChange">+0% from last week</p>
                    </div>
                    <i class="fas fa-user-plus text-orange-600 text-3xl"></i>
                </div>
            </div>
        </div>

        <!-- Tabs -->
        <div class="bg-white rounded-lg shadow mb-6">
            <div class="flex border-b">
                <button onclick="switchTab('cars')" id="carsTab" class="px-6 py-3 font-semibold text-blue-600 border-b-2 border-blue-600">
                    <i class="fas fa-car mr-2"></i>Cars Management
                </button>
                <button onclick="switchTab('bookings')" id="bookingsTab" class="px-6 py-3 font-semibold text-gray-600 hover:text-blue-600">
                    <i class="fas fa-calendar-check mr-2"></i>Bookings
                </button>
                <button onclick="switchTab('users')" id="usersTab" class="px-6 py-3 font-semibold text-gray-600 hover:text-blue-600">
                    <i class="fas fa-users mr-2"></i>Users
                </button>
            </div>
        </div>

        <!-- Cars Tab -->
        <div id="carsContent" class="bg-white rounded-lg shadow p-6">
            <div class="flex justify-between items-center mb-6">
                <h2 class="text-2xl font-bold">Cars Management</h2>
                <button onclick="showAddCarModal()" class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-2 rounded-lg">
                    <i class="fas fa-plus mr-2"></i>Add New Car
                </button>
            </div>
            
            <div id="carsList" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <!-- Cars will be loaded here -->
            </div>
        </div>

        <!-- Bookings Tab -->
        <div id="bookingsContent" class="hidden bg-white rounded-lg shadow p-6">
            <div class="flex justify-between items-center mb-6">
                <h2 class="text-2xl font-bold">All Bookings</h2>
                <button onclick="refreshBookings()" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg flex items-center gap-2 transition">
                    <i class="fas fa-sync-alt" id="refreshIcon"></i>
                    <span>Refresh</span>
                </button>
            </div>
            <div id="bookingsList">
                <!-- Bookings will be loaded here -->
            </div>
        </div>

        <!-- Users Tab -->
        <div id="usersContent" class="hidden bg-white rounded-lg shadow p-6">
            <h2 class="text-2xl font-bold mb-6">Registered Users</h2>
            <div id="usersList">
                <!-- Users will be loaded here -->
            </div>
        </div>
    </div>

    <!-- Add Car Modal -->
    <div id="addCarModal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
        <div class="bg-white rounded-lg p-8 max-w-2xl w-full max-h-[90vh] overflow-y-auto">
            <div class="flex justify-between items-center mb-6">
                <h3 class="text-2xl font-bold">Add New Car</h3>
                <button onclick="closeAddCarModal()" class="text-gray-500 hover:text-gray-700">
                    <i class="fas fa-times text-2xl"></i>
                </button>
            </div>
            
            <form id="addCarForm" class="space-y-4" enctype="multipart/form-data">
                <div class="grid grid-cols-2 gap-4">
                    <!-- Essential fields only to avoid Tomcat 10-part limit -->
                    <div>
                        <label class="block text-sm font-semibold mb-2">Brand</label>
                        <input type="text" name="brand" required class="w-full px-4 py-2 border rounded-lg">
                    </div>
                    <div>
                        <label class="block text-sm font-semibold mb-2">Model</label>
                        <input type="text" name="model" required class="w-full px-4 py-2 border rounded-lg">
                    </div>
                    <div>
                        <label class="block text-sm font-semibold mb-2">Category</label>
                        <select name="category" required class="w-full px-4 py-2 border rounded-lg">
                            <option value="SUV">SUV</option>
                            <option value="Sedan">Sedan</option>
                            <option value="Hatchback">Hatchback</option>
                            <option value="Luxury">Luxury</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-semibold mb-2">Transmission</label>
                        <select name="transmission" required class="w-full px-4 py-2 border rounded-lg">
                            <option value="Automatic">Automatic</option>
                            <option value="Manual">Manual</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-semibold mb-2">Price Per Day (₹)</label>
                        <input type="number" name="pricePerDay" required min="100" step="1" class="w-full px-4 py-2 border rounded-lg">
                    </div>
                    <div>
                        <label class="block text-sm font-semibold mb-2">Registration Number</label>
                        <input type="text" name="registrationNumber" required class="w-full px-4 py-2 border rounded-lg">
                    </div>
                    <div class="col-span-2">
                        <label class="block text-sm font-semibold mb-2">Location</label>
                        <select name="location" required class="w-full px-4 py-2 border rounded-lg">
                            <option value="">-- Select Location --</option>
                            <option value="Mumbai - 5+ Locations">Mumbai - 5+ Locations</option>
                            <option value="Delhi - 4+ Locations">Delhi - 4+ Locations</option>
                            <option value="Hyderabad - 3+ Locations">Hyderabad - 3+ Locations</option>
                            <option value="Bangalore - 3+ Locations">Bangalore - 3+ Locations</option>
                        </select>
                    </div>
                    <div class="col-span-2">
                        <label class="block text-sm font-semibold mb-2">Description</label>
                        <textarea name="description" required rows="3" placeholder="Car features and details..." class="w-full px-4 py-2 border rounded-lg"></textarea>
                    </div>
                    <div class="col-span-2">
                        <label class="block text-sm font-semibold mb-2">Car Image (Required)</label>
                        <input type="file" name="carImage" required accept="image/*" class="w-full px-4 py-2 border rounded-lg">
                    </div>
                </div>
                
                <button id="addCarSubmitBtn" type="submit" class="w-full bg-blue-600 hover:bg-blue-700 text-white py-3 rounded-lg font-semibold transition">
                    <i id="submitBtnIcon" class="fas fa-plus mr-2"></i>
                    <span id="submitBtnText">Add Car</span>
                </button>
                
                <!-- Loading Message -->
                <div id="loadingMessage" class="hidden text-center py-4">
                    <div class="flex items-center justify-center gap-3">
                        <i class="fas fa-spinner fa-spin text-xl text-blue-600"></i>
                        <span class="text-gray-700 font-semibold">Adding car, please wait...</span>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Toast Notification -->
    <div id="toast" class="hidden fixed bottom-4 right-4 bg-gray-900 text-white px-6 py-4 rounded-lg shadow-lg z-50">
        <span id="toastMessage"></span>
    </div>

    <script>
        // Check admin session
        function checkAdminSession() {
            const session = localStorage.getItem('userSession');
            if (!session) {
                window.location.href = '/login';
                return false;
            }
            
            try {
                const sessionData = JSON.parse(session);
                if (sessionData.role !== 'ADMIN') {
                    window.location.href = '/';
                    return false;
                }
                return true;
            } catch (error) {
                window.location.href = '/login';
                return false;
            }
        }

        // Initialize dashboard
        async function initDashboard() {
            if (!checkAdminSession()) return;
            
            await loadCars();
            await loadBookings();
            await loadUsers();
            await loadStats();
        }

        // Load all cars
        async function loadCars() {
            try {
                const response = await fetch('/api/admin/cars');
                const cars = await response.json();
                
                const carsList = document.getElementById('carsList');
                carsList.innerHTML = '';
                
                cars.forEach(car => {
                    const availabilityClass = car.available ? 'bg-green-100 text-green-600' : 'bg-red-100 text-red-600';
                    const availabilityText = car.available ? 'Available' : 'Rented';
                    
                    carsList.innerHTML += '<div class="border rounded-lg overflow-hidden shadow-sm hover:shadow-lg transition">' +
                        '<img src="' + car.imageUrl + '" alt="' + car.brand + ' ' + car.model + '" class="w-full h-48 object-cover">' +
                        '<div class="p-4">' +
                        '<h3 class="font-bold text-lg">' + car.brand + ' ' + car.model + '</h3>' +
                        '<p class="text-gray-600 text-sm">' + car.category + ' · ' + car.transmission + ' · ' + car.seats + ' Seats</p>' +
                        '<p class="text-gray-600 text-sm mb-2">' + car.location + '</p>' +
                        '<p class="text-blue-600 font-bold text-xl mb-3">₹' + car.pricePerDay + '/day</p>' +
                        '<div class="flex gap-2 mb-3">' +
                        '<span class="px-3 py-1 text-xs rounded-full ' + availabilityClass + '">' + availabilityText + '</span>' +
                        '<span class="px-3 py-1 text-xs rounded-full bg-gray-100 text-gray-600">' + (car.totalBookings || 0) + ' bookings</span>' +
                        '</div>' +
                        '<div class="flex gap-2">' +
                        '<button onclick="toggleAvailability(' + car.id + ')" class="flex-1 bg-yellow-500 hover:bg-yellow-600 text-white py-2 rounded text-sm">Toggle Status</button>' +
                        '<button onclick="deleteCar(' + car.id + ')" class="flex-1 bg-red-500 hover:bg-red-600 text-white py-2 rounded text-sm">Delete</button>' +
                        '</div>' +
                        '</div>' +
                        '</div>';
                });
            } catch (error) {
                showToast('Failed to load cars');
            }
        }

        // Load all bookings
        async function loadBookings() {
            try {
                const response = await fetch('/api/admin/bookings');
                const bookings = await response.json();
                
                const bookingsList = document.getElementById('bookingsList');
                bookingsList.innerHTML = '';
                
                if (bookings.length === 0) {
                    bookingsList.innerHTML = '<p class="text-gray-500">No bookings yet</p>';
                    return;
                }
                
                bookings.forEach(booking => {
                    let statusClass = 'bg-blue-100 text-blue-600';
                    if (booking.status == 'CONFIRMED') {
                        statusClass = 'bg-green-100 text-green-600';
                    } else if (booking.status == 'PENDING') {
                        statusClass = 'bg-yellow-100 text-yellow-600';
                    } else if (booking.status == 'CANCELLED') {
                        statusClass = 'bg-red-100 text-red-600';
                    } else if (booking.status == 'COMPLETED') {
                        statusClass = 'bg-purple-100 text-purple-600';
                    }
                    
                    bookingsList.innerHTML += '<div class="border rounded-lg p-4 mb-4">' +
                        '<div class="flex justify-between items-start">' +
                        '<div>' +
                        '<p class="font-semibold">Booking #' + booking.id + '</p>' +
                        '<p class="text-sm text-gray-600">User: ' + booking.userEmail + '</p>' +
                        '<p class="text-sm text-gray-600">Pickup: ' + booking.pickupDate + ' | Dropoff: ' + booking.dropoffDate + '</p>' +
                        '<p class="text-sm text-gray-600">Total: ₹' + booking.totalCost + ' (' + booking.totalDays + ' days)</p>' +
                        '</div>' +
                        '<div class="text-right">' +
                        '<span class="px-3 py-1 rounded-full text-xs font-semibold ' + statusClass + '">' +
                        booking.status +
                        '</span>' +
                        '<p class="text-sm text-gray-600 mt-2">Payment: ' + booking.paymentStatus + '</p>' +
                        '</div>' +
                        '</div>' +
                        '</div>';
                });
            } catch (error) {
                showToast('Failed to load bookings');
            }
        }

        // Refresh bookings with loading indicator
        async function refreshBookings() {
            const refreshIcon = document.getElementById('refreshIcon');
            refreshIcon.classList.add('animate-spin');
            
            try {
                await loadBookings();
                showToast('Bookings refreshed successfully');
            } catch (error) {
                showToast('Failed to refresh bookings');
            } finally {
                refreshIcon.classList.remove('animate-spin');
            }
        }

        // Load all users
        async function loadUsers() {
            try {
                const response = await fetch('/api/admin/users');
                const users = await response.json();
                
                const usersList = document.getElementById('usersList');
                usersList.innerHTML = '';
                
                if (users.length === 0) {
                    usersList.innerHTML = '<p class="text-gray-500">No registered users yet</p>';
                    return;
                }
                
                // Create table
                let tableHtml = '<div class="overflow-x-auto">' +
                    '<table class="min-w-full divide-y divide-gray-200">' +
                    '<thead class="bg-gray-50">' +
                    '<tr>' +
                    '<th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">User</th>' +
                    '<th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Contact</th>' +
                    '<th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Documents</th>' +
                    '<th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Role</th>' +
                    '</tr>' +
                    '</thead>' +
                    '<tbody class="bg-white divide-y divide-gray-200" id="usersTableBody">';
                
                usersList.innerHTML = tableHtml;
                
                const tbody = document.getElementById('usersTableBody');
                users.forEach(user => {
                    const licenseStatus = user.drivingLicenseUrl ? '<span class="px-2 py-1 text-xs bg-green-100 text-green-600 rounded">✓ License</span>' : '<span class="px-2 py-1 text-xs bg-gray-100 text-gray-600 rounded">✗ License</span>';
                    const aadhaarStatus = user.aadhaarPhotoUrl ? '<span class="px-2 py-1 text-xs bg-green-100 text-green-600 rounded ml-1">✓ Aadhaar</span>' : '<span class="px-2 py-1 text-xs bg-gray-100 text-gray-600 rounded ml-1">✗ Aadhaar</span>';
                    const roleClass = user.role == 'ADMIN' ? 'bg-purple-100 text-purple-600' : 'bg-blue-100 text-blue-600';
                    
                    tbody.innerHTML += '<tr class="hover:bg-gray-50">' +
                        '<td class="px-6 py-4 whitespace-nowrap">' +
                        '<div class="flex items-center">' +
                        '<div class="flex-shrink-0 h-10 w-10 bg-blue-100 rounded-full flex items-center justify-center">' +
                        '<i class="fas fa-user text-blue-600"></i>' +
                        '</div>' +
                        '<div class="ml-4">' +
                        '<div class="text-sm font-medium text-gray-900">' + (user.fullName || 'N/A') + '</div>' +
                        '<div class="text-sm text-gray-500">' + user.email + '</div>' +
                        '</div>' +
                        '</div>' +
                        '</td>' +
                        '<td class="px-6 py-4 whitespace-nowrap">' +
                        '<div class="text-sm text-gray-900">' + (user.mobileNumber || 'N/A') + '</div>' +
                        '<div class="text-sm text-gray-500">PAN: ' + (user.panNumber || 'N/A') + '</div>' +
                        '</td>' +
                        '<td class="px-6 py-4 whitespace-nowrap text-sm">' +
                        licenseStatus + ' ' + aadhaarStatus +
                        '</td>' +
                        '<td class="px-6 py-4 whitespace-nowrap">' +
                        '<span class="px-3 py-1 text-xs rounded-full ' + roleClass + '">' +
                        (user.role || 'USER') +
                        '</span>' +
                        '</td>' +
                        '</tr>';
                });
                
                tbody.innerHTML += '</tbody></table></div>';
            } catch (error) {
                showToast('Failed to load users');
            }
        }

        // Load stats
        async function loadStats() {
            try {
                const [carsRes, bookingsRes, usersRes] = await Promise.all([
                    fetch('/api/admin/cars'),
                    fetch('/api/admin/bookings'),
                    fetch('/api/admin/users')
                ]);
                
                const cars = await carsRes.json();
                const bookings = await bookingsRes.json();
                const users = await usersRes.json();
                
                // Dashboard Overview Stats
                const totalBookings = bookings.length;
                const completedBookings = bookings.filter(b => b.status === 'COMPLETED').length;
                const activeBookings = bookings.filter(b => b.status === 'CONFIRMED' || b.status === 'ACTIVE').length;
                const totalVehicles = cars.length;
                
                // Calculate revenue from completed bookings
                const totalRevenue = bookings
                    .filter(b => b.status === 'COMPLETED')
                    .reduce((sum, b) => sum + (b.totalCost || 0), 0);
                const revenueInLakh = (totalRevenue / 100000).toFixed(1);
                
                // Calculate new users (for demo, we'll show total users)
                const totalUsers = users.length;
                
                // Update main stats
                document.getElementById('statTotalBookings').textContent = totalBookings;
                document.getElementById('statCompletedBookings').textContent = completedBookings;
                document.getElementById('statActiveBookings').textContent = activeBookings;
                document.getElementById('statTotalVehicles').textContent = totalVehicles;
                document.getElementById('statRevenue').textContent = '₹' + revenueInLakh + 'L';
                document.getElementById('totalUsers').textContent = totalUsers;
                
                // Update detailed cards
                document.getElementById('activeBookingsCard').textContent = activeBookings;
                document.getElementById('completedBookingsCard').textContent = completedBookings;
                document.getElementById('monthlyRevenue').textContent = '₹' + revenueInLakh + 'L';
                document.getElementById('newUsersCard').textContent = totalUsers;
                
                // Update percentage changes (mock data for now)
                document.getElementById('activeBookingsChange').textContent = '+5.2% from last week';
                document.getElementById('completedBookingsChange').textContent = '+12.5% from last month';
                document.getElementById('revenueChange').textContent = '+8.3% from last month';
                document.getElementById('newUsersChange').textContent = '+15.2% from last week';
            } catch (error) {
                console.error('Failed to load stats');
            }
        }

        // Switch tabs
        function switchTab(tab) {
            // Hide all content
            document.getElementById('carsContent').classList.add('hidden');
            document.getElementById('bookingsContent').classList.add('hidden');
            document.getElementById('usersContent').classList.add('hidden');
            
            // Remove active class from all tabs
            document.getElementById('carsTab').className = 'px-6 py-3 font-semibold text-gray-600 hover:text-blue-600';
            document.getElementById('bookingsTab').className = 'px-6 py-3 font-semibold text-gray-600 hover:text-blue-600';
            document.getElementById('usersTab').className = 'px-6 py-3 font-semibold text-gray-600 hover:text-blue-600';
            
            // Show selected content and activate tab
            document.getElementById(tab + 'Content').classList.remove('hidden');
            document.getElementById(tab + 'Tab').className = 'px-6 py-3 font-semibold text-blue-600 border-b-2 border-blue-600';
        }

        // Show add car modal
        function showAddCarModal() {
            document.getElementById('addCarModal').classList.remove('hidden');
        }

        // Close add car modal
        function closeAddCarModal() {
            document.getElementById('addCarModal').classList.add('hidden');
            document.getElementById('addCarForm').reset();
        }

        // Add car form submission handler
        function setupFormHandler() {
            document.getElementById('addCarForm').addEventListener('submit', async (e) => {
                e.preventDefault();
                
                // Show loading state
                const submitBtn = document.getElementById('addCarSubmitBtn');
                const submitBtnIcon = document.getElementById('submitBtnIcon');
                const submitBtnText = document.getElementById('submitBtnText');
                const loadingMessage = document.getElementById('loadingMessage');
                
                submitBtn.disabled = true;
                submitBtnIcon.className = 'fas fa-spinner fa-spin mr-2';
                submitBtnText.textContent = 'Adding...';
                loadingMessage.classList.remove('hidden');
                
                const formData = new FormData(e.target);
                
                try {
                    const response = await fetch('/api/admin/cars/add', {
                        method: 'POST',
                        body: formData
                    });
                    
                    const result = await response.text();
                    
                    if (result.includes('success')) {
                        showToast('Car added successfully!');
                        closeAddCarModal();
                        await loadCars();
                        await loadStats();
                    } else {
                        showToast(result);
                    }
                } catch (error) {
                    showToast('Failed to add car');
                } finally {
                    // Hide loading state
                    submitBtn.disabled = false;
                    submitBtnIcon.className = 'fas fa-plus mr-2';
                    submitBtnText.textContent = 'Add Car';
                    loadingMessage.classList.add('hidden');
                }
            });
        }

        // Toggle car availability
        async function toggleAvailability(carId) {
            try {
                const response = await fetch('/api/admin/cars/toggle-availability/' + carId, {
                    method: 'POST'
                });
                
                const result = await response.text();
                showToast(result);
                await loadCars();
                await loadStats();
            } catch (error) {
                showToast('Failed to update car availability');
            }
        }

        // Delete car
        async function deleteCar(carId) {
            if (!confirm('Are you sure you want to delete this car?')) return;
            
            try {
                const response = await fetch('/api/admin/cars/delete/' + carId, {
                    method: 'DELETE'
                });
                
                const result = await response.text();
                showToast(result);
                await loadCars();
                await loadStats();
            } catch (error) {
                showToast('Failed to delete car');
            }
        }

        // Show toast
        function showToast(message) {
            const toast = document.getElementById('toast');
            document.getElementById('toastMessage').textContent = message;
            toast.classList.remove('hidden');
            setTimeout(() => toast.classList.add('hidden'), 3000);
        }

        // Logout
        function logout() {
            if (confirm('Are you sure you want to logout?')) {
                localStorage.removeItem('userSession');
                window.location.href = '/login';
            }
        }

        // Initialize on load
        window.addEventListener('DOMContentLoaded', () => {
            setupFormHandler();
            initDashboard();
        });
    </script>
</body>
</html>
