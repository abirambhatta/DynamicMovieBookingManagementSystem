<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- Admin dashboard. Shows stats, charts, tables. --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - MovieMint</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/chart.umd.min.js"></script>
</head>
<body>
    <c:if test="${empty user || user.role != 'admin'}">
        <c:redirect url="login"/>
    </c:if>
    
    <div class="dashboard">
        <jsp:include page="adminHeader.jsp" />
        
        <div class="main-content">
            <div class="welcome-section">
                <h1>Admin Dashboard</h1>
                <p>Manage your movie booking platform</p>
            </div>
            
            <div class="stats-container">
                <div class="stat-card">
                    <h3>Total Movies</h3>
                    <p class="stat-number">${not empty totalMovies ? totalMovies : 0}</p>
                </div>
                
                <div class="stat-card">
                    <h3>Total Users</h3>
                    <p class="stat-number">${not empty totalUsers ? totalUsers : 0}</p>
                </div>
                
                <div class="stat-card">
                    <h3>Total Bookings</h3>
                    <p class="stat-number">${not empty totalBookings ? totalBookings : 0}</p>
                </div>
                
                <div class="stat-card">
                    <h3>Total Revenue</h3>
                    <p class="stat-number">Rs. ${not empty totalRevenue ? totalRevenue : 0}</p>
                </div>
            </div>
            
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(450px, 1fr)); gap: 24px; margin: 32px 0;">
                <div class="table-container">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                        <h2 style="margin: 0; color: #212529;">Revenue Analysis</h2>
                        <select id="revenueFilter" style="padding: 8px 12px; border: 1px solid #ced4da; border-radius: 6px;">
                            <option value="daily">Daily (Last 30 Days)</option>
                            <option value="monthly" selected>Monthly (Last 12 Months)</option>
                            <option value="yearly">Yearly</option>
                        </select>
                    </div>
                    <canvas id="revenueChart" style="max-height: 300px;"></canvas>
                </div>
                
                <div class="table-container">
                    <h2 style="margin-bottom: 20px; color: #212529;">All Movies - Booking Count</h2>
                    <canvas id="moviesChart" style="max-height: 300px;"></canvas>
                </div>
            </div>
            
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(450px, 1fr)); gap: 24px; margin: 32px 0;">
                <div class="table-container">
                    <h2 style="margin-bottom: 20px; color: #212529;">Seat Category Distribution</h2>
                    <canvas id="seatChart" style="max-height: 300px;"></canvas>
                </div>
                
                <div class="table-container">
                    <h2 style="margin-bottom: 20px; color: #212529;">Most Booked Movies</h2>
                    <table style="width: 100%;">
                        <thead>
                            <tr>
                                <th>Movie Title</th>
                                <th>Bookings</th>
                                <th>Total Seats</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty topMovies}">
                                    <c:forEach var="movie" items="${topMovies}">
                                        <tr>
                                            <td>${movie[0]}</td>
                                            <td>${movie[1]}</td>
                                            <td>${movie[2]}</td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="3" style="text-align: center;">No booking data available</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <div class="quick-actions">
                <a href="${pageContext.request.contextPath}/manageMovies" class="btn">Add New Movie</a>
                <a href="${pageContext.request.contextPath}/manageUsers" class="btn btn-secondary">View All Users</a>
                <a href="${pageContext.request.contextPath}/manageBookings" class="btn btn-secondary">View All Bookings</a>
            </div>
        </div>
    </div>
    
    <script>
        // Store revenue data for daily view (last 30 days)
        const revenueDataDaily = [
            <c:forEach var="rev" items="${revenueByDay}" varStatus="status">
                {period: '${rev[0]}', revenue: ${rev[1]}}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];
        
        // Store revenue data for monthly view (last 12 months)
        const revenueDataMonthly = [
            <c:forEach var="rev" items="${revenueByMonth}" varStatus="status">
                {period: '${rev[0]}', revenue: ${rev[1]}}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];
        
        // Store revenue data for yearly view
        const revenueDataYearly = [
            <c:forEach var="rev" items="${revenueByYear}" varStatus="status">
                {period: '${rev[0]}', revenue: ${rev[1]}}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];
        
        // Create revenue chart using Chart.js library
        const revenueCtx = document.getElementById('revenueChart').getContext('2d');
        let revenueChart = new Chart(revenueCtx, {
            type: 'bar', // Bar chart type
            data: {
                // Extract period names from monthly data
                labels: revenueDataMonthly.map(d => d.period).reverse(),
                datasets: [{
                    label: 'Revenue (Rs.)',
                    // Extract revenue values from monthly data
                    data: revenueDataMonthly.map(d => d.revenue).reverse(),
                    backgroundColor: 'rgba(220, 20, 60, 0.8)', // Red color for bars
                    borderColor: '#dc143c',
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: {
                    legend: { display: true }
                },
                scales: {
                    y: { beginAtZero: true } // Y-axis starts at 0
                }
            }
        });
        
        // Listen for changes to revenue filter dropdown
        document.getElementById('revenueFilter').addEventListener('change', function() {
            const filter = this.value;
            let data = revenueDataMonthly; // Default to monthly
            
            // Select data based on filter choice
            if (filter === 'daily') {
                data = revenueDataDaily;
            } else if (filter === 'yearly') {
                data = revenueDataYearly;
            }
            
            // Update chart with new data
            revenueChart.data.labels = data.map(d => d.period).reverse();
            revenueChart.data.datasets[0].data = data.map(d => d.revenue).reverse();
            // Refresh chart display
            revenueChart.update();
        });
        
        // Create chart showing booking count for all movies
        const moviesCtx = document.getElementById('moviesChart').getContext('2d');
        // Store all movies data (title and booking count)
        const allMoviesData = [
            <c:forEach var="movie" items="${allMovies}" varStatus="status">
                {title: '${movie[0]}', count: ${movie[1]}}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];
        
        new Chart(moviesCtx, {
            type: 'bar', // Bar chart type
            data: {
                // Extract movie titles
                labels: allMoviesData.map(d => d.title),
                datasets: [{
                    label: 'Number of Bookings',
                    // Extract booking counts
                    data: allMoviesData.map(d => d.count),
                    backgroundColor: 'rgba(220, 20, 60, 0.8)', // Red color
                    borderColor: '#dc143c',
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: {
                    legend: { display: false } // Hide legend
                },
                scales: {
                    y: { 
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1 // Show whole numbers only
                        }
                    }
                }
            }
        });
        
        // Create doughnut chart for seat category distribution
        const seatCtx = document.getElementById('seatChart').getContext('2d');
        // Store seat distribution data (category and count)
        const seatData = [
            <c:forEach var="seat" items="${seatDistribution}" varStatus="status">
                {category: '${seat[0]}', count: ${seat[1]}}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];
        
        new Chart(seatCtx, {
            type: 'doughnut', // Doughnut chart type
            data: {
                // Extract seat category names
                labels: seatData.map(d => d.category),
                datasets: [{
                    // Extract seat counts
                    data: seatData.map(d => d.count),
                    // Different colors for each seat type
                    backgroundColor: [
                        '#dc143c', // Red
                        '#ff6384', // Pink
                        '#36a2eb', // Blue
                        '#ffce56'  // Yellow
                    ]
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: {
                    legend: { position: 'bottom' } // Show legend at bottom
                }
            }
        });
    </script>
</body>
</html>
