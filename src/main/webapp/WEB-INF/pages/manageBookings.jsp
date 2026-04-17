<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Bookings - MovieMint Admin</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <!-- Check if user is admin, if not redirect to login page -->
    <c:if test="${empty user || user.role != 'admin'}">
        <c:redirect url="login"/>
    </c:if>
    
    <div class="dashboard">
        <!-- Include header navigation for admin -->
        <jsp:include page="adminHeader.jsp" />
        
        <div class="main-content">
            <h1>Manage Bookings</h1>
            
            <!-- Show success message if action was successful -->
            <c:if test="${not empty param.success}">
                <div class="success-message">${param.success}</div>
            </c:if>
            
            <!-- Show error message if action failed -->
            <c:if test="${not empty param.error}">
                <div class="error-message">${param.error}</div>
            </c:if>
            
            <!-- Search section -->
            <div class="search-section">
                <!-- Search form to find bookings by user or movie name -->
                <form action="${pageContext.request.contextPath}/manageBookings" method="get">
                    <!-- Search input field -->
                    <input type="text" name="search" placeholder="Search by user or movie...">
                    <!-- Search button -->
                    <button type="submit" class="btn-search">Search</button>
                </form>
            </div>
            
            <!-- Bookings table -->
            <div class="table-container">
                <table class="data-table">
                    <!-- Table header -->
                    <thead>
                        <tr>
                            <th>Booking ID</th>
                            <th>User</th>
                            <th>Movie</th>
                            <th>Booking Date</th>
                            <th>Show Time</th>
                            <th>Seats</th>
                            <th>Total Price</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <!-- Table body -->
                    <tbody>
                        <!-- Check if bookings list has data -->
                        <c:choose>
                            <c:when test="${not empty bookings}">
                                <!-- Loop through each booking -->
                                <c:forEach var="booking" items="${bookings}">
                                    <tr>
                                        <!-- Booking ID -->
                                        <td>${booking.bookingId}</td>
                                        <!-- User name who made the booking -->
                                        <td>${booking.userName}</td>
                                        <!-- Movie title -->
                                        <td>${booking.movieTitle}</td>
                                        <!-- Date when booking was made -->
                                        <td>${booking.bookingDate}</td>
                                        <!-- Show time for the movie -->
                                        <td>${booking.showTime}</td>
                                        <!-- Number of seats booked -->
                                        <td>${booking.numberOfSeats}</td>
                                        <!-- Total price paid -->
                                        <td>Rs. ${booking.totalPrice}</td>
                                        <!-- Current booking status -->
                                        <td>${booking.status}</td>
                                        <!-- Action buttons -->
                                        <td>
                                            <!-- Form to update booking status -->
                                            <form action="${pageContext.request.contextPath}/manageBookings" method="post" style="display:inline;">
                                                <!-- Hidden field for action type -->
                                                <input type="hidden" name="action" value="updateStatus">
                                                <!-- Hidden field for booking ID -->
                                                <input type="hidden" name="bookingId" value="${booking.bookingId}">
                                                <!-- Dropdown to change booking status -->
                                                <select name="status" onchange="this.form.submit()">
                                                    <!-- Confirmed status option -->
                                                    <option value="Confirmed" ${booking.status == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                                                    <!-- Cancelled status option -->
                                                    <option value="Cancelled" ${booking.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                                    <!-- Completed status option -->
                                                    <option value="Completed" ${booking.status == 'Completed' ? 'selected' : ''}>Completed</option>
                                                </select>
                                            </form>
                                            <!-- Delete button with confirmation -->
                                            <a href="${pageContext.request.contextPath}/manageBookings?action=delete&id=${booking.bookingId}" class="btn-delete" onclick="return confirm('Delete this booking?')">Delete</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <!-- Show message if no bookings found -->
                                <tr>
                                    <td colspan="9">No bookings found.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
