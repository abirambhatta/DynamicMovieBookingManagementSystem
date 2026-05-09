<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In - MovieMint</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        html, body { height: 100%; }

        .login-wrap {
            display: flex;
            min-height: 100vh;
        }

        /* ── Left brand panel ── */
        .login-brand {
            flex: 1;
            background: radial-gradient(circle at 30% 30%, #e61937 0%, #c9152f 40%, #5c0008 100%);
            color: #fff;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 60px 80px;
            flex-shrink: 0;
            position: relative;
            overflow: hidden;
            box-shadow: inset -10px 0 30px rgba(0,0,0,0.15);
        }

        /* Cinematic glowing orbs */
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

        .brand-inner { position: relative; z-index: 1; }

        .brand-logo {
            font-size: 42px;
            font-weight: 900;
            letter-spacing: -1.5px;
            margin-bottom: 12px;
            text-shadow: 0 2px 10px rgba(0,0,0,0.2);
        }

        .brand-tagline {
            font-size: 16px;
            font-weight: 500;
            color: rgba(255,255,255,0.9);
            margin-bottom: 40px;
            line-height: 1.4;
            max-width: 320px;
        }

        .brand-divider {
            width: 40px;
            height: 3px;
            background: #fff;
            border-radius: 2px;
            margin-bottom: 40px;
            opacity: 0.8;
        }

        .feature-list {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .feature-item {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 14px;
            opacity: 0.9;
        }

        .feature-item::before {
            content: '→';
            color: rgba(255,255,255,0.6);
            font-size: 12px;
        }

        /* ── Right form panel ── */
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
            padding: 36px 32px;
            width: 100%;
            max-width: 380px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }

        .login-card h2 {
            font-size: 22px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 4px;
        }

        .login-card .sub {
            font-size: 13px;
            color: #888;
            margin-bottom: 24px;
        }

        .form-group { margin-bottom: 16px; }

        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 500;
            color: #444;
            margin-bottom: 5px;
        }

        .form-group input {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
            font-family: inherit;
            color: #1a1a1a;
            background: #fff;
            transition: border-color 0.15s;
        }

        .form-group input:focus {
            outline: none;
            border-color: #c9152f;
            box-shadow: 0 0 0 2px rgba(201,21,47,0.08);
        }

        .btn-signin {
            width: 100%;
            padding: 11px;
            background: #c9152f;
            color: #fff;
            border: none;
            border-radius: 5px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 8px;
            letter-spacing: 0.2px;
            transition: background 0.15s;
        }

        .btn-signin:hover { background: #a01026; }

        .form-links {
            margin-top: 18px;
            text-align: center;
            font-size: 13px;
            color: #666;
            line-height: 2;
        }

        .form-links a { color: #c9152f; text-decoration: none; }
        .form-links a:hover { text-decoration: underline; }

        .error-message {
            background: #fde8ec;
            color: #8b1a25;
            border: 1px solid #f5c6cb;
            border-radius: 5px;
            padding: 10px 14px;
            font-size: 13px;
            margin-bottom: 16px;
        }

        .success-message {
            background: #e2f5e8;
            color: #1a5c2b;
            border: 1px solid #b8e0c4;
            border-radius: 5px;
            padding: 10px 14px;
            font-size: 13px;
            margin-bottom: 16px;
        }

        @media (max-width: 640px) {
            .login-brand { display: none; }
            .login-form-wrap { background: #f4f4f5; }
        }
    </style>
</head>
<body>
<div class="login-wrap">

    <div class="login-brand">
        <div class="brand-inner">
            <div class="brand-logo">MovieMint</div>
            <p class="brand-tagline">Your local cinema booking system</p>
            <div class="brand-divider"></div>
            <ul class="feature-list">
                <li class="feature-item">Browse now showing films</li>
                <li class="feature-item">Choose your seat</li>
                <li class="feature-item">Get instant ticket confirmation</li>
                <li class="feature-item">Track all your bookings</li>
            </ul>
        </div>
    </div>

    <div class="login-form-wrap">
        <div class="login-card">
            <h2>Sign in</h2>
            <p class="sub">Enter your email and password to continue</p>

            <c:if test="${not empty error}">
                <div class="error-message">${error}</div>
            </c:if>
            <c:if test="${not empty param.success}">
                <div class="success-message">Account created. You can now sign in.</div>
            </c:if>
            <c:if test="${not empty param.message}">
                <div class="success-message">${param.message}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="form-group">
                    <label for="email">Email address</label>
                    <input type="email" id="email" name="email" value="${param.email}"
                           placeholder="you@example.com" required autofocus>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password"
                           placeholder="Your password" required>
                </div>
                <button type="submit" class="btn-signin">Sign in</button>
            </form>

            <div class="form-links">
                <a href="${pageContext.request.contextPath}/forgotPassword">Forgot password?</a><br>
                Don't have an account? <a href="${pageContext.request.contextPath}/register">Register here</a>
            </div>
        </div>
    </div>

</div>
</body>
</html>
