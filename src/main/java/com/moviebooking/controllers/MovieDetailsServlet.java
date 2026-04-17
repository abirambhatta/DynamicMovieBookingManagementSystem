package com.moviebooking.controllers;

import com.moviebooking.dao.MovieDao;
import com.moviebooking.model.Movie;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet for showing a single movie's full details.
 * Gets the movie by ID and shows all its info on the movie details page.
 */
@WebServlet("/movieDetails")
public class MovieDetailsServlet extends HttpServlet {
    private final MovieDao movieDao = new MovieDao();

    /**
     * Get movie details by ID and show the movie details page.
     * If movie ID is missing or movie not found, go back to browse movies.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get movie ID from URL parameter
        String movieIdParam = request.getParameter("id");

        // If no movie ID is given, go back to browse movies
        if (movieIdParam == null || movieIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/browseMovies");
            return;
        }

        try {
            // Get the movie from database using the ID
            int movieId = Integer.parseInt(movieIdParam);
            Movie movie = movieDao.getMovieById(movieId);

            if (movie != null) {
                // Movie found - pass it to the JSP page and show details
                request.setAttribute("movie", movie);
                request.getRequestDispatcher("/WEB-INF/pages/movieDetails.jsp").forward(request, response);
            } else {
                // Movie not found - go back to browse movies
                response.sendRedirect(request.getContextPath() + "/browseMovies");
            }
        } catch (NumberFormatException e) {
            // Invalid movie ID (not a number) - go back to browse movies
            response.sendRedirect(request.getContextPath() + "/browseMovies");
        }
    }
}
