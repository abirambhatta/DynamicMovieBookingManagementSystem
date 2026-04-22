<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.moviebooking.model.User" %>
<% 
    User user = (User) session.getAttribute("user");
    String currentPage = request.getRequestURI();
%>

<div class="navbar admin-navbar">
    <div class="nav-container">
        <div class="logo">
            <a href="${pageContext.request.contextPath}/adminHome">MovieMint Admin</a>
        </div>
        
        <div class="nav-menu">
            <a href="${pageContext.request.contextPath}/adminHome" class="<%= currentPage.contains("/adminHome") ? "active" : "" %>">Dashboard</a>
            <a href="${pageContext.request.contextPath}/manageMovies" class="<%= currentPage.contains("/manageMovies") ? "active" : "" %>">Movies</a>
            <a href="${pageContext.request.contextPath}/manageUsers" class="<%= currentPage.contains("/manageUsers") ? "active" : "" %>">Users</a>
            <a href="${pageContext.request.contextPath}/manageBookings" class="<%= currentPage.contains("/manageBookings") ? "active" : "" %>">Bookings</a>
            <a href="${pageContext.request.contextPath}/manageSettings" class="<%= currentPage.contains("/manageSettings") ? "active" : "" %>">Settings</a>
        </div>
        
        <div class="nav-actions">
            <span class="user-name"><%= user != null ? user.getFullName() : "" %></span>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
        </div>
    </div>
</div>
