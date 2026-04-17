package com.moviebooking.controllers;

import com.moviebooking.dao.BookingDao;
import com.moviebooking.model.Booking;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Servlet for admin to manage all bookings.
 * GET: Shows all bookings or handles delete action.
 * POST: Handles status update (e.g. Confirmed to Cancelled).
 */
@WebServlet("/manageBookings")
public class ManageBookingsServlet extends HttpServlet {
    private final BookingDao bookingDao = new BookingDao();

    /**
     * Show all bookings page or handle delete request.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if the action is "delete"
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            // Handle delete booking
            handleDelete(request, response);
            return;
        }

        // Get all bookings from database and show the manage bookings page
        List<Booking> bookings = bookingDao.getAllBookings();
        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("/WEB-INF/pages/manageBookings.jsp").forward(request, response);
    }

    /**
     * Handle POST requests - only used for updating booking status.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("updateStatus".equals(action)) {
            handleUpdateStatus(request, response);
        }
    }

    /**
     * Update the status of a booking (e.g. change from Confirmed to Cancelled).
     * Gets booking ID and new status from the form, then updates in database.
     */
    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Get booking ID and new status from the form
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            String status = request.getParameter("status");

            // Update the booking status in database
            boolean isUpdated = bookingDao.updateBookingStatus(bookingId, status);

            if (isUpdated) {
                response.sendRedirect(request.getContextPath() + "/manageBookings?success=Status updated successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/manageBookings?error=Failed to update status");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/manageBookings?error=Invalid input");
        }
    }

    /**
     * Delete a booking from the database.
     * Gets the booking ID from the URL parameter.
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Get booking ID from URL and delete it
            int bookingId = Integer.parseInt(request.getParameter("id"));
            boolean isDeleted = bookingDao.deleteBooking(bookingId);

            if (isDeleted) {
                response.sendRedirect(request.getContextPath() + "/manageBookings?success=Booking deleted successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/manageBookings?error=Failed to delete booking");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/manageBookings?error=Invalid booking ID");
        }
    }
}
