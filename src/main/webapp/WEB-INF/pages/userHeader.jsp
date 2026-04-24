<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="currentPage" value="${pageContext.request.servletPath}" />
<header>
    <nav class="navbar">
        <div class="nav-container">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/userHome">MovieMint</a>
            </div>
            <div class="nav-menu">
                <a href="${pageContext.request.contextPath}/userHome" class="${currentPage.contains('userHome') ? 'active' : ''}">Home</a>
                <a href="${pageContext.request.contextPath}/browseMovies" class="${currentPage.contains('browseMovies') || currentPage.contains('movieDetails') || currentPage.contains('bookTicket') ? 'active' : ''}">Browse Movies</a>
                <a href="${pageContext.request.contextPath}/myBookings" class="${currentPage.contains('myBookings') || currentPage.contains('ticketConfirmation') ? 'active' : ''}">My Bookings</a>
                <a href="${pageContext.request.contextPath}/userProfile" class="${currentPage.contains('userProfile') ? 'active' : ''}">Profile</a>
                <a href="${pageContext.request.contextPath}/about" class="${currentPage.contains('about') ? 'active' : ''}">About</a>
                <a href="${pageContext.request.contextPath}/contact" class="${currentPage.contains('contact') ? 'active' : ''}">Contact</a>
            </div>
            <div class="nav-actions">
                <c:if test="${not empty user}">
                    <span class="user-name">Welcome, ${user.fullName}</span>
                </c:if>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
            </div>
        </div>
    </nav>
</header>
