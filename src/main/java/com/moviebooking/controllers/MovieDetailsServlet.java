package com.moviebooking.controllers;

import com.moviebooking.dao.MovieDao;
import com.moviebooking.dao.ShowTimeDao;
import com.moviebooking.model.Movie;
import com.moviebooking.model.ShowTime;
import java.util.List;
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
    private final ShowTimeDao showTimeDao = new ShowTimeDao();

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
                // Fetch showtimes
                List<ShowTime> showTimes = showTimeDao.getShowTimesByMovie(movieId);
                StringBuilder json = new StringBuilder("[");
                for(int i=0; i<showTimes.size(); i++){
                    ShowTime st = showTimes.get(i);
                    json.append("{");
                    json.append("\"id\":").append(st.getShowId()).append(",");
                    json.append("\"date\":\"").append(st.getShowDate().toString()).append("\",");
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("hh:mm a");
                    json.append("\"time\":\"").append(sdf.format(st.getShowTime())).append("\",");
                    json.append("\"hall\":\"").append(st.getHall() != null ? st.getHall() : "Audi 01").append("\"");
                    json.append("}");
                    if(i < showTimes.size() -1) json.append(",");
                }
                json.append("]");

                // Movie found - pass it to the JSP page and show details
                request.setAttribute("movie", movie);
                request.setAttribute("showTimesJson", json.toString());
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
