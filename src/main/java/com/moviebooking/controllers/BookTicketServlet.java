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
 * Servlet for booking a movie ticket.
 * GET: Shows the booking form with movie details and seat prices.
 * POST: Processes the booking and saves it to the database.
 */
@WebServlet("/bookTicket")
public class BookTicketServlet extends HttpServlet {
    private final MovieDao movieDao = new MovieDao();
    private final BookingDao bookingDao = new BookingDao();
    
    // Seat prices for each type (in currency)
    private static final double STANDARD_PRICE = 200.0;
    private static final double PREMIUM_PRICE = 350.0;
    private static final double RECLINER_PRICE = 500.0;
    private static final double VIP_PRICE = 750.0;

    /**
     * Show the booking form page.
     * Gets movie details and passes seat prices to the JSP page.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get the movie ID from the URL parameter
        String movieIdParam = request.getParameter("movieId");

        // If no movie ID, go back to browse movies page
        if (movieIdParam == null || movieIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/browseMovies");
            return;
        }

        try {
            // Get the movie details from database
            int movieId = Integer.parseInt(movieIdParam);
            Movie movie = movieDao.getMovieById(movieId);

            if (movie != null) {
                // Pass the movie and all seat prices to the booking page
                request.setAttribute("movie", movie);
                request.setAttribute("standardPrice", STANDARD_PRICE);
                request.setAttribute("premiumPrice", PREMIUM_PRICE);
                request.setAttribute("reclinerPrice", RECLINER_PRICE);
                request.setAttribute("vipPrice", VIP_PRICE);
                request.getRequestDispatcher("/WEB-INF/pages/bookTicket.jsp").forward(request, response);
            } else {
                // If movie not found, go back to browse movies
                response.sendRedirect(request.getContextPath() + "/browseMovies");
            }
        } catch (NumberFormatException e) {
            // If movie ID is not a valid number, go back to browse movies
            response.sendRedirect(request.getContextPath() + "/browseMovies");
        }
    }

    /**
     * Handle the booking form submission.
     * Gets form data, calculates total price, and saves the booking.
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

        // Get user ID from session and form values
        int userId = (int) session.getAttribute("userId");
        String movieIdParam = request.getParameter("movieId");
        String showTime = request.getParameter("showTime");
        String seatsParam = request.getParameter("numberOfSeats");
        String seatType = request.getParameter("seatType");

        try {
            int movieId = Integer.parseInt(movieIdParam);
            int numberOfSeats = Integer.parseInt(seatsParam);
            
            // Set the price based on which seat type the user picked
            double pricePerSeat = STANDARD_PRICE;
            switch (seatType) {
                case "Premium": pricePerSeat = PREMIUM_PRICE; break;
                case "Recliner": pricePerSeat = RECLINER_PRICE; break;
                case "VIP": pricePerSeat = VIP_PRICE; break;
                default: pricePerSeat = STANDARD_PRICE;
            }
            
            // Calculate total price = number of seats x price per seat
            double totalPrice = numberOfSeats * pricePerSeat;

            // Create a new booking object and save it to the database
            Booking booking = new Booking(userId, movieId, showTime, numberOfSeats, seatType, totalPrice, "Confirmed");
            boolean isBooked = bookingDao.createBooking(booking);

            if (isBooked) {
                // Booking successful - go to my bookings page with success message
                response.sendRedirect(request.getContextPath() + "/myBookings?success=Booking successful");
            } else {
                // Booking failed - show error on the booking page
                request.setAttribute("error", "Booking failed. Please try again");
                doGet(request, response);
            }
        } catch (NumberFormatException e) {
            // If form values are not valid numbers, show error
            request.setAttribute("error", "Invalid input");
            doGet(request, response);
        }
    }
}
