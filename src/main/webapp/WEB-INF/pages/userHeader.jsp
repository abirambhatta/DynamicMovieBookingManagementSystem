<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<header>
    <nav class="navbar">
        <div class="nav-container">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/userHome">MovieMint</a>
            </div>
            <div class="nav-menu">
                <a href="${pageContext.request.contextPath}/userHome">Home</a>
                <a href="${pageContext.request.contextPath}/browseMovies">Browse Movies</a>
                <a href="${pageContext.request.contextPath}/myBookings">My Bookings</a>
                <a href="${pageContext.request.contextPath}/userProfile">Profile</a>
                <a href="${pageContext.request.contextPath}/about">About</a>
                <a href="${pageContext.request.contextPath}/contact">Contact</a>
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
