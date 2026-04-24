package com.moviebooking.controllers;

import com.moviebooking.dao.MovieDao;
import com.moviebooking.dao.ShowTimeDao;
import com.moviebooking.model.Movie;
import com.moviebooking.model.ShowTime;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Servlet for the user home page.
 * Shows the most recent 6 movies to the logged-in user.
 */
@WebServlet("/userHome")
public class UserHomeServlet extends HttpServlet {
    private final MovieDao movieDao = new MovieDao();
    private final ShowTimeDao showTimeDao = new ShowTimeDao();

    /**
     * Get the latest 6 movies and show the user home page.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get the 6 most recent movies to show on the home page
        List<Movie> recentMovies = movieDao.getRecentMovies(6);
        
        // Fetch showtimes for today
        LocalDate today = LocalDate.now();
        List<ShowTime> allShowTimes = showTimeDao.getShowTimesByDate(java.sql.Date.valueOf(today));
        Map<Integer, List<ShowTime>> showTimesMap = allShowTimes.stream()
                .collect(Collectors.groupingBy(ShowTime::getMovieId));

        // Pass the movies to the JSP page
        request.setAttribute("recentMovies", recentMovies);
        request.setAttribute("showTimesMap", showTimesMap);
        request.getRequestDispatcher("/WEB-INF/pages/userHome.jsp").forward(request, response);
    }
}
