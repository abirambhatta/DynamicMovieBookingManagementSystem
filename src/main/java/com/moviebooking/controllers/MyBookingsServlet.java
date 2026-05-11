package com.moviebooking.controllers;

import com.moviebooking.dao.BookingDao;
import com.moviebooking.model.Booking;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Servlet for showing the user's booking history.
 * Gets all bookings for the logged-in user and shows them on the page.
 */
@WebServlet("/myBookings")
public class MyBookingsServlet extends HttpServlet {
    private final BookingDao bookingDao = new BookingDao();

    /**
     * Get all bookings for the logged-in user and show the my bookings page.
     * If user is not logged in, redirect to login page.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            // Not logged in - go to login page
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user ID from session and fetch their bookings
        int userId = (int) session.getAttribute("userId");
        
        // Auto-expire past bookings: if show_time date has passed, mark as Completed
        // show_time format is like "2026-05-09 10:00 - Audi 01", we extract the datetime part
        bookingDao.expirePastBookings();
        
        List<Booking> bookings = bookingDao.getBookingsByUserId(userId);
        // Pass bookings to the JSP page
        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("/WEB-INF/pages/myBookings.jsp").forward(request, response);
    }
}
