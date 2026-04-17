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
     * Get all bookings for a specific user.
     * Used in the "My Bookings" page to show user's booking history.
     * @param userId the ID of the user
     * @return list of bookings for that user, sorted by newest first
     */
    public List<Booking> getBookingsByUserId(int userId) {
        List<Booking> bookings = new ArrayList<>();
        // Join with movies table to also get the movie title
        String query = "SELECT b.*, m.title as movie_title FROM bookings b JOIN movies m ON b.movie_id = m.movie_id WHERE b.user_id = ? ORDER BY b.booking_date DESC";
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
        String query = "SELECT m.title, COUNT(b.booking_id) as booking_count, SUM(b.number_of_seats) as total_seats " +
                      "FROM bookings b JOIN movies m ON b.movie_id = m.movie_id " +
                      "GROUP BY m.movie_id, m.title ORDER BY booking_count DESC";
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
            // Each row has movie title, booking count, and total seats
            while (rs.next()) {
                Object[] row = new Object[3];
                row[0] = rs.getString("title");
                row[1] = rs.getInt("booking_count");
                row[2] = rs.getInt("total_seats");
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
     * Get how many bookings each seat type has.
     * Used to show seat type chart on admin dashboard.
     * @return list of arrays: [seat type, booking count, total seats]
     */
    public List<Object[]> getSeatDistribution() {
        List<Object[]> seatData = new ArrayList<>();
        // Group bookings by seat type and count them
        String query = "SELECT seat_type, COUNT(*) as booking_count, SUM(number_of_seats) as total_seats " +
                      "FROM bookings GROUP BY seat_type ORDER BY booking_count DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                Object[] row = new Object[3];
                row[0] = rs.getString("seat_type");
                row[1] = rs.getInt("booking_count");
                row[2] = rs.getInt("total_seats");
                seatData.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return seatData;
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
}
