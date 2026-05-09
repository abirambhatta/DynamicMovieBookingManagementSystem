<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- Register page. Form for new user signup. --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - MovieMint</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        html, body {
            height: 100%;
            width: 100%;
        }
        
        /* Two column layout for register page */
        .register-container {
            display: flex;
            height: 100vh;
            background-color: #f8f9fa;
            overflow: hidden;
        }
        
        /* Left side - Logo section */
        .register-logo-section {
            flex: 1;
            background: linear-gradient(135deg, #c9152f 0%, #a01026 100%);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 60px 60px;
            color: white;
            position: relative;
            overflow: hidden;
            height: 100vh;
        }
        
        /* Decorative elements - contained within section */
        .register-logo-section::before {
            content: '';
            position: absolute;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            top: -150px;
            right: -150px;
        }
        
        .register-logo-section::after {
            content: '';
            position: absolute;
            width: 200px;
            height: 200px;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 50%;
            bottom: -100px;
            left: -100px;
        }
        
        .logo-content {
            text-align: center;
            position: relative;
            z-index: 1;
        }
        
        .logo-content h1 {
            font-size: 56px;
            font-weight: 700;
            margin-bottom: 16px;
            letter-spacing: -1px;
        }
        
        .logo-content .tagline {
            font-size: 20px;
            opacity: 0.95;
            margin-bottom: 40px;
            font-weight: 300;
        }
        
        .benefits-list {
            margin-top: 50px;
            text-align: left;
            display: inline-block;
        }
        
        .benefits-list li {
            list-style: none;
            margin: 16px 0;
            font-size: 16px;
            opacity: 0.9;
            display: flex;
            align-items: center;
        }
        
        .benefits-list li::before {
            content: '★';
            display: inline-block;
            width: 24px;
            height: 24px;
            text-align: center;
            line-height: 24px;
            margin-right: 12px;
            font-size: 18px;
        }
        
        /* Right side - Form section */
        .register-form-section {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 60px 40px;
            background: white;
            overflow-y: auto;
            height: 100vh;
        }
        
        .register-form-box {
            width: 100%;
            max-width: 380px;
        }
        
        .register-form-box h2 {
            text-align: center;
            color: #212529;
            margin-bottom: 8px;
            font-size: 32px;
            font-weight: 600;
        }
        
        .register-form-box .form-subtitle {
            text-align: center;
            color: #6c757d;
            margin-bottom: 32px;
            font-size: 14px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #495057;
            font-weight: 500;
            font-size: 14px;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid #ced4da;
            border-radius: 6px;
            font-size: 15px;
            transition: all 0.2s;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #dc143c;
            box-shadow: 0 0 0 3px rgba(220, 20, 60, 0.1);
        }
        
        .btn-primary {
            width: 100%;
            padding: 12px;
            background-color: #dc143c;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s;
            margin-top: 8px;
        }
        
        .btn-primary:hover {
            background-color: #b71c1c;
        }
        
        .links {
            text-align: center;
            margin-top: 24px;
        }
        
        .links p {
            margin: 12px 0;
            font-size: 14px;
        }
        
        .links a {
            color: #dc143c;
            text-decoration: none;
            font-weight: 500;
        }
        
        .links a:hover {
            text-decoration: underline;
        }
        
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 12px 16px;
            border-radius: 6px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
            font-size: 14px;
        }
        
        /* Password strength indicator */
        .password-strength {
            margin-top: 8px;
            font-size: 12px;
        }
        .password-requirements {
            margin-top: 8px;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 4px;
            font-size: 12px;
        }
        .requirement {
            margin: 4px 0;
            color: #6c757d;
        }
        .requirement.valid {
            color: #28a745;
        }
        .requirement.valid::before {
            content: '✓ ';
            font-weight: bold;
        }
        .requirement.invalid::before {
            content: '✗ ';
            font-weight: bold;
        }
        .strength-bar {
            height: 4px;
            background: #e9ecef;
            border-radius: 2px;
            margin-top: 8px;
            overflow: hidden;
        }
        .strength-bar-fill {
            height: 100%;
            width: 0;
            transition: all 0.3s;
        }
        .strength-weak { background: #dc3545; width: 33%; }
        .strength-medium { background: #ffc107; width: 66%; }
        .strength-strong { background: #28a745; width: 100%; }
        
        /* Remove text cursor from labels and non-input elements */
        .register-logo-section, .logo-content, .tagline, .benefits-list, label, .form-subtitle, .links { user-select: none; cursor: default; }
        
        /* Responsive design */
        @media (max-width: 768px) {
            .register-container {
                flex-direction: column;
                height: auto;
                overflow: visible;
            }
            
            .register-logo-section {
                padding: 40px 20px;
                height: auto;
                min-height: 250px;
            }
            
            .register-form-section {
                padding: 40px 20px;
                height: auto;
                overflow-y: visible;
            }
            
            .logo-content h1 {
                font-size: 40px;
            }
            
            .logo-content .tagline {
                font-size: 18px;
            }
            
            .benefits-list {
                margin-top: 30px;
            }
            
            .benefits-list li {
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
    <div class="register-container">
        <!-- Left side - Logo section -->
        <div class="register-logo-section">
            <div class="logo-content">
                <h1>MovieMint</h1>
                <p class="tagline">Join Our Community</p>
                
                <ul class="benefits-list">
                    <li>Book tickets instantly</li>
                    <li>Choose your favorite seats</li>
                    <li>Get exclusive offers</li>
                    <li>Manage your bookings</li>
                </ul>
            </div>
        </div>
        
        <!-- Right side - Form section -->
        <div class="register-form-section">
            <div class="register-form-box">
                <h2>Create Account</h2>
                <p class="form-subtitle">Join MovieMint today</p>
                
                <!-- Show error message if registration failed -->
                <c:if test="${not empty error}">
                    <div class="error-message">${error}</div>
                </c:if>

                <!-- Registration form -->
                <form action="${pageContext.request.contextPath}/register" method="post">
                    <!-- Full name input field -->
                    <div class="form-group">
                        <label for="fullName">Full Name</label>
                        <input type="text" id="fullName" name="fullName" value="${param.fullName}" placeholder="Your Name" required>
                    </div>
                    
                    <!-- Email input field -->
                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" name="email" value="${param.email}" placeholder="your@email.com" required>
                    </div>
                    
                    <!-- Phone number input field (max 10 digits) -->
                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="text" id="phone" name="phone" value="${param.phone}" placeholder="Your Number" maxlength="10" required>
                    </div>
                    
                    <!-- Password input field -->
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" placeholder="Enter your password" required>
                        <div class="password-requirements" id="passwordRequirements" style="display:none;">
                            <div class="requirement" id="req-length">At least 8 characters</div>
                            <div class="requirement" id="req-uppercase">One uppercase letter (A-Z)</div>
                            <div class="requirement" id="req-lowercase">One lowercase letter (a-z)</div>
                            <div class="requirement" id="req-number">One number (0-9)</div>
                            <div class="requirement" id="req-special">One special character (!@#$%^&*)</div>
                        </div>
                        <div class="strength-bar">
                            <div class="strength-bar-fill" id="strengthBar"></div>
                        </div>
                    </div>
                    
                    <!-- Confirm password input field -->
                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm your password" required>
                    </div>
                    
                    <!-- Submit button -->
                    <button type="submit" class="btn-primary">Create Account</button>
                </form>
                
                <!-- Link to login page -->
                <div class="links">
                    <p>Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in</a></p>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Password strength validation
        const passwordInput = document.getElementById('password');
        const confirmPasswordInput = document.getElementById('confirmPassword');
        const requirementsDiv = document.getElementById('passwordRequirements');
        const strengthBar = document.getElementById('strengthBar');
        
        const requirements = {
            length: { regex: /.{8,}/, element: document.getElementById('req-length') },
            uppercase: { regex: /[A-Z]/, element: document.getElementById('req-uppercase') },
            lowercase: { regex: /[a-z]/, element: document.getElementById('req-lowercase') },
            number: { regex: /[0-9]/, element: document.getElementById('req-number') },
            special: { regex: /[!@#$%^&*(),.?":{}|<>]/, element: document.getElementById('req-special') }
        };

        passwordInput.addEventListener('focus', function() {
            requirementsDiv.style.display = 'block';
        });

        passwordInput.addEventListener('input', function() {
            const password = this.value;
            let validCount = 0;

            // Check each requirement
            for (let key in requirements) {
                const req = requirements[key];
                if (req.regex.test(password)) {
                    req.element.classList.add('valid');
                    req.element.classList.remove('invalid');
                    validCount++;
                } else {
                    req.element.classList.remove('valid');
                    req.element.classList.add('invalid');
                }
            }

            // Update strength bar
            strengthBar.className = 'strength-bar-fill';
            if (validCount <= 2) {
                strengthBar.classList.add('strength-weak');
            } else if (validCount <= 4) {
                strengthBar.classList.add('strength-medium');
            } else {
                strengthBar.classList.add('strength-strong');
            }
        });

        // Form validation on submit
        document.querySelector('form').addEventListener('submit', function(e) {
            const password = passwordInput.value;
            const confirmPassword = confirmPasswordInput.value;

            // Check all requirements
            let allValid = true;
            for (let key in requirements) {
                if (!requirements[key].regex.test(password)) {
                    allValid = false;
                    break;
                }
            }

            if (!allValid) {
                e.preventDefault();
                alert('Password must meet all requirements:\n- At least 8 characters\n- One uppercase letter\n- One lowercase letter\n- One number\n- One special character');
                return false;
            }

            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match!');
                return false;
            }
        });
    </script>
</body>
</html>
