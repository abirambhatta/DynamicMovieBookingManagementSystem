package com.moviebooking.controllers;

import com.moviebooking.dao.GlobalSettingsDao;
import com.moviebooking.dao.HallConfigDao;
import com.moviebooking.model.HallConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Servlet for admin to manage system-wide settings.
 * GET:  Shows the settings page with current prices, halls, and seat layouts.
 * POST: Handles updating prices, hall list, or per-hall seat configuration.
 */
@WebServlet("/manageSettings")
public class ManageSettingsServlet extends HttpServlet {
    private final GlobalSettingsDao settingsDao = new GlobalSettingsDao();
    private final HallConfigDao hallConfigDao = new HallConfigDao();

    @Override
    public void init() {
        // Auto-create hall_config table and seed defaults on first startup
        hallConfigDao.createTableIfNeeded();
    }

    /**
     * Load all settings and hall configs and forward to the JSP.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Map<String, String> settings = settingsDao.getAllSettings();
        List<HallConfig> hallConfigs = hallConfigDao.getAllHallConfigs();
        request.setAttribute("settings", settings);
        request.setAttribute("hallConfigs", hallConfigs);
        request.getRequestDispatcher("/WEB-INF/pages/manageSettings.jsp").forward(request, response);
    }

    /**
     * Route POST actions: updatePrices, saveHallConfig, deleteHall, addHall.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("updatePrices".equals(action)) {
            // Update the four seat type prices
            settingsDao.updateSetting("PRICE_STANDARD", request.getParameter("PRICE_STANDARD"));
            settingsDao.updateSetting("PRICE_PREMIUM",  request.getParameter("PRICE_PREMIUM"));
            settingsDao.updateSetting("PRICE_RECLINER", request.getParameter("PRICE_RECLINER"));
            settingsDao.updateSetting("PRICE_VIP",      request.getParameter("PRICE_VIP"));
            response.sendRedirect(request.getContextPath() + "/manageSettings?success=Ticket prices updated successfully");

        } else if ("saveHallConfig".equals(action)) {
            // Update an existing hall's seat layout configuration
            String hallName     = request.getParameter("hallName");
            int seatsPerRow     = parseInt(request.getParameter("seatsPerRow"), 12);
            String standardRows = sanitizeRows(request.getParameter("standardRows"));
            String premiumRows  = sanitizeRows(request.getParameter("premiumRows"));
            String reclinerRows = sanitizeRows(request.getParameter("reclinerRows"));
            String vipRows      = sanitizeRows(request.getParameter("vipRows"));

            HallConfig config = new HallConfig(hallName, seatsPerRow, standardRows, premiumRows, reclinerRows, vipRows);
            boolean saved = hallConfigDao.save(config);

            // Rebuild AVAILABLE_HALLS list from all hall configs
            rebuildAvailableHalls();
            String msg = saved ? "Hall configuration saved for " + hallName : "Failed to save hall configuration";
            response.sendRedirect(request.getContextPath() + "/manageSettings?success=" + msg);

        } else if ("addHall".equals(action)) {
            // Add a brand new hall with default configuration
            String newHallName = request.getParameter("newHallName");
            if (newHallName != null && !newHallName.trim().isEmpty()) {
                HallConfig config = new HallConfig(newHallName.trim(), 12, "A,B,C", "D", "", "E");
                hallConfigDao.save(config);
                rebuildAvailableHalls();
                response.sendRedirect(request.getContextPath() + "/manageSettings?success=Hall '" + newHallName.trim() + "' added successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/manageSettings?error=Hall name cannot be empty");
            }

        } else if ("deleteHall".equals(action)) {
            // Remove a hall's configuration
            String hallName = request.getParameter("hallName");
            hallConfigDao.delete(hallName);
            rebuildAvailableHalls();
            response.sendRedirect(request.getContextPath() + "/manageSettings?success=Hall '" + hallName + "' removed");

        } else {
            response.sendRedirect(request.getContextPath() + "/manageSettings");
        }
    }

    /**
     * After any hall change, rebuild the AVAILABLE_HALLS setting from the hall_config table.
     */
    private void rebuildAvailableHalls() {
        List<HallConfig> halls = hallConfigDao.getAllHallConfigs();
        StringBuilder sb = new StringBuilder();
        for (HallConfig h : halls) {
            if (sb.length() > 0) sb.append(",");
            sb.append(h.getHallName());
        }
        settingsDao.updateSetting("AVAILABLE_HALLS", sb.toString());
    }

    /** Safely parse int with a fallback default. */
    private int parseInt(String val, int defaultVal) {
        try { return Integer.parseInt(val); } catch (Exception e) { return defaultVal; }
    }

    /** Uppercase and trim row letters, remove spaces. e.g. "a, b, c" -> "A,B,C" */
    private String sanitizeRows(String input) {
        if (input == null) return "";
        StringBuilder sb = new StringBuilder();
        for (String part : input.split(",")) {
            String trimmed = part.trim().toUpperCase();
            if (!trimmed.isEmpty()) {
                if (sb.length() > 0) sb.append(",");
                sb.append(trimmed);
            }
        }
        return sb.toString();
    }
}
