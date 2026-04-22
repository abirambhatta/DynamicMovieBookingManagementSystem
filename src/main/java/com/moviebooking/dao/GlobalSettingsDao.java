package com.moviebooking.dao;

import com.moviebooking.config.DBConnection;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;

/**
 * Handles fetching dynamic system-wide admin variables like Ticket Prices and Hall availability.
 */
public class GlobalSettingsDao {

    public Map<String, String> getAllSettings() {
        Map<String, String> settings = new HashMap<>();
        String query = "SELECT setting_key, setting_value FROM system_settings";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                settings.put(rs.getString("setting_key"), rs.getString("setting_value"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return settings;
    }

    public String getSetting(String key, String defaultValue) {
        String query = "SELECT setting_value FROM system_settings WHERE setting_key = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, key);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("setting_value");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return defaultValue;
    }

    public boolean updateSetting(String key, String value) {
        // Upsert style query or simple update if we assume seed data exists
        String query = "INSERT INTO system_settings (setting_key, setting_value) VALUES (?, ?) " +
                       "ON DUPLICATE KEY UPDATE setting_value = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, key);
            pstmt.setString(2, value);
            pstmt.setString(3, value);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<String> getAvailableHalls() {
        String hallsStr = getSetting("AVAILABLE_HALLS", "Audi 01,Audi 02,Audi 03");
        List<String> halls = new ArrayList<>();
        for (String h : hallsStr.split(",")) {
            String trimmed = h.trim();
            if (!trimmed.isEmpty()) halls.add(trimmed);
        }
        return halls;
    }
}
