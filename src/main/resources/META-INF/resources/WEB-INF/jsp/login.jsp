<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="DriveHub Login - Access your car rental account">
    <title>Login - DriveHub Car Rental</title>
    
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class'
        }
    </script>
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        .login-gradient {
            background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
        }
    </style>
</head>
<body class="bg-white dark:bg-gray-900">
    
    <!-- Navigation -->
    <nav class="bg-white dark:bg-gray-800 shadow">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
            <a href="/" class="flex items-center gap-2">
                <i class="fas fa-car text-blue-600 text-2xl"></i>
                <span class="text-xl font-bold text-gray-900 dark:text-white">DriveHub</span>
            </a>
            <a href="/" class="text-gray-600 dark:text-gray-400 hover:text-blue-600">
                Back to Home
            </a>
        </div>
    </nav>
    
    <!-- Main Content -->
    <div class="min-h-screen bg-gray-50 dark:bg-gray-900 flex items-center justify-center py-12">
        <div class="w-full max-w-md">
            <!-- Card -->
            <div class="bg-white dark:bg-gray-800 rounded-lg shadow-xl p-8">
                <!-- Header -->
                <div class="text-center mb-8">
                    <h1 class="text-3xl font-bold text-gray-900 dark:text-white mb-2">Welcome Back</h1>
                    <p class="text-gray-600 dark:text-gray-400">Sign in to your DriveHub account</p>
                </div>
                
                <!-- Form -->
                <form id="loginForm" class="space-y-6">
                    <!-- Email Field -->
                    <div>
                        <label for="email" class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">
                            Email Address
                        </label>
                        <div class="relative">
                            <i class="fas fa-envelope absolute left-4 top-1/2 -translate-y-1/2 text-gray-400"></i>
                            <input 
                                type="email" 
                                id="email"
                                name="email" 
                                placeholder="you@example.com" 
                                class="w-full pl-10 pr-4 py-3 border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition"
                                required>
                        </div>
                    </div>
                    
                    <!-- Password Field -->
                    <div>
                        <label for="password" class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">
                            Password
                        </label>
                        <div class="relative">
                            <i class="fas fa-lock absolute left-4 top-1/2 -translate-y-1/2 text-gray-400"></i>
                            <input 
                                type="password" 
                                id="password"
                                name="password" 
                                placeholder="••••••••" 
                                class="w-full pl-10 pr-4 py-3 border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition"
                                required>
                        </div>
                    </div>
                    
                    <!-- Remember & Forgot -->
                    <div class="flex items-center justify-between">
                        <label class="flex items-center cursor-pointer">
                            <input type="checkbox" name="remember" class="w-4 h-4 text-blue-600 rounded">
                            <span class="ml-2 text-sm text-gray-600 dark:text-gray-400">Remember me</span>
                        </label>
                        <a href="#" class="text-sm text-blue-600 hover:text-blue-700 font-semibold">Forgot Password?</a>
                    </div>
                    
                    <!-- Error Message -->
                    <div id="errorMsg" class="hidden bg-red-100 dark:bg-red-900 text-red-700 dark:text-red-200 px-4 py-3 rounded-lg text-sm"></div>
                    
                    <!-- Submit Button -->
                    <button type="submit" id="submitBtn" class="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-4 rounded-lg transition duration-200 shadow-lg hover:shadow-xl">
                        <i class="fas fa-sign-in-alt mr-2"></i><span id="btnText">Sign In</span>
                    </button>
                </form>
                
                <!-- Divider -->
                <div class="relative my-8">
                    <div class="absolute inset-0 flex items-center">
                        <div class="w-full border-t border-gray-300 dark:border-gray-600"></div>
                    </div>
                    <div class="relative flex justify-center text-sm">
                        <span class="px-2 bg-white dark:bg-gray-800 text-gray-500">OR</span>
                    </div>
                </div>
                
                <!-- Social Login -->
                <div class="space-y-3">
                    <button type="button" class="w-full flex items-center justify-center gap-3 bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600 text-gray-900 dark:text-white font-semibold py-3 px-4 rounded-lg transition">
                        <i class="fab fa-google"></i>Google
                    </button>
                    <button type="button" class="w-full flex items-center justify-center gap-3 bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600 text-gray-900 dark:text-white font-semibold py-3 px-4 rounded-lg transition">
                        <i class="fab fa-apple"></i>Apple
                    </button>
                </div>
                
                <!-- Sign Up Link -->
                <p class="text-center mt-8 text-gray-600 dark:text-gray-400">
                    Don't have an account? 
                    <a href="/register" class="text-blue-600 hover:text-blue-700 font-bold">
                        Create Account
                    </a>
                </p>
            </div>
            
            <!-- Footer Note -->
            <div class="text-center mt-6 text-sm text-gray-600 dark:text-gray-400">
                <p>🔒 Your data is encrypted and secure</p>
            </div>
        </div>
    </div>
    
    <script>
        // Check if already logged in
        window.addEventListener('DOMContentLoaded', () => {
            const userSession = localStorage.getItem('userSession');
            if (userSession) {
                window.location.href = '/';
            }
        });
        
        // Handle login form submission
        document.getElementById('loginForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            const submitBtn = document.getElementById('submitBtn');
            const btnText = document.getElementById('btnText');
            const errorMsg = document.getElementById('errorMsg');
            
            // Clear error message
            errorMsg.classList.add('hidden');
            
            // Disable button and show loading state
            submitBtn.disabled = true;
            btnText.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Signing In...';
            
            try {
                const response = await fetch('/api/user/login', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: 'email=' + encodeURIComponent(email) + '&password=' + encodeURIComponent(password)
                });
                
                const result = await response.text();
                const trimmedResult = result.trim();
                
                // Convert to lowercase for case-insensitive comparison
                const resultLower = trimmedResult.toLowerCase();
                
                // Check for failed login
                if (!resultLower.includes('success')) {
                    errorMsg.classList.remove('hidden');
                    errorMsg.textContent = trimmedResult || 'Invalid email or password';
                    submitBtn.disabled = false;
                    btnText.innerHTML = '<i class="fas fa-sign-in-alt mr-2"></i>Sign In';
                    return;
                }
                
                // Check for admin login
                if (resultLower.includes('admin')) {
                    // Store admin session
                    const adminSession = {
                        email: email,
                        timestamp: new Date().toISOString(),
                        loggedIn: true,
                        role: 'ADMIN'
                    };
                    localStorage.setItem('userSession', JSON.stringify(adminSession));
                    
                    // Show success message
                    errorMsg.classList.remove('hidden');
                    errorMsg.className = 'bg-green-100 dark:bg-green-900 text-green-700 dark:text-green-200 px-4 py-3 rounded-lg text-sm';
                    errorMsg.textContent = '✓ Admin login successful! Redirecting to dashboard...';
                    
                    // Redirect to admin dashboard
                    setTimeout(() => {
                        window.location.href = '/admin/dashboard';
                    }, 1500);
                } else {
                    // Store user session in localStorage
                    const userSession = {
                        email: email,
                        timestamp: new Date().toISOString(),
                        loggedIn: true,
                        role: 'USER'
                    };
                    localStorage.setItem('userSession', JSON.stringify(userSession));
                    
                    // Show success message
                    errorMsg.classList.remove('hidden');
                    errorMsg.className = 'bg-green-100 dark:bg-green-900 text-green-700 dark:text-green-200 px-4 py-3 rounded-lg text-sm';
                    errorMsg.textContent = '✓ Login successful! Redirecting...';
                    
                    // Redirect to home page
                    setTimeout(() => {
                        window.location.href = '/';
                    }, 1500);
                }
            } catch (error) {
                console.error('Login error:', error);
                errorMsg.classList.remove('hidden');
                errorMsg.textContent = 'Error: ' + error.message;
            } finally {
                submitBtn.disabled = false;
                btnText.innerHTML = '<i class="fas fa-sign-in-alt mr-2"></i>Sign In';
            }
        });
    </script>
</body>
</html>
