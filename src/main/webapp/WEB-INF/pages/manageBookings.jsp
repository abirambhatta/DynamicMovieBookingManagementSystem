<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Bookings - MovieMint Admin</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: white; padding: 24px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); border-left: 4px solid #dc143c; }
        .stat-card h3 { margin: 0 0 8px 0; font-size: 14px; color: #6c757d; font-weight: 500; text-transform: uppercase; letter-spacing: 0.5px; }
        .stat-card .stat-value { font-size: 32px; font-weight: 700; color: #2c3e50; margin: 0; }
        .stat-card.confirmed { border-left-color: #2ecc71; }
        .stat-card.cancelled { border-left-color: #e74c3c; }
        .stat-card.today { border-left-color: #3498db; }
        .status-badge { padding: 4px 10px; border-radius: 12px; font-size: 12px; font-weight: 600; text-transform: uppercase; }
        .status-badge.confirmed { background: #d4edda; color: #155724; }
        .status-badge.cancelled { background: #f8d7da; color: #721c24; }
        .status-badge.completed { background: #d1ecf1; color: #0c5460; }
        .filter-bar { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); margin-bottom: 24px; }
        .search-section { margin-bottom: 20px; }
        .search-form { display: flex; gap: 8px; }
        .search-form input { flex: 1; padding: 10px 14px; border: 1px solid #ced4da; border-radius: 6px; font-size: 15px; }
        .search-form input:focus { outline: none; border-color: #dc143c; box-shadow: 0 0 0 3px rgba(220, 20, 60, 0.1); }
        .filters-section { display: flex; gap: 12px; flex-wrap: wrap; align-items: flex-end; }
        .filter-group { display: flex; flex-direction: column; gap: 6px; }
        .filter-group label { font-size: 13px; font-weight: 600; color: #495057; }
        .filter-group select, .filter-group input[type="date"] { padding: 10px 14px; border: 1px solid #ced4da; border-radius: 6px; font-size: 14px; cursor: pointer; background: white; min-width: 150px; }
        .filter-group select:focus, .filter-group input[type="date"]:focus { outline: none; border-color: #dc143c; box-shadow: 0 0 0 3px rgba(220, 20, 60, 0.1); }
        .filter-actions { display: flex; gap: 8px; align-items: flex-end; }
        .btn-filter { padding: 10px 20px; background: #dc143c; color: white; border: none; border-radius: 6px; font-size: 14px; font-weight: 500; cursor: pointer; white-space: nowrap; height: 42px; }
        .btn-filter:hover { background: #b8102f; }
        .btn-clear { padding: 10px 20px; background: #6c757d; color: white; border: none; border-radius: 6px; font-size: 14px; font-weight: 500; cursor: pointer; white-space: nowrap; text-decoration: none; display: inline-block; height: 42px; line-height: 22px; }
        .btn-clear:hover { background: #5a6268; }
        .divider { width: 100%; height: 1px; background: #e9ecef; margin: 16px 0; }
    </style>
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
            <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 30px;">
                <div>
                    <h1 style="font-size: 28px; font-weight: 700; margin: 0; color: #212529;">Booking Records</h1>
                    <p style="margin: 5px 0 0 0; color: #6c757d;">Manage and track all customer reservations.</p>
                </div>
            </div>
            
            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <h3>Total Bookings</h3>
                    <p class="stat-value">${totalBookings}</p>
                    <div style="margin-top: 15px; display: flex; align-items: center; font-size: 12px; font-weight: 700; color: #dc143c;">
                        <span class="material-symbols-outlined" style="font-size: 16px; margin-right: 5px;">confirmation_number</span>
                        All time reservations
                    </div>
                </div>
                <div class="stat-card confirmed">
                    <h3>Confirmed</h3>
                    <p class="stat-value">${confirmedBookings}</p>
                    <div style="margin-top: 15px; display: flex; align-items: center; font-size: 12px; font-weight: 700; color: #2ecc71;">
                        <span class="material-symbols-outlined" style="font-size: 16px; margin-right: 5px;">check_circle</span>
                        Successful bookings
                    </div>
                </div>
                <div class="stat-card cancelled">
                    <h3>Cancelled</h3>
                    <p class="stat-value">${cancelledBookings}</p>
                    <div style="margin-top: 15px; display: flex; align-items: center; font-size: 12px; font-weight: 700; color: #e74c3c;">
                        <span class="material-symbols-outlined" style="font-size: 16px; margin-right: 5px;">cancel</span>
                        Refunded or cancelled
                    </div>
                </div>
                <div class="stat-card today">
                    <h3>Today's Bookings</h3>
                    <p class="stat-value">${todayBookings}</p>
                    <div style="margin-top: 15px; display: flex; align-items: center; font-size: 12px; font-weight: 700; color: #3498db;">
                        <span class="material-symbols-outlined" style="font-size: 16px; margin-right: 5px;">today</span>
                        Bookings made today
                    </div>
                </div>
            </div>
            
            <c:if test="${not empty param.success}">
                <div class="success-message">${param.success}</div>
            </c:if>
            
            <c:if test="${not empty param.error}">
                <div class="error-message">${param.error}</div>
            </c:if>
            
            <!-- Filter Bar -->
            <div class="filter-bar">
                <!-- Search Section -->
                <div class="search-section">
                    <form action="${pageContext.request.contextPath}/manageBookings" method="get" class="search-form">
                        <input type="text" name="search" placeholder="Search by user, movie, or booking ID..." value="${param.search}">
                        <button type="submit" class="btn-filter">Search</button>
                    </form>
                </div>
                
                <div class="divider"></div>
                
                <!-- Filter Section -->
                <form action="${pageContext.request.contextPath}/manageBookings" method="get" class="filters-section">
                    <div class="filter-group">
                        <label>Quick Filter</label>
                        <select name="period" id="periodSelect" onchange="handlePeriodChange()">
                            <option value="" ${empty param.period ? 'selected' : ''}>All Time</option>
                            <option value="today" ${param.period == 'today' ? 'selected' : ''}>Today</option>
                            <option value="week" ${param.period == 'week' ? 'selected' : ''}>This Week</option>
                            <option value="month" ${param.period == 'month' ? 'selected' : ''}>This Month</option>
                            <option value="custom" ${param.period == 'custom' ? 'selected' : ''}>Custom Range</option>
                        </select>
                    </div>
                    
                    <div class="filter-group" id="startDateGroup" style="display: ${param.period == 'custom' ? 'flex' : 'none'};">
                        <label>Start Date</label>
                        <input type="date" name="startDate" id="startDate" value="${param.startDate}">
                    </div>
                    
                    <div class="filter-group" id="endDateGroup" style="display: ${param.period == 'custom' ? 'flex' : 'none'};">
                        <label>End Date</label>
                        <input type="date" name="endDate" id="endDate" value="${param.endDate}">
                    </div>
                    
                    <div class="filter-group">
                        <label>Status</label>
                        <select name="status">
                            <option value="all" ${param.status == 'all' || empty param.status ? 'selected' : ''}>All Status</option>
                            <option value="Confirmed" ${param.status == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                            <option value="Cancelled" ${param.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                            <option value="Completed" ${param.status == 'Completed' ? 'selected' : ''}>Completed</option>
                        </select>
                    </div>
                    
                    <div class="filter-actions">
                        <button type="submit" class="btn-filter">Apply Filters</button>
                        <c:if test="${not empty param.search || not empty param.period || not empty param.status || not empty param.startDate}">
                            <a href="${pageContext.request.contextPath}/manageBookings" class="btn-clear">Clear All</a>
                        </c:if>
                    </div>
                </form>
            </div>
            
            <script>
                function handlePeriodChange() {
                    const period = document.getElementById('periodSelect').value;
                    const startDateGroup = document.getElementById('startDateGroup');
                    const endDateGroup = document.getElementById('endDateGroup');
                    
                    if (period === 'custom') {
                        startDateGroup.style.display = 'flex';
                        endDateGroup.style.display = 'flex';
                    } else {
                        startDateGroup.style.display = 'none';
                        endDateGroup.style.display = 'none';
                        // Auto-submit for quick filters
                        if (period !== '') {
                            document.querySelector('.filters-section').submit();
                        }
                    }
                }
            </script>
            
            <!-- Bookings table -->
            <div class="table-container">
                <table class="data-table" data-paginate="true" data-rows-per-page="8">
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
                                        <td>${booking.bookingId}</td>
                                        <td>${booking.userName}</td>
                                        <td>${booking.movieTitle}</td>
                                        <td><fmt:formatDate value="${booking.bookingDate}" pattern="MMM dd, yyyy HH:mm"/></td>
                                        <td>${booking.showTime}</td>
                                        <td>${booking.numberOfSeats}</td>
                                        <td>Rs. <fmt:formatNumber value="${booking.totalPrice}" pattern="#,##0.00"/></td>
                                        <td>
                                            <span class="status-badge ${booking.status.toLowerCase()}">${booking.status}</span>
                                        </td>
                                        <td>
                                            <div style="display: flex; gap: 8px; align-items: center;">
                                                <form action="${pageContext.request.contextPath}/manageBookings" method="post" style="display:inline;">
                                                    <input type="hidden" name="action" value="updateStatus">
                                                    <input type="hidden" name="bookingId" value="${booking.bookingId}">
                                                    <select name="status" onchange="this.form.submit()" style="padding: 6px 10px; border: 1px solid #ced4da; border-radius: 4px; font-size: 13px; cursor: pointer;">
                                                        <option value="Confirmed" ${booking.status == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                                                        <option value="Cancelled" ${booking.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                                        <option value="Completed" ${booking.status == 'Completed' ? 'selected' : ''}>Completed</option>
                                                    </select>
                                                </form>
                                                <a href="${pageContext.request.contextPath}/manageBookings?action=delete&id=${booking.bookingId}" onclick="return confirm('Delete this booking?')" style="padding: 6px 10px; background: white; color: #dc3545; border: 1px solid rgba(220, 53, 69, 0.2); border-radius: 4px; text-decoration: none; display: inline-flex; align-items: center; justify-center; transition: all 0.2s;" onmouseover="this.style.backgroundColor='#dc3545'; this.style.color='white';" onmouseout="this.style.backgroundColor='white'; this.style.color='#dc3545';" title="Delete Booking">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">delete</span>
                                                </a>
                                            </div>
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
    <script src="${pageContext.request.contextPath}/js/pagination.js"></script>
</body>
</html>
