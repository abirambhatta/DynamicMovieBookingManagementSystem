<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookings - MovieMint</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <c:if test="${empty user}">
        <c:redirect url="login"/>
    </c:if>
    
    <div class="dashboard">
        <jsp:include page="userHeader.jsp" />
        
        <div class="main-content">
            <h1>My Bookings</h1>
            
            <div class="search-section">
                <form action="${pageContext.request.contextPath}/myBookings" method="get" class="search-form">
                    <input type="text" name="search" placeholder="Search by movie name..." value="${param.search}">
                    <button type="submit" class="btn-search">Search</button>
                </form>
                <div class="sort-options">
                    <a href="${pageContext.request.contextPath}/myBookings?sort=date" class="btn-sort">Sort by Date</a>
                    <a href="${pageContext.request.contextPath}/myBookings?sort=movie" class="btn-sort">Sort by Movie</a>
                    <a href="${pageContext.request.contextPath}/myBookings" class="btn-sort">All</a>
                </div>
            </div>
            
            <c:choose>
                <c:when test="${not empty bookings}">
                    <c:forEach var="booking" items="${bookings}">
                        <div class="booking-card">
                            <div class="booking-details">
                                <h3>${booking.movieTitle}</h3>
                                <p><strong>Booking ID:</strong> ${booking.bookingId}</p>
                                <p><strong>Show Time:</strong> ${booking.showTime}</p>
                                <p><strong>Number of Seats:</strong> ${booking.numberOfSeats}</p>
                                <p><strong>Total Price:</strong> Rs. ${booking.totalPrice}</p>
                                <p><strong>Status:</strong> <span class="status-${booking.status}">${booking.status}</span></p>
                                <p><strong>Booking Date:</strong> ${booking.bookingDate}</p>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p class="no-results">No bookings found. <a href="${pageContext.request.contextPath}/browseMovies">Browse movies</a> to make your first booking!</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
