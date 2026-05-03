package com.moviebooking.dao;

import com.moviebooking.config.DBConnection;
import com.moviebooking.model.Movie;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * This class handles all database operations for movies.
 * It can add, get, update, delete, and search movies.
 * Used by servlets to work with movie data in the database.
 */
public class MovieDao {
    private static boolean schemaChecked = false;

    private void checkSchema() {
        if (schemaChecked) return;
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            try { stmt.executeUpdate("ALTER TABLE movies ADD COLUMN price_standard DOUBLE NULL"); } catch (SQLException ignored) {}
            try { stmt.executeUpdate("ALTER TABLE movies ADD COLUMN price_premium DOUBLE NULL"); } catch (SQLException ignored) {}
            try { stmt.executeUpdate("ALTER TABLE movies ADD COLUMN price_recliner DOUBLE NULL"); } catch (SQLException ignored) {}
            try { stmt.executeUpdate("ALTER TABLE movies ADD COLUMN price_vip DOUBLE NULL"); } catch (SQLException ignored) {}
            try { stmt.executeUpdate("ALTER TABLE movies ADD COLUMN is_active BOOLEAN DEFAULT TRUE"); } catch (SQLException ignored) {}
        } catch (SQLException ignored) {}
        schemaChecked = true;
    }
    
    /**
     * Add a new movie to the database.
     * Also gets the auto-generated movie ID and sets it on the movie object.
     * @param movie the movie object with all details
     * @return true if movie was added, false if it failed
     */
    public boolean addMovie(Movie movie) {
        checkSchema();
        // SQL query to insert all movie details into the movies table
        String query = "INSERT INTO movies (title, genre, director, duration, language, release_date, start_date, end_date, description, poster_image, format, age_rating, trailer_url, cast_list, price_standard, price_premium, price_recliner, price_vip, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             // RETURN_GENERATED_KEYS lets us get the auto-generated movie ID after insert
             PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            // Set each value in the query
            pstmt.setString(1, movie.getTitle());
            pstmt.setString(2, movie.getGenre());
            pstmt.setString(3, movie.getDirector());
            pstmt.setInt(4, movie.getDuration());
            pstmt.setString(5, movie.getLanguage());
            pstmt.setDate(6, movie.getReleaseDate());
            pstmt.setDate(7, movie.getStartDate());
            pstmt.setDate(8, movie.getEndDate());
            pstmt.setString(9, movie.getDescription());
            pstmt.setString(10, movie.getPosterImage());
            pstmt.setString(11, movie.getFormat() != null ? movie.getFormat() : "2D");
            pstmt.setString(12, movie.getAgeRating() != null ? movie.getAgeRating() : "PG");
            pstmt.setString(13, movie.getTrailerUrl());
            pstmt.setString(14, movie.getCastList());
            
            if (movie.getPriceStandard() != null) pstmt.setDouble(15, movie.getPriceStandard()); else pstmt.setNull(15, Types.DOUBLE);
            if (movie.getPricePremium() != null) pstmt.setDouble(16, movie.getPricePremium()); else pstmt.setNull(16, Types.DOUBLE);
            if (movie.getPriceRecliner() != null) pstmt.setDouble(17, movie.getPriceRecliner()); else pstmt.setNull(17, Types.DOUBLE);
            if (movie.getPriceVip() != null) pstmt.setDouble(18, movie.getPriceVip()); else pstmt.setNull(18, Types.DOUBLE);
            pstmt.setBoolean(19, movie.isActive());

            // Run the insert query
            int result = pstmt.executeUpdate();
            if (result > 0) {
                // Get the auto-generated movie ID from database
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    movie.setMovieId(rs.getInt(1));
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get all movies from the database.
     * Sorted by release date (newest first).
     * Used for the browse movies page.
     * @return list of all Movie objects
     */
    public List<Movie> getAllMovies() {
        checkSchema();
        List<Movie> movies = new ArrayList<>();
        String query = "SELECT * FROM movies ORDER BY release_date DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            // Loop through each row and create a Movie object
            while (rs.next()) {
                Movie movie = new Movie();
                movie.setMovieId(rs.getInt("movie_id"));
                movie.setTitle(rs.getString("title"));
                movie.setGenre(rs.getString("genre"));
                movie.setDirector(rs.getString("director"));
                movie.setDuration(rs.getInt("duration"));
                movie.setLanguage(rs.getString("language"));
                movie.setReleaseDate(rs.getDate("release_date"));
                movie.setStartDate(rs.getDate("start_date"));
                movie.setEndDate(rs.getDate("end_date"));
                movie.setDescription(rs.getString("description"));
                movie.setPosterImage(rs.getString("poster_image"));
                movie.setFormat(rs.getString("format"));
                movie.setAgeRating(rs.getString("age_rating"));
                movie.setTrailerUrl(rs.getString("trailer_url"));
                movie.setCastList(rs.getString("cast_list"));
                movie.setPriceStandard(rs.getObject("price_standard") != null ? rs.getDouble("price_standard") : null);
                movie.setPricePremium(rs.getObject("price_premium") != null ? rs.getDouble("price_premium") : null);
                movie.setPriceRecliner(rs.getObject("price_recliner") != null ? rs.getDouble("price_recliner") : null);
                movie.setPriceVip(rs.getObject("price_vip") != null ? rs.getDouble("price_vip") : null);
                movie.setActive(rs.getBoolean("is_active"));
                movies.add(movie);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return movies;
    }

    /**
     * Get only active movies from the database.
     * @return list of active Movie objects
     */
    public List<Movie> getAllActiveMovies() {
        checkSchema();
        List<Movie> movies = new ArrayList<>();
        String query = "SELECT * FROM movies WHERE is_active = 1 ORDER BY release_date DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                Movie movie = new Movie();
                movie.setMovieId(rs.getInt("movie_id"));
                movie.setTitle(rs.getString("title"));
                movie.setGenre(rs.getString("genre"));
                movie.setDirector(rs.getString("director"));
                movie.setDuration(rs.getInt("duration"));
                movie.setLanguage(rs.getString("language"));
                movie.setReleaseDate(rs.getDate("release_date"));
                movie.setStartDate(rs.getDate("start_date"));
                movie.setEndDate(rs.getDate("end_date"));
                movie.setDescription(rs.getString("description"));
                movie.setPosterImage(rs.getString("poster_image"));
                movie.setFormat(rs.getString("format"));
                movie.setAgeRating(rs.getString("age_rating"));
                movie.setTrailerUrl(rs.getString("trailer_url"));
                movie.setCastList(rs.getString("cast_list"));
                movie.setPriceStandard(rs.getObject("price_standard") != null ? rs.getDouble("price_standard") : null);
                movie.setPricePremium(rs.getObject("price_premium") != null ? rs.getDouble("price_premium") : null);
                movie.setPriceRecliner(rs.getObject("price_recliner") != null ? rs.getDouble("price_recliner") : null);
                movie.setPriceVip(rs.getObject("price_vip") != null ? rs.getDouble("price_vip") : null);
                movie.setActive(rs.getBoolean("is_active"));
                movies.add(movie);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return movies;
    }

    /**
     * Get a single movie by its ID.
     * Used for the movie details page.
     * @param movieId the ID of the movie to find
     * @return the Movie object if found, null if not found
     */
    public Movie getMovieById(int movieId) {
        checkSchema();
        String query = "SELECT * FROM movies WHERE movie_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, movieId);
            ResultSet rs = pstmt.executeQuery();
            // If movie is found, create and return the Movie object
            if (rs.next()) {
                Movie movie = new Movie();
                movie.setMovieId(rs.getInt("movie_id"));
                movie.setTitle(rs.getString("title"));
                movie.setGenre(rs.getString("genre"));
                movie.setDirector(rs.getString("director"));
                movie.setDuration(rs.getInt("duration"));
                movie.setLanguage(rs.getString("language"));
                movie.setReleaseDate(rs.getDate("release_date"));
                movie.setStartDate(rs.getDate("start_date"));
                movie.setEndDate(rs.getDate("end_date"));
                movie.setDescription(rs.getString("description"));
                movie.setPosterImage(rs.getString("poster_image"));
                movie.setFormat(rs.getString("format"));
                movie.setAgeRating(rs.getString("age_rating"));
                movie.setTrailerUrl(rs.getString("trailer_url"));
                movie.setCastList(rs.getString("cast_list"));
                movie.setPriceStandard(rs.getObject("price_standard") != null ? rs.getDouble("price_standard") : null);
                movie.setPricePremium(rs.getObject("price_premium") != null ? rs.getDouble("price_premium") : null);
                movie.setPriceRecliner(rs.getObject("price_recliner") != null ? rs.getDouble("price_recliner") : null);
                movie.setPriceVip(rs.getObject("price_vip") != null ? rs.getDouble("price_vip") : null);
                movie.setActive(rs.getBoolean("is_active"));
                return movie;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Update movie details in the database.
     * @param movie the movie object with updated values
     * @return true if updated, false if failed
     */
    public boolean updateMovie(Movie movie) {
        checkSchema();
        // Update all fields for the movie with the given ID
        String query = "UPDATE movies SET title = ?, genre = ?, director = ?, duration = ?, language = ?, release_date = ?, start_date = ?, end_date = ?, description = ?, poster_image = ?, format = ?, age_rating = ?, trailer_url = ?, cast_list = ?, price_standard = ?, price_premium = ?, price_recliner = ?, price_vip = ?, is_active = ? WHERE movie_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, movie.getTitle());
            pstmt.setString(2, movie.getGenre());
            pstmt.setString(3, movie.getDirector());
            pstmt.setInt(4, movie.getDuration());
            pstmt.setString(5, movie.getLanguage());
            pstmt.setDate(6, movie.getReleaseDate());
            pstmt.setDate(7, movie.getStartDate());
            pstmt.setDate(8, movie.getEndDate());
            pstmt.setString(9, movie.getDescription());
            pstmt.setString(10, movie.getPosterImage());
            pstmt.setString(11, movie.getFormat() != null ? movie.getFormat() : "2D");
            pstmt.setString(12, movie.getAgeRating() != null ? movie.getAgeRating() : "PG");
            pstmt.setString(13, movie.getTrailerUrl());
            pstmt.setString(14, movie.getCastList());
            
            if (movie.getPriceStandard() != null) pstmt.setDouble(15, movie.getPriceStandard()); else pstmt.setNull(15, Types.DOUBLE);
            if (movie.getPricePremium() != null) pstmt.setDouble(16, movie.getPricePremium()); else pstmt.setNull(16, Types.DOUBLE);
            if (movie.getPriceRecliner() != null) pstmt.setDouble(17, movie.getPriceRecliner()); else pstmt.setNull(17, Types.DOUBLE);
            if (movie.getPriceVip() != null) pstmt.setDouble(18, movie.getPriceVip()); else pstmt.setNull(18, Types.DOUBLE);
            pstmt.setBoolean(19, movie.isActive());
            pstmt.setInt(20, movie.getMovieId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Soft delete a movie by setting is_active to false.
     * Keeps the movie in database for historical records (bookings/revenue).
     * @param movieId the ID of the movie to deactivate
     * @return true if deactivated, false if failed
     */
    public boolean deleteMovie(int movieId) {
        String query = "UPDATE movies SET is_active = 0 WHERE movie_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, movieId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Restore a soft-deleted movie.
     * @param movieId the ID of the movie to reactivate
     * @return true if restored, false if failed
     */
    public boolean restoreMovie(int movieId) {
        String query = "UPDATE movies SET is_active = 1 WHERE movie_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, movieId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Search movies by title, genre, or director.
     * Uses LIKE query so partial matches also work.
     * @param keyword the search word to look for
     * @return list of movies that match the search
     */
    public List<Movie> searchMovies(String keyword) {
        checkSchema();
        List<Movie> movies = new ArrayList<>();
        // Only search in active movies for users
        String query = "SELECT * FROM movies WHERE is_active = 1 AND (title LIKE ? OR genre LIKE ? OR director LIKE ?) ORDER BY release_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            // Add % before and after keyword so it matches anywhere in the text
            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Movie movie = new Movie();
                movie.setMovieId(rs.getInt("movie_id"));
                movie.setTitle(rs.getString("title"));
                movie.setGenre(rs.getString("genre"));
                movie.setDirector(rs.getString("director"));
                movie.setDuration(rs.getInt("duration"));
                movie.setLanguage(rs.getString("language"));
                movie.setReleaseDate(rs.getDate("release_date"));
                movie.setDescription(rs.getString("description"));
                movie.setPosterImage(rs.getString("poster_image"));
                movie.setFormat(rs.getString("format"));
                movie.setAgeRating(rs.getString("age_rating"));
                movie.setTrailerUrl(rs.getString("trailer_url"));
                movie.setCastList(rs.getString("cast_list"));
                movie.setPriceStandard(rs.getObject("price_standard") != null ? rs.getDouble("price_standard") : null);
                movie.setPricePremium(rs.getObject("price_premium") != null ? rs.getDouble("price_premium") : null);
                movie.setPriceRecliner(rs.getObject("price_recliner") != null ? rs.getDouble("price_recliner") : null);
                movie.setPriceVip(rs.getObject("price_vip") != null ? rs.getDouble("price_vip") : null);
                movies.add(movie);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return movies;
    }

    /**
     * Get the most recent movies, limited by a number.
     * Used on the home page to show latest movies.
     * @param limit how many movies to return
     * @return list of recent movies
     */
    public List<Movie> getRecentMovies(int limit) {
        checkSchema();
        List<Movie> movies = new ArrayList<>();
        // Get only active, currently showing movies sorted by newest release date, limited to the given number
        String query = "SELECT * FROM movies WHERE is_active = 1 AND CURDATE() BETWEEN start_date AND end_date ORDER BY release_date DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Movie movie = new Movie();
                movie.setMovieId(rs.getInt("movie_id"));
                movie.setTitle(rs.getString("title"));
                movie.setGenre(rs.getString("genre"));
                movie.setDirector(rs.getString("director"));
                movie.setDuration(rs.getInt("duration"));
                movie.setLanguage(rs.getString("language"));
                movie.setReleaseDate(rs.getDate("release_date"));
                movie.setDescription(rs.getString("description"));
                movie.setPosterImage(rs.getString("poster_image"));
                movie.setFormat(rs.getString("format"));
                movie.setAgeRating(rs.getString("age_rating"));
                movie.setTrailerUrl(rs.getString("trailer_url"));
                movie.setCastList(rs.getString("cast_list"));
                movie.setPriceStandard(rs.getObject("price_standard") != null ? rs.getDouble("price_standard") : null);
                movie.setPricePremium(rs.getObject("price_premium") != null ? rs.getDouble("price_premium") : null);
                movie.setPriceRecliner(rs.getObject("price_recliner") != null ? rs.getDouble("price_recliner") : null);
                movie.setPriceVip(rs.getObject("price_vip") != null ? rs.getDouble("price_vip") : null);
                movies.add(movie);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return movies;
    }

    public int getTotalMovies() {
        // We only count active movies for general dashboard stats
        String query = "SELECT COUNT(*) FROM movies WHERE is_active = 1";
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
    
    public int getNowShowingMovies() {
        String query = "SELECT COUNT(*) FROM movies WHERE is_active = 1 AND CURDATE() BETWEEN start_date AND end_date";
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
    
    public int getUpcomingMovies() {
        String query = "SELECT COUNT(*) FROM movies WHERE is_active = 1 AND start_date > CURDATE()";
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
    
    public int getTotalShowTimes() {
        String query = "SELECT COUNT(*) FROM show_times";
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
    
    public List<Movie> getMoviesByFilter(String status, String genre, String language) {
        checkSchema();
        List<Movie> movies = new ArrayList<>();
        // For admin management, we show all movies by default but add a "hidden" status filter
        StringBuilder query = new StringBuilder("SELECT * FROM movies WHERE 1=1");
        
        // Add status filter (now showing, upcoming, ended, hidden)
        if ("showing".equals(status)) {
            query.append(" AND is_active = 1 AND CURDATE() BETWEEN start_date AND end_date");
        } else if ("upcoming".equals(status)) {
            query.append(" AND is_active = 1 AND start_date > CURDATE()");
        } else if ("ended".equals(status)) {
            query.append(" AND is_active = 1 AND end_date < CURDATE()");
        } else if ("hidden".equals(status)) {
            query.append(" AND is_active = 0");
        } else if ("active".equals(status)) {
            query.append(" AND is_active = 1");
        }
        
        // Add genre filter
        if (genre != null && !genre.isEmpty() && !"all".equals(genre)) {
            query.append(" AND genre = ?");
        }
        
        // Add language filter
        if (language != null && !language.isEmpty() && !"all".equals(language)) {
            query.append(" AND language = ?");
        }
        
        query.append(" ORDER BY release_date DESC");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query.toString())) {
            
            int paramIndex = 1;
            
            if (genre != null && !genre.isEmpty() && !"all".equals(genre)) {
                pstmt.setString(paramIndex++, genre);
            }
            
            if (language != null && !language.isEmpty() && !"all".equals(language)) {
                pstmt.setString(paramIndex, language);
            }
            
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Movie movie = new Movie();
                movie.setMovieId(rs.getInt("movie_id"));
                movie.setTitle(rs.getString("title"));
                movie.setGenre(rs.getString("genre"));
                movie.setDirector(rs.getString("director"));
                movie.setDuration(rs.getInt("duration"));
                movie.setLanguage(rs.getString("language"));
                movie.setReleaseDate(rs.getDate("release_date"));
                movie.setStartDate(rs.getDate("start_date"));
                movie.setEndDate(rs.getDate("end_date"));
                movie.setDescription(rs.getString("description"));
                movie.setPosterImage(rs.getString("poster_image"));
                movie.setFormat(rs.getString("format"));
                movie.setAgeRating(rs.getString("age_rating"));
                movie.setTrailerUrl(rs.getString("trailer_url"));
                movie.setCastList(rs.getString("cast_list"));
                movie.setPriceStandard(rs.getObject("price_standard") != null ? rs.getDouble("price_standard") : null);
                movie.setPricePremium(rs.getObject("price_premium") != null ? rs.getDouble("price_premium") : null);
                movie.setPriceRecliner(rs.getObject("price_recliner") != null ? rs.getDouble("price_recliner") : null);
                movie.setPriceVip(rs.getObject("price_vip") != null ? rs.getDouble("price_vip") : null);
                movies.add(movie);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return movies;
    }
    
    public List<String> getAllGenres() {
        List<String> genres = new ArrayList<>();
        String query = "SELECT DISTINCT genre FROM movies ORDER BY genre";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                genres.add(rs.getString("genre"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return genres;
    }
    
    public List<String> getAllLanguages() {
        List<String> languages = new ArrayList<>();
        String query = "SELECT DISTINCT language FROM movies ORDER BY language";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                languages.add(rs.getString("language"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return languages;
    }
}

