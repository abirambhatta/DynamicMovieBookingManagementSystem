package com.moviebooking.dao;

import com.moviebooking.config.DBConnection;
import com.moviebooking.model.Booking;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * This class handles all database operations for bookings.
 * It can create, read, update, and delete bookings.
 * Also has methods for admin stats like revenue and top movies.
 */
public class BookingDao {
    
    /**
     * Save a new booking to the database.
     * @param booking the booking object with all details
     * @return true if booking was saved, false if it failed
     */
    public boolean createBooking(Booking booking) {
        // SQL query to insert a new booking into the bookings table
        String query = "INSERT INTO bookings (user_id, movie_id, show_time, number_of_seats, seat_type, total_price, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            // Set each value in the query using the booking object
            pstmt.setInt(1, booking.getUserId());
            pstmt.setInt(2, booking.getMovieId());
            pstmt.setString(3, booking.getShowTime());
            pstmt.setInt(4, booking.getNumberOfSeats());
            pstmt.setString(5, booking.getSeatType());
            pstmt.setDouble(6, booking.getTotalPrice());
            pstmt.setString(7, booking.getStatus());
            // Run the query and check if a row was added
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Create a new booking and return its generated ID.
     * @param booking the booking details
     * @return generated bookingID or 0 if failed
     */
    public int createBookingReturnId(Booking booking) {
        String query = "INSERT INTO bookings (user_id, movie_id, show_time, number_of_seats, seat_type, total_price, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, booking.getUserId());
            pstmt.setInt(2, booking.getMovieId());
            pstmt.setString(3, booking.getShowTime());
            pstmt.setInt(4, booking.getNumberOfSeats());
            pstmt.setString(5, booking.getSeatType());
            pstmt.setDouble(6, booking.getTotalPrice());
            pstmt.setString(7, booking.getStatus());
            
            if (pstmt.executeUpdate() > 0) {
                try (java.sql.ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            // Propagate the real error message so callers can display it
            e.printStackTrace();
            throw new RuntimeException("DB error saving booking: " + e.getMessage(), e);
        }
        return 0;
    }


    /**
     * Get all bookings for a specific user.
     * Used in the "My Bookings" page to show user's booking history.
     * @param userId the ID of the user
     * @return list of bookings for that user, sorted by newest first
     */
    public List<Booking> getBookingsByUserId(int userId) {
        List<Booking> bookings = new ArrayList<>();
        // Join with movies table to also get the movie title and poster
        String query = "SELECT b.*, m.title as movie_title, m.poster_image as movie_poster FROM bookings b JOIN movies m ON b.movie_id = m.movie_id WHERE b.user_id = ? ORDER BY b.booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            // Loop through each row and create a Booking object
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingId(rs.getInt("booking_id"));
                booking.setUserId(rs.getInt("user_id"));
                booking.setMovieId(rs.getInt("movie_id"));
                booking.setShowTime(rs.getString("show_time"));
                booking.setNumberOfSeats(rs.getInt("number_of_seats"));
                booking.setSeatType(rs.getString("seat_type"));
                booking.setTotalPrice(rs.getDouble("total_price"));
                booking.setStatus(rs.getString("status"));
                booking.setBookingDate(rs.getTimestamp("booking_date"));
                booking.setMovieTitle(rs.getString("movie_title"));
                booking.setMoviePoster(rs.getString("movie_poster"));
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    /**
     * Get all bookings in the system (for admin).
     * Includes user name and movie title for display.
     * @return list of all bookings, sorted by newest first
     */
    public List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();
        // Join bookings with movies and users tables to get movie title and user name
        String query = "SELECT b.*, m.title as movie_title, u.full_name as user_name FROM bookings b JOIN movies m ON b.movie_id = m.movie_id JOIN users u ON b.user_id = u.user_id ORDER BY b.booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            // Loop through each row and create a Booking object
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingId(rs.getInt("booking_id"));
                booking.setUserId(rs.getInt("user_id"));
                booking.setMovieId(rs.getInt("movie_id"));
                booking.setShowTime(rs.getString("show_time"));
                booking.setNumberOfSeats(rs.getInt("number_of_seats"));
                booking.setSeatType(rs.getString("seat_type"));
                booking.setTotalPrice(rs.getDouble("total_price"));
                booking.setStatus(rs.getString("status"));
                booking.setBookingDate(rs.getTimestamp("booking_date"));
                booking.setMovieTitle(rs.getString("movie_title"));
                booking.setUserName(rs.getString("user_name"));
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    /**
     * Get a single booking by its ID.
     * @param bookingId the ID of the booking to find
     * @return the Booking object if found, null if not found
     */
    public Booking getBookingById(int bookingId) {
        // Join with movies table to also get the movie title
        String query = "SELECT b.*, m.title as movie_title FROM bookings b JOIN movies m ON b.movie_id = m.movie_id WHERE b.booking_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, bookingId);
            ResultSet rs = pstmt.executeQuery();
            // If a booking is found, create and return the Booking object
            if (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingId(rs.getInt("booking_id"));
                booking.setUserId(rs.getInt("user_id"));
                booking.setMovieId(rs.getInt("movie_id"));
                booking.setShowTime(rs.getString("show_time"));
                booking.setNumberOfSeats(rs.getInt("number_of_seats"));
                booking.setSeatType(rs.getString("seat_type"));
                booking.setTotalPrice(rs.getDouble("total_price"));
                booking.setStatus(rs.getString("status"));
                booking.setBookingDate(rs.getTimestamp("booking_date"));
                booking.setMovieTitle(rs.getString("movie_title"));
                return booking;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get all confirmed bookings for a specific movie.
     * Used to figure out which seats are already occupied for a specific showtime.
     * @param movieId the ID of the movie
     * @return list of confirmed bookings for the movie
     */
    public List<Booking> getBookingsByMovieId(int movieId) {
        List<Booking> bookings = new ArrayList<>();
        String query = "SELECT b.*, m.title as movie_title FROM bookings b JOIN movies m ON b.movie_id = m.movie_id WHERE b.movie_id = ? AND b.status = 'Confirmed'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, movieId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingId(rs.getInt("booking_id"));
                booking.setUserId(rs.getInt("user_id"));
                booking.setMovieId(rs.getInt("movie_id"));
                booking.setShowTime(rs.getString("show_time"));
                booking.setNumberOfSeats(rs.getInt("number_of_seats"));
                booking.setSeatType(rs.getString("seat_type"));
                booking.setTotalPrice(rs.getDouble("total_price"));
                booking.setStatus(rs.getString("status"));
                booking.setBookingDate(rs.getTimestamp("booking_date"));
                booking.setMovieTitle(rs.getString("movie_title"));
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    /**
     * Update the status of a booking (e.g. Confirmed to Cancelled).
     * @param bookingId the ID of the booking to update
     * @param status the new status to set
     * @return true if updated, false if failed
     */
    public boolean updateBookingStatus(int bookingId, String status) {
        String query = "UPDATE bookings SET status = ? WHERE booking_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, status);
            pstmt.setInt(2, bookingId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete a booking from the database.
     * @param bookingId the ID of the booking to delete
     * @return true if deleted, false if failed
     */
    public boolean deleteBooking(int bookingId) {
        String query = "DELETE FROM bookings WHERE booking_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, bookingId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get the total revenue from all bookings.
     * Used on admin dashboard to show total earnings.
     * @return total revenue as a double value
     */
    public double getTotalRevenue() {
        // COALESCE returns 0 if there are no bookings (avoids null)
        String query = "SELECT COALESCE(SUM(total_price), 0) FROM bookings";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Get the most booked movies with their booking count and total seats.
     * Used to show popular movies on admin dashboard.
     * @param limit max number of movies to return (0 for all)
     * @return list of arrays: [movie title, booking count, total seats]
     */
    public List<Object[]> getTopBookedMovies(int limit) {
        List<Object[]> topMovies = new ArrayList<>();
        // Group bookings by movie and count them, sorted by most booked
        String query = "SELECT m.title, COUNT(b.booking_id) as booking_count, SUM(b.number_of_seats) as total_seats, m.poster_image " +
                      "FROM bookings b JOIN movies m ON b.movie_id = m.movie_id " +
                      "GROUP BY m.movie_id, m.title, m.poster_image ORDER BY booking_count DESC";
        // Add LIMIT if a limit is given
        if (limit > 0) {
            query += " LIMIT ?";
        }
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            if (limit > 0) {
                pstmt.setInt(1, limit);
            }
            ResultSet rs = pstmt.executeQuery();
            // Each row has movie title, booking count, total seats, and poster image
            while (rs.next()) {
                Object[] row = new Object[4];
                row[0] = rs.getString("title");
                row[1] = rs.getInt("booking_count");
                row[2] = rs.getInt("total_seats");
                row[3] = rs.getString("poster_image");
                topMovies.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return topMovies;
    }
    
    /**
     * Get revenue grouped by month for the past 12 months.
     * Used to show monthly revenue chart on admin dashboard.
     * @return list of arrays: [month (YYYY-MM), revenue amount]
     */
    public List<Object[]> getRevenueByMonth() {
        List<Object[]> revenueData = new ArrayList<>();
        // Group bookings by month, get total revenue for each month
        String query = "SELECT DATE_FORMAT(booking_date, '%Y-%m') as month, SUM(total_price) as revenue " +
                      "FROM bookings GROUP BY month ORDER BY month DESC LIMIT 12";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                Object[] row = new Object[2];
                row[0] = rs.getString("month");
                row[1] = rs.getDouble("revenue");
                revenueData.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return revenueData;
    }
    
    /**
     * Get revenue grouped by day for the last 30 days.
     * Used to show daily revenue chart on admin dashboard.
     * @return list of arrays: [day (YYYY-MM-DD), revenue amount]
     */
    public List<Object[]> getRevenueByDay() {
        List<Object[]> revenueData = new ArrayList<>();
        // Only get bookings from the last 30 days, group by day
        String query = "SELECT DATE(booking_date) as day, SUM(total_price) as revenue " +
                      "FROM bookings WHERE booking_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) " +
                      "GROUP BY day ORDER BY day DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                Object[] row = new Object[2];
                row[0] = rs.getString("day");
                row[1] = rs.getDouble("revenue");
                revenueData.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return revenueData;
    }
    
    /**
     * Get revenue grouped by year.
     * Used to show yearly revenue chart on admin dashboard.
     * @return list of arrays: [year, revenue amount]
     */
    public List<Object[]> getRevenueByYear() {
        List<Object[]> revenueData = new ArrayList<>();
        // Group bookings by year, get total revenue for each year
        String query = "SELECT YEAR(booking_date) as year, SUM(total_price) as revenue " +
                      "FROM bookings GROUP BY year ORDER BY year DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                Object[] row = new Object[2];
                row[0] = rs.getString("year");
                row[1] = rs.getDouble("revenue");
                revenueData.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return revenueData;
    }
    
    /**
     * Get how many seats of each type (Standard, Premium, Recliner, VIP) have been booked.
     * Uses hall configurations from database to determine seat types dynamically.
     * Used to show seat type chart on admin dashboard.
     * @return list of arrays: [seat type name, total seat count]
     */
    public List<Object[]> getSeatDistribution() {
        List<Object[]> seatData = new ArrayList<>();
        
        // Count seats by type
        int standardCount = 0;
        int premiumCount = 0;
        int reclinerCount = 0;
        int vipCount = 0;
        
        try (Connection conn = DBConnection.getConnection()) {
            // First, load all hall configurations to build a map of row -> seat type
            java.util.Map<String, String> rowToTypeMap = new java.util.HashMap<>();
            
            String hallConfigQuery = "SELECT hall_name, standard_rows, premium_rows, recliner_rows, vip_rows FROM hall_config";
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(hallConfigQuery)) {
                
                while (rs.next()) {
                    String standardRows = rs.getString("standard_rows");
                    String premiumRows = rs.getString("premium_rows");
                    String reclinerRows = rs.getString("recliner_rows");
                    String vipRows = rs.getString("vip_rows");
                    
                    // Parse and map each row letter to its type
                    if (standardRows != null && !standardRows.trim().isEmpty()) {
                        for (String row : standardRows.split(",")) {
                            rowToTypeMap.put(row.trim().toUpperCase(), "Standard");
                        }
                    }
                    if (premiumRows != null && !premiumRows.trim().isEmpty()) {
                        for (String row : premiumRows.split(",")) {
                            rowToTypeMap.put(row.trim().toUpperCase(), "Premium");
                        }
                    }
                    if (reclinerRows != null && !reclinerRows.trim().isEmpty()) {
                        for (String row : reclinerRows.split(",")) {
                            rowToTypeMap.put(row.trim().toUpperCase(), "Recliner");
                        }
                    }
                    if (vipRows != null && !vipRows.trim().isEmpty()) {
                        for (String row : vipRows.split(",")) {
                            rowToTypeMap.put(row.trim().toUpperCase(), "VIP");
                        }
                    }
                }
            }
            
            // Now get all bookings and categorize seats
            String bookingQuery = "SELECT seat_type FROM bookings WHERE status = 'Confirmed'";
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(bookingQuery)) {
                
                while (rs.next()) {
                    String seatIds = rs.getString("seat_type");
                    if (seatIds == null || seatIds.trim().isEmpty()) continue;
                    
                    // Split comma-separated seat IDs (e.g., "A1, B2, C3")
                    String[] seats = seatIds.split(",");
                    for (String seat : seats) {
                        seat = seat.trim();
                        if (seat.isEmpty()) continue;
                        
                        // Extract row letter (first character or characters before digits)
                        String rowLetter = "";
                        for (int i = 0; i < seat.length(); i++) {
                            char c = seat.charAt(i);
                            if (Character.isDigit(c)) break;
                            rowLetter += c;
                        }
                        rowLetter = rowLetter.toUpperCase();
                        
                        // Look up seat type from hall config
                        String seatType = rowToTypeMap.getOrDefault(rowLetter, "Standard");
                        
                        // Increment the appropriate counter
                        switch (seatType) {
                            case "Standard":
                                standardCount++;
                                break;
                            case "Premium":
                                premiumCount++;
                                break;
                            case "Recliner":
                                reclinerCount++;
                                break;
                            case "VIP":
                                vipCount++;
                                break;
                        }
                    }
                }
            }
            
            // Add results only if there are bookings
            if (standardCount > 0) {
                Object[] row = new Object[2];
                row[0] = "Standard";
                row[1] = standardCount;
                seatData.add(row);
            }
            if (premiumCount > 0) {
                Object[] row = new Object[2];
                row[0] = "Premium";
                row[1] = premiumCount;
                seatData.add(row);
            }
            if (reclinerCount > 0) {
                Object[] row = new Object[2];
                row[0] = "Recliner";
                row[1] = reclinerCount;
                seatData.add(row);
            }
            if (vipCount > 0) {
                Object[] row = new Object[2];
                row[0] = "VIP";
                row[1] = vipCount;
                seatData.add(row);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return seatData;
    }
    
    public List<Object[]> getSeatDistributionByPeriod(String period, String startDate, String endDate) {
        List<Object[]> seatData = new ArrayList<>();
        
        int standardCount = 0;
        int premiumCount = 0;
        int reclinerCount = 0;
        int vipCount = 0;
        
        try (Connection conn = DBConnection.getConnection()) {
            java.util.Map<String, String> rowToTypeMap = new java.util.HashMap<>();
            
            String hallConfigQuery = "SELECT hall_name, standard_rows, premium_rows, recliner_rows, vip_rows FROM hall_config";
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(hallConfigQuery)) {
                
                while (rs.next()) {
                    String standardRows = rs.getString("standard_rows");
                    String premiumRows = rs.getString("premium_rows");
                    String reclinerRows = rs.getString("recliner_rows");
                    String vipRows = rs.getString("vip_rows");
                    
                    if (standardRows != null && !standardRows.trim().isEmpty()) {
                        for (String row : standardRows.split(",")) {
                            rowToTypeMap.put(row.trim().toUpperCase(), "Standard");
                        }
                    }
                    if (premiumRows != null && !premiumRows.trim().isEmpty()) {
                        for (String row : premiumRows.split(",")) {
                            rowToTypeMap.put(row.trim().toUpperCase(), "Premium");
                        }
                    }
                    if (reclinerRows != null && !reclinerRows.trim().isEmpty()) {
                        for (String row : reclinerRows.split(",")) {
                            rowToTypeMap.put(row.trim().toUpperCase(), "Recliner");
                        }
                    }
                    if (vipRows != null && !vipRows.trim().isEmpty()) {
                        for (String row : vipRows.split(",")) {
                            rowToTypeMap.put(row.trim().toUpperCase(), "VIP");
                        }
                    }
                }
            }
            
            StringBuilder query = new StringBuilder("SELECT seat_type FROM bookings WHERE status = 'Confirmed'");
            
            if ("day".equals(period)) {
                query.append(" AND DATE(booking_date) = CURDATE() ");
            } else if ("week".equals(period)) {
                query.append(" AND booking_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) ");
            } else if ("month".equals(period)) {
                query.append(" AND booking_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) ");
            } else if ("month_year".equals(period)) {
                query.append(" AND booking_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH) ");
            } else if ("year".equals(period)) {
                // All years
            } else if ("custom".equals(period) && startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
                query.append(" AND DATE(booking_date) BETWEEN ? AND ? ");
            }
            
            try (PreparedStatement pstmt = conn.prepareStatement(query.toString())) {
                if ("custom".equals(period) && startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
                    pstmt.setString(1, startDate);
                    pstmt.setString(2, endDate);
                }
                
                ResultSet rs = pstmt.executeQuery();
                
                while (rs.next()) {
                    String seatIds = rs.getString("seat_type");
                    if (seatIds == null || seatIds.trim().isEmpty()) continue;
                    
                    String[] seats = seatIds.split(",");
                    for (String seat : seats) {
                        seat = seat.trim();
                        if (seat.isEmpty()) continue;
                        
                        String rowLetter = "";
                        for (int i = 0; i < seat.length(); i++) {
                            char c = seat.charAt(i);
                            if (Character.isDigit(c)) break;
                            rowLetter += c;
                        }
                        rowLetter = rowLetter.toUpperCase();
                        
                        String seatType = rowToTypeMap.getOrDefault(rowLetter, "Standard");
                        
                        switch (seatType) {
                            case "Standard": standardCount++; break;
                            case "Premium": premiumCount++; break;
                            case "Recliner": reclinerCount++; break;
                            case "VIP": vipCount++; break;
                        }
                    }
                }
            }
            
            if (standardCount > 0) seatData.add(new Object[]{"Standard", standardCount});
            if (premiumCount > 0) seatData.add(new Object[]{"Premium", premiumCount});
            if (reclinerCount > 0) seatData.add(new Object[]{"Recliner", reclinerCount});
            if (vipCount > 0) seatData.add(new Object[]{"VIP", vipCount});
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return seatData;
    }
    
    public List<Object[]> getRevenueChartData(String period, String startDate, String endDate, String group) {
        List<Object[]> data = new ArrayList<>();
        StringBuilder query = new StringBuilder();
        
        if ("day".equals(period)) {
            query.append("SELECT DATE_FORMAT(booking_date, '%Y-%m-%d %H:00') as label, COALESCE(SUM(total_price), 0) as revenue ");
            query.append("FROM bookings WHERE status != 'Cancelled' AND DATE(booking_date) = CURDATE() ");
            query.append("GROUP BY label ORDER BY label ASC");
        } else if ("week".equals(period)) {
            query.append("SELECT DATE(booking_date) as label, COALESCE(SUM(total_price), 0) as revenue ");
            query.append("FROM bookings WHERE status != 'Cancelled' AND booking_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) ");
            query.append("GROUP BY label ORDER BY label ASC");
        } else if ("month".equals(period)) {
            query.append("SELECT DATE(booking_date) as label, COALESCE(SUM(total_price), 0) as revenue ");
            query.append("FROM bookings WHERE status != 'Cancelled' AND booking_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) ");
            query.append("GROUP BY label ORDER BY label ASC");
        } else if ("month_year".equals(period)) {
            query.append("SELECT DATE_FORMAT(booking_date, '%Y-%m') as label, COALESCE(SUM(total_price), 0) as revenue ");
            query.append("FROM bookings WHERE status != 'Cancelled' AND booking_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH) ");
            query.append("GROUP BY label ORDER BY label ASC");
        } else if ("year".equals(period)) {
            query.append("SELECT YEAR(booking_date) as label, COALESCE(SUM(total_price), 0) as revenue ");
            query.append("FROM bookings WHERE status != 'Cancelled' ");
            query.append("GROUP BY label ORDER BY label ASC");
        } else if ("custom".equals(period) && startDate != null && endDate != null) {
            String groupBy = "day";
            if (group != null && !group.isEmpty()) {
                groupBy = group;
            } else {
                try {
                    java.time.LocalDate start = java.time.LocalDate.parse(startDate);
                    java.time.LocalDate end = java.time.LocalDate.parse(endDate);
                    long days = java.time.temporal.ChronoUnit.DAYS.between(start, end);
                    if (days > 90) groupBy = "month";
                    else if (days > 30) groupBy = "week";
                } catch (Exception e) {}
            }
            
            if ("month".equals(groupBy)) {
                query.append("SELECT DATE_FORMAT(booking_date, '%Y-%m') as label, COALESCE(SUM(total_price), 0) as revenue ");
            } else if ("week".equals(groupBy)) {
                query.append("SELECT DATE_ADD(DATE(booking_date), INTERVAL (1-DAYOFWEEK(booking_date)) DAY) as label, COALESCE(SUM(total_price), 0) as revenue ");
            } else {
                query.append("SELECT DATE(booking_date) as label, COALESCE(SUM(total_price), 0) as revenue ");
            }
            query.append("FROM bookings WHERE status != 'Cancelled' AND DATE(booking_date) BETWEEN ? AND ? ");
            query.append("GROUP BY label ORDER BY label ASC");
        } else {
            query.append("SELECT DATE_FORMAT(booking_date, '%Y-%m') as label, COALESCE(SUM(total_price), 0) as revenue ");
            query.append("FROM bookings WHERE status != 'Cancelled' AND booking_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH) ");
            query.append("GROUP BY label ORDER BY label ASC");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query.toString())) {
             
            if ("custom".equals(period) && startDate != null && endDate != null) {
                pstmt.setString(1, startDate);
                pstmt.setString(2, endDate);
            }
            
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                data.add(new Object[]{rs.getString("label"), rs.getDouble("revenue")});
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return data;
    }
    
    public List<Object[]> getAllMoviesWithBookingCount() {
        List<Object[]> movieData = new ArrayList<>();
        // LEFT JOIN means all movies are shown, even if they have no bookings
        // COALESCE returns 0 instead of null for movies with no bookings
        String query = "SELECT m.title, COALESCE(COUNT(b.booking_id), 0) as booking_count, COALESCE(SUM(b.number_of_seats), 0) as total_seats " +
                      "FROM movies m LEFT JOIN bookings b ON m.movie_id = b.movie_id " +
                      "GROUP BY m.movie_id, m.title ORDER BY booking_count DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                Object[] row = new Object[3];
                row[0] = rs.getString("title");
                row[1] = rs.getInt("booking_count");
                row[2] = rs.getInt("total_seats");
                movieData.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return movieData;
    }

    public int getTotalBookings() {
        String query = "SELECT COUNT(*) FROM bookings";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int getConfirmedBookings() {
        String query = "SELECT COUNT(*) FROM bookings WHERE status = 'Confirmed'";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int getCancelledBookings() {
        String query = "SELECT COUNT(*) FROM bookings WHERE status = 'Cancelled'";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int getTodayBookings() {
        String query = "SELECT COUNT(*) FROM bookings WHERE DATE(booking_date) = CURDATE()";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public List<Booking> searchBookings(String keyword) {
        List<Booking> bookings = new ArrayList<>();
        String query = "SELECT b.*, m.title as movie_title, u.full_name as user_name FROM bookings b " +
                      "JOIN movies m ON b.movie_id = m.movie_id JOIN users u ON b.user_id = u.user_id " +
                      "WHERE u.full_name LIKE ? OR m.title LIKE ? OR b.booking_id LIKE ? " +
                      "ORDER BY b.booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingId(rs.getInt("booking_id"));
                booking.setUserId(rs.getInt("user_id"));
                booking.setMovieId(rs.getInt("movie_id"));
                booking.setShowTime(rs.getString("show_time"));
                booking.setNumberOfSeats(rs.getInt("number_of_seats"));
                booking.setSeatType(rs.getString("seat_type"));
                booking.setTotalPrice(rs.getDouble("total_price"));
                booking.setStatus(rs.getString("status"));
                booking.setBookingDate(rs.getTimestamp("booking_date"));
                booking.setMovieTitle(rs.getString("movie_title"));
                booking.setUserName(rs.getString("user_name"));
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    public List<Booking> getBookingsByFilter(String period, String status, String startDate, String endDate) {
        List<Booking> bookings = new ArrayList<>();
        StringBuilder query = new StringBuilder(
            "SELECT b.*, m.title as movie_title, u.full_name as user_name FROM bookings b " +
            "JOIN movies m ON b.movie_id = m.movie_id JOIN users u ON b.user_id = u.user_id WHERE 1=1"
        );
        
        // Add period filter (quick filters)
        if ("today".equals(period)) {
            query.append(" AND DATE(b.booking_date) = CURDATE()");
        } else if ("week".equals(period)) {
            query.append(" AND b.booking_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)");
        } else if ("month".equals(period)) {
            query.append(" AND b.booking_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)");
        } else if ("month_year".equals(period)) {
            query.append(" AND b.booking_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)");
        } else if ("year".equals(period)) {
            // All years
        }
        // Add custom date range filter
        else if (startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
            query.append(" AND DATE(b.booking_date) BETWEEN ? AND ?");
        }
        
        // Add status filter
        boolean hasStatusFilter = status != null && !status.isEmpty() && !"all".equals(status);
        if (hasStatusFilter) {
            query.append(" AND b.status = ?");
        }
        
        query.append(" ORDER BY b.booking_date DESC");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query.toString())) {
            
            int paramIndex = 1;
            
            // Set date range parameters if custom range is used
            if (startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty() 
                && period == null) {
                pstmt.setString(paramIndex++, startDate);
                pstmt.setString(paramIndex++, endDate);
            }
            
            // Set status parameter
            if (hasStatusFilter) {
                pstmt.setString(paramIndex, status);
            }
            
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingId(rs.getInt("booking_id"));
                booking.setUserId(rs.getInt("user_id"));
                booking.setMovieId(rs.getInt("movie_id"));
                booking.setShowTime(rs.getString("show_time"));
                booking.setNumberOfSeats(rs.getInt("number_of_seats"));
                booking.setSeatType(rs.getString("seat_type"));
                booking.setTotalPrice(rs.getDouble("total_price"));
                booking.setStatus(rs.getString("status"));
                booking.setBookingDate(rs.getTimestamp("booking_date"));
                booking.setMovieTitle(rs.getString("movie_title"));
                booking.setUserName(rs.getString("user_name"));
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    public List<Booking> getRecentBookings(int limit) {
        List<Booking> bookings = new ArrayList<>();
        String query = "SELECT b.*, m.title as movie_title, u.full_name as user_name FROM bookings b " +
                      "JOIN movies m ON b.movie_id = m.movie_id JOIN users u ON b.user_id = u.user_id " +
                      "ORDER BY b.booking_date DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingId(rs.getInt("booking_id"));
                booking.setUserId(rs.getInt("user_id"));
                booking.setMovieId(rs.getInt("movie_id"));
                booking.setShowTime(rs.getString("show_time"));
                booking.setNumberOfSeats(rs.getInt("number_of_seats"));
                booking.setSeatType(rs.getString("seat_type"));
                booking.setTotalPrice(rs.getDouble("total_price"));
                booking.setStatus(rs.getString("status"));
                booking.setBookingDate(rs.getTimestamp("booking_date"));
                booking.setMovieTitle(rs.getString("movie_title"));
                booking.setUserName(rs.getString("user_name"));
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    public int getBookingsCountByPeriod(String period, String startDate, String endDate) {
        StringBuilder query = new StringBuilder("SELECT COUNT(*) FROM bookings WHERE 1=1");
        
        if ("day".equals(period)) {
            query.append(" AND DATE(booking_date) = CURDATE()");
        } else if ("week".equals(period)) {
            query.append(" AND booking_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)");
        } else if ("month".equals(period)) {
            query.append(" AND booking_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)");
        } else if ("month_year".equals(period)) {
            query.append(" AND booking_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)");
        } else if ("year".equals(period)) {
            // All years
        } else if ("custom".equals(period) && startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
            query.append(" AND DATE(booking_date) BETWEEN ? AND ?");
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query.toString())) {
            
            if ("custom".equals(period) && startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
                pstmt.setString(1, startDate);
                pstmt.setString(2, endDate);
            }
            
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public double getTotalRevenueByPeriod(String period, String startDate, String endDate) {
        StringBuilder query = new StringBuilder("SELECT COALESCE(SUM(total_price), 0) FROM bookings WHERE status != 'Cancelled'");
        
        if ("day".equals(period)) {
            query.append(" AND DATE(booking_date) = CURDATE()");
        } else if ("week".equals(period)) {
            query.append(" AND booking_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)");
        } else if ("month".equals(period)) {
            query.append(" AND booking_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)");
        } else if ("month_year".equals(period)) {
            query.append(" AND booking_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)");
        } else if ("year".equals(period)) {
            // All years
        } else if ("custom".equals(period) && startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
            query.append(" AND DATE(booking_date) BETWEEN ? AND ?");
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query.toString())) {
            
            if ("custom".equals(period) && startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
                pstmt.setString(1, startDate);
                pstmt.setString(2, endDate);
            }
            
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public List<Object[]> getAllMoviesWithBookingCountByPeriod(String period, String startDate, String endDate) {
        List<Object[]> movieData = new ArrayList<>();
        StringBuilder query = new StringBuilder(
            "SELECT m.title, COALESCE(COUNT(b.booking_id), 0) as booking_count, COALESCE(SUM(b.number_of_seats), 0) as total_seats " +
            "FROM movies m LEFT JOIN bookings b ON m.movie_id = b.movie_id "
        );
        
        if ("day".equals(period)) {
            query.append(" AND DATE(b.booking_date) = CURDATE() ");
        } else if ("week".equals(period)) {
            query.append(" AND b.booking_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) ");
        } else if ("month".equals(period)) {
            query.append(" AND b.booking_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) ");
        } else if ("month_year".equals(period)) {
            query.append(" AND b.booking_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH) ");
        } else if ("year".equals(period)) {
            // All years
        } else if ("custom".equals(period) && startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
            query.append(" AND DATE(b.booking_date) BETWEEN ? AND ? ");
        }
        
        query.append("GROUP BY m.movie_id, m.title ORDER BY booking_count DESC");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query.toString())) {
             
            if ("custom".equals(period) && startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
                pstmt.setString(1, startDate);
                pstmt.setString(2, endDate);
            }
            
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Object[] row = new Object[3];
                row[0] = rs.getString("title");
                row[1] = rs.getInt("booking_count");
                row[2] = rs.getInt("total_seats");
                movieData.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return movieData;
    }

    public List<Object[]> getTopBookedMoviesByPeriod(int limit, String period, String startDate, String endDate) {
        List<Object[]> topMovies = new ArrayList<>();
        StringBuilder query = new StringBuilder(
            "SELECT m.title, COUNT(b.booking_id) as booking_count, SUM(b.number_of_seats) as total_seats, m.poster_image " +
            "FROM bookings b JOIN movies m ON b.movie_id = m.movie_id WHERE b.status != 'Cancelled' "
        );
        
        if ("day".equals(period)) {
            query.append(" AND DATE(b.booking_date) = CURDATE() ");
        } else if ("week".equals(period)) {
            query.append(" AND b.booking_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) ");
        } else if ("month".equals(period)) {
            query.append(" AND b.booking_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) ");
        } else if ("month_year".equals(period)) {
            query.append(" AND b.booking_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH) ");
        } else if ("year".equals(period)) {
            // All years
        } else if ("custom".equals(period) && startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
            query.append(" AND DATE(b.booking_date) BETWEEN ? AND ? ");
        }
        
        query.append("GROUP BY m.movie_id, m.title, m.poster_image ORDER BY booking_count DESC");
        
        if (limit > 0) {
            query.append(" LIMIT ?");
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query.toString())) {
             
            int paramIndex = 1;
            if ("custom".equals(period) && startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
                pstmt.setString(paramIndex++, startDate);
                pstmt.setString(paramIndex++, endDate);
            }
            if (limit > 0) {
                pstmt.setInt(paramIndex, limit);
            }
            
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Object[] row = new Object[4];
                row[0] = rs.getString("title");
                row[1] = rs.getInt("booking_count");
                row[2] = rs.getInt("total_seats");
                row[3] = rs.getString("poster_image");
                topMovies.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return topMovies;
    }
}
