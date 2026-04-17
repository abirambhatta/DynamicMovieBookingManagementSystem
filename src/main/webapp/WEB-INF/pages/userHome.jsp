<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- User home page. Shows recent movies list. --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - MovieMint</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <!-- Check if user is logged in, if not redirect to login page -->
    <c:if test="${empty user}">
        <c:redirect url="login"/>
    </c:if>
    
    <div class="dashboard">
        <!-- Include header navigation for user -->
        <jsp:include page="userHeader.jsp" />
        
        <div class="main-content">
            <!-- Welcome message with user's name -->
            <div class="welcome-section">
                <h1>Welcome back, ${user.fullName}!</h1>
                <p>${user.email}</p>
            </div>
            
            <!-- Section for recently added movies -->
            <div class="recent-movies-section">
                <h2>Recently Added Movies</h2>
                <!-- Loop through recent movies list from servlet -->
                <div class="movie-grid">
                    <!-- Check if recent movies list has data -->
                    <c:choose>
                        <c:when test="${not empty recentMovies}">
                            <!-- Loop through each movie -->
                            <c:forEach var="movie" items="${recentMovies}">
                                <!-- Movie card with poster and details -->
                                <div class="movie-card">
                                    <div class="movie-poster">
                                        <!-- Display movie poster image -->
                                        <img src="${pageContext.request.contextPath}/images/${movie.posterImage}" alt="${movie.title}">
                                    </div>
                                    <div class="movie-card-content">
                                        <!-- Display movie title -->
                                        <h3>${movie.title}</h3>
                                        <!-- Display movie genre -->
                                        <p><strong>Genre:</strong> ${movie.genre}</p>
                                        <!-- Link to view full movie details -->
                                        <a href="${pageContext.request.contextPath}/movieDetails?id=${movie.movieId}" class="btn">View Details</a>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <!-- Show message if no movies available -->
                            <p class="no-results">No movies available at the moment.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <!-- Quick action buttons -->
            <div class="quick-actions">
                <!-- Link to browse all movies -->
                <a href="${pageContext.request.contextPath}/browseMovies" class="btn">Browse All Movies</a>
                <!-- Link to view user's bookings -->
                <a href="${pageContext.request.contextPath}/myBookings" class="btn btn-secondary">My Bookings</a>
            </div>
        </div>
    </div>
</body>
</html>
