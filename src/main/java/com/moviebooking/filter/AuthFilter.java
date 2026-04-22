package com.moviebooking.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

// This filter runs before the listed pages are accessed
// It checks if the user is logged in and has the right role
@WebFilter({"/userHome", "/browseMovies", "/movieDetails", "/bookTicket", "/myBookings", "/userProfile", 
            "/adminHome", "/manageMovies", "/manageUsers", "/manageBookings", "/manageSettings"})
/**
 * This filter checks if user is logged in.
 * Redirects to login page if user is not logged in or has wrong role.
 */
public class AuthFilter implements Filter {

    /**
     * Main filter method - runs before every request to the listed URLs.
     * Checks session for user and role.
     * If no session or wrong role, sends user back to login page.
     */
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        // Cast to HTTP request and response so we can use session and redirect
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        // Get existing session, don't create new one (false means no new session)
        HttpSession session = req.getSession(false);

        // Get the URL the user is trying to access
        String uri = req.getRequestURI();
        // Check if the page is a user page (normal user pages)
        boolean isUserPage = uri.contains("/userHome") || uri.contains("/browseMovies") || 
                             uri.contains("/movieDetails") || uri.contains("/bookTicket") || 
                             uri.contains("/myBookings") || uri.contains("/userProfile");
        boolean isAdminPage = uri.contains("/adminHome") || uri.contains("/manageMovies") || 
                              uri.contains("/manageUsers") || uri.contains("/manageBookings") || uri.contains("/manageSettings");

        // If no session exists or no user is logged in, go to login page
        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Get the role of the logged in user (admin or user)
        String role = (String) session.getAttribute("role");

        // If trying to access admin page but user is not an admin, go to login
        if (isAdminPage && !"admin".equals(role)) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // If trying to access user page but user is not a normal user, go to login
        if (isUserPage && !"user".equals(role)) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // If all checks pass, let the request go through to the page
        chain.doFilter(request, response);
    }
}
