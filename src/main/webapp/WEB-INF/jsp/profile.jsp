<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="DriveHub Profile - Manage your account">
    <title>Profile - DriveHub Car Rental</title>
    
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class'
        }
    </script>
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700;800;900&family=Sora:wght@400;500;600;700;800&family=Poppins:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    
    <style>
        * {
            font-family: 'Sora', 'Poppins', sans-serif;
        }
        
        h1, h2, h3, h4, h5, h6 {
            font-family: 'Playfair Display', serif;
            font-weight: 700;
        }
        
        .profile-gradient {
            background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
        }
        
        .card-hover {
            transition: all 0.3s ease;
        }
        
        .card-hover:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.15);
        }
        
        .badge-gradient {
            background: linear-gradient(135deg, #3b82f6 0%, #1e40af 100%);
        }
        
        .stat-card {
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.1) 0%, rgba(30, 64, 175, 0.1) 100%);
        }
        
        .icon-box {
            width: 60px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 12px;
            font-size: 24px;
        }
        
        .icon-blue {
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
        }
        
        .icon-green {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
        }
        
        .icon-purple {
            background: linear-gradient(135deg, #a855f7 0%, #7e22ce 100%);
            color: white;
        }
        
        .icon-orange {
            background: linear-gradient(135deg, #f97316 0%, #ea580c 100%);
            color: white;
        }
        
        .booking-status-active {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
        }
        
        .booking-status-completed {
            background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%);
        }
        
        .booking-status-cancelled {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
        }
        
        .tab-active {
            border-bottom: 2px solid #2563eb;
            color: #2563eb;
        }
        
        .tab-inactive {
            color: #6b7280;
        }
    </style>
</head>
<body class="bg-gray-50 dark:bg-gray-900">
    
    <!-- Navigation -->
    <nav class="bg-white dark:bg-gray-800 shadow sticky top-0 z-40">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
                <a href="/" class="flex items-center gap-2">
                    <i class="fas fa-car text-blue-600 text-2xl"></i>
                    <span class="text-xl font-bold text-gray-900 dark:text-white">DriveHub</span>
                </a>
                <div class="flex items-center gap-4">
                    <button onclick="toggleDarkMode()" class="p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-400">
                        <i class="fas fa-moon dark:hidden"></i>
                        <i class="fas fa-sun hidden dark:block"></i>
                    </button>
                    <a href="/" class="text-gray-600 dark:text-gray-400 hover:text-blue-600">
                        <i class="fas fa-home mr-2"></i>Back to Home
                    </a>
                    <button onclick="logout()" class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg transition">
                        <i class="fas fa-sign-out-alt mr-2"></i>Logout
                    </button>
        </div>
    </nav>
    
    <!-- Main Content -->
    <div class="min-h-screen">
        
        <!-- ================== USER PROFILE ================== -->
        <div id="userProfile" class="hidden">
            
            <!-- Profile Header -->
            <div class="profile-gradient text-white py-12 px-4">
                <div class="max-w-7xl mx-auto">
                    <div class="flex flex-col md:flex-row items-center md:items-end gap-6 mb-8">
                        <div class="w-24 h-24 md:w-32 md:h-32 rounded-full bg-white bg-opacity-20 border-4 border-white flex items-center justify-center">
                            <i class="fas fa-user text-4xl md:text-5xl"></i>
                        </div>
                        <div>
                            <h1 class="text-3xl md:text-4xl font-bold mb-2" id="userFullName">John Doe</h1>
                            <p class="text-blue-100 mb-4" id="userEmail">john@example.com</p>
                            <div class="flex gap-3 flex-wrap">
                                <span class="badge-gradient text-white px-4 py-2 rounded-full text-sm font-semibold">
                                    <i class="fas fa-star mr-2"></i>Premium Member
                                </span>
                                <span class="bg-white bg-opacity-20 text-white px-4 py-2 rounded-full text-sm font-semibold">
                                    <i class="fas fa-phone mr-2"></i><span id="userPhone">9876543210</span>
                                </span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Quick Stats -->
                    <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                        <div class="bg-white bg-opacity-10 backdrop-blur rounded-lg p-4 text-center">
                            <div class="text-3xl font-bold mb-1" id="totalBookings">12</div>
                            <div class="text-sm text-blue-100">Total Bookings</div>
                        </div>
                        <div class="bg-white bg-opacity-10 backdrop-blur rounded-lg p-4 text-center">
                            <div class="text-3xl font-bold mb-1" id="activeBookings">2</div>
                            <div class="text-sm text-blue-100">Active Bookings</div>
                        </div>
                        <div class="bg-white bg-opacity-10 backdrop-blur rounded-lg p-4 text-center">
                            <div class="text-3xl font-bold mb-1" id="walletBalance">₹5,000</div>
                            <div class="text-sm text-blue-100">Wallet Balance</div>
                        </div>
                        <div class="bg-white bg-opacity-10 backdrop-blur rounded-lg p-4 text-center">
                            <div class="text-3xl font-bold mb-1" id="memberSince">1 Year</div>
                            <div class="text-sm text-blue-100">Member Since</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Tabs Navigation -->
            <div class="max-w-7xl mx-auto px-4 mt-8 mb-8">
                <div class="flex gap-8 border-b border-gray-200 dark:border-gray-700">
                    <button onclick="switchTab('bookings')" class="tab-active pb-4 font-semibold flex items-center gap-2 transition">
                        <i class="fas fa-calendar-check"></i>My Bookings
                    </button>
                    <button onclick="switchTab('wallet')" class="tab-inactive pb-4 font-semibold flex items-center gap-2 transition hover:text-gray-700 dark:hover:text-gray-300">
                        <i class="fas fa-wallet"></i>Wallet
                    </button>
                    <button onclick="switchTab('details')" class="tab-inactive pb-4 font-semibold flex items-center gap-2 transition hover:text-gray-700 dark:hover:text-gray-300">
                        <i class="fas fa-user-cog"></i>Account Details
                    </button>
                </div>
            </div>
            
            <!-- Tab Content -->
            <div class="max-w-7xl mx-auto px-4 pb-12">
                
                <!-- Bookings Tab -->
                <div id="bookingsTab" class="space-y-6">
                    <div class="flex justify-between items-center mb-6">
                        <h2 class="text-2xl font-bold text-gray-900 dark:text-white">My Bookings</h2>
                        <a href="/" class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-2 rounded-lg transition font-semibold">
                            <i class="fas fa-plus mr-2"></i>New Booking
                        </a>
                    </div>
                    
                    <!-- Booking Cards -->
                    <div class="space-y-4" id="bookingsList">
                        <!-- Bookings will be loaded here dynamically -->
                    </div>
                    
                    <!-- Empty State -->
                    <div id="noBookings" class="hidden text-center py-12">
                        <i class="fas fa-inbox text-6xl text-gray-300 dark:text-gray-600 mb-4"></i>
                        <p class="text-gray-600 dark:text-gray-400 text-lg">No bookings yet</p>
                        <p class="text-gray-500 dark:text-gray-500 mb-6">Start your first booking to see it here</p>
                        <a href="/cars" class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg transition font-semibold inline-block">
                            <i class="fas fa-car mr-2"></i>Explore Cars
                        </a>
                    </div>
                </div>
                
                <!-- Wallet Tab -->
                <div id="walletTab" class="hidden space-y-6">
                    <h2 class="text-2xl font-bold text-gray-900 dark:text-white">Wallet</h2>
                    
                    <!-- Wallet Balance Card -->
                    <div class="bg-gradient-to-br from-blue-600 to-blue-800 text-white rounded-lg p-8 shadow-lg">
                        <p class="text-blue-100 mb-2">Current Balance</p>
                        <h3 class="text-4xl font-bold mb-6" id="walletBalanceDisplay">₹5,000</h3>
                        <div class="flex gap-3">
                            <button class="bg-white text-blue-600 hover:bg-blue-50 px-6 py-3 rounded-lg font-semibold transition">
                                <i class="fas fa-plus mr-2"></i>Add Money
                            </button>
                            <button class="bg-blue-700 hover:bg-blue-900 px-6 py-3 rounded-lg font-semibold transition">
                                <i class="fas fa-exchange-alt mr-2"></i>Withdraw
                            </button>
                        </div>
                    </div>
                    
                    <!-- Transaction History -->
                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-6">
                        <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-6">Transaction History</h3>
                        
                        <div class="space-y-4" id="transactionsList">
                            <!-- Sample Transaction -->
                            <div class="flex items-center justify-between p-4 border border-gray-200 dark:border-gray-700 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700 transition">
                                <div class="flex items-center gap-4">
                                    <div class="icon-box icon-blue">
                                        <i class="fas fa-minus"></i>
                                    </div>
                                    <div>
                                        <p class="font-semibold text-gray-900 dark:text-white">Booking Payment - Toyota Fortuner</p>
                                        <p class="text-sm text-gray-600 dark:text-gray-400">Dec 08, 2025 at 2:30 PM</p>
                                    </div>
                                </div>
                                <p class="font-bold text-red-600">-₹12,500</p>
                            </div>
                            
                            <!-- More transactions would go here -->
                        </div>
                    </div>
                </div>
                
                <!-- Account Details Tab -->
                <div id="detailsTab" class="hidden space-y-6">
                    <h2 class="text-2xl font-bold text-gray-900 dark:text-white mb-6">Account Details</h2>
                    
                    <div class="grid md:grid-cols-2 gap-6">
                        <!-- Personal Info Card -->
                        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-6">
                            <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-6 flex items-center gap-2">
                                <div class="icon-box icon-blue">
                                    <i class="fas fa-user"></i>
                                </div>
                                Personal Information
                            </h3>
                            
                            <div class="space-y-4">
                                <div>
                                    <label class="text-sm text-gray-600 dark:text-gray-400">Full Name</label>
                                    <p class="font-semibold text-gray-900 dark:text-white" id="detailsFullName">John Doe</p>
                                </div>
                                <div>
                                    <label class="text-sm text-gray-600 dark:text-gray-400">Email Address</label>
                                    <p class="font-semibold text-gray-900 dark:text-white" id="detailsEmail">john@example.com</p>
                                </div>
                                <div>
                                    <label class="text-sm text-gray-600 dark:text-gray-400">Phone Number</label>
                                    <p class="font-semibold text-gray-900 dark:text-white" id="detailsPhone">9876543210</p>
                                </div>
                                <button class="w-full bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg transition font-semibold mt-4">
                                    <i class="fas fa-edit mr-2"></i>Edit Profile
                                </button>
                            </div>
                        </div>
                        
                        <!-- Document Info Card -->
                        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-6">
                            <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-6 flex items-center gap-2">
                                <div class="icon-box icon-green">
                                    <i class="fas fa-id-card"></i>
                                </div>
                                Documents
                            </h3>
                            
                            <div class="space-y-4">
                                <div>
                                    <label class="text-sm text-gray-600 dark:text-gray-400">Driving License</label>
                                    <p class="font-semibold text-gray-900 dark:text-white flex items-center gap-2">
                                        <i class="fas fa-check-circle text-green-600"></i>
                                        Verified
                                    </p>
                                </div>
                                <div>
                                    <label class="text-sm text-gray-600 dark:text-gray-400">Aadhaar Number</label>
                                    <p class="font-semibold text-gray-900 dark:text-white flex items-center gap-2">
                                        <i class="fas fa-check-circle text-green-600"></i>
                                        Verified
                                    </p>
                                </div>
                                <div>
                                    <label class="text-sm text-gray-600 dark:text-gray-400">PAN Number</label>
                                    <p class="font-semibold text-gray-900 dark:text-white flex items-center gap-2">
                                        <i class="fas fa-check-circle text-green-600"></i>
                                        Verified
                                    </p>
                                </div>
                                <button class="w-full bg-gray-200 hover:bg-gray-300 dark:bg-gray-700 dark:hover:bg-gray-600 text-gray-900 dark:text-white px-4 py-2 rounded-lg transition font-semibold mt-4">
                                    <i class="fas fa-refresh mr-2"></i>Update Documents
                                </button>
                            </div>
                        </div>
                        
                        <!-- Security Card -->
                        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-6">
                            <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-6 flex items-center gap-2">
                                <div class="icon-box icon-purple">
                                    <i class="fas fa-lock"></i>
                                </div>
                                Security
                            </h3>
                            
                            <div class="space-y-4">
                                <button class="w-full bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg transition font-semibold text-left flex items-center justify-between">
                                    <span><i class="fas fa-key mr-2"></i>Change Password</span>
                                    <i class="fas fa-chevron-right"></i>
                                </button>
                                <button class="w-full bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg transition font-semibold text-left flex items-center justify-between">
                                    <span><i class="fas fa-shield-alt mr-2"></i>Two-Factor Auth</span>
                                    <i class="fas fa-chevron-right"></i>
                                </button>
                            </div>
                        </div>
                        
                        <!-- Preferences Card -->
                        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-6">
                            <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-6 flex items-center gap-2">
                                <div class="icon-box icon-orange">
                                    <i class="fas fa-cog"></i>
                                </div>
                                Preferences
                            </h3>
                            
                            <div class="space-y-4">
                                <div class="flex items-center justify-between p-3 border border-gray-200 dark:border-gray-700 rounded-lg">
                                    <label class="text-sm font-semibold text-gray-900 dark:text-white">Email Notifications</label>
                                    <input type="checkbox" checked class="w-5 h-5 text-blue-600 rounded">
                                </div>
                                <div class="flex items-center justify-between p-3 border border-gray-200 dark:border-gray-700 rounded-lg">
                                    <label class="text-sm font-semibold text-gray-900 dark:text-white">SMS Notifications</label>
                                    <input type="checkbox" class="w-5 h-5 text-blue-600 rounded">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- ================== ADMIN PROFILE ================== -->
        <!-- Removed: Admin users are now redirected to /admin-dashboard -->
        <div id="adminProfile" class="hidden" style="display: none;">
            
            <!-- Admin Header -->
            <div class="profile-gradient text-white py-12 px-4">
                <div class="max-w-7xl mx-auto">
                    <div class="flex flex-col md:flex-row items-center md:items-end gap-6 mb-8">
                        <div class="w-24 h-24 md:w-32 md:h-32 rounded-full bg-white bg-opacity-20 border-4 border-white flex items-center justify-center">
                            <i class="fas fa-user-shield text-4xl md:text-5xl"></i>
                        </div>
                        <div>
                            <h1 class="text-3xl md:text-4xl font-bold mb-2" id="adminFullName">Admin User</h1>
                            <p class="text-blue-100 mb-4" id="adminEmail">admin@drivehub.com</p>
                            <div class="flex gap-3 flex-wrap">
                                <span class="badge-gradient text-white px-4 py-2 rounded-full text-sm font-semibold">
                                    <i class="fas fa-crown mr-2"></i>Administrator
                                </span>
                                <span class="bg-white bg-opacity-20 text-white px-4 py-2 rounded-full text-sm font-semibold">
                                    <i class="fas fa-phone mr-2"></i><span id="adminPhone">9876543210</span>
                                </span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Admin Stats -->
                    <div class="grid grid-cols-2 md:grid-cols-5 gap-4">
                        <div class="bg-white bg-opacity-10 backdrop-blur rounded-lg p-4 text-center">
                            <div class="text-3xl font-bold mb-1">245</div>
                            <div class="text-sm text-blue-100">Total Users</div>
                        </div>
                        <div class="bg-white bg-opacity-10 backdrop-blur rounded-lg p-4 text-center">
                            <div class="text-3xl font-bold mb-1">1,542</div>
                            <div class="text-sm text-blue-100">Total Bookings</div>
                        </div>
                        <div class="bg-white bg-opacity-10 backdrop-blur rounded-lg p-4 text-center">
                            <div class="text-3xl font-bold mb-1">856</div>
                            <div class="text-sm text-blue-100">Vehicles</div>
                        </div>
                        <div class="bg-white bg-opacity-10 backdrop-blur rounded-lg p-4 text-center">
                            <div class="text-3xl font-bold mb-1">₹52.4L</div>
                            <div class="text-sm text-blue-100">Revenue</div>
                        </div>
                        <div class="bg-white bg-opacity-10 backdrop-blur rounded-lg p-4 text-center">
                            <div class="text-3xl font-bold mb-1">98%</div>
                            <div class="text-sm text-blue-100">Satisfaction</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Admin Tabs Navigation -->
            <div class="max-w-7xl mx-auto px-4 mt-8 mb-8">
                <div class="flex gap-8 border-b border-gray-200 dark:border-gray-700 overflow-x-auto">
                    <button onclick="switchAdminTab('dashboard')" class="tab-active pb-4 font-semibold flex items-center gap-2 transition whitespace-nowrap">
                        <i class="fas fa-chart-line"></i>Dashboard
                    </button>
                    <button onclick="switchAdminTab('users')" class="tab-inactive pb-4 font-semibold flex items-center gap-2 transition hover:text-gray-700 dark:hover:text-gray-300 whitespace-nowrap">
                        <i class="fas fa-users"></i>Users
                    </button>
                    <button onclick="switchAdminTab('vehicles')" class="tab-inactive pb-4 font-semibold flex items-center gap-2 transition hover:text-gray-700 dark:hover:text-gray-300 whitespace-nowrap">
                        <i class="fas fa-car"></i>Vehicles
                    </button>
                    <button onclick="switchAdminTab('bookings')" class="tab-inactive pb-4 font-semibold flex items-center gap-2 transition hover:text-gray-700 dark:hover:text-gray-300 whitespace-nowrap">
                        <i class="fas fa-calendar"></i>Bookings
                    </button>
                    <button onclick="switchAdminTab('reports')" class="tab-inactive pb-4 font-semibold flex items-center gap-2 transition hover:text-gray-700 dark:hover:text-gray-300 whitespace-nowrap">
                        <i class="fas fa-file-chart-line"></i>Reports
                    </button>
                </div>
            </div>
            
            <!-- Admin Tab Content -->
            <div class="max-w-7xl mx-auto px-4 pb-12">
                
                <!-- Dashboard Tab -->
                <div id="dashboardTab" class="space-y-6">
                    <h2 class="text-2xl font-bold text-gray-900 dark:text-white">Dashboard Overview</h2>
                    
                    <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
                        <!-- Active Bookings -->
                        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-6 card-hover">
                            <div class="flex justify-between items-start mb-4">
                                <div>
                                    <p class="text-gray-600 dark:text-gray-400 text-sm">Active Bookings</p>
                                    <h3 class="text-3xl font-bold text-gray-900 dark:text-white">342</h3>
                                </div>
                                <div class="icon-box icon-blue">
                                    <i class="fas fa-hourglass-half"></i>
                                </div>
                            </div>
                            <p class="text-green-600 text-sm font-semibold"><i class="fas fa-arrow-up mr-1"></i>+5.2% from last week</p>
                        </div>
                        
                        <!-- Completed Bookings -->
                        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-6 card-hover">
                            <div class="flex justify-between items-start mb-4">
                                <div>
                                    <p class="text-gray-600 dark:text-gray-400 text-sm">Completed Bookings</p>
                                    <h3 class="text-3xl font-bold text-gray-900 dark:text-white">1,200</h3>
                                </div>
                                <div class="icon-box icon-green">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                            </div>
                            <p class="text-green-600 text-sm font-semibold"><i class="fas fa-arrow-up mr-1"></i>+12.5% from last month</p>
                        </div>
                        
                        <!-- Revenue -->
                        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-6 card-hover">
                            <div class="flex justify-between items-start mb-4">
                                <div>
                                    <p class="text-gray-600 dark:text-gray-400 text-sm">Monthly Revenue</p>
                                    <h3 class="text-3xl font-bold text-gray-900 dark:text-white">₹18.5L</h3>
                                </div>
                                <div class="icon-box icon-purple">
                                    <i class="fas fa-rupee-sign"></i>
                                </div>
                            </div>
                            <p class="text-green-600 text-sm font-semibold"><i class="fas fa-arrow-up mr-1"></i>+8.3% from last month</p>
                        </div>
                        
                        <!-- New Users -->
                        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-6 card-hover">
                            <div class="flex justify-between items-start mb-4">
                                <div>
                                    <p class="text-gray-600 dark:text-gray-400 text-sm">New Users</p>
                                    <h3 class="text-3xl font-bold text-gray-900 dark:text-white">38</h3>
                                </div>
                                <div class="icon-box icon-orange">
                                    <i class="fas fa-user-plus"></i>
                                </div>
                            </div>
                            <p class="text-green-600 text-sm font-semibold"><i class="fas fa-arrow-up mr-1"></i>+15.2% from last week</p>
                        </div>
                    </div>
                </div>
                
                <!-- Users Tab -->
                <div id="usersTab" class="hidden space-y-6">
                    <div class="flex justify-between items-center mb-6">
                        <h2 class="text-2xl font-bold text-gray-900 dark:text-white">Manage Users</h2>
                        <button class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg transition font-semibold">
                            <i class="fas fa-user-plus mr-2"></i>Add User
                        </button>
                    </div>
                    
                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-lg overflow-hidden">
                        <table class="w-full">
                            <thead class="bg-gray-100 dark:bg-gray-700">
                                <tr>
                                    <th class="px-6 py-4 text-left text-sm font-semibold text-gray-900 dark:text-white">Name</th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold text-gray-900 dark:text-white">Email</th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold text-gray-900 dark:text-white">Bookings</th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold text-gray-900 dark:text-white">Status</th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold text-gray-900 dark:text-white">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class="border-t border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-700">
                                    <td class="px-6 py-4"><span class="font-semibold text-gray-900 dark:text-white">John Doe</span></td>
                                    <td class="px-6 py-4"><span class="text-gray-600 dark:text-gray-400">john@example.com</span></td>
                                    <td class="px-6 py-4"><span class="font-semibold text-gray-900 dark:text-white">12</span></td>
                                    <td class="px-6 py-4"><span class="badge-gradient text-white px-3 py-1 rounded-full text-sm">Active</span></td>
                                    <td class="px-6 py-4 space-x-2">
                                        <button class="text-blue-600 hover:text-blue-700 font-semibold"><i class="fas fa-eye"></i></button>
                                        <button class="text-red-600 hover:text-red-700 font-semibold"><i class="fas fa-trash"></i></button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <!-- Vehicles Tab -->
                <div id="vehiclesTab" class="hidden space-y-6">
                    <div class="flex justify-between items-center mb-6">
                        <h2 class="text-2xl font-bold text-gray-900 dark:text-white">Manage Vehicles</h2>
                        <button class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg transition font-semibold">
                            <i class="fas fa-plus mr-2"></i>Add Vehicle
                        </button>
                    </div>
                    
                    <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-lg overflow-hidden card-hover">
                            <div class="bg-gradient-to-br from-gray-200 to-gray-300 dark:from-gray-700 dark:to-gray-600 h-40 flex items-center justify-center">
                                <i class="fas fa-car text-5xl text-gray-400"></i>
                            </div>
                            <div class="p-4">
                                <h3 class="font-bold text-gray-900 dark:text-white mb-2">Toyota Fortuner</h3>
                                <p class="text-gray-600 dark:text-gray-400 text-sm mb-3">SUV · Auto · ₹4,000/day</p>
                                <div class="flex gap-2">
                                    <button class="flex-1 bg-blue-600 hover:bg-blue-700 text-white px-3 py-2 rounded text-sm transition">Edit</button>
                                    <button class="flex-1 bg-red-600 hover:bg-red-700 text-white px-3 py-2 rounded text-sm transition">Delete</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Bookings Tab -->
                <div id="bookingsTab" class="hidden space-y-6">
                    <h2 class="text-2xl font-bold text-gray-900 dark:text-white mb-6">All Bookings</h2>
                    
                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-lg overflow-hidden">
                        <table class="w-full">
                            <thead class="bg-gray-100 dark:bg-gray-700">
                                <tr>
                                    <th class="px-6 py-4 text-left text-sm font-semibold text-gray-900 dark:text-white">Booking ID</th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold text-gray-900 dark:text-white">Customer</th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold text-gray-900 dark:text-white">Vehicle</th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold text-gray-900 dark:text-white">Amount</th>
                                    <th class="px-6 py-4 text-left text-sm font-semibold text-gray-900 dark:text-white">Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class="border-t border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-700">
                                    <td class="px-6 py-4"><span class="font-mono text-sm text-gray-900 dark:text-white">#BK-001234</span></td>
                                    <td class="px-6 py-4"><span class="text-gray-900 dark:text-white">John Doe</span></td>
                                    <td class="px-6 py-4"><span class="text-gray-600 dark:text-gray-400">Toyota Fortuner</span></td>
                                    <td class="px-6 py-4"><span class="font-bold text-gray-900 dark:text-white">₹12,500</span></td>
                                    <td class="px-6 py-4"><span class="booking-status-active text-white px-3 py-1 rounded-full text-sm">Active</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <!-- Reports Tab -->
                <div id="reportsTab" class="hidden space-y-6">
                    <h2 class="text-2xl font-bold text-gray-900 dark:text-white mb-6">Reports & Analytics</h2>
                    
                    <div class="grid md:grid-cols-2 gap-6">
                        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-6">
                            <h3 class="text-lg font-bold text-gray-900 dark:text-white mb-4">Monthly Revenue</h3>
                            <div class="h-48 bg-gradient-to-br from-gray-100 to-gray-200 dark:from-gray-700 dark:to-gray-600 rounded flex items-center justify-center">
                                <p class="text-gray-500 dark:text-gray-400">Chart Placeholder</p>
                            </div>
                        </div>
                        
                        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-6">
                            <h3 class="text-lg font-bold text-gray-900 dark:text-white mb-4">Booking Trends</h3>
                            <div class="h-48 bg-gradient-to-br from-gray-100 to-gray-200 dark:from-gray-700 dark:to-gray-600 rounded flex items-center justify-center">
                                <p class="text-gray-500 dark:text-gray-400">Chart Placeholder</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Toast Notification -->
    <div id="toast" class="hidden fixed bottom-4 right-4 bg-gray-900 dark:bg-gray-100 text-white dark:text-gray-900 px-6 py-4 rounded-lg shadow-lg flex items-center gap-3 z-50">
        <i class="fas fa-check-circle"></i>
        <span id="toastMessage">Success!</span>
    </div>
    
    <!-- JavaScript -->
    <script>
        // ========== SESSION PROTECTION ==========
        // Check if user is logged in, redirect to login if not
        function checkSession() {
            const userSession = localStorage.getItem('userSession');
            if (!userSession) {
                // No session found, redirect to login
                window.location.href = '/login';
                return null;
            }
            
            try {
                return JSON.parse(userSession);
            } catch (error) {
                console.error('Error parsing session:', error);
                localStorage.removeItem('userSession');
                window.location.href = '/login';
                return null;
            }
        }

        // ========== FETCH USER DATA FROM API ==========
        async function fetchUserData(email) {
            try {
                const response = await fetch('/api/user/details?email=' + encodeURIComponent(email));
                if (!response.ok) {
                    throw new Error('Failed to fetch user data');
                }
                const userData = await response.json();
                return userData;
            } catch (error) {
                console.error('Error fetching user data:', error);
                showToast('Failed to load user data');
                return null;
            }
        }

        // Check user role and display appropriate profile
        async function initializeProfile() {
            // First check session
            const session = checkSession();
            if (!session) return; // Will redirect to login
            
            console.log('Session found:', session);

            // Fetch user data from API
            const user = await fetchUserData(session.email);
            if (!user) {
                showToast('Failed to load profile');
                return;
            }
            
            console.log('User data fetched:', user);

            const role = user.role || 'user';
            
            if (role === 'ADMIN' || role === 'admin') {
                // Redirect to admin dashboard
                window.location.href = '/admin-dashboard';
                return;
            } else {
                document.getElementById('userProfile').classList.remove('hidden');
                populateUserProfile(user);
                // Load bookings for user
                console.log('About to load bookings for:', user.email);
                loadUserBookings(user.email);
            }
        }
        
        function populateUserProfile(user) {
            document.getElementById('userFullName').textContent = user.fullName || 'User';
            document.getElementById('userEmail').textContent = user.email || 'user@example.com';
            document.getElementById('userPhone').textContent = user.mobileNumber || 'N/A';
            document.getElementById('detailsFullName').textContent = user.fullName || 'User';
            document.getElementById('detailsEmail').textContent = user.email || 'user@example.com';
            document.getElementById('detailsPhone').textContent = user.mobileNumber || 'N/A';
            
            // Calculate member duration
            const createdAt = user.createdAt;
            if (createdAt) {
                const joinDate = new Date(createdAt);
                const now = new Date();
                const yearsAgo = Math.floor((now - joinDate) / (1000 * 60 * 60 * 24 * 365));
                const memberText = yearsAgo > 0 ? yearsAgo + ' Year' + (yearsAgo > 1 ? 's' : '') : 'New Member';
                document.getElementById('memberSince').textContent = memberText;
            }
        }

        // Load user bookings from database
        async function loadUserBookings(email) {
            try {
                console.log('Loading bookings for email:', email);
                const url = '/api/user/bookings?email=' + encodeURIComponent(email);
                console.log('API URL:', url);
                
                const response = await fetch(url);
                console.log('Response status:', response.status);
                
                if (!response.ok) {
                    throw new Error('Failed to fetch bookings: ' + response.status);
                }
                
                const bookings = await response.json();
                console.log('Bookings loaded:', bookings);
                console.log('Number of bookings:', bookings ? bookings.length : 0);
                
                if (!Array.isArray(bookings) || bookings.length === 0) {
                    console.log('No bookings found or invalid format');
                    document.getElementById('bookingsList').classList.add('hidden');
                    document.getElementById('noBookings').classList.remove('hidden');
                    return;
                }
                
                console.log('Displaying bookings...');
                displayBookings(bookings);
            } catch (error) {
                console.error('Error loading bookings:', error);
                console.error('Error details:', error.message);
                document.getElementById('bookingsList').classList.add('hidden');
                document.getElementById('noBookings').classList.remove('hidden');
            }
        }

        // Display bookings in the bookings list
        function displayBookings(bookings) {
            const bookingsList = document.getElementById('bookingsList');
            console.log('bookingsList element:', bookingsList);
            console.log('bookingsList parent:', bookingsList?.parentElement);
            
            bookingsList.innerHTML = ''; // Clear existing content
            
            let activeCount = 0;
            let totalCost = 0;
            
            bookings.forEach((booking, index) => {
                console.log('Processing booking', index, ':', booking);
                
                // Count active bookings and total cost
                if (booking.status === 'CONFIRMED' || booking.status === 'ACTIVE') {
                    activeCount++;
                }
                totalCost += booking.totalCost || 0;
                
                const statusBgClass = getStatusBgClass(booking.status);
                const placeholderUrl = 'https://via.placeholder.com/400x300?text=' + encodeURIComponent(booking.carName);
                const imageUrl = booking.carImage && booking.carImage.trim() ? booking.carImage : placeholderUrl;
                
                // Format dates
                const pickupDate = new Date(booking.pickupDate).toLocaleDateString('en-IN');
                const dropoffDate = new Date(booking.dropoffDate).toLocaleDateString('en-IN');
                const totalCostRounded = Math.round(booking.totalCost);
                
                const bookingId = booking.id || booking.transactionId || Math.random();
                console.log('Creating card with ID:', bookingId);
                console.log('Car details - Name:', booking.carName, 'Category:', booking.carCategory, 'Cost:', totalCostRounded);
                
                const bookingCard = document.createElement('div');
                bookingCard.className = 'bg-white dark:bg-gray-800 rounded-lg shadow-lg overflow-hidden card-hover';
                bookingCard.setAttribute('data-booking-id', bookingId);
                
                // Build HTML without template literals to avoid JSP/EL conflicts
                let cardHTML = '<div class="md:flex">';
                cardHTML += '<div class="md:w-1/4 bg-gradient-to-br from-gray-200 to-gray-300 dark:from-gray-700 dark:to-gray-600 p-6 flex items-center justify-center min-h-[200px]">';
                cardHTML += '<img src="' + imageUrl + '" alt="' + booking.carName + '" style="width: 100%; height: 100%; object-fit: cover;" onerror="this.src=\'' + placeholderUrl + '\'">';
                cardHTML += '</div>';
                cardHTML += '<div class="p-6 md:w-3/4">';
                cardHTML += '<div class="flex justify-between items-start mb-4">';
                cardHTML += '<div>';
                cardHTML += '<h3 class="text-xl font-bold text-gray-900 dark:text-white">' + booking.carName + '</h3>';
                cardHTML += '<p class="text-gray-600 dark:text-gray-400 text-sm">' + booking.carCategory + ' · ' + booking.carTransmission + ' · ' + booking.carSeats + '-Seater</p>';
                cardHTML += '</div>';
                cardHTML += '<span class="' + statusBgClass + ' text-white px-4 py-2 rounded-full text-sm font-semibold">';
                cardHTML += '<i class="fas fa-check-circle mr-1"></i>' + booking.status;
                cardHTML += '</span>';
                cardHTML += '</div>';
                cardHTML += '<div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-4">';
                cardHTML += '<div>';
                cardHTML += '<p class="text-gray-600 dark:text-gray-400 text-sm">Pickup</p>';
                cardHTML += '<p class="font-semibold text-gray-900 dark:text-white">' + pickupDate + '</p>';
                cardHTML += '</div>';
                cardHTML += '<div>';
                cardHTML += '<p class="text-gray-600 dark:text-gray-400 text-sm">Dropoff</p>';
                cardHTML += '<p class="font-semibold text-gray-900 dark:text-white">' + dropoffDate + '</p>';
                cardHTML += '</div>';
                cardHTML += '<div>';
                cardHTML += '<p class="text-gray-600 dark:text-gray-400 text-sm">Days</p>';
                cardHTML += '<p class="font-semibold text-gray-900 dark:text-white">' + booking.totalDays + ' Days</p>';
                cardHTML += '</div>';
                cardHTML += '<div>';
                cardHTML += '<p class="text-gray-600 dark:text-gray-400 text-sm">Total Cost</p>';
                cardHTML += '<p class="font-semibold text-blue-600 text-lg">₹' + totalCostRounded + '</p>';
                cardHTML += '</div>';
                cardHTML += '</div>';
                cardHTML += '<div class="flex gap-3">';
                cardHTML += '<button onclick="viewBookingDetails(\'' + bookingId + '\')" class="flex-1 bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg transition font-semibold">';
                cardHTML += '<i class="fas fa-eye mr-2"></i>View Details';
                cardHTML += '</button>';
                cardHTML += '<button onclick="downloadInvoice(\'' + bookingId + '\')" class="flex-1 bg-gray-200 hover:bg-gray-300 dark:bg-gray-700 dark:hover:bg-gray-600 text-gray-900 dark:text-white px-4 py-2 rounded-lg transition font-semibold">';
                cardHTML += '<i class="fas fa-download mr-2"></i>Invoice';
                cardHTML += '</button>';
                cardHTML += '</div>';
                cardHTML += '</div>';
                cardHTML += '</div>';
                
                bookingCard.innerHTML = cardHTML;
                console.log('Card HTML created, appending to list');
                bookingsList.appendChild(bookingCard);
                console.log('Card appended, current child count:', bookingsList.children.length);
            });
            
            // Update stats
            console.log('Updating stats - Total:', bookings.length, 'Active:', activeCount, 'Cost:', totalCost);
            document.getElementById('totalBookings').textContent = bookings.length;
            document.getElementById('activeBookings').textContent = activeCount;
            document.getElementById('walletBalance').textContent = '₹' + Math.round(totalCost);
            
            document.getElementById('bookingsList').classList.remove('hidden');
            document.getElementById('noBookings').classList.add('hidden');
            console.log('Display bookings complete, bookingsList children:', document.getElementById('bookingsList').children.length);
        }

        // Get status background color class
        function getStatusBgClass(status) {
            switch(status.toUpperCase()) {
                case 'ACTIVE':
                case 'CONFIRMED':
                    return 'booking-status-active';
                case 'COMPLETED':
                    return 'booking-status-completed';
                case 'CANCELLED':
                    return 'booking-status-cancelled';
                default:
                    return 'bg-gray-500';
            }
        }

        // View booking details
        function viewBookingDetails(bookingId) {
            console.log('Viewing details for booking ID:', bookingId);
            alert('Booking Details\n\nID: ' + bookingId + '\n\nFeature coming soon...');
            // TODO: Implement booking details modal with full information
        }

        // Download invoice
        function downloadInvoice(bookingId) {
            console.log('Downloading invoice for booking ID:', bookingId);
            alert('Invoice download for booking ID: ' + bookingId + '\n\nFeature coming soon...');
            // TODO: Implement invoice generation and download
        }
        
        function populateAdminProfile(user) {
            document.getElementById('adminFullName').textContent = user.fullName || 'Admin';
            document.getElementById('adminEmail').textContent = user.email || 'admin@example.com';
            document.getElementById('adminPhone').textContent = user.mobileNumber || 'N/A';
        }
        
        function switchTab(tabName) {
            // Hide all tabs
            document.getElementById('bookingsTab').classList.add('hidden');
            document.getElementById('walletTab').classList.add('hidden');
            document.getElementById('detailsTab').classList.add('hidden');
            
            // Remove active class from all buttons
            document.querySelectorAll('.tab-active, .tab-inactive').forEach(btn => {
                btn.classList.remove('tab-active');
                btn.classList.add('tab-inactive');
            });
            
            // Show selected tab
            document.getElementById(tabName + 'Tab').classList.remove('hidden');
            
            // Add active class to clicked button
            event.target.closest('button').classList.remove('tab-inactive');
            event.target.closest('button').classList.add('tab-active');
        }
        
        function switchAdminTab(tabName) {
            // Hide all tabs
            document.querySelectorAll('[id$="Tab"]').forEach(tab => {
                if (tab.id !== 'bookingsTab' || tabName !== 'bookings') {
                    tab.classList.add('hidden');
                }
            });
            document.getElementById('dashboardTab').classList.add('hidden');
            document.getElementById('usersTab').classList.add('hidden');
            document.getElementById('vehiclesTab').classList.add('hidden');
            document.getElementById('bookingsTab').classList.add('hidden');
            document.getElementById('reportsTab').classList.add('hidden');
            
            // Remove active class from all buttons
            document.querySelectorAll('.tab-active, .tab-inactive').forEach(btn => {
                btn.classList.remove('tab-active');
                btn.classList.add('tab-inactive');
            });
            
            // Show selected tab
            document.getElementById(tabName + 'Tab').classList.remove('hidden');
            
            // Add active class to clicked button
            event.target.closest('button').classList.remove('tab-inactive');
            event.target.closest('button').classList.add('tab-active');
        }
        
        function toggleDarkMode() {
            document.documentElement.classList.toggle('dark');
            localStorage.setItem('darkMode', document.documentElement.classList.contains('dark'));
        }
        
        function showToast(message) {
            const toast = document.getElementById('toast');
            document.getElementById('toastMessage').textContent = message;
            toast.classList.remove('hidden');
            setTimeout(() => {
                toast.classList.add('hidden');
            }, 3000);
        }
        
        function logout() {
            if (confirm('Are you sure you want to logout?')) {
                localStorage.removeItem('userSession');
                window.location.href = '/login';
            }
        }
        
        // Initialize dark mode
        if (localStorage.getItem('darkMode') === 'true') {
            document.documentElement.classList.add('dark');
        }
        
        // Initialize profile on page load
        initializeProfile();
    </script>
</body>
</html>
