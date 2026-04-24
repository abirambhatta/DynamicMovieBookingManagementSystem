package com.moviebooking.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Service to interact with The Movie Database (TMDB) API v3.
 * Reads the API key from the context-param "TMDB_API_KEY" set in web.xml.
 */
public class TmdbService {

    private static final String BASE_URL     = "https://api.themoviedb.org/3";
    private static final String IMAGE_BASE   = "https://image.tmdb.org/t/p/w500";
    private final String apiKey;

    public TmdbService(String apiKey) {
        this.apiKey = apiKey;
    }

    /**
     * Search for movies by title on TMDB.
     * Returns a list of result maps, each with keys:
     *   tmdbId, title, overview, posterUrl, releaseDate, rating, language
     */
    public List<Map<String, String>> searchMovies(String query) {
        List<Map<String, String>> results = new ArrayList<>();
        try {
            String encoded = URLEncoder.encode(query, "UTF-8");
            String urlStr  = BASE_URL + "/search/movie?api_key=" + apiKey
                           + "&query=" + encoded + "&language=en-US&page=1";
            String json = fetchJson(urlStr);
            if (json == null) return results;

            // Simple hand-rolled JSON extraction (no external libraries needed)
            String[] items = json.split("\\{\"adult\"");
            for (int i = 1; i < items.length; i++) {
                String item = "{\"adult\"" + items[i];
                Map<String, String> m = new LinkedHashMap<>();
                m.put("tmdbId",      extractJsonString(item, "id", true));
                m.put("title",       extractJsonString(item, "title", false));
                m.put("overview",    extractJsonString(item, "overview", false));
                m.put("releaseDate", extractJsonString(item, "release_date", false));
                m.put("rating",      extractJsonString(item, "vote_average", true));
                m.put("language",    extractJsonString(item, "original_language", false));
                String poster = extractJsonString(item, "poster_path", false);
                m.put("posterUrl",   (poster != null && !poster.equals("null"))
                                     ? IMAGE_BASE + poster : "");
                if (m.get("tmdbId") != null && !m.get("tmdbId").isEmpty()) {
                    results.add(m);
                }
            }
        } catch (Exception e) {
            System.err.println("[TmdbService] searchMovies error: " + e.getMessage());
        }
        return results;
    }

    /**
     * Get full movie details by TMDB ID.
     * Returns a map with keys:
     *   tmdbId, title, overview, posterUrl, releaseDate, rating, language,
     *   duration (runtime in minutes), genre, director
     */
    public Map<String, String> getMovieDetails(String tmdbId) {
        Map<String, String> m = new LinkedHashMap<>();
        try {
            // Get base movie info (includes runtime, genres)
            String urlStr = BASE_URL + "/movie/" + tmdbId
                          + "?api_key=" + apiKey + "&language=en-US";
            String json = fetchJson(urlStr);
            if (json == null) return m;

            m.put("tmdbId",      tmdbId);
            m.put("title",       extractJsonString(json, "title", false));
            m.put("overview",    extractJsonString(json, "overview", false));
            m.put("releaseDate", extractJsonString(json, "release_date", false));
            m.put("rating",      extractJsonString(json, "vote_average", true));
            m.put("language",    extractJsonString(json, "original_language", false));
            m.put("duration",    extractJsonString(json, "runtime", true));

            // Extract first genre name
            String genresBlock = extractBlock(json, "genres");
            String genreName   = extractJsonString(genresBlock, "name", false);
            m.put("genre", genreName != null ? genreName : "");

            String poster = extractJsonString(json, "poster_path", false);
            m.put("posterUrl", (poster != null && !poster.equals("null"))
                               ? IMAGE_BASE + poster : "");

            // Get director and top 5 cast from credits endpoint
            String creditsUrl = BASE_URL + "/movie/" + tmdbId
                              + "/credits?api_key=" + apiKey;
            String creditsJson = fetchJson(creditsUrl);
            if (creditsJson != null) {
                // Find crew member with job "Director"
                String director = extractDirector(creditsJson);
                m.put("director", director != null ? director : "");
                
                // Extract top 5 cast members
                String castStr = extractTopCast(creditsJson, 5);
                m.put("cast", castStr);
            }

            // Get YouTube trailer from /videos endpoint
            String trailerUrl = fetchTrailerUrl(tmdbId);
            m.put("trailerUrl", trailerUrl != null ? trailerUrl : "");

        } catch (Exception e) {
            System.err.println("[TmdbService] getMovieDetails error: " + e.getMessage());
        }
        return m;
    }

