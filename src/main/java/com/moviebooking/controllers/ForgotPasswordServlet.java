package com.moviebooking.controllers;

import com.moviebooking.dao.UserDao;
import com.moviebooking.service.EmailService;
import com.moviebooking.util.OtpUtil;
import com.moviebooking.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet for password reset with 2FA using OTP.
 * Implements 3-step verification process:
 * 1. Email verification - user enters email
 * 2. OTP verification - user enters 6-digit OTP sent to email
 * 3. Password reset - user sets new password
 */
@WebServlet("/forgotPassword")
public class ForgotPasswordServlet extends HttpServlet {
    private final UserDao userDao = new UserDao();

    /**
     * Show the forgot password form page.
     * Displays different steps based on the 'step' parameter.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String step = request.getParameter("step");
        if (step == null) {
            step = "1";
        }
        request.setAttribute("step", step);
        request.getRequestDispatcher("/WEB-INF/pages/forgotPassword.jsp").forward(request, response);
    }

    /**
     * Handle form submission for password reset.
     * Routes to appropriate handler based on current step.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String step = request.getParameter("step");
        
        if ("1".equals(step)) {
            handleEmailVerification(request, response);
        } else if ("2".equals(step)) {
            handleOtpVerification(request, response);
        } else if ("3".equals(step)) {
            handlePasswordReset(request, response);
        }
    }

    /**
     * Step 1: Verify email exists and send OTP.
     * Generates 6-digit OTP, stores it with 10-minute expiry, and sends via email.
     */
    private void handleEmailVerification(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        
        // Validate email input
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email is required");
            request.setAttribute("step", "1");
            request.getRequestDispatcher("/WEB-INF/pages/forgotPassword.jsp").forward(request, response);
            return;
        }

        // Check if email exists in database
        if (!userDao.emailExists(email)) {
            request.setAttribute("error", "Email not found in our system");
            request.setAttribute("step", "1");
            request.getRequestDispatcher("/WEB-INF/pages/forgotPassword.jsp").forward(request, response);
            return;
        }

        // Generate OTP and calculate expiry time (10 minutes from now)
        String otp = OtpUtil.generateOtp();
        long expiryTime = OtpUtil.getCurrentTimeMillis() + (10 * 60 * 1000);

        // Store OTP in database and send email
        if (userDao.storeOtp(email, otp, expiryTime) && EmailService.sendOtpEmail(email, otp)) {
            // Store email in session for next steps
            HttpSession session = request.getSession();
            session.setAttribute("resetEmail", email);
            session.setAttribute("otpSentTime", System.currentTimeMillis());
            
            // Move to step 2 (OTP verification)
            request.setAttribute("step", "2");
            request.setAttribute("email", email);
            request.setAttribute("success", "OTP sent to your email");
            request.getRequestDispatcher("/WEB-INF/pages/forgotPassword.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Failed to send OTP. Please try again");
            request.setAttribute("step", "1");
            request.getRequestDispatcher("/WEB-INF/pages/forgotPassword.jsp").forward(request, response);
        }
    }

    /**
     * Step 2: Verify OTP entered by user.
     * Checks if OTP matches and hasn't expired.
     */
    private void handleOtpVerification(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Validate session exists
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("resetEmail") == null) {
            request.setAttribute("error", "Session expired. Please start over");
            request.setAttribute("step", "1");
            request.getRequestDispatcher("/WEB-INF/pages/forgotPassword.jsp").forward(request, response);
            return;
        }

        String email = (String) session.getAttribute("resetEmail");
        String otp = request.getParameter("otp");

        // Validate OTP input
        if (otp == null || otp.trim().isEmpty()) {
            request.setAttribute("error", "OTP is required");
            request.setAttribute("step", "2");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/pages/forgotPassword.jsp").forward(request, response);
            return;
        }

        // Verify OTP against database
        if (userDao.verifyOtp(email, otp)) {
            // OTP is valid, move to step 3 (password reset)
            request.setAttribute("step", "3");
            request.setAttribute("email", email);
            request.setAttribute("success", "OTP verified successfully");
            request.getRequestDispatcher("/WEB-INF/pages/forgotPassword.jsp").forward(request, response);
        } else {
            // OTP is invalid or expired
            request.setAttribute("error", "Invalid or expired OTP");
            request.setAttribute("step", "2");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/pages/forgotPassword.jsp").forward(request, response);
        }
    }

    /**
     * Step 3: Reset password after OTP verification.
     * Hashes new password and updates database.
     */
    private void handlePasswordReset(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Validate session exists
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("resetEmail") == null) {
            request.setAttribute("error", "Session expired. Please start over");
            request.setAttribute("step", "1");
            request.getRequestDispatcher("/WEB-INF/pages/forgotPassword.jsp").forward(request, response);
            return;
        }

        String email = (String) session.getAttribute("resetEmail");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate password inputs
        if (newPassword == null || newPassword.trim().isEmpty() || 
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("error", "Both password fields are required");
            request.setAttribute("step", "3");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/pages/forgotPassword.jsp").forward(request, response);
            return;
        }

        // Check if passwords match
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.setAttribute("step", "3");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/pages/forgotPassword.jsp").forward(request, response);
            return;
        }

        // Check password length
        if (newPassword.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters");
            request.setAttribute("step", "3");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/pages/forgotPassword.jsp").forward(request, response);
            return;
        }

        // Hash password and update database
        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        if (userDao.updatePassword(email, hashedPassword) && userDao.clearOtp(email)) {
            // Clear session and redirect to login
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login?success=Password reset successful. Please login with your new password");
        } else {
            request.setAttribute("error", "Failed to reset password. Please try again");
            request.setAttribute("step", "3");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/pages/forgotPassword.jsp").forward(request, response);
        }
    }
}
