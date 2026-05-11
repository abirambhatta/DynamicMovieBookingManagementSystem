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
            } else if ("restore".equals(action)) {
                handleRestore(request, response);
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
            
            // --- POSTER IMAGE HANDLING ---
            // We check if the user uploaded a file OR if they used the TMDB auto-fill poster URL.
            Part filePart = request.getPart("posterImage");
            String tmdbPosterUrl = request.getParameter("tmdbPosterUrl");
            String fileName = null;
            
            // Where we will save the images on the server
            String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs(); // Create folder if it doesn't exist

            if (filePart != null && filePart.getSize() > 0) {
                // CASE 1: User uploaded a file from their computer
                fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String fullPath = uploadPath + File.separator + fileName;
                filePart.write(fullPath);
                
                // --- SOLUTION 2: Save to source folder too ---
                saveToSource(fullPath, fileName);
                
            } else if (tmdbPosterUrl != null && !tmdbPosterUrl.trim().isEmpty()) {
                // CASE 2: No file uploaded, but we have a TMDB URL from auto-fill
                try {
                    // Create a unique name for the downloaded image
                    String ext = tmdbPosterUrl.contains(".") ? tmdbPosterUrl.substring(tmdbPosterUrl.lastIndexOf('.')) : ".jpg";
                    fileName = "tmdb_" + System.currentTimeMillis() + ext;
                    String fullPath = uploadPath + File.separator + fileName;
                    
                    URL imgUrl = new URL(tmdbPosterUrl);
                    // Download the image and save it to our images folder
                    try (InputStream in = imgUrl.openStream();
                         OutputStream out = new java.io.FileOutputStream(fullPath)) {
                        byte[] buf = new byte[4096]; int n;
                        while ((n = in.read(buf)) != -1) out.write(buf, 0, n);
                    }
                    
                    // --- SOLUTION 2: Save to source folder too ---
                    saveToSource(fullPath, fileName);
                    
                } catch (Exception ex) {
                    // If download fails, use the default placeholder
                    System.err.println("[ManageMoviesServlet] Failed to download TMDB poster: " + ex.getMessage());
                    fileName = "default.jpg";
                }
            } else {
                // CASE 3: No image provided at all, use default
                fileName = "default.jpg";
            }
            
            // --- DATE VALIDATION ---
            // End date must be after Start date!
            if (endDate.before(startDate)) {
                request.setAttribute("error", "End date cannot be before start date");
                doGet(request, response);
                return;
            }

            // Create movie object and save to database
            Movie movie = new Movie(title, genre, director, duration, language, releaseDate, startDate, endDate, description, fileName, 0.0, format, ageRating);
            movie.setTrailerUrl(trailerUrl);
            movie.setCastList(castList);
            
            String pStd = request.getParameter("priceStandard");
            String pPrem = request.getParameter("pricePremium");
            String pRec = request.getParameter("priceRecliner");
            String pVip = request.getParameter("priceVip");
            if (pStd != null && !pStd.trim().isEmpty()) movie.setPriceStandard(Double.parseDouble(pStd));
            if (pPrem != null && !pPrem.trim().isEmpty()) movie.setPricePremium(Double.parseDouble(pPrem));
            if (pRec != null && !pRec.trim().isEmpty()) movie.setPriceRecliner(Double.parseDouble(pRec));
            if (pVip != null && !pVip.trim().isEmpty()) movie.setPriceVip(Double.parseDouble(pVip));
            
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
            String castList = request.getParameter("castList"); // Restored missing parameter
            
            // Handle custom genre if selected in edit form
            if ("custom".equals(genre)) {
                genre = request.getParameter("customGenre");
            }

            // --- DATE VALIDATION ---
            if (endDate.before(startDate)) {
                request.setAttribute("error", "End date cannot be before start date");
                doGet(request, response);
                return;
            }

            Movie existingMovie = movieDao.getMovieById(movieId);
            String posterImage = existingMovie.getPosterImage();
            
            Part filePart = request.getPart("posterImage");
            String tmdbPosterUrl = request.getParameter("tmdbPosterUrl");
            String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            if (filePart != null && filePart.getSize() > 0) {
                // CASE 1: File upload override
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String fullPath = uploadPath + File.separator + fileName;
                filePart.write(fullPath);
                posterImage = fileName;
                saveToSource(fullPath, fileName);
            } else if (tmdbPosterUrl != null && !tmdbPosterUrl.trim().isEmpty()) {
                // CASE 2: TMDB Restore
                try {
                    String ext = tmdbPosterUrl.contains(".") ? tmdbPosterUrl.substring(tmdbPosterUrl.lastIndexOf('.')) : ".jpg";
                    String fileName = "tmdb_" + System.currentTimeMillis() + ext;
                    String fullPath = uploadPath + File.separator + fileName;
                    URL imgUrl = new URL(tmdbPosterUrl);
                    try (InputStream in = imgUrl.openStream();
                         OutputStream out = new java.io.FileOutputStream(fullPath)) {
                        byte[] buf = new byte[4096]; int n;
                        while ((n = in.read(buf)) != -1) out.write(buf, 0, n);
                    }
                    posterImage = fileName;
                    saveToSource(fullPath, fileName);
                } catch (Exception ex) {
                    System.err.println("[ManageMoviesServlet] Failed to download TMDB poster in Update: " + ex.getMessage());
                }
            }
            
            Movie movie = new Movie(title, genre, director, duration, language, 
                    releaseDate, startDate, 
                    endDate, description, posterImage, 
                    existingMovie.getRating(), format, ageRating);
            movie.setMovieId(movieId);
            movie.setTrailerUrl(trailerUrl);
            movie.setCastList(castList);
            movie.setActive(existingMovie.isActive());
            
            String pStd = request.getParameter("priceStandard");
            String pPrem = request.getParameter("pricePremium");
            String pRec = request.getParameter("priceRecliner");
            String pVip = request.getParameter("priceVip");
            if (pStd != null && !pStd.trim().isEmpty()) movie.setPriceStandard(Double.parseDouble(pStd));
            if (pPrem != null && !pPrem.trim().isEmpty()) movie.setPricePremium(Double.parseDouble(pPrem));
            if (pRec != null && !pRec.trim().isEmpty()) movie.setPriceRecliner(Double.parseDouble(pRec));
            if (pVip != null && !pVip.trim().isEmpty()) movie.setPriceVip(Double.parseDouble(pVip));
            
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
            int movieId = Integer.parseInt(request.getParameter("id"));
            boolean isDeleted = movieDao.deleteMovie(movieId);
            if (isDeleted) {
                response.sendRedirect(request.getContextPath() + "/manageMovies?success=Movie hidden successfully. History is preserved.");
            } else {
                response.sendRedirect(request.getContextPath() + "/manageMovies?error=Failed to hide movie");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/manageMovies?error=Invalid movie ID");
        }
    }

    /**
     * Handle restoring a soft-deleted movie.
     */
    private void handleRestore(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int movieId = Integer.parseInt(request.getParameter("id"));
            boolean isRestored = movieDao.restoreMovie(movieId);
            if (isRestored) {
                response.sendRedirect(request.getContextPath() + "/manageMovies?success=Movie restored successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/manageMovies?error=Failed to restore movie");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/manageMovies?error=Invalid movie ID");
        }
    }
    /**
     * Helper for Solution 2: Saves the uploaded image to the project's source folder
     * so it survives Tomcat redeployments/restarts.
     */
    private void saveToSource(String currentPath, String fileName) {
        try {
            String sourcePath = settingsDao.getSetting("PROJECT_SOURCE_PATH", null);
            if (sourcePath != null && !sourcePath.isEmpty()) {
                File sourceDir = new File(sourcePath);
                if (sourceDir.exists()) {
                    Files.copy(Paths.get(currentPath), Paths.get(sourcePath + File.separator + fileName), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                    System.out.println("[ManageMoviesServlet] Successfully backed up " + fileName + " to source folder.");
                }
            }
        } catch (Exception e) {
            System.err.println("[ManageMoviesServlet] Failed to back up image to source: " + e.getMessage());
        }
    }
}