    // -------------------------------------------------------
    // HTTP helper
    // -------------------------------------------------------
    private String fetchJson(String urlStr) {
        try {
            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/json");
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(5000);

            if (conn.getResponseCode() != 200) {
                System.err.println("[TmdbService] HTTP " + conn.getResponseCode() + " for " + urlStr);
                return null;
            }

            BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) sb.append(line);
            reader.close();
            return sb.toString();
        } catch (Exception e) {
            System.err.println("[TmdbService] fetchJson error: " + e.getMessage());
            return null;
        }
    }

    // -------------------------------------------------------
    // Minimal JSON helpers (no external lib needed)
    // -------------------------------------------------------

    /** Extract a string or numeric value by key from a flat JSON snippet. */
    private String extractJsonString(String json, String key, boolean isNumeric) {
        if (json == null) return "";
        try {
            String searchKey = "\"" + key + "\":";
            int idx = json.indexOf(searchKey);
            if (idx < 0) return "";
            int start = idx + searchKey.length();
            if (isNumeric) {
                int end = start;
                while (end < json.length() && (Character.isDigit(json.charAt(end))
                       || json.charAt(end) == '.' || json.charAt(end) == '-')) end++;
                return json.substring(start, end).trim();
            } else {
                if (json.charAt(start) == '"') {
                    start++;
                    int end = start;
                    while (end < json.length() && json.charAt(end) != '"') {
                        if (json.charAt(end) == '\\') end++; // skip escape
                        end++;
                    }
                    return json.substring(start, end)
                               .replace("\\u0026", "&")
                               .replace("\\u2019", "'")
                               .replace("\\\"", "\"");
                } else if (json.startsWith("null", start)) {
                    return "null";
                }
            }
        } catch (Exception ignored) {}
        return "";
    }

    /** Extract the content of the first array/block for a given key. */
    private String extractBlock(String json, String key) {
        if (json == null) return "";
        try {
            String searchKey = "\"" + key + "\":[";
            int idx = json.indexOf(searchKey);
            if (idx < 0) return "";
            int start = idx + searchKey.length() - 1; // include '['
            int depth = 0, i = start;
            while (i < json.length()) {
                char c = json.charAt(i);
                if (c == '[' || c == '{') depth++;
                else if (c == ']' || c == '}') { depth--; if (depth == 0) break; }
                i++;
            }
            return json.substring(start, i + 1);
        } catch (Exception ignored) {}
        return "";
    }

    /** Find the first crew member with job == "Director". */
    private String extractDirector(String creditsJson) {
        try {
            String crewBlock = extractBlock(creditsJson, "crew");
            String[] members = crewBlock.split("\\{\"");
            for (String member : members) {
                if (member.contains("\"Director\"")) {
                    return extractJsonString("{\"" + member, "name", false);
                }
            }
        } catch (Exception ignored) {}
        return "";
    }

    /** Extract top N cast names from credits JSON. Returns comma-separated string. */
    private String extractTopCast(String creditsJson, int maxCount) {
        try {
            String castBlock = extractBlock(creditsJson, "cast");
            // Split on each cast member object
            String[] members = castBlock.split("\\{\"adult\"");
            StringBuilder sb = new StringBuilder();
            int count = 0;
            for (int i = 1; i < members.length && count < maxCount; i++) {
                String name = extractJsonString("{\"adult\"" + members[i], "name", false);
                if (name != null && !name.isEmpty() && !name.equals("null")) {
                    if (count > 0) sb.append(", ");
                    sb.append(name);
                    count++;
                }
            }
            return sb.toString();
        } catch (Exception ignored) {}
        return "";
    }

    /** Fetch YouTube trailer embed URL from TMDB /videos endpoint. */
    private String fetchTrailerUrl(String tmdbId) {
        try {
            String urlStr = BASE_URL + "/movie/" + tmdbId + "/videos?api_key=" + apiKey + "&language=en-US";
            String json = fetchJson(urlStr);
            if (json == null) return null;
            // Find a YouTube Trailer
            String[] items = json.split("\\{\"id\"");
            for (int i = 1; i < items.length; i++) {
                String item = "{\"id\"" + items[i];
                String type = extractJsonString(item, "type", false);
                String site = extractJsonString(item, "site", false);
                if ("Trailer".equalsIgnoreCase(type) && "YouTube".equalsIgnoreCase(site)) {
                    String key = extractJsonString(item, "key", false);
                    if (key != null && !key.isEmpty()) {
                        return "https://www.youtube.com/embed/" + key + "?autoplay=1";
                    }
                }
            }
            // Fallback: any YouTube video (Teaser etc.)
            for (int i = 1; i < items.length; i++) {
                String item = "{\"id\"" + items[i];
                String site = extractJsonString(item, "site", false);
                if ("YouTube".equalsIgnoreCase(site)) {
                    String key = extractJsonString(item, "key", false);
                    if (key != null && !key.isEmpty()) {
                        return "https://www.youtube.com/embed/" + key + "?autoplay=1";
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("[TmdbService] fetchTrailerUrl error: " + e.getMessage());
        }
        return null;
    }
}
