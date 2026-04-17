package com.moviebooking.controllers;

import com.moviebooking.dao.MovieDao;
import com.moviebooking.dao.ShowTimeDao;
import com.moviebooking.model.Movie;
import com.moviebooking.model.ShowTime;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
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

    /**
     * Show all movies page, or handle edit/delete actions.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");

            if ("delete".equals(action)) {
                // Handle delete movie
                handleDelete(request, response);
                return;
            } else if ("edit".equals(action)) {
                // Handle edit - get the movie to edit and pass it to the page
                int id = Integer.parseInt(request.getParameter("id"));
                Movie movie = movieDao.getMovieById(id);
                request.setAttribute("editMovie", movie);
            }

            // Get all movies and show the manage movies page
            List<Movie> movies = movieDao.getAllMovies();
            System.out.println("Movies fetched: " + (movies != null ? movies.size() : "null"));
            request.setAttribute("movies", movies);
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
            
            // Handle poster image file upload
            Part filePart = request.getPart("posterImage");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            // Save the image to the "images" folder inside the app
            String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
            File uploadDir = new File(uploadPath);
            // Create the images folder if it doesn't exist
            if (!uploadDir.exists()) uploadDir.mkdirs();
            // Write the uploaded file to the folder
            filePart.write(uploadPath + File.separator + fileName);

            // Create movie object and save to database
            Movie movie = new Movie(title, genre, director, duration, language, releaseDate, startDate, endDate, description, fileName, 0.0);
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
                    existingMovie.getReleaseDate(), existingMovie.getStartDate(), 
                    existingMovie.getEndDate(), description, posterImage, 
                    existingMovie.getRating());
            movie.setMovieId(movieId);
            boolean isUpdated = movieDao.updateMovie(movie);

            if (isUpdated) {
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
