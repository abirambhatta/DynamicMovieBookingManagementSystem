package com.moviebooking.dao;

import com.moviebooking.config.DBConnection;
import com.moviebooking.model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * This class handles all database operations for users.
 * It can register, login, update, delete users, and manage account locking.
 * Used by servlets to work with user data in the database.
 */
public class UserDao {
    
    /**
     * Save a new user to the database (register).
     * @param user the user object with name, email, phone, password, role
     * @return true if user was saved, false if it failed
     */
    public boolean registerUser(User user) {
        String query = "INSERT INTO users (full_name, email, phone, password, role) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, user.getFullName());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPhone());
            pstmt.setString(4, user.getPassword());
            pstmt.setString(5, user.getRole());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Create a new user (admin function).
     * Same as registerUser but clearer name for admin context.
     * @param user the user object with name, email, phone, password, role
     * @return true if user was created, false if it failed
     */
    public boolean createUser(User user) {
        return registerUser(user);
    }

    /**
     * Check if email and password match a user in the database (login check).
     * @param email the email entered by the user
     * @param password the password entered by the user
     * @return User object if login is correct, null if email/password is wrong
     */
    public User validateUser(String email, String password) {
        String query = "SELECT * FROM users WHERE email = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, email);
            pstmt.setString(2, password);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getString("role"));
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Check if an email is already registered in the database.
     * Used during registration to avoid duplicate emails.
     * @param email the email to check
     * @return true if email already exists, false if not
     */
    public boolean emailExists(String email) {
        String query = "SELECT COUNT(*) FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Check if a phone number is already registered in the database.
     * Used during registration to avoid duplicate phones.
     * @param phone the phone number to check
     * @return true if phone already exists, false if not
     */
    public boolean phoneExists(String phone) {
        String query = "SELECT COUNT(*) FROM users WHERE phone = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, phone);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get all users from the database with their booking count and total spent.
     * Used on the admin manage users page.
     * @return list of all users, sorted by newest first
     */
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String query = "SELECT u.*, " +
                      "(SELECT COUNT(*) FROM bookings b WHERE b.user_id = u.user_id) as booking_count, " +
                      "(SELECT COALESCE(SUM(b.total_price), 0) FROM bookings b WHERE b.user_id = u.user_id) as total_spent " +
                      "FROM users u ORDER BY u.user_id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getString("role"));
                user.setRegistrationDate(rs.getTimestamp("created_at"));
                user.setBookingCount(rs.getInt("booking_count"));
                user.setTotalSpent(rs.getDouble("total_spent"));
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    /**
     * Get a single user by their ID.
     * @param userId the ID of the user to find
     * @return the User object if found, null if not found
     */
    public User getUserById(int userId) {
        String query = "SELECT * FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getString("role"));
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get a single user by their email.
     * @param email the email of the user to find
     * @return the User object if found, null if not found
     */
    public User getUserByEmail(String email) {
        String query = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getString("role"));
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Update user's name, email, phone, and role in the database.
     * Used when admin edits a user or user edits their profile.
     * @param user the user object with updated values
     * @return true if updated, false if failed
     */
    public boolean updateUser(User user) {
        String query = "UPDATE users SET full_name = ?, email = ?, phone = ?, role = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, user.getFullName());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPhone());
            pstmt.setString(4, user.getRole());
            pstmt.setInt(5, user.getUserId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete a user from the database by their ID.
     * Used by admin to remove a user.
     * @param userId the ID of the user to delete
     * @return true if deleted, false if failed
     */
    public boolean deleteUser(int userId) {
        String query = "DELETE FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update password for a user and reset their failed attempts and unlock account.
     * Used in the forgot password feature.
     * @param email the email of the user
     * @param newPassword the new password to set
     * @return true if updated, false if failed
     */
    public boolean updatePassword(String email, String newPassword) {
        String query = "UPDATE users SET password = ? WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, newPassword);
            pstmt.setString(2, email);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getTotalUsers() {
        String query = "SELECT COUNT(*) FROM users";
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
    
    /**
     * Count how many admin users exist in the system.
     * @return number of admin users
     */
    public int countAdmins() {
        String query = "SELECT COUNT(*) FROM users WHERE role = 'admin'";
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
    
    /**
     * Count users registered in the last 30 days.
     * @return number of new users this month
     */
    public int getNewUsersThisMonth() {
        String query = "SELECT COUNT(*) FROM users WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)";
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
    
    /**
     * Count users who made at least one booking in the last 30 days.
     * @return number of active users
     */
    public int getActiveUsers() {
        String query = "SELECT COUNT(DISTINCT user_id) FROM bookings WHERE booking_date >= DATE_SUB(NOW(), INTERVAL 30 DAY)";
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
    
    public List<User> getUsersByFilter(String role, String period, String startDate, String endDate) {
        List<User> users = new ArrayList<>();
        StringBuilder query = new StringBuilder(
            "SELECT u.*, " +
            "(SELECT COUNT(*) FROM bookings b WHERE b.user_id = u.user_id) as booking_count, " +
            "(SELECT COALESCE(SUM(b.total_price), 0) FROM bookings b WHERE b.user_id = u.user_id) as total_spent " +
            "FROM users u WHERE 1=1"
        );
        
        // Add role filter
        if (role != null && !role.isEmpty() && !"all".equals(role)) {
            query.append(" AND u.role = ?");
        }
        
        // Add period filter
        if ("today".equals(period)) {
            query.append(" AND DATE(u.created_at) = CURDATE()");
        } else if ("week".equals(period)) {
            query.append(" AND u.created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)");
        } else if ("month".equals(period)) {
            query.append(" AND u.created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)");
        }
        // Add custom date range
        else if (startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
            query.append(" AND DATE(u.created_at) BETWEEN ? AND ?");
        }
        
        query.append(" ORDER BY u.user_id DESC");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query.toString())) {
            
            int paramIndex = 1;
            
            if (role != null && !role.isEmpty() && !"all".equals(role)) {
                pstmt.setString(paramIndex++, role);
            }
            
            if (startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty() 
                && period == null) {
                pstmt.setString(paramIndex++, startDate);
                pstmt.setString(paramIndex++, endDate);
            }
            
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getString("role"));
                user.setRegistrationDate(rs.getTimestamp("created_at"));
                user.setBookingCount(rs.getInt("booking_count"));
                user.setTotalSpent(rs.getDouble("total_spent"));
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
}
