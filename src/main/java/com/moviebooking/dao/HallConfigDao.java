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

    // This flag ensures we only check the database structure once while the app is running.
    private static boolean schemaChecked = false;

    // This function checks if the database tables need to be updated.
    private void checkSchema() {
        if (schemaChecked) return;
        createTableIfNeeded(); // Run the table creation/update logic
        schemaChecked = true;
    }

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
                "vip_rows VARCHAR(100) DEFAULT 'F'," +
                "layout_map TEXT" +
                ")";
        String updateHallsSql = "UPDATE system_settings SET setting_value = ? WHERE setting_key = 'AVAILABLE_HALLS'";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(createSql);

            // We try to update the bookings table to support long seat strings.
            try { stmt.execute("ALTER TABLE bookings MODIFY COLUMN seat_type TEXT"); }
            catch (SQLException ignored) {} 

            // We add the layout_map column to the hall_config table if it is missing.
            try { stmt.execute("ALTER TABLE hall_config ADD COLUMN layout_map TEXT"); }
            catch (SQLException ignored) {} 

            // Seed default hall data for each standard hall (Audi 01, 02, 03)
            String[] defaultHalls = {"Audi 01", "Audi 02", "Audi 03"};
            String defaultLayout = "S S S S S S S S S S S S|S S S S S S S S S S S S|S S S S S S S S S S S S|S S S S S S S S S S S S|P P P P P P P P P P P P|V V V V V V V V V V V V";
            for (String hall : defaultHalls) {
                String insert = "INSERT IGNORE INTO hall_config " +
                        "(hall_name, seats_per_row, standard_rows, premium_rows, recliner_rows, vip_rows, layout_map) " +
                        "VALUES ('" + hall + "', 12, 'A,B,C,D', 'E', '', 'F', '" + defaultLayout + "')";
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
        checkSchema();
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
        checkSchema();
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
        checkSchema();
        String sql = "INSERT INTO hall_config (hall_name, seats_per_row, standard_rows, premium_rows, recliner_rows, vip_rows, layout_map) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?) " +
                "ON DUPLICATE KEY UPDATE seats_per_row=?, standard_rows=?, premium_rows=?, recliner_rows=?, vip_rows=?, layout_map=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, config.getHallName());
            pstmt.setInt(2, config.getSeatsPerRow());
            pstmt.setString(3, config.getStandardRows());
            pstmt.setString(4, config.getPremiumRows());
            pstmt.setString(5, config.getReclinerRows());
            pstmt.setString(6, config.getVipRows());
            pstmt.setString(7, config.getLayoutMap());
            // ON DUPLICATE KEY values
            pstmt.setInt(8, config.getSeatsPerRow());
            pstmt.setString(9, config.getStandardRows());
            pstmt.setString(10, config.getPremiumRows());
            pstmt.setString(11, config.getReclinerRows());
            pstmt.setString(12, config.getVipRows());
            pstmt.setString(13, config.getLayoutMap());
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
        c.setLayoutMap(rs.getString("layout_map"));
        return c;
    }
}
