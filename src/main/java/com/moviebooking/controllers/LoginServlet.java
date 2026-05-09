package com.moviebooking.controllers;

import com.moviebooking.model.User;
import com.moviebooking.service.UserService;
import com.moviebooking.util.Validation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet for user login.
 * GET: Shows the login form page.
 * POST: Checks email and password, creates session if correct.
 * Supports both plain text and hashed passwords during migration period.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final UserService userService = new UserService();

    /**
     * Show the login form page.
     */
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
        
        request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
    }

    /**
     * Handle login form submission.
     * Checks email and password, creates session if login is successful.
     * Stores user info in session for use throughout the application.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get email and password from login form
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Check if email or password is empty
        if (Validation.isEmpty(email) || Validation.isEmpty(password)) {
            request.setAttribute("error", "Email and password are required");
            request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
            return;
        }

        // Attempt login
        UserService.LoginResult result = userService.login(email, password);
        if (result.isSuccess()) {
            User user = result.getUser();
            
            // Create session and store user information
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userName", user.getFullName());
            session.setAttribute("userEmail", user.getEmail());  // Added for email functionality
            session.setAttribute("role", user.getRole());
            
            // Redirect based on role
            if ("admin".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/adminHome");
            } else {
                response.sendRedirect(request.getContextPath() + "/userHome");
            }
        } else {
            // Login failed - show error message
            request.setAttribute("error", result.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
        }
    }
}
