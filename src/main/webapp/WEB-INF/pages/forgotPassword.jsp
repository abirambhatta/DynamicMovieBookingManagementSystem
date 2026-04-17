<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - MovieMint</title>
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
        
        /* Two column layout for forgot password page */
        .forgot-password-container {
            display: flex;
            height: 100vh;
            background-color: #f8f9fa;
            overflow: hidden;
        }
        
        /* Left side - Logo section */
        .forgot-password-logo-section {
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
        .forgot-password-logo-section::before {
            content: '';
            position: absolute;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            top: -150px;
            right: -150px;
        }
        
        .forgot-password-logo-section::after {
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
        
        .reset-info {
            margin-top: 50px;
            text-align: left;
            display: inline-block;
            max-width: 300px;
        }
        
        .reset-info h3 {
            font-size: 18px;
            margin-bottom: 16px;
            font-weight: 600;
        }
        
        .reset-info p {
            font-size: 15px;
            opacity: 0.9;
            line-height: 1.6;
            margin-bottom: 12px;
        }
        
        /* Right side - Form section */
        .forgot-password-form-section {
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
        
        .forgot-password-form-box {
            width: 100%;
            max-width: 380px;
        }
        
        .forgot-password-form-box h2 {
            text-align: center;
            color: #212529;
            margin-bottom: 8px;
            font-size: 32px;
            font-weight: 600;
        }
        
        .forgot-password-form-box .form-subtitle {
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
            .forgot-password-container {
                flex-direction: column;
                height: auto;
                overflow: visible;
            }
            
            .forgot-password-logo-section {
                padding: 40px 20px;
                height: auto;
                min-height: 250px;
            }
            
            .forgot-password-form-section {
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
            
            .reset-info {
                margin-top: 30px;
            }
            
            .reset-info h3 {
                font-size: 16px;
            }
            
            .reset-info p {
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
    <div class="forgot-password-container">
        <!-- Left side - Logo section -->
        <div class="forgot-password-logo-section">
            <div class="logo-content">
                <h1>MovieMint</h1>
                <p class="tagline">Recover Your Access</p>
                
                <div class="reset-info">
                    <h3>Password Reset</h3>
                    <p>Enter your email address and create a new password to regain access to your MovieMint account.</p>
                    <p>Your account will be secured with your new password.</p>
                </div>
            </div>
        </div>
        
        <!-- Right side - Form section -->
        <div class="forgot-password-form-section">
            <div class="forgot-password-form-box">
                <h2>Reset Password</h2>
                <p class="form-subtitle">Create a new password</p>
                
                <!-- Show error message if reset failed -->
                <c:if test="${not empty error}">
                    <div class="error-message">${error}</div>
                </c:if>
                
                <!-- Show success message if reset was successful -->
                <c:if test="${not empty success}">
                    <div class="success-message">${success}</div>
                </c:if>

                <!-- Password reset form -->
                <form action="${pageContext.request.contextPath}/forgotPassword" method="post">
                    <!-- Email input field -->
                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" name="email" value="${param.email}" placeholder="your@email.com" required>
                    </div>
                    
                    <!-- New password input field -->
                    <div class="form-group">
                        <label for="newPassword">New Password</label>
                        <input type="password" id="newPassword" name="newPassword" placeholder="Enter new password" required>
                    </div>
                    
                    <!-- Confirm password input field -->
                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm your password" required>
                    </div>
                    
                    <!-- Submit button to reset password -->
                    <button type="submit" class="btn-primary">Reset Password</button>
                </form>
                
                <!-- Link back to login page -->
                <div class="links">
                    <p><a href="${pageContext.request.contextPath}/login">Back to Login</a></p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
