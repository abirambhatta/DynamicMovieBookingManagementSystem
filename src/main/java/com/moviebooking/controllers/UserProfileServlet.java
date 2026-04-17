package com.moviebooking.controllers;

import com.moviebooking.dao.UserDao;
import com.moviebooking.model.User;
import com.moviebooking.util.Validation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet for the user profile page.
 * GET: Shows the user's current profile info.
 * POST: Updates the user's profile (name, email, phone).
 */
@WebServlet("/userProfile")
public class UserProfileServlet extends HttpServlet {
    private final UserDao userDao = new UserDao();

    /**
     * Get the user's profile data and show the profile page.
     * If user is not logged in, redirect to login.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user details from database and pass to JSP page
        int userId = (int) session.getAttribute("userId");
        User user = userDao.getUserById(userId);
        request.setAttribute("user", user);
        request.getRequestDispatcher("/WEB-INF/pages/userProfile.jsp").forward(request, response);
    }

    /**
     * Handle profile update form submission.
     * Validates the new values and saves them to database.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user ID from session and new values from form
        int userId = (int) session.getAttribute("userId");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        // Validate the new name
        if (!Validation.isValidName(fullName)) {
            request.setAttribute("error", "Full name should contain only letters");
            doGet(request, response);
            return;
        }

        // Validate the new email
        if (!Validation.isValidEmail(email)) {
            request.setAttribute("error", "Invalid email format");
            doGet(request, response);
            return;
        }

        // Validate the new phone number
        if (!Validation.isValidPhone(phone)) {
            request.setAttribute("error", "Phone number must be 10 digits");
            doGet(request, response);
            return;
        }

        // Create user object with updated values and save to database
        User user = new User();
        user.setUserId(userId);
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);

        boolean isUpdated = userDao.updateUser(user);

        if (isUpdated) {
            // Update the name in session so it shows correctly in the header
            session.setAttribute("userName", fullName);
            request.setAttribute("success", "Profile updated successfully");
        } else {
            request.setAttribute("error", "Update failed");
        }

        // Show the profile page again with success or error message
        doGet(request, response);
    }
}
