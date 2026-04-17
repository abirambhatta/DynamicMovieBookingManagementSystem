package com.moviebooking.controllers;

import com.moviebooking.dao.MovieDao;
import com.moviebooking.model.Movie;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Servlet for the browse movies page.
 * Shows all movies or search results if user searched for something.
 */
@WebServlet("/browseMovies")
public class BrowseMoviesServlet extends HttpServlet {
    private final MovieDao movieDao = new MovieDao();

    /**
     * Get all movies or search results and show the browse movies page.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user typed something in the search box
        String search = request.getParameter("search");
        List<Movie> movies;

        if (search != null && !search.trim().isEmpty()) {
            // If search word exists, search movies by title, genre, or director
            movies = movieDao.searchMovies(search);
            request.setAttribute("searchKeyword", search);
        } else {
            // If no search, get all movies
            movies = movieDao.getAllMovies();
        }

        // Pass the movies list to the JSP page and show it
        request.setAttribute("movies", movies);
        request.getRequestDispatcher("/WEB-INF/pages/browseMovies.jsp").forward(request, response);
    }
}
