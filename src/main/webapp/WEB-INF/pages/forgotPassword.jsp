<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MovieMint | Reset Password</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .forgot-password-container {
            max-width: 420px;
            margin: 60px auto;
            background: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            border: 1px solid #e9ecef;
        }
        .forgot-password-container h2 {
            text-align: center;
            color: #212529;
            margin-bottom: 32px;
            font-size: 28px;
            font-weight: 600;
        }
        .step-indicator {
            display: flex;
            justify-content: space-between;
            margin-bottom: 32px;
            gap: 12px;
        }
        .step {
            flex: 1;
            height: 4px;
            background: #e9ecef;
            border-radius: 2px;
            transition: background 0.3s;
        }
        .step.active {
            background: #dc143c;
        }
        .step.completed {
            background: #28a745;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 6px;
            color: #495057;
            font-weight: 500;
            font-size: 14px;
        }
        .form-group input {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ced4da;
            border-radius: 6px;
            font-size: 15px;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .form-group input:focus {
            outline: none;
            border-color: #dc143c;
            box-shadow: 0 0 0 3px rgba(220, 20, 60, 0.1);
        }
        .otp-input-group {
            display: flex;
            gap: 8px;
            justify-content: center;
            margin: 20px 0;
        }
        .otp-input {
            width: 50px;
            height: 50px;
            font-size: 24px;
            text-align: center;
            border: 2px solid #ced4da;
            border-radius: 6px;
            transition: border-color 0.2s;
        }
        .otp-input:focus {
            outline: none;
            border-color: #dc143c;
        }
        .btn {
            width: 100%;
            padding: 12px;
            background-color: #dc143c;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.2s;
            margin-top: 12px;
        }
        .btn:hover {
            background-color: #b71c1c;
        }
        .btn:disabled {
            background-color: #ccc;
            cursor: not-allowed;
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
        .info-text {
            color: #6c757d;
            font-size: 14px;
            margin-top: 12px;
            text-align: center;
        }
        .resend-otp {
            text-align: center;
            margin-top: 16px;
        }
        .resend-otp a {
            color: #dc143c;
            text-decoration: none;
            font-weight: 500;
        }
        .resend-otp a:hover {
            text-decoration: underline;
        }
        .timer {
            color: #dc143c;
            font-weight: 600;
        }
        .back-link {
            text-align: center;
            margin-top: 20px;
        }
        .back-link a {
            color: #dc143c;
            text-decoration: none;
            font-size: 14px;
        }
        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <jsp:include page="userHeader.jsp" />

    <div class="forgot-password-container">
        <h2>Reset Password</h2>

        <div class="step-indicator">
            <div class="step ${step == '1' ? 'active' : (step != '1' ? 'completed' : '')}"></div>
            <div class="step ${step == '2' ? 'active' : (step == '3' ? 'completed' : '')}"></div>
            <div class="step ${step == '3' ? 'active' : ''}"></div>
        </div>

        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="success-message">${success}</div>
        </c:if>

        <!-- Step 1: Email Verification -->
        <c:if test="${step == '1' || step == null}">
            <form method="POST" action="${pageContext.request.contextPath}/forgotPassword">
                <input type="hidden" name="step" value="1">
                
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" required placeholder="Enter your registered email">
                </div>

                <p class="info-text">We'll send you an OTP to verify your identity</p>

                <button type="submit" class="btn">Send OTP</button>

                <div class="back-link">
                    <a href="${pageContext.request.contextPath}/login">Back to Login</a>
                </div>
            </form>
        </c:if>

        <!-- Step 2: OTP Verification -->
        <c:if test="${step == '2'}">
            <form method="POST" action="${pageContext.request.contextPath}/forgotPassword">
                <input type="hidden" name="step" value="2">
                <input type="hidden" name="email" value="${email}">

                <p class="info-text">Enter the 6-digit OTP sent to ${email}</p>

                <div class="form-group">
                    <label for="otp">One-Time Password</label>
                    <input type="text" id="otp" name="otp" required placeholder="000000" maxlength="6" pattern="[0-9]{6}">
                </div>

                <p class="info-text">OTP expires in <span class="timer" id="timer">10:00</span></p>

                <button type="submit" class="btn">Verify OTP</button>

                <div class="resend-otp">
                    <a href="${pageContext.request.contextPath}/forgotPassword?step=1">Resend OTP</a>
                </div>

                <div class="back-link">
                    <a href="${pageContext.request.contextPath}/login">Back to Login</a>
                </div>
            </form>

            <script>
                let timeLeft = 600;
                const timerElement = document.getElementById('timer');
                
                const countdown = setInterval(() => {
                    timeLeft--;
                    const minutes = Math.floor(timeLeft / 60);
                    const seconds = timeLeft % 60;
                    timerElement.textContent = minutes + ':' + (seconds < 10 ? '0' : '') + seconds;
                    
                    if (timeLeft <= 0) {
                        clearInterval(countdown);
                        timerElement.textContent = 'Expired';
                    }
                }, 1000);
            </script>
        </c:if>

        <!-- Step 3: New Password -->
        <c:if test="${step == '3'}">
            <form method="POST" action="${pageContext.request.contextPath}/forgotPassword">
                <input type="hidden" name="step" value="3">
                <input type="hidden" name="email" value="${email}">

                <p class="info-text">Create a new password for your account</p>

                <div class="form-group">
                    <label for="newPassword">New Password</label>
                    <input type="password" id="newPassword" name="newPassword" required placeholder="At least 6 characters">
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required placeholder="Re-enter your password">
                </div>

                <button type="submit" class="btn">Reset Password</button>

                <div class="back-link">
                    <a href="${pageContext.request.contextPath}/login">Back to Login</a>
                </div>
            </form>
        </c:if>
    </div>
</body>
</html>
