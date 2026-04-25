package com.moviebooking.controllers;

import com.moviebooking.service.TmdbService;
import com.moviebooking.util.EnvLoader;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

/**
 * AJAX endpoint for TMDB movie search and detail lookups.
 *
 * GET /tmdbSearch?action=search&q=Inception
 *   -> returns JSON array of search results
 *
 * GET /tmdbSearch?action=details&tmdbId=27205
 *   -> returns JSON object with full movie details
 */
@WebServlet("/tmdbSearch")
public class TmdbSearchServlet extends HttpServlet {

    private TmdbService tmdbService;

    @Override
    public void init() throws ServletException {
        // Read API key from environment variables
        String apiKey = EnvLoader.get("TMDB_API_KEY");
        if (apiKey == null || apiKey.trim().isEmpty()) {
            System.err.println("[TmdbSearchServlet] WARNING: TMDB_API_KEY not set in .env file!");
        }
        tmdbService = new TmdbService(apiKey);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String action = request.getParameter("action");

        if ("details".equals(action)) {
            // ---- GET FULL DETAILS FOR ONE MOVIE ----
            String tmdbId = request.getParameter("tmdbId");
            if (tmdbId == null || tmdbId.trim().isEmpty()) {
                out.print("{\"error\":\"Missing tmdbId\"}");
                return;
            }
            Map<String, String> details = tmdbService.getMovieDetails(tmdbId.trim());
            out.print(mapToJson(details));

        } else if ("youtube".equals(action)) {
            // ---- SEARCH YOUTUBE FOR TRAILERS ----
            String title = request.getParameter("title");
            if (title == null || title.trim().isEmpty()) {
                out.print("[]");
                return;
            }
            List<Map<String, String>> results = tmdbService.searchYoutube(title.trim());
            StringBuilder sb = new StringBuilder("[");
            for (int i = 0; i < results.size(); i++) {
                sb.append(mapToJson(results.get(i)));
                if (i < results.size() - 1) sb.append(",");
            }
            sb.append("]");
            out.print(sb.toString());

        } else {
            // ---- SEARCH BY TITLE (default action) ----
            String query = request.getParameter("q");
            if (query == null || query.trim().isEmpty()) {
                out.print("[]");
                return;
            }
            List<Map<String, String>> results = tmdbService.searchMovies(query.trim());
            StringBuilder sb = new StringBuilder("[");
            for (int i = 0; i < results.size(); i++) {
                sb.append(mapToJson(results.get(i)));
                if (i < results.size() - 1) sb.append(",");
            }
            sb.append("]");
            out.print(sb.toString());
        }
    }

    /** Convert a simple String->String map to a JSON object string. */
    private String mapToJson(Map<String, String> m) {
        StringBuilder sb = new StringBuilder("{");
        boolean first = true;
        for (Map.Entry<String, String> e : m.entrySet()) {
            if (!first) sb.append(",");
            sb.append("\"").append(e.getKey()).append("\":\"")
              .append(escapeJson(e.getValue()))
              .append("\"");
            first = false;
        }
        sb.append("}");
        return sb.toString();
    }

    private String escapeJson(String s) {
        return s == null ? "" : s.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "");
    }
}
