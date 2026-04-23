package com.moviebooking.controllers;

import com.moviebooking.dao.BookingDao;
import com.moviebooking.dao.MovieDao;
import com.moviebooking.dao.UserDao;
import com.moviebooking.model.Booking;
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
    private final UserDao userDao = new UserDao();
    private final MovieDao movieDao = new MovieDao();
    private final BookingDao bookingDao = new BookingDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get filter parameters
        String period = request.getParameter("period");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        
        int totalUsers = userDao.getTotalUsers();
        int totalMovies = movieDao.getTotalMovies();
        
        // Get bookings count based on filter
        int totalBookings;
        if (period != null && !period.isEmpty()) {
            totalBookings = bookingDao.getBookingsCountByPeriod(period, startDate, endDate);
        } else {
            totalBookings = bookingDao.getTotalBookings();
        }
        
        double totalRevenue = bookingDao.getTotalRevenue();
        
        List<Object[]> allMovies = bookingDao.getAllMoviesWithBookingCount();
        List<Object[]> topMovies = bookingDao.getTopBookedMovies(0);
        List<Booking> recentBookings = bookingDao.getRecentBookings(5);
        List<Object[]> revenueByDay = bookingDao.getRevenueByDay();
        List<Object[]> revenueByMonth = bookingDao.getRevenueByMonth();
        List<Object[]> revenueByYear = bookingDao.getRevenueByYear();
        List<Object[]> seatDistribution = bookingDao.getSeatDistribution();

        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalMovies", totalMovies);
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("totalRevenue", String.format("%.2f", totalRevenue));
        request.setAttribute("allMovies", allMovies);
        request.setAttribute("topMovies", topMovies);
        request.setAttribute("recentBookings", recentBookings);
        request.setAttribute("revenueByDay", revenueByDay);
        request.setAttribute("revenueByMonth", revenueByMonth);
        request.setAttribute("revenueByYear", revenueByYear);
        request.setAttribute("seatDistribution", seatDistribution);
        request.setAttribute("selectedPeriod", period);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        
        request.getRequestDispatcher("/WEB-INF/pages/adminHome.jsp").forward(request, response);
    }
}
