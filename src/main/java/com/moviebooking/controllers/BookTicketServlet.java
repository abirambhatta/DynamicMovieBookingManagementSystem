package com.moviebooking.controllers;
import java.util.LinkedHashMap;

import com.moviebooking.dao.BookingDao;
import com.moviebooking.dao.GlobalSettingsDao;
import com.moviebooking.dao.HallConfigDao;
import com.moviebooking.dao.MovieDao;
import com.moviebooking.model.Booking;
import com.moviebooking.model.HallConfig;
import com.moviebooking.model.Movie;
import com.moviebooking.dao.ShowTimeDao;
import com.moviebooking.model.ShowTime;
import java.util.List;
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
    private final ShowTimeDao showTimeDao = new ShowTimeDao();
    private final GlobalSettingsDao settingsDao = new GlobalSettingsDao();
    private final HallConfigDao hallConfigDao = new HallConfigDao();

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
                List<ShowTime> showTimes = showTimeDao.getShowTimesByMovie(movieId);
                StringBuilder json = new StringBuilder("[");
                for(int i=0; i<showTimes.size(); i++){
                    ShowTime st = showTimes.get(i);
                    json.append("{");
                    json.append("\"date\":\"").append(st.getShowDate().toString()).append("\",");
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("HH:mm");
                    json.append("\"time\":\"").append(sdf.format(st.getShowTime())).append("\",");
                    json.append("\"hall\":\"").append(st.getHall() != null ? st.getHall() : "Audi 01").append("\"");
                    json.append("}");
                    if(i < showTimes.size() -1) json.append(",");
                }
                json.append("]");

                // Fetch booked seats — accumulate ALL seat IDs per showtime
                // so multiple bookings for the same showtime are merged correctly
                List<Booking> bookings = bookingDao.getBookingsByMovieId(movieId);
                LinkedHashMap<String, StringBuilder> seatsByShowtime = new LinkedHashMap<>();
                for (Booking b : bookings) {
                    String key = b.getShowTime();
                    String seats = b.getSeatType();
                    if (seats == null || seats.trim().isEmpty() || "Not selected".equals(seats.trim())) continue;
                    if (!seatsByShowtime.containsKey(key)) {
                        seatsByShowtime.put(key, new StringBuilder(seats.trim()));
                    } else {
                        seatsByShowtime.get(key).append(",").append(seats.trim());
                    }
                }
                StringBuilder bookedSeatsJson = new StringBuilder("{");
                boolean firstEntry = true;
                for (java.util.Map.Entry<String, StringBuilder> entry : seatsByShowtime.entrySet()) {
                    if (!firstEntry) bookedSeatsJson.append(",");
                    bookedSeatsJson.append("\"").append(entry.getKey()).append("\":\"").append(entry.getValue()).append("\"");
                    firstEntry = false;
                }
                bookedSeatsJson.append("}");
                
                // Load dynamic prices from admin settings
                double standardPrice = Double.parseDouble(settingsDao.getSetting("PRICE_STANDARD", "200.0"));
                double premiumPrice  = Double.parseDouble(settingsDao.getSetting("PRICE_PREMIUM",  "350.0"));
                double reclinerPrice = Double.parseDouble(settingsDao.getSetting("PRICE_RECLINER", "500.0"));
                double vipPrice      = Double.parseDouble(settingsDao.getSetting("PRICE_VIP",      "750.0"));

                // Build hall configs JSON for the seat grid
                List<HallConfig> hallConfigs = hallConfigDao.getAllHallConfigs();
                StringBuilder hcJson = new StringBuilder("{");
                for (int h = 0; h < hallConfigs.size(); h++) {
                    HallConfig hc = hallConfigs.get(h);
                    hcJson.append("\"").append(hc.getHallName()).append("\":{")
                        .append("\"seatsPerRow\":").append(hc.getSeatsPerRow()).append(",")
                        .append("\"standardRows\":\"").append(hc.getStandardRows() != null ? hc.getStandardRows() : "").append("\",")
                        .append("\"premiumRows\":\"").append(hc.getPremiumRows() != null ? hc.getPremiumRows() : "").append("\",")
                        .append("\"reclinerRows\":\"").append(hc.getReclinerRows() != null ? hc.getReclinerRows() : "").append("\",")
                        .append("\"vipRows\":\"").append(hc.getVipRows() != null ? hc.getVipRows() : "").append("\"")
                        .append("}");
                    if (h < hallConfigs.size() - 1) hcJson.append(",");
                }
                hcJson.append("}");

                request.setAttribute("bookedSeatsJson", bookedSeatsJson.toString());
                request.setAttribute("showTimesJson", json.toString());
                request.setAttribute("hallConfigsJson", hcJson.toString());
                request.setAttribute("movie", movie);
                request.setAttribute("standardPrice", standardPrice);
                request.setAttribute("premiumPrice", premiumPrice);
                request.setAttribute("reclinerPrice", reclinerPrice);
                request.setAttribute("vipPrice", vipPrice);
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
        String movieIdParam    = request.getParameter("movieId");
        String finalShowTime   = request.getParameter("finalShowTime");
        String seatsParam      = request.getParameter("numberOfSeats");
        String selectedSeatIds = request.getParameter("selectedSeatIds");

        // Basic validation before hitting the DB
        if (finalShowTime == null || finalShowTime.trim().isEmpty()) {
            request.setAttribute("error", "Please select a showtime before booking.");
            doGet(request, response);
            return;
        }
        if (seatsParam == null || seatsParam.trim().isEmpty() || "0".equals(seatsParam.trim())) {
            request.setAttribute("error", "Please select at least one seat before booking.");
            doGet(request, response);
            return;
        }

        try {
            int movieId      = Integer.parseInt(movieIdParam);
            int numberOfSeats = Integer.parseInt(seatsParam);
            
            // Get total price calculated by client (handles premium/VIP seat pricing)
            String totalPriceParam = request.getParameter("totalPrice");
            double totalPrice = 0.0;
            if (totalPriceParam != null && !totalPriceParam.trim().isEmpty()) {
                totalPrice = Double.parseDouble(totalPriceParam);
            } else {
                // Fallback to standard price if client didn't send it
                double pricePerSeat = Double.parseDouble(settingsDao.getSetting("PRICE_STANDARD", "200.0"));
                totalPrice = numberOfSeats * pricePerSeat;
            }

            // Store specific seat IDs in the seatType column (re-used as seat identifier store)
            String seatType = (selectedSeatIds != null && !selectedSeatIds.trim().isEmpty())
                    ? selectedSeatIds : "Not selected";

            Booking booking = new Booking(userId, movieId, finalShowTime, numberOfSeats, seatType, totalPrice, "Confirmed");
            int newBookingId = bookingDao.createBookingReturnId(booking);

            if (newBookingId > 0) {
                Movie movie   = movieDao.getMovieById(movieId);
                String orderRef = "MBK-" + String.format("%05d", newBookingId);

                request.setAttribute("bookingId",    newBookingId);
                request.setAttribute("orderRef",     orderRef);
                request.setAttribute("movie",        movie);
                request.setAttribute("showTime",     finalShowTime);
                request.setAttribute("seatIds",      seatType);
                request.setAttribute("numberOfSeats", numberOfSeats);
                request.setAttribute("totalPrice",   totalPrice);
                request.setAttribute("userName",     session.getAttribute("userName"));
                request.setAttribute("userEmail",    session.getAttribute("userEmail"));

                request.getRequestDispatcher("/WEB-INF/pages/ticketConfirmation.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Booking could not be saved. Please try again.");
                doGet(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid form data. Please go back and try again.");
            doGet(request, response);
        } catch (RuntimeException e) {
            // Log real DB error to server console — show clean message to user
            System.err.println("[BookTicketServlet] Booking DB error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Booking failed: " + e.getMessage());
            doGet(request, response);
        } catch (Exception e) {
            System.err.println("[BookTicketServlet] Unexpected error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Booking failed: " + e.getMessage());
            doGet(request, response);
        }
    }
}
