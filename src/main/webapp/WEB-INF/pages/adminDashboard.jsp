<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - MovieMint</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: white; border: 1px solid #e9ecef; border-radius: 8px; padding: 20px; text-align: center; }
        .stat-number { font-size: 32px; font-weight: bold; color: #dc143c; margin: 10px 0; }
        .stat-label { color: #6c757d; font-size: 14px; }
        .tabs { display: flex; gap: 10px; margin-bottom: 20px; border-bottom: 2px solid #e9ecef; }
        .tab-btn { padding: 12px 20px; background: none; border: none; cursor: pointer; font-size: 14px; font-weight: 500; color: #6c757d; border-bottom: 3px solid transparent; }
        .tab-btn.active { color: #dc143c; border-bottom-color: #dc143c; }
        .tab-content { display: none; }
        .tab-content.active { display: block; }
        .show-time-item { background: #f8f9fa; padding: 15px; border-radius: 6px; margin-bottom: 10px; display: flex; justify-content: space-between; align-items: center; }
        .show-time-info { flex: 1; }
        .show-time-date { font-weight: 500; color: #333; }
        .show-time-details { font-size: 13px; color: #6c757d; margin-top: 5px; }
        .booking-item { background: #f8f9fa; padding: 15px; border-radius: 6px; margin-bottom: 10px; }
        .booking-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px; }
        .booking-user { font-weight: 500; color: #333; }
        .booking-status { font-size: 12px; padding: 4px 8px; border-radius: 4px; background: #28a745; color: white; }
        .booking-details { font-size: 13px; color: #6c757d; }
    </style>
</head>
<body>
    <c:if test="${empty user || user.role != 'admin'}">
        <c:redirect url="login"/>
    </c:if>
    
    <div class="dashboard">
        <jsp:include page="adminHeader.jsp" />
        
        <div class="main-content">
            <h1>Admin Dashboard</h1>
            
            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-label">Total Movies</div>
                    <div class="stat-number">${totalMovies}</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Total Users</div>
                    <div class="stat-number">${totalUsers}</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Total Bookings</div>
                    <div class="stat-number">${totalBookings}</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Total Revenue</div>
                    <div class="stat-number">Rs. ${totalRevenue}</div>
                </div>
            </div>
            
            <!-- Tabs for different sections -->
            <div class="tabs">
                <button class="tab-btn active" onclick="switchTab('showTimes')">Show Times</button>
                <button class="tab-btn" onclick="switchTab('bookings')">Recent Bookings</button>
            </div>
            
            <!-- Show Times Tab -->
            <div id="showTimes" class="tab-content active">
                <h2>Upcoming Show Times</h2>
                <c:choose>
                    <c:when test="${not empty showTimes}">
                        <c:forEach var="showTime" items="${showTimes}">
                            <div class="show-time-item">
                                <div class="show-time-info">
                                    <div class="show-time-date">${showTime.movieTitle}</div>
                                    <div class="show-time-details">
                                        Date: ${showTime.showDate} | Time: ${showTime.showTime} | Hall: ${showTime.hall}
                                    </div>
                                </div>
                                <button onclick="deleteShowTime(${showTime.showTimeId})" class="btn-delete" style="padding: 6px 12px; font-size: 13px;">Delete</button>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p style="color: #6c757d;">No upcoming show times.</p>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- Bookings Tab -->
            <div id="bookings" class="tab-content">
                <h2>Recent Bookings</h2>
                <c:choose>
                    <c:when test="${not empty recentBookings}">
                        <c:forEach var="booking" items="${recentBookings}">
                            <div class="booking-item">
                                <div class="booking-header">
                                    <div class="booking-user">${booking.userName} - ${booking.movieTitle}</div>
                                    <div class="booking-status">Confirmed</div>
                                </div>
                                <div class="booking-details">
                                    Seats: ${booking.seatsBooked} | Amount: Rs. ${booking.totalAmount} | Date: ${booking.bookingDate}
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p style="color: #6c757d;">No recent bookings.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <script>
        function switchTab(tabName) {
            // Hide all tabs
            document.querySelectorAll('.tab-content').forEach(tab => tab.classList.remove('active'));
            document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
            
            // Show selected tab
            document.getElementById(tabName).classList.add('active');
            event.target.classList.add('active');
        }
        
        function deleteShowTime(showTimeId) {
            if (confirm('Are you sure you want to delete this show time?')) {
                window.location.href = '${pageContext.request.contextPath}/adminDashboard?action=deleteShowTime&id=' + showTimeId;
            }
        }
    </script>
</body>
</html>
