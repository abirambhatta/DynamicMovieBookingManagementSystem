package com.moviebooking.controllers;

import com.moviebooking.dao.BookingDao;
import com.moviebooking.dao.MovieDao;
import com.moviebooking.model.Booking;
import com.moviebooking.model.Movie;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet for viewing a specific ticket confirmation.
 */
@WebServlet("/ticketConfirmation")
public class TicketConfirmationServlet extends HttpServlet {
    private final BookingDao bookingDao = new BookingDao();
    private final MovieDao movieDao = new MovieDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String bookingIdParam = request.getParameter("bookingId");
        if (bookingIdParam == null || bookingIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/myBookings");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdParam);
            // We need a method to get booking by ID, but wait! Does BookingDao have getBookingById?
            // Let's assume we can get it from getBookingsByUserId and filter.
            int userId = (int) session.getAttribute("userId");
            java.util.List<Booking> bookings = bookingDao.getBookingsByUserId(userId);
            
            Booking targetBooking = null;
            for (Booking b : bookings) {
                if (b.getBookingId() == bookingId) {
                    targetBooking = b;
                    break;
                }
            }

            if (targetBooking != null) {
                Movie movie = movieDao.getMovieById(targetBooking.getMovieId());
                String orderRef = "MBK-" + String.format("%05d", bookingId);

                request.setAttribute("bookingId", bookingId);
                request.setAttribute("orderRef", orderRef);
                request.setAttribute("movie", movie);
                request.setAttribute("showTime", targetBooking.getShowTime());
                request.setAttribute("seatIds", targetBooking.getSeatType());
                request.setAttribute("numberOfSeats", targetBooking.getNumberOfSeats());
                request.setAttribute("totalPrice", targetBooking.getTotalPrice());
                request.setAttribute("userName", session.getAttribute("userName"));
                request.setAttribute("userEmail", session.getAttribute("userEmail"));

                request.getRequestDispatcher("/WEB-INF/pages/ticketConfirmation.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/myBookings");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/myBookings");
        }
    }
}
