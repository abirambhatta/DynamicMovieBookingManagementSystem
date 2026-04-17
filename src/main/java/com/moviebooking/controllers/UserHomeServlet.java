package com.moviebooking.controllers;

import com.moviebooking.dao.MovieDao;
import com.moviebooking.model.Movie;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Servlet for the user home page.
 * Shows the most recent 6 movies to the logged-in user.
 */
@WebServlet("/userHome")
public class UserHomeServlet extends HttpServlet {
    private final MovieDao movieDao = new MovieDao();

    /**
     * Get the latest 6 movies and show the user home page.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get the 6 most recent movies to show on the home page
        List<Movie> recentMovies = movieDao.getRecentMovies(6);
        // Pass the movies to the JSP page
        request.setAttribute("recentMovies", recentMovies);
        request.getRequestDispatcher("/WEB-INF/pages/userHome.jsp").forward(request, response);
    }
}
