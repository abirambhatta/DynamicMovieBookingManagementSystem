<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In - MovieMint</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        html, body { height: 100%; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; }

        .split-layout { display: flex; min-height: 100vh; }

        .brand-side {
            flex: 1;
            background: #c9152f;
            color: #fff;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 48px 48px;
        }

        .brand-inner {
            max-width: 320px;
            width: 100%;
        }

        .brand-name {
            font-size: 44px;
            font-weight: 900;
            letter-spacing: -1px;
            margin-bottom: 12px;
            line-height: 1.1;
        }

        .brand-desc {
            font-size: 16px;
            color: rgba(255,255,255,0.9);
            margin-bottom: 36px;
            line-height: 1.5;
        }

        .brand-divider {
            width: 32px;
            height: 2px;
            background: rgba(255,255,255,0.4);
            margin-bottom: 28px;
        }

        .brand-list {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .brand-list li {
            font-size: 13px;
            color: rgba(255,255,255,0.85);
            padding-left: 16px;
            position: relative;
        }

        .brand-list li::before {
            content: '–';
            position: absolute;
            left: 0;
            color: rgba(255,255,255,0.4);
        }

        .form-side {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f6f6f6;
            padding: 40px 24px;
        }

        .form-box {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 32px 28px;
            width: 100%;
            max-width: 360px;
        }

        .form-box h2 {
            font-size: 20px;
            font-weight: 700;
            color: #111;
            margin-bottom: 4px;
        }

        .form-box .hint {
            font-size: 13px;
            color: #888;
            margin-bottom: 22px;
        }

        .field { margin-bottom: 14px; }

        .field label {
            display: block;
            font-size: 12px;
            font-weight: 600;
            color: #555;
            margin-bottom: 4px;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .field input {
            width: 100%;
            padding: 9px 11px;
            border: 1px solid #ccc;
            border-radius: 3px;
            font-size: 14px;
            font-family: inherit;
            color: #111;
            background: #fff;
        }

        .field input:focus {
            outline: none;
            border-color: #c9152f;
        }

        input:-webkit-autofill { -webkit-box-shadow: 0 0 0 30px white inset !important; }

        .submit-btn {
            width: 100%;
            padding: 10px;
            background: #c9152f;
            color: #fff;
            border: none;
            border-radius: 3px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 6px;
        }

        .submit-btn:hover { background: #a01026; }

        .form-footer {
            margin-top: 16px;
            font-size: 13px;
            color: #666;
            text-align: center;
            line-height: 1.9;
        }

        .form-footer a { color: #c9152f; text-decoration: none; }
        .form-footer a:hover { text-decoration: underline; }

        .msg-error {
            background: #fde8ec;
            color: #8b1a25;
            border: 1px solid #f5c6cb;
            border-radius: 3px;
            padding: 9px 12px;
            font-size: 13px;
            margin-bottom: 14px;
        }

        .msg-ok {
            background: #e2f5e8;
            color: #1a5c2b;
            border: 1px solid #b8e0c4;
            border-radius: 3px;
            padding: 9px 12px;
            font-size: 13px;
            margin-bottom: 14px;
        }

        @media (max-width: 640px) {
            .brand-side { display: none; }
            .form-side { background: #fff; }
        }
    </style>
</head>
<body>
<div class="split-layout">

    <div class="brand-side">
        <div class="brand-inner">
            <div class="brand-name">MovieMint</div>
            <p class="brand-desc">Online cinema ticket booking</p>
            <div class="brand-divider"></div>
            <ul class="brand-list">
                <li>Browse currently showing films</li>
                <li>Pick your seat from the hall map</li>
                <li>Get a booking confirmation instantly</li>
                <li>View or reprint your tickets anytime</li>
            </ul>
        </div>
    </div>

    <div class="form-side">
        <div class="form-box">
            <h2>Sign in</h2>
            <p class="hint">Enter your email and password</p>

            <c:if test="${not empty error}">
                <div class="msg-error">${error}</div>
            </c:if>
            <c:if test="${not empty param.success}">
                <div class="msg-ok">Account created. You can now sign in.</div>
            </c:if>
            <c:if test="${not empty param.message}">
                <div class="msg-ok">${param.message}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="field">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" value="${param.email}" placeholder="you@example.com" required autofocus>
                </div>
                <div class="field">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="Your password" required>
                </div>
                <button type="submit" class="submit-btn">Sign in</button>
            </form>

            <div class="form-footer">
                <a href="${pageContext.request.contextPath}/forgotPassword">Forgot password?</a><br>
                No account? <a href="${pageContext.request.contextPath}/register">Register</a>
            </div>
        </div>
    </div>

</div>
</body>
</html>
