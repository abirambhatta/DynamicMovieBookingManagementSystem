package com.moviebooking.dao;

import com.moviebooking.config.DBConnection;
import com.moviebooking.model.ShowTime;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * This class handles all database operations for show times.
 * It can add, get, and delete show times for movies.
 * Each movie can have many show times (different dates and times).
 */
public class ShowTimeDao {
    
    /**
     * Add a new show time for a movie.
     * @param showTime the show time object with movie ID, date, and time
     * @return true if added, false if failed
     */
    public boolean addShowTime(ShowTime showTime) {
        String query = "INSERT INTO show_times (movie_id, show_date, show_time, hall) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection()) {
            
            // Add column if it doesn't exist yet
            try (Statement s = conn.createStatement()) {
                s.executeUpdate("ALTER TABLE show_times ADD COLUMN IF NOT EXISTS hall VARCHAR(50)");
            } catch (Exception e) {}

            try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                pstmt.setInt(1, showTime.getMovieId());
                pstmt.setDate(2, showTime.getShowDate());
                pstmt.setTime(3, showTime.getShowTime());
                pstmt.setString(4, showTime.getHall() != null ? showTime.getHall() : "Grand Hall 01");
                return pstmt.executeUpdate() > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get a specific show time by its ID.
     * @param showTimeId the ID of the show time
     * @return ShowTime object or null if not found
     */
    public ShowTime getShowTimeById(int showTimeId) {
        String query = "SELECT * FROM show_times WHERE show_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, showTimeId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                ShowTime st = new ShowTime();
                st.setShowTimeId(rs.getInt("show_id"));
                st.setMovieId(rs.getInt("movie_id"));
                st.setShowDate(rs.getDate("show_date"));
                st.setShowTime(rs.getTime("show_time"));
                try {
                    String hall = rs.getString("hall");
                    st.setHall(hall != null ? hall : "Audi 01");
                } catch(Exception e) {
                    st.setHall("Audi 01");
                }
                return st;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Get all show times for a specific movie.
     * Sorted by date and time so the earliest shows come first.
     * @param movieId the ID of the movie
     * @return list of show times for that movie
     */
    public List<ShowTime> getShowTimesByMovie(int movieId) {
        List<ShowTime> showTimes = new ArrayList<>();
        String query = "SELECT * FROM show_times WHERE movie_id = ? ORDER BY show_date, show_time";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, movieId);
            ResultSet rs = pstmt.executeQuery();
            // Loop through each row and create a ShowTime object
            while (rs.next()) {
                ShowTime st = new ShowTime();
                st.setShowTimeId(rs.getInt("show_id"));
                st.setMovieId(rs.getInt("movie_id"));
                st.setShowDate(rs.getDate("show_date"));
                st.setShowTime(rs.getTime("show_time"));
                try {
                    String hall = rs.getString("hall");
                    st.setHall(hall != null ? hall : "Audi 01");
                } catch(Exception e) {
                    st.setHall("Audi 01");
                }
                showTimes.add(st);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return showTimes;
    }
    
    /**
     * Delete a single show time by its ID.
     * @param showTimeId the ID of the show time to delete
     * @return true if deleted, false if failed
     */
    public boolean deleteShowTime(int showTimeId) {
        String query = "DELETE FROM show_times WHERE show_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, showTimeId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete all show times for a specific movie.
     * Used when a movie is deleted so its show times are also removed.
     * @param movieId the ID of the movie
     * @return true if deleted, false if failed
     */
    public boolean deleteShowTimesByMovie(int movieId) {
        String query = "DELETE FROM show_times WHERE movie_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, movieId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<ShowTime> getUpcomingShowTimes() {
        List<ShowTime> showTimes = new ArrayList<>();
        String query = "SELECT st.*, m.title as movie_title FROM show_times st " +
                      "JOIN movies m ON st.movie_id = m.movie_id " +
                      "WHERE st.show_date >= CURDATE() ORDER BY st.show_date, st.show_time LIMIT 20";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                ShowTime st = new ShowTime();
                st.setShowTimeId(rs.getInt("show_id"));
                st.setMovieId(rs.getInt("movie_id"));
                st.setShowDate(rs.getDate("show_date"));
                st.setShowTime(rs.getTime("show_time"));
                try {
                    String hall = rs.getString("hall");
                    st.setHall(hall != null ? hall : "Audi 01");
                } catch(Exception e) {
                    st.setHall("Audi 01");
                }
                st.setMovieTitle(rs.getString("movie_title"));
                showTimes.add(st);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return showTimes;
    }

    public List<ShowTime> getAllShowTimes() {
        List<ShowTime> showTimes = new ArrayList<>();
        String query = "SELECT * FROM show_times ORDER BY show_date, show_time";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                ShowTime st = new ShowTime();
                st.setShowTimeId(rs.getInt("show_id"));
                st.setMovieId(rs.getInt("movie_id"));
                st.setShowDate(rs.getDate("show_date"));
                st.setShowTime(rs.getTime("show_time"));
                try {
                    String hall = rs.getString("hall");
                    st.setHall(hall != null ? hall : "Audi 01");
                } catch(Exception e) {
                    st.setHall("Audi 01");
                }
                showTimes.add(st);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return showTimes;
    }

    public List<ShowTime> getShowTimesByDate(java.sql.Date date) {
        List<ShowTime> showTimes = new ArrayList<>();
        String query = "SELECT * FROM show_times WHERE show_date = ? ORDER BY show_time";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setDate(1, date);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                ShowTime st = new ShowTime();
                st.setShowTimeId(rs.getInt("show_id"));
                st.setMovieId(rs.getInt("movie_id"));
                st.setShowDate(rs.getDate("show_date"));
                st.setShowTime(rs.getTime("show_time"));
                try {
                    String hall = rs.getString("hall");
                    st.setHall(hall != null ? hall : "Audi 01");
                } catch(Exception e) {
                    st.setHall("Audi 01");
                }
                showTimes.add(st);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return showTimes;
    }
}
