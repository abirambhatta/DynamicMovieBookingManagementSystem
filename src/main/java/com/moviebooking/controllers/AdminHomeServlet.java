package com.moviebooking.controllers;

import com.moviebooking.dao.BookingDao;
import com.moviebooking.dao.MovieDao;
import com.moviebooking.dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Servlet for the admin dashboard page.
 * Gets all stats like total users, movies, bookings, and revenue.
 * Also gets data for charts (revenue by day/month/year, seat types, etc).
 */
@WebServlet("/adminHome")
public class AdminHomeServlet extends HttpServlet {
    // DAO objects to get data from the database
    private final UserDao userDao = new UserDao();
    private final MovieDao movieDao = new MovieDao();
    private final BookingDao bookingDao = new BookingDao();

    /**
     * Get all stats and chart data, then show the admin dashboard page.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get total counts for the dashboard cards
        int totalUsers = userDao.getTotalUsers();
        int totalMovies = movieDao.getTotalMovies();
        int totalBookings = bookingDao.getTotalBookings();
        double totalRevenue = bookingDao.getTotalRevenue();
        
        // Get data for the dashboard charts
        List<Object[]> allMovies = bookingDao.getAllMoviesWithBookingCount();
        List<Object[]> topMovies = bookingDao.getTopBookedMovies(0);
        List<Object[]> revenueByDay = bookingDao.getRevenueByDay();
        List<Object[]> revenueByMonth = bookingDao.getRevenueByMonth();
        List<Object[]> revenueByYear = bookingDao.getRevenueByYear();
        List<Object[]> seatDistribution = bookingDao.getSeatDistribution();

        // Set all data as request attributes so JSP page can use them
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalMovies", totalMovies);
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("totalRevenue", String.format("%.2f", totalRevenue));
        request.setAttribute("allMovies", allMovies);
        request.setAttribute("topMovies", topMovies);
        request.setAttribute("revenueByDay", revenueByDay);
        request.setAttribute("revenueByMonth", revenueByMonth);
        request.setAttribute("revenueByYear", revenueByYear);
        request.setAttribute("seatDistribution", seatDistribution);
        
        // Forward to the admin home JSP page
        request.getRequestDispatcher("/WEB-INF/pages/adminHome.jsp").forward(request, response);
    }
}
