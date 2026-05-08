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
        html, body { height: 100%; background: #f4f4f5; }

        .login-wrap {
            display: flex;
            min-height: 100vh;
        }

        .login-brand {
            width: 340px;
            background: #c9152f;
            color: #fff;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 48px 40px;
            flex-shrink: 0;
        }

        .login-brand h1 {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 6px;
            letter-spacing: -0.5px;
        }

        .login-brand p {
            font-size: 14px;
            opacity: 0.8;
            line-height: 1.5;
            margin-bottom: 32px;
        }

        .brand-divider {
            width: 32px;
            height: 2px;
            background: rgba(255,255,255,0.4);
            margin-bottom: 24px;
        }

        .brand-features {
            list-style: none;
            font-size: 14px;
            line-height: 2;
            opacity: 0.85;
        }

        .brand-features li::before {
            content: '→ ';
            opacity: 0.6;
        }

        .login-form-wrap {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 24px;
            background: #fff;
        }

        .login-form-box {
            width: 100%;
            max-width: 360px;
        }

        .login-form-box h2 {
            font-size: 20px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 4px;
        }

        .login-form-box .sub {
            font-size: 13px;
            color: #777;
            margin-bottom: 24px;
        }

        .form-group { margin-bottom: 14px; }

        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 500;
            color: #444;
            margin-bottom: 5px;
        }

        .form-group input {
            width: 100%;
            padding: 9px 11px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
            font-family: inherit;
            transition: border-color 0.15s;
        }

        .form-group input:focus {
            outline: none;
            border-color: #c9152f;
            box-shadow: 0 0 0 2px rgba(201,21,47,0.08);
        }

        .btn-signin {
            width: 100%;
            padding: 10px;
            background: #c9152f;
            color: #fff;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 6px;
            transition: background 0.15s;
        }

        .btn-signin:hover { background: #a01026; }

        .form-links {
            margin-top: 16px;
            text-align: center;
            font-size: 13px;
            color: #666;
            line-height: 2;
        }

        .form-links a { color: #c9152f; }

        .error-message {
            background: #fde8ec;
            color: #8b1a25;
            border: 1px solid #f5c6cb;
            border-radius: 4px;
            padding: 9px 13px;
            font-size: 13px;
            margin-bottom: 14px;
        }

        .success-message {
            background: #e2f5e8;
            color: #1a5c2b;
            border: 1px solid #b8e0c4;
            border-radius: 4px;
            padding: 9px 13px;
            font-size: 13px;
            margin-bottom: 14px;
        }

        @media (max-width: 640px) {
            .login-brand { display: none; }
            .login-form-wrap { background: #f4f4f5; }
            .login-form-box {
                background: #fff;
                padding: 28px;
                border-radius: 6px;
                border: 1px solid #ddd;
                box-shadow: 0 1px 4px rgba(0,0,0,0.08);
            }
        }
    </style>
</head>
<body>
<div class="login-wrap">
    <div class="login-brand">
        <h1>MovieMint</h1>
        <p>Your local cinema booking system</p>
        <div class="brand-divider"></div>
        <ul class="brand-features">
            <li>Browse now showing films</li>
            <li>Choose your seat</li>
            <li>Get ticket confirmation</li>
        </ul>
    </div>

    <div class="login-form-wrap">
        <div class="login-form-box">
            <h2>Sign in</h2>
            <p class="sub">Enter your registered email and password</p>

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
                    <input type="email" id="email" name="email" value="${param.email}" placeholder="you@example.com" required autofocus>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="Your password" required>
                </div>
                <button type="submit" class="btn-signin">Sign in</button>
            </form>

            <div class="form-links">
                <a href="${pageContext.request.contextPath}/forgotPassword">Forgot password?</a><br>
                Don't have an account? <a href="${pageContext.request.contextPath}/register">Register</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
