package com.moviebooking.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import com.moviebooking.util.EnvLoader;

/**
 * This class connects the app to MySQL database.
 * Has details for database URL, username, password.
 */
public class DBConnection {
    // Database connection URL - loaded from environment variables
    private static final String URL = EnvLoader.get("DB_URL") != null ? 
        EnvLoader.get("DB_URL") : "jdbc:mysql://localhost:3306/movie_booking_db?useSSL=false&serverTimezone=UTC";
    // Database username - loaded from environment variables
    private static final String USER = EnvLoader.get("DB_USER") != null ? 
        EnvLoader.get("DB_USER") : "root";
    // Database password - loaded from environment variables
    private static final String PASSWORD = EnvLoader.get("DB_PASSWORD") != null ? 
        EnvLoader.get("DB_PASSWORD") : "";

    // This block runs once when the class is first loaded
    // It loads the MySQL driver so we can connect to the database
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    /**
     * Get connection to database.
     * Use this in DAOs to query database.
     * @return a Connection object to the MySQL database
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
