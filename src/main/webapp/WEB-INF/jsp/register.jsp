<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="DriveHub Registration - Create your car rental account">
    <title>Register - DriveHub Car Rental</title>
    
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
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        
        .toast {
            padding: 16px 20px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            display: flex;
            align-items: center;
            gap: 12px;
            animation: slideIn 0.3s ease-out;
            color: white;
            font-weight: 500;
        }
        
        .toast.success {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
        }
        
        .toast.error {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
        }
        
        .toast.info {
            background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
        }
        
        @keyframes slideIn {
            from {
                transform: translateX(400px);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        
        @keyframes slideOut {
            from {
                transform: translateX(0);
                opacity: 1;
            }
            to {
                transform: translateX(400px);
                opacity: 0;
            }
        }
        
        .toast.removing {
            animation: slideOut 0.3s ease-out forwards;
        }
        
        .loading-spinner {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 0.8s linear infinite;
        }
        
        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Car Animation */
        .car-animation {
            position: relative;
            height: 100px;
            margin: 40px 0;
            overflow: hidden;
        }

        .car {
            position: absolute;
            font-size: 3rem;
            animation: driveCar 8s linear infinite;
        }

        @keyframes driveCar {
            0% {
                left: -80px;
                transform: translateY(0);
            }
            50% {
                left: 50%;
                transform: translateY(-10px);
            }
            100% {
                left: calc(100% + 20px);
                transform: translateY(0);
            }
        }

        .road {
            position: absolute;
            bottom: 30px;
            width: 100%;
            height: 4px;
            background: repeating-linear-gradient(
                to right,
                #fff 0px,
                #fff 20px,
                transparent 20px,
                transparent 40px
            );
            animation: moveRoad 1s linear infinite;
        }

        @keyframes moveRoad {
            0% { background-position: 0 0; }
            100% { background-position: 40px 0; }
        }

        /* Floating elements */
        .float {
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
        }

        /* Custom scrollbar */
        .custom-scroll::-webkit-scrollbar {
            width: 8px;
        }

        .custom-scroll::-webkit-scrollbar-track {
            background: #f1f1f1;
        }

        .custom-scroll::-webkit-scrollbar-thumb {
            background: #3b82f6;
            border-radius: 4px;
        }

        .custom-scroll::-webkit-scrollbar-thumb:hover {
            background: #2563eb;
        }
    </style>
</head>
<body class="bg-gray-50">
    
    <!-- Main Container -->
    <div class="min-h-screen flex">
        
        <!-- LEFT SIDE - Form (50%) -->
        <div class="w-full lg:w-1/2 flex flex-col">
            
            <!-- Header -->
            <div class="p-6 bg-white shadow-sm">
                <a href="/" class="flex items-center gap-2">
                    <i class="fas fa-car text-blue-600 text-2xl"></i>
                    <span class="text-xl font-bold text-gray-900">DriveHub</span>
                </a>
            </div>
            
            <!-- Form Container -->
            <div class="flex-1 overflow-y-auto custom-scroll px-6 py-8 lg:px-12 lg:py-12">
                
                <div class="max-w-xl mx-auto">
                    
                    <!-- Header -->
                    <div class="mb-8">
                        <h1 class="text-3xl lg:text-4xl font-bold text-gray-900 mb-2">Create Account</h1>
                        <p class="text-gray-600">Join DriveHub and start your journey today!</p>
                    </div>
                    
                    <!-- Form -->
                    <form id="registrationForm" class="space-y-6">
                        
                        <!-- Basic Information -->
                        <div>
                            <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center gap-2">
                                <span class="bg-blue-600 text-white w-7 h-7 rounded-full flex items-center justify-center text-sm">1</span>
                                Basic Information
                            </h2>
                            
                            <div class="space-y-4">
                                <!-- Full Name -->
                                <div>
                                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                                        Full Name <span class="text-red-500">*</span>
                                    </label>
                                    <div class="relative">
                                        <i class="fas fa-user absolute left-3 top-1/2 -translate-y-1/2 text-gray-400"></i>
                                        <input 
                                            type="text" 
                                            name="fullName" 
                                            placeholder="John Doe" 
                                            class="w-full pl-10 pr-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition"
                                            required>
                                    </div>
                                </div>
                                
                                <!-- Email -->
                                <div>
                                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                                        Email Address <span class="text-red-500">*</span>
                                    </label>
                                    <div class="relative">
                                        <i class="fas fa-envelope absolute left-3 top-1/2 -translate-y-1/2 text-gray-400"></i>
                                        <input 
                                            type="email" 
                                            name="email" 
                                            placeholder="you@example.com" 
                                            class="w-full pl-10 pr-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition"
                                            required>
                                    </div>
                                </div>
                                
                                <!-- Mobile & Password -->
                                <div class="grid grid-cols-2 gap-4">
                                    <div>
                                        <label class="block text-sm font-semibold text-gray-700 mb-2">
                                            Mobile <span class="text-red-500">*</span>
                                        </label>
                                        <input 
                                            type="tel" 
                                            name="mobileNumber" 
                                            placeholder="9876543210" 
                                            pattern="[0-9]{10}"
                                            maxlength="10"
                                            class="w-full px-3 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition"
                                            required>
                                    </div>
                                    
                                    <div>
                                        <label class="block text-sm font-semibold text-gray-700 mb-2">
                                            Password <span class="text-red-500">*</span>
                                        </label>
                                        <input 
                                            type="password" 
                                            name="password" 
                                            placeholder="••••••••" 
                                            class="w-full px-3 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition"
                                            required>
                                    </div>
                                </div>
                                
                                <!-- Confirm Password -->
                                <div>
                                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                                        Confirm Password <span class="text-red-500">*</span>
                                    </label>
                                    <input 
                                        type="password" 
                                        name="confirmPassword" 
                                        placeholder="••••••••" 
                                        class="w-full px-3 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition"
                                        required>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Document Information -->
                        <div class="pt-4">
                            <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center gap-2">
                                <span class="bg-blue-600 text-white w-7 h-7 rounded-full flex items-center justify-center text-sm">2</span>
                                Documents
                            </h2>
                            
                            <div class="grid grid-cols-2 gap-4">
                                <div>
                                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                                        PAN Number <span class="text-red-500">*</span>
                                    </label>
                                    <input 
                                        type="text" 
                                        name="panNumber" 
                                        placeholder="ABCDE1234F" 
                                        pattern="[A-Z]{5}[0-9]{4}[A-Z]{1}"
                                        maxlength="10"
                                        class="w-full px-3 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition uppercase"
                                        required>
                                </div>
                                
                                <div>
                                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                                        Aadhaar Number <span class="text-red-500">*</span>
                                    </label>
                                    <input 
                                        type="text" 
                                        name="aadhaarNumber" 
                                        placeholder="123456789012" 
                                        pattern="[0-9]{12}"
                                        maxlength="12"
                                        class="w-full px-3 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition"
                                        required>
                                </div>
                            </div>
                        </div>
                        
                        <!-- File Uploads -->
                        <div class="pt-4">
                            <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center gap-2">
                                <span class="bg-blue-600 text-white w-7 h-7 rounded-full flex items-center justify-center text-sm">3</span>
                                Upload Files
                            </h2>
                            
                            <div class="grid grid-cols-2 gap-4">
                                <!-- Driving License -->
                                <div>
                                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                                        Driving License <span class="text-red-500">*</span>
                                    </label>
                                    <div class="border-2 border-dashed border-gray-300 rounded-lg p-4 text-center hover:border-blue-500 transition cursor-pointer" onclick="document.getElementById('drivingLicense').click()">
                                        <i class="fas fa-cloud-upload-alt text-2xl text-gray-400 mb-1"></i>
                                        <p class="text-xs text-gray-600">Upload</p>
                                        <input 
                                            type="file" 
                                            id="drivingLicense"
                                            name="drivingLicense" 
                                            accept=".jpg,.jpeg,.png,.pdf"
                                            class="hidden"
                                            required>
                                        <span id="dlFileName" class="text-xs text-blue-600 mt-1 block"></span>
                                    </div>
                                </div>
                                
                                <!-- Aadhaar Photo -->
                                <div>
                                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                                        Aadhaar Photo <span class="text-red-500">*</span>
                                    </label>
                                    <div class="border-2 border-dashed border-gray-300 rounded-lg p-4 text-center hover:border-blue-500 transition cursor-pointer" onclick="document.getElementById('aadhaarPhoto').click()">
                                        <i class="fas fa-cloud-upload-alt text-2xl text-gray-400 mb-1"></i>
                                        <p class="text-xs text-gray-600">Upload</p>
                                        <input 
                                            type="file" 
                                            id="aadhaarPhoto"
                                            name="aadhaarPhoto" 
                                            accept=".jpg,.jpeg,.png,.pdf"
                                            class="hidden"
                                            required>
                                        <span id="aadhaarFileName" class="text-xs text-blue-600 mt-1 block"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Terms -->
                        <div class="bg-blue-50 rounded-lg p-4">
                            <div class="flex items-start gap-3">
                                <input 
                                    type="checkbox" 
                                    id="terms"
                                    name="terms"
                                    class="mt-1 w-4 h-4 text-blue-600 rounded cursor-pointer"
                                    required>
                                <label for="terms" class="text-sm text-gray-700 cursor-pointer">
                                    I agree to the <a href="#" class="text-blue-600 hover:underline font-semibold">Terms & Conditions</a> and <a href="#" class="text-blue-600 hover:underline font-semibold">Privacy Policy</a> <span class="text-red-500">*</span>
                                </label>
                            </div>
                        </div>
                        
                        <!-- Submit Button -->
                        <button type="button" onclick="handleRegistration()" id="submitBtn" class="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-6 rounded-lg transition duration-200 shadow-lg hover:shadow-xl">
                            <i class="fas fa-user-plus mr-2"></i><span id="btnText">Create Account</span>
                        </button>
                        
                        <!-- Sign In Link -->
                        <p class="text-center text-gray-600 text-sm">
                            Already have an account? 
                            <a href="/login" class="text-blue-600 hover:underline font-bold">
                                Sign In
                            </a>
                        </p>
                    </form>
                    
                </div>
            </div>
        </div>
        
        <!-- RIGHT SIDE - Branding (50%) -->
        <div class="hidden lg:flex lg:w-1/2 bg-gradient-to-br from-blue-600 via-blue-700 to-blue-900 relative overflow-hidden">
            
            <!-- Decorative Elements -->
            <div class="absolute inset-0 opacity-10">
                <div class="absolute top-20 left-20 w-64 h-64 bg-white rounded-full blur-3xl"></div>
                <div class="absolute bottom-20 right-20 w-96 h-96 bg-white rounded-full blur-3xl"></div>
            </div>
            
            <!-- Content -->
            <div class="relative z-10 flex flex-col items-center justify-center w-full p-12 text-white">
                
                <!-- Logo -->
                <div class="float mb-8">
                    <i class="fas fa-car text-8xl opacity-90"></i>
                </div>
                
                <!-- Title -->
                <h2 class="text-5xl font-bold mb-4 text-center">Welcome to DriveHub</h2>
                <p class="text-xl text-blue-100 mb-8 text-center max-w-md">
                    Your journey to seamless car rentals starts here
                </p>
                
                <!-- Animated Car -->
                <div class="car-animation w-full max-w-lg">
                    <div class="road"></div>
                    <div class="car">
                        <i class="fas fa-car text-white"></i>
                    </div>
                </div>
                
                <!-- Features -->
                <div class="grid grid-cols-2 gap-6 mt-12 max-w-lg w-full">
                    <div class="bg-white bg-opacity-10 backdrop-blur-sm rounded-lg p-6 text-center hover:bg-opacity-20 transition">
                        <i class="fas fa-shield-alt text-3xl mb-3"></i>
                        <h3 class="font-bold mb-1">Secure</h3>
                        <p class="text-sm text-blue-100">Your data is encrypted</p>
                    </div>
                    
                    <div class="bg-white bg-opacity-10 backdrop-blur-sm rounded-lg p-6 text-center hover:bg-opacity-20 transition">
                        <i class="fas fa-clock text-3xl mb-3"></i>
                        <h3 class="font-bold mb-1">Quick</h3>
                        <p class="text-sm text-blue-100">Register in minutes</p>
                    </div>
                    
                    <div class="bg-white bg-opacity-10 backdrop-blur-sm rounded-lg p-6 text-center hover:bg-opacity-20 transition">
                        <i class="fas fa-star text-3xl mb-3"></i>
                        <h3 class="font-bold mb-1">Premium</h3>
                        <p class="text-sm text-blue-100">Best car selection</p>
                    </div>
                    
                    <div class="bg-white bg-opacity-10 backdrop-blur-sm rounded-lg p-6 text-center hover:bg-opacity-20 transition">
                        <i class="fas fa-headset text-3xl mb-3"></i>
                        <h3 class="font-bold mb-1">Support</h3>
                        <p class="text-sm text-blue-100">24/7 assistance</p>
                    </div>
                </div>
                
            </div>
        </div>
        
    </div>
    
    <!-- OTP MODAL -->
    <div id="otpModal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
        <div class="bg-white rounded-lg shadow-2xl w-full max-w-md mx-4">
            <div class="p-6 border-b border-gray-200">
                <h2 class="text-2xl font-bold text-gray-900 flex items-center gap-3">
                    <i class="fas fa-shield-alt text-blue-600"></i>
                    Verify Email OTP
                </h2>
            </div>
            
            <form id="otpForm" class="p-6 space-y-6">
                <p class="text-gray-600">
                    We've sent a 6-digit OTP to your email address. Please enter it below.
                </p>
                
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-3">
                        Enter OTP
                    </label>
                    <input 
                        type="text" 
                        id="otp"
                        name="otp" 
                        placeholder="000000" 
                        maxlength="6"
                        inputmode="numeric"
                        pattern="[0-9]{6}"
                        class="w-full px-4 py-4 text-center text-3xl tracking-widest border-2 border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition font-mono"
                        required>
                </div>
                
                <div class="text-center text-sm text-gray-600">
                    <p id="timerText" class="mb-2">Time remaining: <span id="timer">300</span>s</p>
                    <p>Didn't receive the code? 
                        <button type="button" id="resendBtn" onclick="resendOtp()" disabled class="text-blue-600 hover:underline font-semibold disabled:opacity-50 disabled:cursor-not-allowed">
                            Resend OTP
                        </button>
                    </p>
                </div>
                
                <div class="flex gap-3">
                    <button type="button" onclick="closeOtpModal()" class="flex-1 bg-gray-300 hover:bg-gray-400 text-gray-900 font-bold py-3 px-4 rounded-lg transition">
                        Cancel
                    </button>
                    <button type="submit" id="verifyBtn" class="flex-1 bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-4 rounded-lg transition">
                        <span id="verifyBtnText">Verify & Create</span>
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <!-- TOAST CONTAINER -->
    <div id="toastContainer" class="toast-container"></div>
    
    <!-- JAVASCRIPT -->
    <script>
        let otpTimer;
        let registrationData;
        
        function showToast(message, type = 'info') {
            const container = document.getElementById('toastContainer');
            const toast = document.createElement('div');
            toast.className = `toast ${type}`;
            
            let icon = '';
            if (type === 'success') icon = '<i class="fas fa-check-circle"></i>';
            else if (type === 'error') icon = '<i class="fas fa-exclamation-circle"></i>';
            else icon = '<i class="fas fa-info-circle"></i>';
            
            toast.innerHTML = `${icon} ${message}`;
            container.appendChild(toast);
            
            setTimeout(() => {
                toast.classList.add('removing');
                setTimeout(() => toast.remove(), 300);
            }, 4000);
        }
        
        document.getElementById('drivingLicense')?.addEventListener('change', function(e) {
            const fileName = e.target.files[0]?.name;
            document.getElementById('dlFileName').textContent = fileName ? `✓ ${fileName}` : '';
        });
        
        document.getElementById('aadhaarPhoto')?.addEventListener('change', function(e) {
            const fileName = e.target.files[0]?.name;
            document.getElementById('aadhaarFileName').textContent = fileName ? `✓ ${fileName}` : '';
        });
        
        async function handleRegistration() {
            const form = document.getElementById('registrationForm');
            
            if (!form.checkValidity()) {
                form.reportValidity();
                return;
            }
            
            if (!document.getElementById('terms').checked) {
                showToast('Please accept terms & conditions', 'error');
                return;
            }
            
            const submitBtn = document.getElementById('submitBtn');
            const btnText = document.getElementById('btnText');
            
            submitBtn.disabled = true;
            btnText.innerHTML = '<div class="loading-spinner"></div> Sending OTP...';
            
            try {
                const formData = new FormData(form);
                
                console.log('📤 Sending registration form...');
                const response = await fetch('/api/user/register', {
                    method: 'POST',
                    body: formData
                });
                
                console.log('📥 Response status:', response.status);
                const result = await response.text();
                console.log('📝 Response text:', result);
                
                if (result.includes('OTP sent successfully') || result.includes('successfully')) {
                    console.log('✅ OTP sent successfully! Showing modal...');
                    showToast('OTP sent to your email', 'info');
                    registrationData = new FormData(form);
                    
                    const otpModal = document.getElementById('otpModal');
                    console.log('🔍 OTP Modal element:', otpModal);
                    console.log('🔍 Modal classes before:', otpModal?.className);
                    otpModal.classList.remove('hidden');
                    console.log('🔍 Modal classes after:', otpModal?.className);
                    
                    startOtpTimer();
                } else {
                    console.log('❌ Unexpected response:', result);
                    showToast(result || 'Failed to send OTP', 'error');
                }
            } catch (error) {
                console.error('💥 Error:', error);
                showToast('Error: ' + error.message, 'error');
            } finally {
                submitBtn.disabled = false;
                btnText.innerHTML = '<i class="fas fa-user-plus mr-2"></i>Create Account';
            }
        }
        
        function startOtpTimer() {
            let timeLeft = 300;
            const timerElement = document.getElementById('timer');
            const resendBtn = document.getElementById('resendBtn');
            
            resendBtn.disabled = true;
            
            otpTimer = setInterval(() => {
                timeLeft--;
                timerElement.textContent = timeLeft;
                
                if (timeLeft <= 0) {
                    clearInterval(otpTimer);
                    resendBtn.disabled = false;
                    document.getElementById('timerText').classList.add('text-red-600');
                }
            }, 1000);
        }
        
        function closeOtpModal() {
            document.getElementById('otpModal').classList.add('hidden');
            document.getElementById('otp').value = '';
            if (otpTimer) clearInterval(otpTimer);
        }
        
        async function resendOtp() {
            try {
                const response = await fetch('/api/user/register', {
                    method: 'POST',
                    body: registrationData
                });
                
                const result = await response.text();
                
                if (result.includes('OTP sent successfully') || result.includes('successfully')) {
                    showToast('OTP resent to your email', 'info');
                    document.getElementById('otp').value = '';
                    startOtpTimer();
                } else {
                    showToast(result || 'Failed to resend OTP', 'error');
                }
            } catch (error) {
                showToast('Error: ' + error.message, 'error');
            }
        }
        
        document.getElementById('otpForm')?.addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const otp = document.getElementById('otp').value;
            
            if (!otp || otp.length !== 6) {
                showToast('Please enter 6-digit OTP', 'error');
                return;
            }
            
            const verifyBtn = document.getElementById('verifyBtn');
            const verifyBtnText = document.getElementById('verifyBtnText');
            
            verifyBtn.disabled = true;
            verifyBtnText.innerHTML = '<div class="loading-spinner"></div> Verifying...';
            
            try {
                const data = new FormData();
                data.append('email', registrationData.get('email'));
                data.append('otp', otp);
                data.append('fullName', registrationData.get('fullName'));
                data.append('mobileNumber', registrationData.get('mobileNumber'));
                data.append('password', registrationData.get('password'));
                data.append('panNumber', registrationData.get('panNumber'));
                data.append('aadhaarNumber', registrationData.get('aadhaarNumber'));
                
                if (registrationData.has('drivingLicense')) {
                    data.append('drivingLicense', registrationData.get('drivingLicense'));
                }
                if (registrationData.has('aadhaarPhoto')) {
                    data.append('aadhaarPhoto', registrationData.get('aadhaarPhoto'));
                }
                
                const response = await fetch('/api/user/verify-otp', {
                    method: 'POST',
                    body: data
                });
                
                const result = await response.text();
                
                if (result.includes('Registration successful') || result.includes('successfully')) {
                    showToast('✓ Account created successfully!', 'success');
                    
                    closeOtpModal();
                    
                    setTimeout(() => {
                        window.location.href = '/';
                    }, 1500);
                } else {
                    showToast(result || 'Failed to verify OTP', 'error');
                }
            } catch (error) {
                showToast('Error: ' + error.message, 'error');
            } finally {
                verifyBtn.disabled = false;
                verifyBtnText.innerHTML = 'Verify & Create';
            }
        });
        
        document.getElementById('otpModal')?.addEventListener('click', (e) => {
            if (e.target === document.getElementById('otpModal')) {
                closeOtpModal();
            }
        });
    </script>
</body>