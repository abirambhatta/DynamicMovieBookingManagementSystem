<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Movie Details - MovieMint</title>
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
            <!-- Check if movie data is available -->
            <c:choose>
                <c:when test="${not empty movie}">
                    <!-- Movie detail container -->
                    <div class="movie-detail-container">
                        <!-- Large movie poster image -->
                        <div class="movie-poster-large">
                            <img src="${pageContext.request.contextPath}/images/${movie.posterImage}" alt="${movie.title}">
                        </div>
                        
                        <!-- Movie information section -->
                        <div class="movie-info">
                            <!-- Movie title -->
                            <h1>${movie.title}</h1>
                            <!-- Movie director -->
                            <p><strong>Director:</strong> ${movie.director}</p>
                            <!-- Movie genre -->
                            <p><strong>Genre:</strong> ${movie.genre}</p>
                            <!-- Movie language -->
                            <p><strong>Language:</strong> ${movie.language}</p>
                            <!-- Movie duration in minutes -->
                            <p><strong>Duration:</strong> ${movie.duration} mins</p>
                            <!-- Movie description/synopsis -->
                            <p><strong>Description:</strong> ${movie.description}</p>
                            
                            <!-- Booking section -->
                            <div class="booking-section">
                                <!-- Link to book tickets for this movie -->
                                <a href="${pageContext.request.contextPath}/bookTicket?movieId=${movie.movieId}" class="btn-primary">Book Tickets</a>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Show error message if movie not found -->
                    <p class="error-message">Movie not found.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
