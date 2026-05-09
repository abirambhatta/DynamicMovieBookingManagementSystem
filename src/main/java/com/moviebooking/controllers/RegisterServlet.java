package com.moviebooking.controllers;

import com.moviebooking.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet for new user registration.
 * GET: Shows the registration form page.
 * POST: Validates all input fields and saves the new user to database.
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private final UserService userService = new UserService();

    // Show the registration form page
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // If user is already logged in, redirect them to their home page
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            String role = (String) session.getAttribute("role");
            if ("admin".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/adminHome");
            } else {
                response.sendRedirect(request.getContextPath() + "/userHome");
            }
            return;
        }
        
        request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
    }

    /**
     * Handle registration form submission.
     * Validates all fields (name, email, phone, password).
     * Checks for duplicate email and phone.
     * Saves user to database if everything is valid.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        UserService.ServiceResult result = userService.registerUser(fullName, email, phone, password, confirmPassword);
        if (result.isSuccess()) {
            response.sendRedirect(request.getContextPath() + "/login?success=Registration successful");
        } else {
            request.setAttribute("error", result.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
        }
    }
}
