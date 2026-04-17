package com.moviebooking.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/pages/contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");
        
        if (name != null && email != null && subject != null && message != null) {
            request.setAttribute("success", "Thank you for contacting us! We will get back to you soon.");
        } else {
            request.setAttribute("error", "Please fill in all fields.");
        }
        
        request.getRequestDispatcher("/WEB-INF/pages/contact.jsp").forward(request, response);
    }
}
