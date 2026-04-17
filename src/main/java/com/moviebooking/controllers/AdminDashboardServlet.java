package com.moviebooking.controllers;

import com.moviebooking.dao.MovieDao;
import com.moviebooking.dao.UserDao;
import com.moviebooking.dao.BookingDao;
import com.moviebooking.dao.ShowTimeDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/adminDashboard")
public class AdminDashboardServlet extends HttpServlet {
    private final MovieDao movieDao = new MovieDao();
    private final UserDao userDao = new UserDao();
    private final BookingDao bookingDao = new BookingDao();
    private final ShowTimeDao showTimeDao = new ShowTimeDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            
            if ("deleteShowTime".equals(action)) {
                int showTimeId = Integer.parseInt(request.getParameter("id"));
                showTimeDao.deleteShowTime(showTimeId);
                response.sendRedirect(request.getContextPath() + "/adminDashboard");
                return;
            }
            
            // Get statistics
            int totalMovies = movieDao.getTotalMovies();
            int totalUsers = userDao.getTotalUsers();
            int totalBookings = bookingDao.getTotalBookings();
            double totalRevenue = bookingDao.getTotalRevenue();
            
            // Get upcoming show times
            List<?> showTimes = showTimeDao.getUpcomingShowTimes();
            
            // Get recent bookings
            List<?> recentBookings = bookingDao.getRecentBookings(10);
            
            request.setAttribute("totalMovies", totalMovies);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("showTimes", showTimes);
            request.setAttribute("recentBookings", recentBookings);
            
            request.getRequestDispatcher("/WEB-INF/pages/adminDashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
}
