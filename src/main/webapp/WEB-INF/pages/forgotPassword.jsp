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
        .login-layout {
            display: flex;
            min-height: 100vh;
            width: 100%;
        }

        .login-brand {
            flex: 1;
            background: radial-gradient(circle at 30% 30%, #e61937 0%, #c9152f 40%, #5c0008 100%);
            color: #fff;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 60px 80px;
            position: relative;
            overflow: hidden;
            box-shadow: inset -10px 0 30px rgba(0,0,0,0.15);
        }

        .login-brand::before {
            content: '';
            position: absolute;
            width: 600px; height: 600px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(255,255,255,0.08) 0%, transparent 70%);
            top: -200px; left: -100px;
            pointer-events: none;
        }

        .login-brand::after {
            content: '';
            position: absolute;
            width: 400px; height: 400px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(0,0,0,0.3) 0%, transparent 70%);
            bottom: -100px; right: -100px;
            pointer-events: none;
        }

        .brand-content {
            position: relative;
            z-index: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
        }

        .brand-title {
            font-size: 54px;
            font-weight: 900;
            letter-spacing: -1.5px;
            margin-bottom: 12px;
            text-shadow: 0 2px 10px rgba(0,0,0,0.2);
            line-height: 1.1;
        }

        .brand-tag {
            font-size: 18px;
            color: rgba(255,255,255,0.9);
            line-height: 1.5;
        }

        .login-form-wrap {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f5f5f5;
            padding: 40px 24px;
        }

        .login-card {
            background: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 40px 36px;
            width: 100%;
            max-width: 440px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }

        .login-card h2 {
            text-align: center;
            color: #212529;
            margin-bottom: 32px;
            font-size: 28px;
            font-weight: 700;
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
            margin-bottom: 8px;
            color: #495057;
            font-weight: 600;
            font-size: 16px;
        }
        .form-group input {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid #ced4da;
            border-radius: 6px;
            font-size: 16px;
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
            padding: 14px;
            background-color: #dc143c;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 17px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s;
            margin-top: 16px;
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
            font-size: 16px;
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
            font-size: 16px;
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
    <div class="login-layout">
        <div class="login-brand">
            <div class="brand-content">
                <div class="brand-title">MovieMint</div>
                <div class="brand-tag">Account Recovery</div>
            </div>
        </div>

        <div class="login-form-wrap">
            <div class="login-card">
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
            <form method="POST" action="${pageContext.request.contextPath}/forgotPassword" onsubmit="return combineOtp()">
                <input type="hidden" name="step" value="2">
                <input type="hidden" name="email" value="${email}">
                <input type="hidden" name="otp" id="fullOtp">

                <p class="info-text">Enter the 6-digit OTP sent to ${email}</p>

                <div class="otp-input-group">
                    <input type="text" class="otp-input" id="otp1" maxlength="1" oninput="moveToNext(this, 'otp2')" onkeydown="moveToPrev(event, this, null)">
                    <input type="text" class="otp-input" id="otp2" maxlength="1" oninput="moveToNext(this, 'otp3')" onkeydown="moveToPrev(event, this, 'otp1')">
                    <input type="text" class="otp-input" id="otp3" maxlength="1" oninput="moveToNext(this, 'otp4')" onkeydown="moveToPrev(event, this, 'otp2')">
                    <input type="text" class="otp-input" id="otp4" maxlength="1" oninput="moveToNext(this, 'otp5')" onkeydown="moveToPrev(event, this, 'otp3')">
                    <input type="text" class="otp-input" id="otp5" maxlength="1" oninput="moveToNext(this, 'otp6')" onkeydown="moveToPrev(event, this, 'otp4')">
                    <input type="text" class="otp-input" id="otp6" maxlength="1" oninput="moveToNext(this, null)" onkeydown="moveToPrev(event, this, 'otp5')">
                </div>

                <% 
                    Long otpSent = (Long) request.getAttribute("otpSentTime");
                    if (otpSent == null) otpSent = (Long) session.getAttribute("otpSentTime");
                    
                    long remain = 300;
                    if (otpSent != null) {
                        long elapsed = (System.currentTimeMillis() - otpSent) / 1000;
                        remain = 300 - elapsed;
                        if (remain < 0) remain = 0;
                    }
                    long mins = remain / 60;
                    long secs = remain % 60;
                %>
                <p class="info-text">OTP expires in <span class="timer" id="timer"><%= mins %>:<%= (secs < 10 ? "0" : "") + secs %></span></p>

                <button type="submit" class="btn" id="verifyBtn">Verify OTP</button>

                <div class="resend-otp">
                    <a href="${pageContext.request.contextPath}/forgotPassword?step=resend">Resend OTP</a>
                </div>

                <div class="back-link">
                    <a href="${pageContext.request.contextPath}/login">Back to Login</a>
                </div>
            </form>

            <script>
                function moveToNext(current, nextFieldID) {
                    if (current.value.length >= 1) {
                        if (nextFieldID) {
                            document.getElementById(nextFieldID).focus();
                        } else {
                            current.blur();
                        }
                    }
                }
                
                function moveToPrev(e, current, prevFieldID) {
                    if (e.key === 'Backspace' && current.value.length === 0 && prevFieldID) {
                        document.getElementById(prevFieldID).focus();
                    }
                }
                
                function combineOtp() {
                    var otp = '';
                    for (var i = 1; i <= 6; i++) {
                        otp += document.getElementById('otp' + i).value;
                    }
                    document.getElementById('fullOtp').value = otp;
                    return true;
                }
                
                var timeLeft = <%= remain %>;
                
                var timerId = setInterval(function() {
                    if (timeLeft <= 0) {
                        clearInterval(timerId);
                        document.getElementById("timer").innerHTML = "Expired";
                        document.getElementById("verifyBtn").disabled = true;
                    } else {
                        var minutes = Math.floor(timeLeft / 60);
                        var seconds = timeLeft % 60;
                        document.getElementById("timer").innerHTML = 
                            minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
                        timeLeft -= 1;
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
        </div>
    </div>
</body>
</html>
