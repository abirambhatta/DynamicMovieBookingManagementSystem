<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- Login page. Form for email and password. --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - MovieMint</title>
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
        
        /* Two column layout for login page */
        .login-container {
            display: flex;
            height: 100vh;
            background-color: #f8f9fa;
            overflow: hidden;
        }
        
        /* Left side - Logo section */
        .login-logo-section {
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
        .login-logo-section::before {
            content: '';
            position: absolute;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            top: -150px;
            right: -150px;
        }
        
        .login-logo-section::after {
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
        
        .features-list {
            margin-top: 50px;
            text-align: left;
            display: inline-block;
        }
        
        .features-list li {
            list-style: none;
            margin: 16px 0;
            font-size: 16px;
            opacity: 0.9;
            display: flex;
            align-items: center;
        }
        
        .features-list li::before {
            content: '✓';
            display: inline-block;
            width: 24px;
            height: 24px;
            background: rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            text-align: center;
            line-height: 24px;
            margin-right: 12px;
            font-weight: bold;
        }
        
        /* Right side - Form section */
        .login-form-section {
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
        
        .login-form-box {
            width: 100%;
            max-width: 380px;
        }
        
        .login-form-box h2 {
            text-align: center;
            color: #212529;
            margin-bottom: 8px;
            font-size: 32px;
            font-weight: 600;
        }
        
        .login-form-box .form-subtitle {
            text-align: center;
            color: #6c757d;
            margin-bottom: 32px;
            font-size: 14px;
        }
        
        .form-group {
            margin-bottom: 24px;
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
        
        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 12px 16px;
            border-radius: 6px;
            margin-bottom: 20px;
            border: 1px solid #c3e6cb;
            font-size: 14px;
        }
        
        /* Responsive design */
        @media (max-width: 768px) {
            .login-container {
                flex-direction: column;
                height: auto;
                overflow: visible;
            }
            
            .login-logo-section {
                padding: 40px 20px;
                height: auto;
                min-height: 250px;
            }
            
            .login-form-section {
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
            
            .features-list {
                margin-top: 30px;
            }
            
            .features-list li {
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <!-- Left side - Logo section -->
        <div class="login-logo-section">
            <div class="logo-content">
                <h1>MovieMint</h1>
                <p class="tagline">Book Your Favorite Movies</p>
                
                <ul class="features-list">
                    <li>Easy ticket booking</li>
                    <li>Multiple seat options</li>
                    <li>Secure payments</li>
                    <li>Instant confirmation</li>
                </ul>
            </div>
        </div>
        
        <!-- Right side - Form section -->
        <div class="login-form-section">
            <div class="login-form-box">
                <h2>Welcome Back</h2>
                <p class="form-subtitle">Sign in to your account</p>
                
                <!-- Show error message if login failed -->
                <c:if test="${not empty error}">
                    <div class="error-message">${error}</div>
                </c:if>

                <!-- Show success message if registration was successful -->
                <c:if test="${not empty param.success}">
                    <div class="success-message">Registration successful. Please login.</div>
                </c:if>

                <!-- Login form -->
                <form action="${pageContext.request.contextPath}/login" method="post">
                    <!-- Email input field -->
                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" name="email" value="${param.email}" placeholder="your@email.com" required>
                    </div>
                    
                    <!-- Password input field -->
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" placeholder="Enter your password" required>
                    </div>
                    
                    <!-- Submit button -->
                    <button type="submit" class="btn-primary">Sign In</button>
                </form>
                
                <!-- Links for forgot password and registration -->
                <div class="links">
                    <!-- Link to forgot password page -->
                    <p><a href="${pageContext.request.contextPath}/forgotPassword">Forgot your password?</a></p>
                    <!-- Link to registration page -->
                    <p>Don't have an account? <a href="${pageContext.request.contextPath}/register">Create one</a></p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
