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
 * Also handles account locking after too many failed login attempts.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final UserService userService = new UserService();

    // Show the login form page
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
    }

    /**
     * Handle login form submission.
     * Checks email and password, locks account if too many wrong tries.
     * Creates a session with user info if login is successful.
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

        UserService.LoginResult result = userService.login(email, password);
        if (result.isSuccess()) {
            User user = result.getUser();
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userName", user.getFullName());
            session.setAttribute("role", user.getRole());
            if ("admin".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/adminHome");
            } else {
                response.sendRedirect(request.getContextPath() + "/userHome");
            }
        } else {
            request.setAttribute("error", result.getMessage());
            request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
        }
    }
}
