package com.moviebooking.controllers;

import com.moviebooking.dao.BookingDao;
import com.moviebooking.dao.MovieDao;
import com.moviebooking.model.Booking;
import com.moviebooking.model.Movie;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.stream.Collectors;

/**
 * REST API Servlet for AJAX requests
 * Handles: seat availability, movie search, booking validation, stats
 */
@WebServlet("/api/*")
public class ApiServlet extends HttpServlet {
    private final MovieDao movieDao = new MovieDao();
    private final BookingDao bookingDao = new BookingDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            sendError(out, "Invalid API endpoint");
            return;
        }

        try {
            switch (pathInfo) {
                case "/seats/available":
                    handleSeatAvailability(request, out);
                    break;
                case "/movies/search":
                    handleMovieSearch(request, out);
                    break;
                case "/stats/revenue":
                    handleRevenueStats(request, out);
                    break;
                case "/stats/bookings/recent":
                    handleRecentBookings(request, out);
                    break;
                default:
                    sendError(out, "Unknown API endpoint: " + pathInfo);
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendError(out, "Server error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            sendError(out, "Invalid API endpoint");
            return;
        }

        try {
            if ("/bookings/validate".equals(pathInfo)) {
                handleBookingValidation(request, out);
            } else {
                sendError(out, "Unknown API endpoint: " + pathInfo);
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendError(out, "Server error: " + e.getMessage());
        }
    }

    /**
     * API: Check seat availability for a specific showtime
     * GET /api/seats/available?movieId=1&showTime=2025-04-27 18:00 - Audi 01
     */
    private void handleSeatAvailability(HttpServletRequest request, PrintWriter out) {
        String movieIdParam = request.getParameter("movieId");
        String showTime = request.getParameter("showTime");

        if (movieIdParam == null || showTime == null) {
            sendError(out, "Missing movieId or showTime parameter");
            return;
        }

        try {
            int movieId = Integer.parseInt(movieIdParam);
            List<Booking> bookings = bookingDao.getBookingsByMovieId(movieId);

            // Filter bookings for this specific showtime
            List<Booking> showtimeBookings = bookings.stream()
                .filter(b -> showTime.equals(b.getShowTime()))
                .collect(Collectors.toList());

            // Collect all booked seat IDs
            StringBuilder bookedSeats = new StringBuilder();
            for (int i = 0; i < showtimeBookings.size(); i++) {
                bookedSeats.append(showtimeBookings.get(i).getSeatType());
                if (i < showtimeBookings.size() - 1) bookedSeats.append(",");
            }

            // Calculate total booked seats
            int totalBooked = showtimeBookings.stream()
                .mapToInt(Booking::getNumberOfSeats)
                .sum();

            out.print("{");
            out.print("\"success\":true,");
            out.print("\"showTime\":\"" + escapeJson(showTime) + "\",");
            out.print("\"totalBooked\":" + totalBooked + ",");
            out.print("\"bookedSeats\":\"" + escapeJson(bookedSeats.toString()) + "\"");
            out.print("}");
        } catch (NumberFormatException e) {
            sendError(out, "Invalid movieId format");
        }
    }

    /**
     * API: Search movies by title
     * GET /api/movies/search?q=inception
     */
    private void handleMovieSearch(HttpServletRequest request, PrintWriter out) {
        String query = request.getParameter("q");
        if (query == null || query.trim().isEmpty()) {
            out.print("{\"success\":true,\"movies\":[]}");
            return;
        }

        List<Movie> allMovies = movieDao.getAllMovies();
        List<Movie> filtered = allMovies.stream()
            .filter(m -> m.getTitle().toLowerCase().contains(query.toLowerCase()))
            .limit(10)
            .collect(Collectors.toList());

        out.print("{\"success\":true,\"movies\":[");
        for (int i = 0; i < filtered.size(); i++) {
            Movie m = filtered.get(i);
            out.print("{");
            out.print("\"movieId\":" + m.getMovieId() + ",");
            out.print("\"title\":\"" + escapeJson(m.getTitle()) + "\",");
            out.print("\"genre\":\"" + escapeJson(m.getGenre()) + "\",");
            out.print("\"language\":\"" + escapeJson(m.getLanguage()) + "\",");
            out.print("\"posterImage\":\"" + escapeJson(m.getPosterImage()) + "\"");
            out.print("}");
            if (i < filtered.size() - 1) out.print(",");
        }
        out.print("]}");
    }

    /**
     * API: Get revenue statistics
     * GET /api/stats/revenue?period=month
     */
    private void handleRevenueStats(HttpServletRequest request, PrintWriter out) {
        String period = request.getParameter("period");
        if (period == null) period = "month";

        List<Object[]> revenueData;
        switch (period) {
            case "day":
                revenueData = bookingDao.getRevenueByDay();
                break;
            case "year":
                revenueData = bookingDao.getRevenueByYear();
                break;
            default:
                revenueData = bookingDao.getRevenueByMonth();
        }

        out.print("{\"success\":true,\"period\":\"" + period + "\",\"data\":[");
        for (int i = 0; i < revenueData.size(); i++) {
            Object[] row = revenueData.get(i);
            out.print("{");
            out.print("\"period\":\"" + escapeJson(String.valueOf(row[0])) + "\",");
            out.print("\"revenue\":" + row[1]);
            out.print("}");
            if (i < revenueData.size() - 1) out.print(",");
        }
        out.print("]}");
    }

    /**
     * API: Get recent bookings
     * GET /api/stats/bookings/recent?limit=10
     */
    private void handleRecentBookings(HttpServletRequest request, PrintWriter out) {
        String limitParam = request.getParameter("limit");
        int limit = 10;
        if (limitParam != null) {
            try {
                limit = Integer.parseInt(limitParam);
            } catch (NumberFormatException e) {
                limit = 10;
            }
        }

        List<Booking> bookings = bookingDao.getRecentBookings(limit);
        out.print("{\"success\":true,\"bookings\":[");
        for (int i = 0; i < bookings.size(); i++) {
            Booking b = bookings.get(i);
            out.print("{");
            out.print("\"bookingId\":" + b.getBookingId() + ",");
            out.print("\"movieTitle\":\"" + escapeJson(b.getMovieTitle()) + "\",");
            out.print("\"userName\":\"" + escapeJson(b.getUserName()) + "\",");
            out.print("\"showTime\":\"" + escapeJson(b.getShowTime()) + "\",");
            out.print("\"numberOfSeats\":" + b.getNumberOfSeats() + ",");
            out.print("\"totalPrice\":" + b.getTotalPrice() + ",");
            out.print("\"status\":\"" + escapeJson(b.getStatus()) + "\"");
            out.print("}");
            if (i < bookings.size() - 1) out.print(",");
        }
        out.print("]}");
    }

    /**
     * API: Validate booking before submission
     * POST /api/bookings/validate
     * Body: movieId, showTime, seatIds (comma-separated)
     */
    private void handleBookingValidation(HttpServletRequest request, PrintWriter out) {
        String movieIdParam = request.getParameter("movieId");
        String showTime = request.getParameter("showTime");
        String seatIds = request.getParameter("seatIds");

        if (movieIdParam == null || showTime == null || seatIds == null) {
            out.print("{\"success\":false,\"error\":\"Missing required parameters\"}");
            return;
        }

        try {
            int movieId = Integer.parseInt(movieIdParam);
            List<Booking> bookings = bookingDao.getBookingsByMovieId(movieId);

            // Get all booked seats for this showtime
            List<String> bookedSeatsList = bookings.stream()
                .filter(b -> showTime.equals(b.getShowTime()))
                .map(Booking::getSeatType)
                .collect(Collectors.toList());

            String bookedSeatsStr = String.join(",", bookedSeatsList);
            String[] requestedSeats = seatIds.split(",");
            
            // Check if any requested seat is already booked
            for (String seat : requestedSeats) {
                String trimmedSeat = seat.trim();
                if (bookedSeatsStr.contains(trimmedSeat)) {
                    out.print("{\"success\":false,\"error\":\"Seat " + escapeJson(trimmedSeat) + " is already booked\"}");
                    return;
                }
            }

            // Check if showtime has passed (15 min buffer)
            String[] parts = showTime.split(" ");
            if (parts.length >= 2) {
                String dateStr = parts[0];
                String timeStr = parts[1];
                
                java.time.LocalDate showDate = java.time.LocalDate.parse(dateStr);
                java.time.LocalTime showTimeTime = java.time.LocalTime.parse(timeStr);
                java.time.LocalDateTime showDateTime = java.time.LocalDateTime.of(showDate, showTimeTime);
                java.time.LocalDateTime cutoff = showDateTime.minusMinutes(15);
                
                if (java.time.LocalDateTime.now().isAfter(cutoff)) {
                    out.print("{\"success\":false,\"error\":\"This showtime is no longer available for booking\"}");
                    return;
                }
            }

            out.print("{\"success\":true,\"message\":\"Seats are available\"}");
        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"error\":\"Invalid movieId format\"}");
        } catch (Exception e) {
            out.print("{\"success\":false,\"error\":\"Validation error: " + escapeJson(e.getMessage()) + "\"}");
        }
    }

    /**
     * Helper: Send error response
     */
    private void sendError(PrintWriter out, String message) {
        out.print("{\"success\":false,\"error\":\"" + escapeJson(message) + "\"}");
    }

    /**
     * Helper: Escape JSON special characters
     */
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}
