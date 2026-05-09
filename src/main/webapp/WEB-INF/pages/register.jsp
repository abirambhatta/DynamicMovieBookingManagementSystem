<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - MovieMint</title>
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
            font-size: 28px;
            font-weight: 800;
            letter-spacing: -0.5px;
            margin-bottom: 8px;
        }

        .brand-desc {
            font-size: 14px;
            color: rgba(255,255,255,0.8);
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
            overflow-y: auto;
        }

        .form-box {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 32px 28px;
            width: 100%;
            max-width: 380px;
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

        /* Password strength */
        .pwd-reqs {
            display: none;
            margin-top: 6px;
            padding: 8px 10px;
            background: #f8f8f8;
            border: 1px solid #e8e8e8;
            border-radius: 3px;
            font-size: 11px;
        }

        .req { color: #999; margin: 3px 0; }
        .req.ok { color: #1a7a35; }
        .req.ok::before { content: '✓ '; }
        .req.fail::before { content: '✗ '; color: #c82333; }

        .strength-bar { height: 3px; background: #eee; border-radius: 1px; margin-top: 6px; }
        .strength-fill { height: 100%; border-radius: 1px; width: 0; transition: width 0.2s, background 0.2s; }
        .strength-fill.weak { width: 33%; background: #c82333; }
        .strength-fill.medium { width: 66%; background: #e09000; }
        .strength-fill.strong { width: 100%; background: #1a7a35; }

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
            <p class="brand-desc">Create an account to start booking</p>
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
            <h2>Create account</h2>
            <p class="hint">Fill in your details to register</p>

            <c:if test="${not empty error}">
                <div class="msg-error">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post" id="regForm">
                <div class="field">
                    <label for="fullName">Full name</label>
                    <input type="text" id="fullName" name="fullName" value="${param.fullName}" placeholder="Your name" required>
                </div>
                <div class="field">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" value="${param.email}" placeholder="you@example.com" required>
                </div>
                <div class="field">
                    <label for="phone">Phone</label>
                    <input type="text" id="phone" name="phone" value="${param.phone}" placeholder="10-digit number" maxlength="10" required>
                </div>
                <div class="field">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="Create a password" required>
                    <div class="pwd-reqs" id="pwdReqs">
                        <div class="req" id="req-len">At least 8 characters</div>
                        <div class="req" id="req-upper">One uppercase letter</div>
                        <div class="req" id="req-lower">One lowercase letter</div>
                        <div class="req" id="req-num">One number</div>
                        <div class="req" id="req-special">One special character</div>
                    </div>
                    <div class="strength-bar"><div class="strength-fill" id="strengthFill"></div></div>
                </div>
                <div class="field">
                    <label for="confirmPassword">Confirm password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Repeat password" required>
                </div>
                <button type="submit" class="submit-btn">Create account</button>
            </form>

            <div class="form-footer">
                Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in</a>
            </div>
        </div>
    </div>

</div>

<script>
    const pwdInput = document.getElementById('password');
    const confirmInput = document.getElementById('confirmPassword');
    const reqs = {
        len:     { el: document.getElementById('req-len'),     re: /.{8,}/ },
        upper:   { el: document.getElementById('req-upper'),   re: /[A-Z]/ },
        lower:   { el: document.getElementById('req-lower'),   re: /[a-z]/ },
        num:     { el: document.getElementById('req-num'),     re: /[0-9]/ },
        special: { el: document.getElementById('req-special'), re: /[!@#$%^&*(),.?":{}|<>]/ }
    };

    pwdInput.addEventListener('focus', () => document.getElementById('pwdReqs').style.display = 'block');

    pwdInput.addEventListener('input', function() {
        let count = 0;
        for (let k in reqs) {
            const ok = reqs[k].re.test(this.value);
            reqs[k].el.className = 'req ' + (ok ? 'ok' : (this.value ? 'fail' : ''));
            if (ok) count++;
        }
        const fill = document.getElementById('strengthFill');
        fill.className = 'strength-fill ' + (count <= 2 ? 'weak' : count <= 4 ? 'medium' : 'strong');
    });

    document.getElementById('regForm').addEventListener('submit', function(e) {
        const pwd = pwdInput.value;
        let allOk = true;
        for (let k in reqs) { if (!reqs[k].re.test(pwd)) { allOk = false; break; } }
        if (!allOk) { e.preventDefault(); alert('Password does not meet all requirements.'); return; }
        if (pwd !== confirmInput.value) { e.preventDefault(); alert('Passwords do not match.'); }
    });
</script>
</body>
</html>
