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
            background: linear-gradient(135deg, #dc143c 0%, #b71c1c 100%);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 60px 40px;
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
                        <input type="text" id="fullName" name="fullName" value="${param.fullName}" placeholder="John Doe" required>
                    </div>
                    
                    <!-- Email input field -->
                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" name="email" value="${param.email}" placeholder="your@email.com" required>
                    </div>
                    
                    <!-- Phone number input field (max 10 digits) -->
                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="text" id="phone" name="phone" value="${param.phone}" placeholder="9876543210" maxlength="10" required>
                    </div>
                    
                    <!-- Password input field -->
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" placeholder="Enter your password" required>
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
</body>
</html>
