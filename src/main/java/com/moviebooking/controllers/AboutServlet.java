package com.moviebooking.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet for the About page.
 * Just shows the about.jsp page with info about the system.
 */
@WebServlet("/about")
public class AboutServlet extends HttpServlet {

    // When user visits /about, show the about page
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/pages/about.jsp").forward(request, response);
    }
}
