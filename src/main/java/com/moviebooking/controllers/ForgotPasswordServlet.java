package com.moviebooking.controllers;

import com.moviebooking.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet for the forgot password page.
 * GET: Shows the forgot password form.
 * POST: Checks the email exists, validates new password, and updates it.
 */
@WebServlet("/forgotPassword")
public class ForgotPasswordServlet extends HttpServlet {
    private final UserService userService = new UserService();

    // Show the forgot password form page
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/pages/forgotPassword.jsp").forward(request, response);
    }

    /**
     * Handle the forgot password form submission.
     * Validates email, checks passwords match, then updates the password.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        UserService.ServiceResult result = userService.resetPassword(email, newPassword, confirmPassword);
        if (result.isSuccess()) {
            response.sendRedirect(request.getContextPath() + "/login?success=Password reset successful");
        } else {
            request.setAttribute("error", result.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/forgotPassword.jsp").forward(request, response);
        }
    }
}
