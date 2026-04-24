package com.moviebooking.controllers;

import com.moviebooking.dao.MovieDao;
import com.moviebooking.dao.ShowTimeDao;
import com.moviebooking.dao.GlobalSettingsDao;
import com.moviebooking.dao.HallConfigDao;
import com.moviebooking.model.Movie;
import com.moviebooking.model.ShowTime;
import com.moviebooking.model.HallConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Date;
import java.sql.Time;
import java.util.List;

/**
 * Servlet for admin to manage movies (add, edit, delete).
 * GET: Shows all movies, handles edit and delete actions.
 * POST: Handles add new movie and update existing movie.
 * Uses MultipartConfig to allow file upload for movie poster images.
 */
@WebServlet("/manageMovies")
@MultipartConfig(maxFileSize = 10485760, maxRequestSize = 20971520) // Max 10MB file, 20MB total request
public class ManageMoviesServlet extends HttpServlet {
    private final MovieDao movieDao = new MovieDao();
    private final ShowTimeDao showTimeDao = new ShowTimeDao();
    private final GlobalSettingsDao settingsDao = new GlobalSettingsDao();
    private final HallConfigDao hallConfigDao = new HallConfigDao();

    /**
     * Show all movies page, or handle edit/delete actions.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");

            if ("delete".equals(action)) {
                handleDelete(request, response);
                return;
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Movie movie = movieDao.getMovieById(id);
                request.setAttribute("editMovie", movie);
                
                List<ShowTime> movieShowTimes = showTimeDao.getShowTimesByMovie(id);
                System.out.println("Show times for movie " + id + ": " + (movieShowTimes != null ? movieShowTimes.size() : "null"));
                request.setAttribute("movieShowTimes", movieShowTimes);
            }

            // Get statistics
            int totalMovies = movieDao.getTotalMovies();
            int nowShowing = movieDao.getNowShowingMovies();
            int upcoming = movieDao.getUpcomingMovies();
            int totalShowTimes = movieDao.getTotalShowTimes();
            
            request.setAttribute("totalMovies", totalMovies);
            request.setAttribute("nowShowing", nowShowing);
            request.setAttribute("upcoming", upcoming);
            request.setAttribute("totalShowTimes", totalShowTimes);

            // Get filter parameters
            String search = request.getParameter("search");
            String status = request.getParameter("status");
            String genre = request.getParameter("genre");
            String language = request.getParameter("language");
            
            List<Movie> movies;
            
            // Apply search if provided
            if (search != null && !search.trim().isEmpty()) {
                movies = movieDao.searchMovies(search.trim());
            }
            // Apply filters if provided
            else if ((status != null && !status.isEmpty()) || (genre != null && !genre.isEmpty()) 
                    || (language != null && !language.isEmpty())) {
                movies = movieDao.getMoviesByFilter(status, genre, language);
            }
            // Otherwise get all movies
            else {
                movies = movieDao.getAllMovies();
            }
            
            // Get distinct genres and languages for filter dropdowns
            List<String> genres = movieDao.getAllGenres();
            List<String> languages = movieDao.getAllLanguages();
            
            request.setAttribute("genres", genres);
            request.setAttribute("languages", languages);
            System.out.println("Movies fetched: " + (movies != null ? movies.size() : "null"));
            request.setAttribute("movies", movies);
            
            List<ShowTime> allShowTimes = showTimeDao.getAllShowTimes();
            System.out.println("Show times fetched: " + (allShowTimes != null ? allShowTimes.size() : "null"));
            request.setAttribute("allShowTimes", allShowTimes);
            
            List<HallConfig> hallConfigs = hallConfigDao.getAllHallConfigs();
            java.util.List<String> hallNames = new java.util.ArrayList<>();
            for (HallConfig hc : hallConfigs) { hallNames.add(hc.getHallName()); }
            request.setAttribute("availableHalls", hallNames);
            
            request.getRequestDispatcher("/WEB-INF/pages/manageMovies.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }

    /**
     * Handle POST requests - either add a new movie or update an existing one.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            handleAdd(request, response);
        } else if ("update".equals(action)) {
            handleUpdate(request, response);
        }
    }

    /**
     * Handle adding a new movie.
     * Gets all form values, uploads poster image, saves movie to database.
     * Also saves show time schedule if provided.
     */
    private void handleAdd(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Get all movie details from the form
            String title = request.getParameter("title");
            String genre = request.getParameter("genre");
            // If genre is "custom", use the custom genre text instead
            if ("custom".equals(genre)) {
                genre = request.getParameter("customGenre");
            }
            String director = request.getParameter("director");
            int duration = Integer.parseInt(request.getParameter("duration"));
            String language = request.getParameter("language");
            Date releaseDate = Date.valueOf(request.getParameter("releaseDate"));
            Date startDate = Date.valueOf(request.getParameter("startDate"));
            Date endDate = Date.valueOf(request.getParameter("endDate"));
            String description = request.getParameter("description");
            String format = request.getParameter("format");
            String ageRating = request.getParameter("ageRating");
            String trailerUrl = request.getParameter("trailerUrl");
            String castList = request.getParameter("castList");
            
            // Handle poster image file upload or TMDB poster URL
            Part filePart = request.getPart("posterImage");
            String tmdbPosterUrl = request.getParameter("tmdbPosterUrl");
            String fileName = null;
            String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            if (filePart != null && filePart.getSize() > 0) {
                // User uploaded a custom poster — use it (overrides TMDB)
                fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                filePart.write(uploadPath + File.separator + fileName);
            } else if (tmdbPosterUrl != null && !tmdbPosterUrl.trim().isEmpty()) {
                // Download poster from TMDB and save locally
                try {
                    String ext = tmdbPosterUrl.contains(".") ? tmdbPosterUrl.substring(tmdbPosterUrl.lastIndexOf('.')) : ".jpg";
                    fileName = "tmdb_" + System.currentTimeMillis() + ext;
                    URL imgUrl = new URL(tmdbPosterUrl);
                    try (InputStream in = imgUrl.openStream();
                         OutputStream out = new java.io.FileOutputStream(uploadPath + File.separator + fileName)) {
                        byte[] buf = new byte[4096]; int n;
                        while ((n = in.read(buf)) != -1) out.write(buf, 0, n);
                    }
                } catch (Exception ex) {
                    System.err.println("[ManageMoviesServlet] Failed to download TMDB poster: " + ex.getMessage());
                    fileName = "default.jpg";
                }
            } else {
                fileName = "default.jpg";
            }

            // Create movie object and save to database
            Movie movie = new Movie(title, genre, director, duration, language, releaseDate, startDate, endDate, description, fileName, 0.0, format, ageRating);
            movie.setTrailerUrl(trailerUrl);
            movie.setCastList(castList);
            boolean isAdded = movieDao.addMovie(movie);

            if (isAdded) {
                // If movie was added, also add show time schedule if provided
                String scheduleData = request.getParameter("scheduleData");
                if (scheduleData != null && !scheduleData.isEmpty()) {
                    // Schedule data format: "date|hall|time,date|hall|time,..."
                    String[] entries = scheduleData.split(",");
                    for (String entry : entries) {
                        String[] parts = entry.split("\\|");
                        if (parts.length == 3) {
                            // Parse each show time entry
                            Date showDate = Date.valueOf(parts[0].trim());
                            String hall = parts[1].trim();
                            Time showTime = Time.valueOf(parts[2].trim() + ":00");
                            ShowTime st = new ShowTime(movie.getMovieId(), showDate, showTime);
                            st.setHall(hall);
                            showTimeDao.addShowTime(st);
                        }
                    }
                }
                response.sendRedirect(request.getContextPath() + "/manageMovies?success=Movie added successfully");
            } else {
                request.setAttribute("error", "Failed to add movie");
                doGet(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Invalid input: " + e.getMessage());
            doGet(request, response);
        }
    }

    /**
     * Handle updating an existing movie.
     * Gets updated values from the form and saves to database.
     */
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int movieId = Integer.parseInt(request.getParameter("movieId"));
            String title = request.getParameter("title");
            String genre = request.getParameter("genre");
            String director = request.getParameter("director");
            int duration = Integer.parseInt(request.getParameter("duration"));
            String language = request.getParameter("language");
            String description = request.getParameter("description");
            String format = request.getParameter("format");
            String ageRating = request.getParameter("ageRating");
            Date releaseDate = Date.valueOf(request.getParameter("releaseDate"));
            Date startDate = Date.valueOf(request.getParameter("startDate"));
            Date endDate = Date.valueOf(request.getParameter("endDate"));
            String trailerUrl = request.getParameter("trailerUrl");
            String castList = request.getParameter("castList");

            Movie existingMovie = movieDao.getMovieById(movieId);
            String posterImage = existingMovie.getPosterImage();
            
            // Handle poster image upload if provided
            Part filePart = request.getPart("posterImage");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                filePart.write(uploadPath + File.separator + fileName);
                posterImage = fileName;
            }
            
