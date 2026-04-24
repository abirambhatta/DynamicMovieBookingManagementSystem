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
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.stream.Collectors;

/**
 * Servlet for the browse movies page.
 * Shows all movies or search results if user searched for something.
 */
@WebServlet("/browseMovies")
public class BrowseMoviesServlet extends HttpServlet {
    private final MovieDao movieDao = new MovieDao();
    private final ShowTimeDao showTimeDao = new ShowTimeDao();

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
            // If no search, get all active movies
            movies = movieDao.getAllActiveMovies();
        }

        // Handle Status and Date filtering
        String status = request.getParameter("status");
        if (status == null || status.trim().isEmpty()) {
            status = "now_showing"; // Default
        }
        
        LocalDate today = LocalDate.now();
        String dateParam = request.getParameter("date");
        LocalDate selectedDate = today;
        
        if (dateParam != null && !dateParam.trim().isEmpty()) {
            try {
                selectedDate = LocalDate.parse(dateParam);
            } catch (Exception e) {
                selectedDate = today;
            }
        }
        
        // Generate next 10 dates for the UI tabs
        List<Map<String, String>> dateTabs = new ArrayList<>();
        DateTimeFormatter displayFormatter = DateTimeFormatter.ofPattern("dMMM");
        
        for (int i = 0; i < 10; i++) {
            LocalDate d = today.plusDays(i);
            Map<String, String> tab = new HashMap<>();
            tab.put("value", d.toString());
            
            if (i == 0) {
                tab.put("display", "Today");
            } else if (i == 1) {
                tab.put("display", "Tomm");
            } else {
                tab.put("display", d.format(displayFormatter));
            }
            dateTabs.add(tab);
        }
        
        // Filter movies based on status and date
        final LocalDate filterDate = selectedDate;
        
        if ("coming_soon".equals(status)) {
            movies = movies.stream()
                .filter(m -> {
                    if (m.getStartDate() == null) return false;
                    LocalDate start = m.getStartDate().toLocalDate();
                    return start.isAfter(today);
                })
                .collect(Collectors.toList());
        } else {
            // "now_showing"
            movies = movies.stream()
                .filter(m -> {
                    if (m.getStartDate() == null || m.getEndDate() == null) return false;
                    LocalDate start = m.getStartDate().toLocalDate();
                    LocalDate end = m.getEndDate().toLocalDate();
                    // A movie is showing if it has started on or before the selected date
                    // AND it has not ended before the selected date.
                    return !filterDate.isBefore(start) && !filterDate.isAfter(end);
                })
                .collect(Collectors.toList());
        }

        // Filter by Genre and Language if provided
        String genre = request.getParameter("genre");
        if (genre != null && !genre.trim().isEmpty()) {
            movies = movies.stream().filter(m -> m.getGenre().equalsIgnoreCase(genre)).collect(Collectors.toList());
        }
        
        String language = request.getParameter("language");
        if (language != null && !language.trim().isEmpty()) {
            movies = movies.stream().filter(m -> m.getLanguage().equalsIgnoreCase(language)).collect(Collectors.toList());
        }

        // Fetch showtimes for the selected date
        List<ShowTime> allShowTimes = showTimeDao.getShowTimesByDate(java.sql.Date.valueOf(filterDate));
        Map<Integer, List<ShowTime>> showTimesMap = allShowTimes.stream()
                .collect(Collectors.groupingBy(ShowTime::getMovieId));

        // Pass dynamic genres and languages
        List<String> genresList = movieDao.getAllGenres();
        request.setAttribute("genres", genresList);
        
        List<String> rawLanguages = movieDao.getAllLanguages();
        Map<String, String> languageMap = new HashMap<>();
        for (String lang : rawLanguages) {
            String display = lang;
            if (lang != null && !lang.trim().isEmpty()) {
                if (lang.equalsIgnoreCase("EN")) display = "English";
                else if (lang.equalsIgnoreCase("HI")) display = "Hindi";
                else if (lang.equalsIgnoreCase("NE")) display = "Nepali";
                else if (lang.equalsIgnoreCase("BN")) display = "Bengali";
                else if (lang.equalsIgnoreCase("ZH")) display = "Chinese";
                else if (lang.equalsIgnoreCase("DE")) display = "German";
                else if (lang.equalsIgnoreCase("FR")) display = "French";
                else if (lang.equalsIgnoreCase("ES")) display = "Spanish";
                else if (lang.equalsIgnoreCase("JA")) display = "Japanese";
                else if (lang.equalsIgnoreCase("KO")) display = "Korean";
                else if (lang.equalsIgnoreCase("RU")) display = "Russian";
                else if (lang.equalsIgnoreCase("IT")) display = "Italian";
                else if (lang.equalsIgnoreCase("TA")) display = "Tamil";
                else if (lang.equalsIgnoreCase("TE")) display = "Telugu";
                else if (lang.equalsIgnoreCase("ML")) display = "Malayalam";
                else {
                    display = lang.substring(0, 1).toUpperCase() + lang.substring(1).toLowerCase();
                }
            }
            languageMap.put(lang, display);
        }
        request.setAttribute("languageMap", languageMap);

        // Pass data to JSP
        request.setAttribute("movies", movies);
        request.setAttribute("currentStatus", status);
        request.setAttribute("currentDate", filterDate.toString());
        request.setAttribute("dateTabs", dateTabs);
        request.setAttribute("showTimesMap", showTimesMap);
        
        request.getRequestDispatcher("/WEB-INF/pages/browseMovies.jsp").forward(request, response);
    }
}
