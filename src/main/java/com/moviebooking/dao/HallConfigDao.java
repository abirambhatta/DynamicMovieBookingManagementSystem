package com.moviebooking.dao;

import com.moviebooking.config.DBConnection;
import com.moviebooking.model.HallConfig;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for managing per-hall seat layout configuration.
 * Reads from and writes to the hall_config table.
 */
public class HallConfigDao {

    /**
     * Create the hall_config table if it does not exist, and seed default data.
     * Called once on startup by the servlet.
     */
    public void createTableIfNeeded() {
        String createSql = "CREATE TABLE IF NOT EXISTS hall_config (" +
                "hall_name VARCHAR(100) PRIMARY KEY," +
                "seats_per_row INT NOT NULL DEFAULT 12," +
                "standard_rows VARCHAR(100) DEFAULT 'A,B,C,D'," +
                "premium_rows VARCHAR(100) DEFAULT 'E'," +
                "recliner_rows VARCHAR(100) DEFAULT ''," +
                "vip_rows VARCHAR(100) DEFAULT 'F'" +
                ")";
        String updateHallsSql = "UPDATE system_settings SET setting_value = ? WHERE setting_key = 'AVAILABLE_HALLS'";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(createSql);

            // Expand seat_type column to TEXT to handle long seat ID lists (e.g. A1, A2, B1, B2 ...)
            try { stmt.execute("ALTER TABLE bookings MODIFY COLUMN seat_type TEXT"); }
            catch (SQLException ignored) {} // already TEXT or no bookings table yet

            // Seed default hall data for each standard hall (Audi 01, 02, 03)
            String[] defaultHalls = {"Audi 01", "Audi 02", "Audi 03"};
            for (String hall : defaultHalls) {
                String insert = "INSERT IGNORE INTO hall_config " +
                        "(hall_name, seats_per_row, standard_rows, premium_rows, recliner_rows, vip_rows) " +
                        "VALUES ('" + hall + "', 12, 'A,B,C,D', 'E', '', 'F')";
                stmt.execute(insert);
            }

            // Fix the system_settings halls to match actual hall names
            try (PreparedStatement pstmt = conn.prepareStatement(updateHallsSql)) {
                pstmt.setString(1, "Audi 01,Audi 02,Audi 03");
                pstmt.executeUpdate();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /** Get all hall configurations. */
    public List<HallConfig> getAllHallConfigs() {
        List<HallConfig> list = new ArrayList<>();
        String sql = "SELECT * FROM hall_config ORDER BY hall_name";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Get configuration for a specific hall. Returns null if not found. */
    public HallConfig getByHallName(String hallName) {
        String sql = "SELECT * FROM hall_config WHERE hall_name = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, hallName);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /** Insert or update a hall configuration (upsert). */
    public boolean save(HallConfig config) {
        String sql = "INSERT INTO hall_config (hall_name, seats_per_row, standard_rows, premium_rows, recliner_rows, vip_rows) " +
                "VALUES (?, ?, ?, ?, ?, ?) " +
                "ON DUPLICATE KEY UPDATE seats_per_row=?, standard_rows=?, premium_rows=?, recliner_rows=?, vip_rows=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, config.getHallName());
            pstmt.setInt(2, config.getSeatsPerRow());
            pstmt.setString(3, config.getStandardRows());
            pstmt.setString(4, config.getPremiumRows());
            pstmt.setString(5, config.getReclinerRows());
            pstmt.setString(6, config.getVipRows());
            // ON DUPLICATE KEY values
            pstmt.setInt(7, config.getSeatsPerRow());
            pstmt.setString(8, config.getStandardRows());
            pstmt.setString(9, config.getPremiumRows());
            pstmt.setString(10, config.getReclinerRows());
            pstmt.setString(11, config.getVipRows());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /** Delete a hall's configuration. Used when admin removes a hall. */
    public boolean delete(String hallName) {
        String sql = "DELETE FROM hall_config WHERE hall_name = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, hallName);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private HallConfig mapRow(ResultSet rs) throws SQLException {
        HallConfig c = new HallConfig();
        c.setHallName(rs.getString("hall_name"));
        c.setSeatsPerRow(rs.getInt("seats_per_row"));
        c.setStandardRows(rs.getString("standard_rows"));
        c.setPremiumRows(rs.getString("premium_rows"));
        c.setReclinerRows(rs.getString("recliner_rows"));
        c.setVipRows(rs.getString("vip_rows"));
        return c;
    }
}
