<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="DriveHub - Your Perfect Car Rental Solution. Book vehicles instantly with 24/7 support.">
    <title>DriveHub - Car Rental System | Find Your Perfect Ride</title>
    
    <!-- Tailwind CSS CDN -->
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
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Beautiful Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800;900&family=Sora:wght@400;500;600;700;800&family=Playfair+Display:wght@600;700;800;900&display=swap" rel="stylesheet">
    
    <style>
        * {
            font-family: 'Sora', 'Poppins', sans-serif;
        }
        
        h1, h2, h3, h4, h5, h6 {
            font-family: 'Playfair Display', 'Poppins', serif;
            font-weight: 700;
        }
        
        .hero-gradient {
            background: linear-gradient(135deg, #2563eb 0%, #1e40af 50%, #0f3460 100%);
        }
        
        .hero-bg-pattern {
            position: relative;
            overflow: hidden;
        }
        
        .hero-bg-pattern::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 600px;
            height: 600px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            filter: blur(40px);
            z-index: 0;
        }
        
        .hero-bg-pattern::after {
            content: '';
            position: absolute;
            bottom: -30%;
            left: -5%;
            width: 400px;
            height: 400px;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 50%;
            filter: blur(40px);
            z-index: 0;
        }
        
        .card-hover {
            transition: all 0.3s ease;
        }
        .card-hover:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
        }
        .smooth-scroll {
            scroll-behavior: smooth;
        }
        
        .btn-glow {
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(37, 99, 235, 0.4);
        }
        
        .btn-glow:hover {
            box-shadow: 0 8px 25px rgba(37, 99, 235, 0.6);
            transform: translateY(-2px);
        }
        
        .icon-float {
            animation: float 3s ease-in-out infinite;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
        }
        
        .text-gradient {
            background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
    </style>
</head>
<body class="bg-white dark:bg-gray-900 transition-colors duration-300">
    
    <!-- ==================== NAVIGATION HEADER ==================== -->
    <nav class="fixed w-full bg-white dark:bg-gray-800 shadow-lg z-50">
        <div class="w-full px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-16">
                <!-- Logo -->
                <div class="flex items-center gap-2 flex-shrink-0">
                    <i class="fas fa-car text-blue-600 text-2xl"></i>
                    <span class="text-lg md:text-xl font-bold text-gray-900 dark:text-white">DriveHub</span>
                </div>
                
                <!-- Desktop Menu (Only visible on medium+ screens) -->
                <div class="hidden md:flex items-center gap-8 flex-grow justify-center">
                    <a href="#home" class="text-gray-700 dark:text-gray-300 hover:text-blue-600 dark:hover:text-blue-400">Home</a>
                    <a href="/cars" class="text-gray-700 dark:text-gray-300 hover:text-blue-600 dark:hover:text-blue-400">All Cars</a>
                    <a href="#why-us" class="text-gray-700 dark:text-gray-300 hover:text-blue-600 dark:hover:text-blue-400">Why Us</a>
                    <a href="#testimonials" class="text-gray-700 dark:text-gray-300 hover:text-blue-600 dark:hover:text-blue-400">Reviews</a>
                </div>
                
                <!-- Right Actions - Always pushed to right -->
                <div class="flex items-center gap-2 md:gap-4 ml-auto">
                    <!-- Dark Mode Toggle -->
                    <button id="darkModeToggle" class="p-2 rounded-lg bg-gray-200 dark:bg-gray-700 hover:bg-gray-300 dark:hover:bg-gray-600 transition flex-shrink-0">
                        <i class="fas fa-moon text-gray-800 dark:text-yellow-400"></i>
                    </button>
                    
                    <!-- Auth Buttons (Hidden when logged in, hidden on mobile) -->
                    <div id="authButtons" class="hidden md:flex items-center gap-4" style="display: none;">
                        <a href="/login">
                            <button class="px-4 py-2 text-blue-600 dark:text-blue-400 font-semibold hover:text-blue-800 dark:hover:text-blue-300">
                                Login
                            </button>
                        </a>
                        <a href="/register">
                            <button class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition">
                                Sign Up
                            </button>
                        </a>
                    </div>
                    
                    <!-- Profile Menu (Shown when logged in, mobile shows icon-only) -->
                    <div id="profileMenu" class="relative" style="display: none;">
                        <button id="profileBtn" class="flex items-center gap-2 md:px-4 md:py-2 p-1 bg-blue-100 dark:bg-blue-900 rounded-lg hover:bg-blue-200 dark:hover:bg-blue-800 transition">
                            <i class="fas fa-user-circle text-blue-600 dark:text-blue-400 text-xl"></i>
                            <span id="userEmail" class="hidden md:inline text-gray-700 dark:text-gray-300 text-sm font-semibold cursor-pointer hover:text-blue-600 dark:hover:text-blue-400" onclick="goToProfile()">Profile</span>
                        </button>
                        
                        <!-- Dropdown Menu -->
                        <div id="profileDropdown" class="hidden absolute right-0 mt-2 w-48 bg-white dark:bg-gray-800 rounded-lg shadow-xl z-50 border border-gray-200 dark:border-gray-700">
                            <div class="px-4 py-3 border-b border-gray-200 dark:border-gray-700">
                                <p class="text-sm text-gray-600 dark:text-gray-400">Logged in as</p>
                                <p id="dropdownEmail" class="font-semibold text-gray-900 dark:text-white truncate"></p>
                            </div>
                            
                            <a href="#" onclick="goToProfile(); return false;" class="flex items-center gap-3 px-4 py-3 hover:bg-gray-100 dark:hover:bg-gray-700 transition">
                                <i class="fas fa-user text-blue-600"></i>
                                <span class="text-gray-700 dark:text-gray-300">My Profile</span>
                            </a>
                            
                            <a href="/bookings" class="flex items-center gap-3 px-4 py-3 hover:bg-gray-100 dark:hover:bg-gray-700 transition">
                                <i class="fas fa-calendar text-blue-600"></i>
                                <span class="text-gray-700 dark:text-gray-300">My Bookings</span>
                            </a>
                            
                            <a href="/settings" class="flex items-center gap-3 px-4 py-3 hover:bg-gray-100 dark:hover:bg-gray-700 transition">
                                <i class="fas fa-cog text-blue-600"></i>
                                <span class="text-gray-700 dark:text-gray-300">Settings</span>
                            </a>
                            
                            <button onclick="handleLogout()" class="w-full flex items-center gap-3 px-4 py-3 hover:bg-red-50 dark:hover:bg-red-900 transition text-left border-t border-gray-200 dark:border-gray-700">
                                <i class="fas fa-sign-out-alt text-red-600"></i>
                                <span class="text-red-600 font-semibold">Logout</span>
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Mobile Menu Toggle Button (Outside right actions for better visibility) -->
                <button id="mobileMenuBtn" class="md:hidden flex-shrink-0 ml-2 p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 transition z-50">
                    <i class="fas fa-bars text-3xl text-gray-900 dark:text-white"></i>
                </button>
            </div>
            
            <!-- Mobile Menu -->
            <div id="mobileMenu" class="hidden md:hidden fixed inset-0 top-16 bg-white dark:bg-gray-800 z-40 flex flex-col items-center justify-center gap-6 p-6">
                <!-- Close Button -->
                <button onclick="document.getElementById('mobileMenu').classList.add('hidden')" class="absolute top-4 right-4 p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 transition">
                    <i class="fas fa-times text-2xl text-gray-900 dark:text-white"></i>
                </button>
                
                <a href="#home" class="text-xl text-gray-700 dark:text-gray-300 hover:text-blue-600 dark:hover:text-blue-400 transition font-semibold">Home</a>
                <a href="/cars" class="text-xl text-gray-700 dark:text-gray-300 hover:text-blue-600 dark:hover:text-blue-400 transition font-semibold">All Cars</a>
                <a href="#why-us" class="text-xl text-gray-700 dark:text-gray-300 hover:text-blue-600 dark:hover:text-blue-400 transition font-semibold">Why Us</a>
                <a href="#testimonials" class="text-xl text-gray-700 dark:text-gray-300 hover:text-blue-600 dark:hover:text-blue-400 transition font-semibold">Reviews</a>
                
                <!-- Mobile Auth Buttons (Hidden when logged in) -->
                <div id="mobileAuthButtons" class="border-t border-gray-200 dark:border-gray-700 w-full pt-6 mt-6 flex flex-col gap-4" style="display: flex;">
                    <a href="/login" class="text-center px-4 py-2 text-blue-600 border-2 border-blue-600 rounded-lg hover:bg-blue-50 dark:hover:bg-blue-900 transition font-semibold">
                        Login
                    </a>
                    <a href="/register" class="text-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition font-semibold">
                        Sign Up
                    </a>
                </div>
                
                <!-- Mobile Profile Menu (Shown when logged in) -->
                <div id="mobileProfileMenu" class="border-t border-gray-200 dark:border-gray-700 w-full pt-6 mt-6 flex flex-col gap-4" style="display: none;">
                    <button onclick="goToProfile(); document.getElementById('mobileMenu').classList.add('hidden')" class="text-center px-4 py-2 text-blue-600 border-2 border-blue-600 rounded-lg hover:bg-blue-50 dark:hover:bg-blue-900 transition font-semibold">
                        <i class="fas fa-user mr-2"></i>My Profile
                    </button>
                    <a href="/bookings" class="text-center px-4 py-2 bg-blue-100 dark:bg-blue-900 text-blue-600 dark:text-blue-400 rounded-lg hover:bg-blue-200 dark:hover:bg-blue-800 transition font-semibold">
                        <i class="fas fa-calendar mr-2"></i>My Bookings
                    </a>
                    <button onclick="handleLogout()" class="text-center px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition font-semibold">
                        <i class="fas fa-sign-out-alt mr-2"></i>Logout
                    </button>
                </div>
            </div>
        </div>
    </nav>
    
    <!-- ==================== HERO SECTION ==================== -->
    <section id="home" class="hero-gradient hero-bg-pattern text-white pt-0 pb-0 min-h-screen flex items-center" style="height: 96vh;">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 w-full relative z-10">
            <div class="grid md:grid-cols-2 gap-8 items-center h-full">
                <!-- Left Content -->
                <div class="space-y-8">
                    <div class="space-y-6">
                        <div class="inline-flex items-center bg-white/20 backdrop-blur-md rounded-full px-6 py-3 border border-white/30">
                            <i class="fas fa-spark text-yellow-300 mr-2"></i>
                            <span class="text-sm font-semibold">Welcome to DriveHub Premium</span>
                        </div>
                        
                        <h1 class="text-6xl md:text-7xl font-black leading-tight">
                            Find Your 
                            <span class="text-yellow-300 block">Perfect Ride</span>
                        </h1>
                        
                        <p class="text-xl text-blue-100 max-w-lg leading-relaxed">
                            🚗 Discover premium vehicles, competitive prices, and seamless booking experience. Available anytime, anywhere across major cities.
                        </p>
                    </div>
                    
                    <div class="flex flex-col sm:flex-row gap-4 pt-4">
                        <button onclick="scrollToBooking()" class="px-10 py-4 bg-white text-blue-600 font-bold text-lg rounded-xl hover:bg-blue-50 transition shadow-2xl btn-glow flex items-center justify-center gap-2">
                            <i class="fas fa-search text-xl"></i>
                            Search Now
                        </button>
                        <button class="px-10 py-4 border-2 border-white text-white font-bold text-lg rounded-xl hover:bg-white/10 transition backdrop-blur-sm flex items-center justify-center gap-2">
                            <i class="fas fa-play-circle text-xl"></i>
                            Watch Demo
                        </button>
                    </div>
                    
                    <!-- Stats -->
                    <div class="grid grid-cols-3 gap-6 pt-8 border-t border-white/20">
                        <div>
                            <div class="text-4xl font-bold text-yellow-300">5000+</div>
                            <p class="text-blue-100 text-sm mt-1">Happy Customers</p>
                        </div>
                        <div>
                            <div class="text-4xl font-bold text-yellow-300">1200+</div>
                            <p class="text-blue-100 text-sm mt-1">Premium Vehicles</p>
                        </div>
                        <div>
                            <div class="text-4xl font-bold text-yellow-300">25+</div>
                            <p class="text-blue-100 text-sm mt-1">Cities Covered</p>
                        </div>
                    </div>
                </div>
                
                <!-- Right Image with Floating Icons -->
                <div class="hidden md:flex relative h-full items-center justify-center">
                    <div class="relative">
                        <!-- Main Car Image -->
                        <img src="https://cdn.pixabay.com/photo/2015/10/01/17/17/car-967387_1280.png" 
                             alt="Premium Car Rental" 
                             class="rounded-3xl  relative z-10 object-cover h-full w-full"
                             loading="lazy">
                        
                        <!-- Floating Cards -->
                        <div class="absolute -top-6 -left-8 bg-white/95 backdrop-blur-md rounded-2xl p-4 shadow-2xl icon-float" style="animation-delay: 0s;">
                            <div class="flex items-center gap-3">
                                <div class="bg-green-500 rounded-full p-3">
                                    <i class="fas fa-check text-white text-xl"></i>
                                </div>
                                <div>
                                    <p class="text-sm font-bold text-gray-900">Verified Safe</p>
                                    <p class="text-xs text-gray-600">100% Secure</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="absolute -bottom-4 -right-8 bg-white/95 backdrop-blur-md rounded-2xl p-4 shadow-2xl icon-float" style="animation-delay: 0.5s;">
                            <div class="flex items-center gap-3">
                                <div class="bg-blue-500 rounded-full p-3">
                                    <i class="fas fa-lightning-bolt text-white text-xl"></i>
                                </div>
                                <div>
                                    <p class="text-sm font-bold text-gray-900">Instant Booking</p>
                                    <p class="text-xs text-gray-600">In seconds</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="absolute top-20 -right-6 bg-white/95 backdrop-blur-md rounded-2xl p-4 shadow-2xl icon-float" style="animation-delay: 1s;">
                            <div class="flex items-center gap-3">
                                <div class="bg-purple-500 rounded-full p-3">
                                    <i class="fas fa-star text-white text-xl"></i>
                                </div>
                                <div>
                                    <p class="text-sm font-bold text-gray-900">4.9 Rating</p>
                                    <p class="text-xs text-gray-600">From users</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- ==================== FEATURED CARS SECTION ==================== -->
    <section id="cars" class="py-20 bg-white dark:bg-gray-900">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-16">
                <h2 class="text-5xl md:text-6xl font-black text-gray-900 dark:text-white mb-4">
                    <i class="fas fa-car text-blue-600 mr-3"></i>Featured Vehicles
                </h2>
                <p class="text-gray-600 dark:text-gray-400 text-lg max-w-2xl mx-auto">
                    Choose from our premium selection of well-maintained, insured vehicles
                </p>
            </div>
            
            <!-- Car Grid from Database -->
            <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
                
                <!-- Display cars from database -->
                <c:choose>
                    <c:when test="${not empty cars}">
                        <!-- JSP forEach Loop - Display database cars -->
                        <c:forEach items="${cars}" var="car">
                            <div class="group bg-white dark:bg-gray-800 rounded-2xl overflow-hidden card-hover shadow-lg border border-gray-200 dark:border-gray-700">
                                <div class="relative overflow-hidden h-48">
                                    <img src="${car.imageUrl}" 
                                         alt="${car.brand} ${car.model}" 
                                         class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300"
                                         loading="lazy">
                                    <div class="absolute top-4 right-4 bg-blue-600 text-white rounded-full px-4 py-1 text-sm font-bold">
                                        <i class="fas fa-bolt mr-1"></i>${car.category}
                                    </div>
                                </div>
                                <div class="p-6">
                                    <h3 class="text-2xl font-bold text-gray-900 dark:text-white mb-2">${car.brand} ${car.model}</h3>
                                    <div class="flex items-center gap-2 mb-4 text-sm text-gray-600 dark:text-gray-400">
                                        <span class="bg-blue-100 dark:bg-blue-900 text-blue-700 dark:text-blue-200 px-3 py-1 rounded-full">
                                            <i class="fas fa-tag mr-1"></i>${car.category}
                                        </span>
                                        <span class="flex items-center gap-1">
                                            <i class="fas fa-users text-blue-600"></i>${car.seats} Seats
                                        </span>
                                        <span class="flex items-center gap-1">
                                            <i class="fas fa-cog text-blue-600"></i>${car.transmission}
                                        </span>
                                    </div>
                                    <div class="border-t border-gray-200 dark:border-gray-700 pt-4 mb-4">
                                        <div class="flex justify-between items-center mb-4">
                                            <div>
                                                <span class="text-3xl font-black text-blue-600">₹${car.pricePerDay}</span>
                                                <span class="text-sm text-gray-600 dark:text-gray-400 ml-2">/day</span>
                                            </div>
                                            <div class="flex items-center text-yellow-400">
                                                <c:if test="${car.rating > 0}">
                                                    <span class="text-sm text-gray-600 dark:text-gray-400 mr-2">${car.rating}/5</span>
                                                </c:if>
                                                <i class="fas fa-star"></i>
                                            </div>
                                        </div>
                                    </div>
                                    <button onclick="goToCars()" class="w-full bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 text-white font-bold py-3 px-4 rounded-xl transition shadow-lg flex items-center justify-center gap-2">
                                        <i class="fas fa-calendar-check"></i>Book Now
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <!-- Default Sample Cars if no data in database -->
                        <div class="group bg-white dark:bg-gray-800 rounded-2xl overflow-hidden card-hover shadow-lg border border-gray-200 dark:border-gray-700">
                            <div class="relative overflow-hidden h-48">
                                <img src="https://images.unsplash.com/photo-1625231724441-3f60e5fbda0f?w=400&q=80" 
                                     alt="Honda City" 
                                     class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300"
                                     loading="lazy">
                                <div class="absolute top-4 right-4 bg-blue-600 text-white rounded-full px-4 py-1 text-sm font-bold">
                                    <i class="fas fa-bolt mr-1"></i>Economy
                                </div>
                            </div>
                            <div class="p-6">
                                <h3 class="text-2xl font-bold text-gray-900 dark:text-white mb-2">Honda City</h3>
                                <div class="flex items-center gap-2 mb-4 text-sm text-gray-600 dark:text-gray-400">
                                    <span class="bg-blue-100 dark:bg-blue-900 text-blue-700 dark:text-blue-200 px-3 py-1 rounded-full">
                                        <i class="fas fa-sedan mr-1"></i>Economy
                                    </span>
                                    <span class="flex items-center gap-1">
                                        <i class="fas fa-users text-blue-600"></i>5 Seats
                                    </span>
                                    <span class="flex items-center gap-1">
                                        <i class="fas fa-cog text-blue-600"></i>Manual
                                    </span>
                                </div>
                                <div class="border-t border-gray-200 dark:border-gray-700 pt-4 mb-4">
                                    <div class="flex justify-between items-center mb-4">
                                        <div>
                                            <span class="text-3xl font-black text-blue-600">₹2,499</span>
                                            <span class="text-sm text-gray-600 dark:text-gray-400 ml-2">/day</span>
                                        </div>
                                        <div class="flex items-center text-yellow-400">
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star-half-alt"></i>
                                        </div>
                                    </div>
                                </div>
                                <button onclick="goToCars()" class="w-full bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 text-white font-bold py-3 px-4 rounded-xl transition shadow-lg flex items-center justify-center gap-2">
                                    <i class="fas fa-calendar-check"></i>Book Now
                                </button>
                            </div>
                        </div>
                        
                        <div class="group bg-white dark:bg-gray-800 rounded-2xl overflow-hidden card-hover shadow-lg border border-gray-200 dark:border-gray-700">
                            <div class="relative overflow-hidden h-48">
                                <img src="https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?w=400&q=80" 
                                     alt="BMW 5 Series" 
                                     class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300"
                                     loading="lazy">
                                <div class="absolute top-4 right-4 bg-purple-600 text-white rounded-full px-4 py-1 text-sm font-bold">
                                    <i class="fas fa-crown mr-1"></i>Luxury
                                </div>
                            </div>
                            <div class="p-6">
                                <h3 class="text-2xl font-bold text-gray-900 dark:text-white mb-2">BMW 5 Series</h3>
                                <div class="flex items-center gap-2 mb-4 text-sm text-gray-600 dark:text-gray-400">
                                    <span class="bg-purple-100 dark:bg-purple-900 text-purple-700 dark:text-purple-200 px-3 py-1 rounded-full">
                                        <i class="fas fa-gem mr-1"></i>Luxury
                                    </span>
                                    <span class="flex items-center gap-1">
                                        <i class="fas fa-users text-blue-600"></i>5 Seats
                                    </span>
                                    <span class="flex items-center gap-1">
                                        <i class="fas fa-cog text-blue-600"></i>Automatic
                                    </span>
                                </div>
                                <div class="border-t border-gray-200 dark:border-gray-700 pt-4 mb-4">
                                    <div class="flex justify-between items-center mb-4">
                                        <div>
                                            <span class="text-3xl font-black text-blue-600">₹8,999</span>
                                            <span class="text-sm text-gray-600 dark:text-gray-400 ml-2">/day</span>
                                        </div>
                                        <div class="flex items-center text-yellow-400">
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                        </div>
                                    </div>
                                </div>
                                <button onclick="goToCars()" class="w-full bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 text-white font-bold py-3 px-4 rounded-xl transition shadow-lg flex items-center justify-center gap-2">
                                    <i class="fas fa-calendar-check"></i>Book Now
                                </button>
                            </div>
                        </div>
                        
                        <div class="group bg-white dark:bg-gray-800 rounded-2xl overflow-hidden card-hover shadow-lg border border-gray-200 dark:border-gray-700">
                            <div class="relative overflow-hidden h-48">
                                <img src="https://images.unsplash.com/photo-1606611013016-969c19d14311?w=400&q=80" 
                                     alt="Mahindra XUV500" 
                                     class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300"
                                     loading="lazy">
                                <div class="absolute top-4 right-4 bg-orange-600 text-white rounded-full px-4 py-1 text-sm font-bold">
                                    <i class="fas fa-mountain mr-1"></i>SUV
                                </div>
                            </div>
                            <div class="p-6">
                                <h3 class="text-2xl font-bold text-gray-900 dark:text-white mb-2">Mahindra XUV500</h3>
                                <div class="flex items-center gap-2 mb-4 text-sm text-gray-600 dark:text-gray-400">
                                    <span class="bg-orange-100 dark:bg-orange-900 text-orange-700 dark:text-orange-200 px-3 py-1 rounded-full">
                                        <i class="fas fa-square mr-1"></i>SUV
                                    </span>
                                    <span class="flex items-center gap-1">
                                        <i class="fas fa-users text-blue-600"></i>7 Seats
                                    </span>
                                    <span class="flex items-center gap-1">
                                        <i class="fas fa-cog text-blue-600"></i>Automatic
                                    </span>
                                </div>
                                <div class="border-t border-gray-200 dark:border-gray-700 pt-4 mb-4">
                                    <div class="flex justify-between items-center mb-4">
                                        <div>
                                            <span class="text-3xl font-black text-blue-600">₹4,999</span>
                                            <span class="text-sm text-gray-600 dark:text-gray-400 ml-2">/day</span>
                                        </div>
                                        <div class="flex items-center text-yellow-400">
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star-half-alt"></i>
                                        </div>
                                    </div>
                                </div>
                                <button onclick="goToCars()" class="w-full bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 text-white font-bold py-3 px-4 rounded-xl transition shadow-lg flex items-center justify-center gap-2">
                                    <i class="fas fa-calendar-check"></i>Book Now
                                </button>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
        </div>
    </section>
    
    <!-- ==================== PROMOTIONS BANNER ==================== -->
    <section class="py-12 bg-gradient-to-r from-blue-600 to-blue-800 text-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="grid md:grid-cols-3 gap-6">
                <div class="text-center">
                    <h3 class="text-2xl font-bold mb-2">🎉 15% OFF Weekend Rentals</h3>
                    <p>Book your weekend getaway and save big!</p>
                </div>
                <div class="text-center border-l border-r border-blue-400">
                    <h3 class="text-2xl font-bold mb-2">🎁 WELCOME10 - First Time Users</h3>
                    <p>Get ₹1,000 off on your first booking</p>
                </div>
                <div class="text-center">
                    <h3 class="text-2xl font-bold mb-2">💰 Long Term Discounts</h3>
                    <p>7+ days rental: 20% off | 30+ days: 35% off</p>
                </div>
            </div>
        </div>
    </section>
    
    <!-- ==================== WHY CHOOSE US SECTION ==================== -->
    <section id="why-us" class="py-20 bg-white dark:bg-gray-900">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-16">
                <h2 class="text-5xl md:text-6xl font-black text-gray-900 dark:text-white mb-4">
                    <i class="fas fa-medal text-blue-600 mr-3"></i>Why Choose DriveHub?
                </h2>
                <p class="text-gray-600 dark:text-gray-400 text-lg max-w-2xl mx-auto">
                    Experience the difference with our premium car rental service backed by cutting-edge technology and exceptional customer care
                </p>
            </div>
            
            <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
                <!-- Benefit Card 1 -->
                <div class="group bg-gradient-to-br from-blue-50 dark:from-gray-800 to-blue-100 dark:to-gray-700 rounded-2xl p-8 text-center card-hover border border-blue-200 dark:border-gray-600">
                    <div class="inline-flex items-center justify-center w-16 h-16 bg-blue-600 text-white rounded-2xl mb-6 group-hover:scale-110 transition-transform">
                        <i class="fas fa-headset text-2xl"></i>
                    </div>
                    <h3 class="text-2xl font-bold text-gray-900 dark:text-white mb-3">24/7 Support</h3>
                    <p class="text-gray-600 dark:text-gray-400 leading-relaxed">
                        Round-the-clock customer support via phone, chat, and email for all your queries
                    </p>
                </div>
                
                <!-- Benefit Card 2 -->
                <div class="group bg-gradient-to-br from-green-50 dark:from-gray-800 to-green-100 dark:to-gray-700 rounded-2xl p-8 text-center card-hover border border-green-200 dark:border-gray-600">
                    <div class="inline-flex items-center justify-center w-16 h-16 bg-green-600 text-white rounded-2xl mb-6 group-hover:scale-110 transition-transform">
                        <i class="fas fa-undo text-2xl"></i>
                    </div>
                    <h3 class="text-2xl font-bold text-gray-900 dark:text-white mb-3">Free Cancellation</h3>
                    <p class="text-gray-600 dark:text-gray-400 leading-relaxed">
                        Cancel up to 24 hours before pickup with full refund, no questions asked
                    </p>
                </div>
                
                <!-- Benefit Card 3 -->
                <div class="group bg-gradient-to-br from-yellow-50 dark:from-gray-800 to-yellow-100 dark:to-gray-700 rounded-2xl p-8 text-center card-hover border border-yellow-200 dark:border-gray-600">
                    <div class="inline-flex items-center justify-center w-16 h-16 bg-yellow-600 text-white rounded-2xl mb-6 group-hover:scale-110 transition-transform">
                        <i class="fas fa-tag text-2xl"></i>
                    </div>
                    <h3 class="text-2xl font-bold text-gray-900 dark:text-white mb-3">Best Prices</h3>
                    <p class="text-gray-600 dark:text-gray-400 leading-relaxed">
                        Guaranteed lowest prices in the market with transparent, upfront pricing
                    </p>
                </div>
                
                <!-- Benefit Card 4 -->
                <div class="group bg-gradient-to-br from-purple-50 dark:from-gray-800 to-purple-100 dark:to-gray-700 rounded-2xl p-8 text-center card-hover border border-purple-200 dark:border-gray-600">
                    <div class="inline-flex items-center justify-center w-16 h-16 bg-purple-600 text-white rounded-2xl mb-6 group-hover:scale-110 transition-transform">
                        <i class="fas fa-tools text-2xl"></i>
                    </div>
                    <h3 class="text-2xl font-bold text-gray-900 dark:text-white mb-3">Well-Maintained</h3>
                    <p class="text-gray-600 dark:text-gray-400 leading-relaxed">
                        All vehicles regularly serviced, inspected, and insured for your safety
                    </p>
                </div>
            </div>
        </div>
    </section>
    
    <!-- ==================== HOW IT WORKS SECTION ==================== -->
    <section class="py-20 bg-gray-50 dark:bg-gray-800">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-16">
                <h2 class="text-5xl md:text-6xl font-black text-gray-900 dark:text-white mb-4">
                    <i class="fas fa-traffic-light text-blue-600 mr-3"></i>How It Works
                </h2>
                <p class="text-gray-600 dark:text-gray-400 text-lg max-w-2xl mx-auto">
                    Book your perfect ride in just 4 simple steps
                </p>
            </div>
            
            <div class="grid md:grid-cols-4 gap-6">
                <!-- Step 1 -->
                <div class="relative">
                    <div class="bg-white dark:bg-gray-700 rounded-2xl p-8 text-center border-2 border-blue-200 dark:border-blue-600">
                        <div class="inline-flex items-center justify-center w-20 h-20 bg-gradient-to-br from-blue-600 to-blue-700 text-white rounded-2xl mb-6 text-3xl font-bold shadow-lg">
                            <i class="fas fa-magnifying-glass"></i>
                        </div>
                        <h3 class="text-2xl font-bold text-gray-900 dark:text-white mb-3">Search</h3>
                        <p class="text-gray-600 dark:text-gray-400">
                            Enter your location, dates, and car type preferences
                        </p>
                    </div>
                    <div class="hidden md:block absolute top-1/2 -right-3 w-6 h-0.5 bg-gradient-to-r from-blue-600 to-transparent"></div>
                </div>
                
                <!-- Step 2 -->
                <div class="relative">
                    <div class="bg-white dark:bg-gray-700 rounded-2xl p-8 text-center border-2 border-green-200 dark:border-green-600">
                        <div class="inline-flex items-center justify-center w-20 h-20 bg-gradient-to-br from-green-600 to-green-700 text-white rounded-2xl mb-6 text-3xl font-bold shadow-lg">
                            <i class="fas fa-hand-pointer"></i>
                        </div>
                        <h3 class="text-2xl font-bold text-gray-900 dark:text-white mb-3">Select</h3>
                        <p class="text-gray-600 dark:text-gray-400">
                            Browse and choose from available vehicles that match your needs
                        </p>
                    </div>
                    <div class="hidden md:block absolute top-1/2 -right-3 w-6 h-0.5 bg-gradient-to-r from-green-600 to-transparent"></div>
                </div>
                
                <!-- Step 3 -->
                <div class="relative">
                    <div class="bg-white dark:bg-gray-700 rounded-2xl p-8 text-center border-2 border-purple-200 dark:border-purple-600">
                        <div class="inline-flex items-center justify-center w-20 h-20 bg-gradient-to-br from-purple-600 to-purple-700 text-white rounded-2xl mb-6 text-3xl font-bold shadow-lg">
                            <i class="fas fa-credit-card"></i>
                        </div>
                        <h3 class="text-2xl font-bold text-gray-900 dark:text-white mb-3">Pay</h3>
                        <p class="text-gray-600 dark:text-gray-400">
                            Secure payment via card, wallet, or other payment methods
                        </p>
                    </div>
                    <div class="hidden md:block absolute top-1/2 -right-3 w-6 h-0.5 bg-gradient-to-r from-purple-600 to-transparent"></div>
                </div>
                
                <!-- Step 4 -->
                <div>
                    <div class="bg-white dark:bg-gray-700 rounded-2xl p-8 text-center border-2 border-orange-200 dark:border-orange-600">
                        <div class="inline-flex items-center justify-center w-20 h-20 bg-gradient-to-br from-orange-600 to-orange-700 text-white rounded-2xl mb-6 text-3xl font-bold shadow-lg">
                            <i class="fas fa-road"></i>
                        </div>
                        <h3 class="text-2xl font-bold text-gray-900 dark:text-white mb-3">Drive</h3>
                        <p class="text-gray-600 dark:text-gray-400">
                            Get confirmation and enjoy your premium driving experience!
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- ==================== TESTIMONIALS SECTION ==================== -->
    <section id="testimonials" class="py-20 bg-white dark:bg-gray-900">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-16">
                <h2 class="text-4xl font-bold text-gray-900 dark:text-white mb-4">
                    📝 What Our Customers Say
                </h2>
                <p class="text-gray-600 dark:text-gray-400 text-lg">
                    Join thousands of satisfied customers
                </p>
            </div>
            
            <div class="grid md:grid-cols-3 gap-8">
                <!-- Testimonial 1 -->
                <div class="bg-gray-50 dark:bg-gray-800 rounded-lg p-8 card-hover">
                    <div class="flex items-center mb-4">
                        <div class="flex text-yellow-400">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                        </div>
                        <span class="ml-2 text-gray-600 dark:text-gray-400">(5.0)</span>
                    </div>
                    <p class="text-gray-700 dark:text-gray-300 mb-4">
                        "Excellent service! The car was clean, well-maintained, and the booking process was super easy. Highly recommended!"
                    </p>
                    <div class="flex items-center">
                        <img src="https://i.pravatar.cc/48?img=1" alt="User" class="w-12 h-12 rounded-full mr-3">
                        <div>
                            <p class="font-bold text-gray-900 dark:text-white">Rajesh Kumar</p>
                            <p class="text-sm text-gray-600 dark:text-gray-400">Verified Renter</p>
                        </div>
                    </div>
                </div>
                
                <!-- Testimonial 2 -->
                <div class="bg-gray-50 dark:bg-gray-800 rounded-lg p-8 card-hover">
                    <div class="flex items-center mb-4">
                        <div class="flex text-yellow-400">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                        </div>
                        <span class="ml-2 text-gray-600 dark:text-gray-400">(5.0)</span>
                    </div>
                    <p class="text-gray-700 dark:text-gray-300 mb-4">
                        "Great prices and fantastic customer support. They helped me with everything I needed. Will definitely book again!"
                    </p>
                    <div class="flex items-center">
                        <img src="https://i.pravatar.cc/48?img=2" alt="User" class="w-12 h-12 rounded-full mr-3">
                        <div>
                            <p class="font-bold text-gray-900 dark:text-white">Priya Sharma</p>
                            <p class="text-sm text-gray-600 dark:text-gray-400">Verified Renter</p>
                        </div>
                    </div>
                </div>
                
                <!-- Testimonial 3 -->
                <div class="bg-gray-50 dark:bg-gray-800 rounded-lg p-8 card-hover">
                    <div class="flex items-center mb-4">
                        <div class="flex text-yellow-400">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                        </div>
                        <span class="ml-2 text-gray-600 dark:text-gray-400">(5.0)</span>
                    </div>
                    <p class="text-gray-700 dark:text-gray-300 mb-4">
                        "Best car rental service in town. Free cancellation policy is amazing, and the cars are top-notch!"
                    </p>
                    <div class="flex items-center">
                        <img src="https://i.pravatar.cc/48?img=3" alt="User" class="w-12 h-12 rounded-full mr-3">
                        <div>
                            <p class="font-bold text-gray-900 dark:text-white">Amit Singh</p>
                            <p class="text-sm text-gray-600 dark:text-gray-400">Verified Renter</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- ==================== LOCATIONS MAP SECTION ==================== -->
    <section class="py-20 bg-gray-50 dark:bg-gray-800">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-16">
                <h2 class="text-4xl font-bold text-gray-900 dark:text-white mb-4">
                    🗺️ Cities We Serve
                </h2>
                <p class="text-gray-600 dark:text-gray-400 text-lg">
                    Available across major cities in India
                </p>
            </div>
            
            <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
                <div class="bg-white dark:bg-gray-700 rounded-lg p-6 text-center card-hover">
                    <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-2">Mumbai</h3>
                    <p class="text-gray-600 dark:text-gray-400">5+ Locations</p>
                </div>
                <div class="bg-white dark:bg-gray-700 rounded-lg p-6 text-center card-hover">
                    <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-2">Delhi</h3>
                    <p class="text-gray-600 dark:text-gray-400">4+ Locations</p>
                </div>
                <div class="bg-white dark:bg-gray-700 rounded-lg p-6 text-center card-hover">
                    <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-2">Hyderabad</h3>
                    <p class="text-gray-600 dark:text-gray-400">3+ Locations</p>
                </div>
                <div class="bg-white dark:bg-gray-700 rounded-lg p-6 text-center card-hover">
                    <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-2">Bangalore</h3>
                    <p class="text-gray-600 dark:text-gray-400">3+ Locations</p>
                </div>
            </div>
        </div>
    </section>
    
    <!-- ==================== FOOTER ==================== -->
    <footer class="bg-gray-900 text-white py-16">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="grid md:grid-cols-4 gap-8 mb-12">
                <!-- Company Info -->
                <div>
                    <div class="flex items-center gap-2 mb-4">
                        <i class="fas fa-car text-blue-400 text-2xl"></i>
                        <span class="text-xl font-bold">DriveHub</span>
                    </div>
                    <p class="text-gray-400 mb-4">
                        Your trusted partner for premium car rentals across India.
                    </p>
                    <div class="flex gap-4">
                        <a href="#" class="text-gray-400 hover:text-blue-400"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="text-gray-400 hover:text-blue-400"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="text-gray-400 hover:text-blue-400"><i class="fab fa-instagram"></i></a>
                        <a href="#" class="text-gray-400 hover:text-blue-400"><i class="fab fa-linkedin-in"></i></a>
                    </div>
                </div>
                
                <!-- Quick Links -->
                <div>
                    <h4 class="text-lg font-bold mb-6">Quick Links</h4>
                    <ul class="space-y-3 text-gray-400">
                        <li><a href="#home" class="hover:text-blue-400">Home</a></li>
                        <li><a href="#cars" class="hover:text-blue-400">Our Fleet</a></li>
                        <li><a href="#why-us" class="hover:text-blue-400">Why Us</a></li>
                        <li><a href="#testimonials" class="hover:text-blue-400">Reviews</a></li>
                    </ul>
                </div>
                
                <!-- Support -->
                <div>
                    <h4 class="text-lg font-bold mb-6">Support</h4>
                    <ul class="space-y-3 text-gray-400">
                        <li><a href="#" class="hover:text-blue-400">Help Center</a></li>
                        <li><a href="#" class="hover:text-blue-400">Contact Us</a></li>
                        <li><a href="#" class="hover:text-blue-400">FAQs</a></li>
                        <li><a href="#" class="hover:text-blue-400">Booking Support</a></li>
                    </ul>
                </div>
                
                <!-- Legal -->
                <div>
                    <h4 class="text-lg font-bold mb-6">Legal</h4>
                    <ul class="space-y-3 text-gray-400">
                        <li><a href="#" class="hover:text-blue-400">Terms & Conditions</a></li>
                        <li><a href="#" class="hover:text-blue-400">Privacy Policy</a></li>
                        <li><a href="#" class="hover:text-blue-400">Cookie Policy</a></li>
                        <li><a href="#" class="hover:text-blue-400">Refund Policy</a></li>
                    </ul>
                </div>
            </div>
            
            <!-- Contact Info -->
            <div class="border-t border-gray-800 pt-8 mb-8">
                <div class="grid md:grid-cols-3 gap-8">
                    <div class="flex items-center gap-3">
                        <i class="fas fa-phone text-blue-400 text-xl"></i>
                        <div>
                            <p class="text-gray-400 text-sm">Call Us</p>
                            <p class="text-white font-semibold">+91-1234-567-890</p>
                        </div>
                    </div>
                    <div class="flex items-center gap-3">
                        <i class="fas fa-envelope text-blue-400 text-xl"></i>
                        <div>
                            <p class="text-gray-400 text-sm">Email</p>
                            <p class="text-white font-semibold">support@drivehub.com</p>
                        </div>
                    </div>
                    <div class="flex items-center gap-3">
                        <i class="fas fa-map-marker-alt text-blue-400 text-xl"></i>
                        <div>
                            <p class="text-gray-400 text-sm">Address</p>
                            <p class="text-white font-semibold">123 Tech Park, Mumbai</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Bottom Footer -->
            <div class="border-t border-gray-800 pt-8 text-center text-gray-400">
                <p>&copy; 2025 DriveHub. All rights reserved. | Crafted with <span class="text-red-500">❤</span> in India</p>
            </div>
        </div>
    </footer>
    
    <!-- ==================== LOGIN MODAL ==================== -->
    <div id="loginModal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-2xl w-full max-w-md">
            <div class="flex justify-between items-center p-6 border-b border-gray-200 dark:border-gray-700">
                <h2 class="text-2xl font-bold text-gray-900 dark:text-white">Login</h2>
                <button onclick="closeLoginModal()" class="text-gray-500 hover:text-gray-700">
                    <i class="fas fa-times text-2xl"></i>
                </button>
            </div>
            
            <form id="loginForm" class="p-6 space-y-4">
                <div>
                    <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">
                        Email Address
                    </label>
                    <input type="email" 
                           name="email" 
                           placeholder="you@example.com" 
                           class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                           required>
                </div>
                
                <div>
                    <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">
                        Password
                    </label>
                    <input type="password" 
                           name="password" 
                           placeholder="••••••••" 
                           class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                           required>
                </div>
                
                <div class="flex items-center justify-between">
                    <label class="flex items-center">
                        <input type="checkbox" class="mr-2">
                        <span class="text-sm text-gray-600 dark:text-gray-400">Remember me</span>
                    </label>
                    <a href="#" class="text-sm text-blue-600 hover:text-blue-700">Forgot password?</a>
                </div>
                
                <button type="submit" class="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-lg transition">
                    Login
                </button>
                
                <p class="text-center text-gray-600 dark:text-gray-400">
                    Don't have an account? 
                    <button type="button" onclick="switchToRegister()" class="text-blue-600 hover:text-blue-700 font-semibold">
                        Sign Up
                    </button>
                </p>
            </form>
        </div>
    </div>
    
    <!-- ==================== REGISTER MODAL ==================== -->
    <div id="registerModal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 overflow-y-auto">
        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-2xl w-full max-w-md my-8">
            <div class="flex justify-between items-center p-6 border-b border-gray-200 dark:border-gray-700">
                <h2 class="text-2xl font-bold text-gray-900 dark:text-white">Create Account</h2>
                <button onclick="closeRegisterModal()" class="text-gray-500 hover:text-gray-700">
                    <i class="fas fa-times text-2xl"></i>
                </button>
            </div>
            
            <form id="registerForm" class="p-6 space-y-4">
                <div>
                    <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">
                        Full Name
                    </label>
                    <input type="text" 
                           name="fullName" 
                           placeholder="John Doe" 
                           class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                           required>
                </div>
                
                <div>
                    <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">
                        Email Address
                    </label>
                    <input type="email" 
                           name="email" 
                           placeholder="you@example.com" 
                           class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                           required>
                </div>
                
                <div>
                    <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">
                        Mobile Number
                    </label>
                    <input type="tel" 
                           name="mobileNumber" 
                           placeholder="9876543210" 
                           class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                           required>
                </div>
                
                <div>
                    <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">
                        Password
                    </label>
                    <input type="password" 
                           name="password" 
                           placeholder="••••••••" 
                           class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                           required>
                </div>
                
                <div>
                    <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">
                        Confirm Password
                    </label>
                    <input type="password" 
                           name="confirmPassword" 
                           placeholder="••••••••" 
                           class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                           required>
                </div>
                
                <button type="button" 
                        onclick="showOtpModal()" 
                        class="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-lg transition">
                    Create Account
                </button>
                
                <p class="text-center text-gray-600 dark:text-gray-400">
                    Already have an account? 
                    <button type="button" onclick="switchToLogin()" class="text-blue-600 hover:text-blue-700 font-semibold">
                        Login
                    </button>
                </p>
            </form>
        </div>
    </div>
    
    <!-- ==================== OTP VERIFICATION MODAL ==================== -->
    <div id="otpModal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-2xl w-full max-w-md">
            <div class="flex justify-between items-center p-6 border-b border-gray-200 dark:border-gray-700">
                <h2 class="text-2xl font-bold text-gray-900 dark:text-white">Verify OTP</h2>
                <button onclick="closeOtpModal()" class="text-gray-500 hover:text-gray-700">
                    <i class="fas fa-times text-2xl"></i>
                </button>
            </div>
            
            <form id="otpForm" class="p-6 space-y-4">
                <p class="text-gray-600 dark:text-gray-400 text-center">
                    We've sent a 6-digit OTP to your email address.
                </p>
                
                <div>
                    <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">
                        Enter OTP
                    </label>
                    <input type="text" 
                           name="otp" 
                           placeholder="000000" 
                           maxlength="6"
                           inputmode="numeric"
                           class="w-full px-4 py-3 text-center text-2xl border-2 border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                           required>
                </div>
                
                <div class="text-center text-sm text-gray-600 dark:text-gray-400">
                    <p>Didn't receive the code? 
                        <button type="button" class="text-blue-600 hover:text-blue-700 font-semibold">
                            Resend OTP
                        </button>
                    </p>
                </div>
                
                <button type="submit" class="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-lg transition">
                    Verify & Create Account
                </button>
            </form>
        </div>
    </div>
    
    <!-- ==================== JAVASCRIPT ==================== -->
    <script>
/* ============================================================
    NAVIGATION & SESSION MANAGEMENT
   ============================================================ */

function goToProfile() {
    const session = JSON.parse(localStorage.getItem("userSession") || "{}");
    if (!session.loggedIn) return (window.location.href = "/login");
    window.location.href = session.role === "ADMIN" ? "/admin/dashboard" : "/profile";
}

function goToCars() {
    window.location.href = "/cars";
}

function handleLogout() {
    if (confirm("Are you sure you want to logout?")) {
        localStorage.removeItem("userSession");
        window.location.href = "/";
    }
}

function checkUserSession() {
    const session = JSON.parse(localStorage.getItem("userSession") || "{}");

    const authDesktop = document.getElementById("authButtons");
    const profileDesktop = document.getElementById("profileMenu");

    const authMobile = document.getElementById("mobileAuthButtons");
    const profileMobile = document.getElementById("mobileProfileMenu");

    if (session.loggedIn) {
        authDesktop.style.display = "none";
        profileDesktop.style.display = "block";

        authMobile.style.display = "none";
        profileMobile.style.display = "flex";

        document.getElementById("userEmail").textContent = session.email.split("@")[0];
        document.getElementById("dropdownEmail").textContent = session.email;
    } else {
        authDesktop.style.display = "flex";
        profileDesktop.style.display = "none";

        authMobile.style.display = "flex";
        profileMobile.style.display = "none";
    }
}

window.addEventListener("DOMContentLoaded", checkUserSession);


/* ============================================================
    DARK MODE TOGGLE
   ============================================================ */

const darkBtn = document.getElementById("darkModeToggle");
const html = document.documentElement;

if (localStorage.getItem("darkMode") === "true") html.classList.add("dark");

darkBtn.addEventListener("click", () => {
    html.classList.toggle("dark");
    localStorage.setItem("darkMode", html.classList.contains("dark"));
});


/* ============================================================
    MOBILE MENU
   ============================================================ */

const mobileMenuBtn = document.getElementById("mobileMenuBtn");
const mobileMenu = document.getElementById("mobileMenu");

mobileMenuBtn.onclick = () => mobileMenu.classList.toggle("hidden");

document.querySelectorAll("#mobileMenu a").forEach(a => {
    a.onclick = () => mobileMenu.classList.add("hidden");
});


/* ============================================================
    MODALS
   ============================================================ */

function openLoginModal() { document.getElementById("loginModal").classList.remove("hidden"); }
function closeLoginModal() { document.getElementById("loginModal").classList.add("hidden"); }

function openRegisterModal() { document.getElementById("registerModal").classList.remove("hidden"); }
function closeRegisterModal() { document.getElementById("registerModal").classList.add("hidden"); }

function showOtpModal() {
    closeRegisterModal();
    document.getElementById("otpModal").classList.remove("hidden");
}

function closeOtpModal() { document.getElementById("otpModal").classList.add("hidden"); }

function switchToLogin() { closeRegisterModal(); openLoginModal(); }
function switchToRegister() { closeLoginModal(); openRegisterModal(); }


/* ============================================================
    LOGIN SUBMISSION
   ============================================================ */

document.getElementById("loginForm")?.addEventListener("submit", async (e) => {
    e.preventDefault();

    const email = e.target.email.value.trim();
    const password = e.target.password.value.trim();

    try {
        const response = await fetch("/api/user/login", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: new URLSearchParams({ email, password })
        });

        const result = await response.text().then(r => r.toLowerCase());

        // Check if login failed
        if (!result.includes("success")) {
            alert("Invalid email or password");
            return;
        }

        const role = result.includes("admin") ? "ADMIN" : "USER";

        localStorage.setItem("userSession", JSON.stringify({
            email,
            loggedIn: true,
            role
        }));

        alert("Login successful!");
        closeLoginModal();
        checkUserSession();

        // Handle pending booking
        const pending = sessionStorage.getItem("pendingBooking");
        if (pending) {
            sessionStorage.removeItem("pendingBooking");
            window.location.href = "/booking?carId=" + pending;
            return;
        }

        window.location.href = role === "ADMIN" ? "/admin/dashboard" : "/";
    } catch (error) {
        alert("Login failed. Please try again.");
    }
});


/* ============================================================
    EVENT DELEGATION FOR BOOK NOW BUTTONS
   ============================================================ */

document.addEventListener("click", function (e) {
    const btn = e.target.closest(".book-now-btn");
    if (!btn) return;

    const carId = btn.getAttribute("data-car-id");
    if (!carId) return alert("Car ID missing");

    bookCarNow(parseInt(carId));
});


/* ============================================================
    BOOK NOW HANDLER
   ============================================================ */

function bookCarNow(carId) {
    const session = JSON.parse(localStorage.getItem("userSession") || "{}");

    if (!session.loggedIn) {
        sessionStorage.setItem("pendingBooking", carId);
        openLoginModal();
        return;
    }

    window.location.href = "/booking?carId=" + carId;
}

</script>

</body>
</html>
