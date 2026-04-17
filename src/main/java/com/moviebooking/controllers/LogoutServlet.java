package com.moviebooking.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet for logging out the user.
 * Destroys the session and sends user back to login page.
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    /**
     * Handle logout - destroy session and redirect to login.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get the current session (don't create a new one if it doesn't exist)
        HttpSession session = request.getSession(false);
        if (session != null) {
            // Destroy the session - removes all stored user data
            session.invalidate();
        }
        // Send user back to login page
        response.sendRedirect(request.getContextPath() + "/login");
    }
}