            Movie movie = new Movie(title, genre, director, duration, language, 
                    releaseDate, startDate, 
                    endDate, description, posterImage, 
                    existingMovie.getRating(), format, ageRating);
            movie.setMovieId(movieId);
            movie.setTrailerUrl(trailerUrl);
            movie.setCastList(castList);
            boolean isUpdated = movieDao.updateMovie(movie);

            if (isUpdated) {
                // UPDATE SHOWTIMES
                String scheduleData = request.getParameter("scheduleData");
                if (scheduleData != null) { 
                    // Delete all old show times for this movie to cleanly replace
                    showTimeDao.deleteShowTimesByMovie(movieId);
                    
                    if (!scheduleData.isEmpty()) {
                        String[] entries = scheduleData.split(",");
                        for (String entry : entries) {
                            String[] parts = entry.split("\\|");
                            if (parts.length == 3) {
                                Date showDate = Date.valueOf(parts[0].trim());
                                String hall = parts[1].trim();
                                Time showTime = Time.valueOf(parts[2].trim() + ":00");
                                ShowTime st = new ShowTime(movieId, showDate, showTime);
                                st.setHall(hall);
                                showTimeDao.addShowTime(st);
                            }
                        }
                    }
                }
                response.sendRedirect(request.getContextPath() + "/manageMovies?success=Movie updated successfully");
            } else {
                request.setAttribute("error", "Failed to update movie");
                doGet(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Invalid input: " + e.getMessage());
            doGet(request, response);
        }
    }

    /**
     * Handle deleting a movie by its ID.
     * Gets the movie ID from the URL parameter.
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Get movie ID from URL and delete it
            int movieId = Integer.parseInt(request.getParameter("id"));
            boolean isDeleted = movieDao.deleteMovie(movieId);

            if (isDeleted) {
                response.sendRedirect(request.getContextPath() + "/manageMovies?success=Movie deleted successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/manageMovies?error=Failed to delete movie");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/manageMovies?error=Invalid movie ID");
        }
    }
}
