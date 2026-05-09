<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bookings - MovieMint Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background: #f0f0f1; }
        .admin-wrap { max-width: 1160px; margin: 0 auto; padding: 24px 20px 40px; }
        .page-header { margin-bottom: 18px; }
        .page-header h1 { font-size: 20px; font-weight: 700; color: #111; margin-bottom: 2px; }
        .page-header p { font-size: 13px; color: #666; }

        .stats-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; margin-bottom: 16px; }
        .stat-box { background: #fff; border: 1px solid #ddd; border-left: 3px solid #ccc; border-radius: 3px; padding: 14px 16px; }
        .stat-box.red { border-left-color: #c9152f; }
        .stat-box.green { border-left-color: #218a3a; }
        .stat-box.orange { border-left-color: #e09000; }
        .stat-box.blue { border-left-color: #3498db; }
        .stat-box .label { font-size: 11px; font-weight: 600; color: #888; text-transform: uppercase; letter-spacing: 0.3px; margin-bottom: 6px; }
        .stat-box .value { font-size: 24px; font-weight: 700; color: #111; }
        .stat-box .sub { font-size: 11px; color: #aaa; margin-top: 4px; }

        .filter-bar { background: #fff; border: 1px solid #ddd; border-radius: 3px; padding: 14px 16px; margin-bottom: 12px; display: flex; flex-direction: column; gap: 10px; }

        /* Search row */
        .search-section {}
        .search-form { display: flex; gap: 6px; }
        .search-form input { flex: 1; padding: 7px 10px; border: 1px solid #ccc; border-radius: 3px; font-size: 13px; font-family: inherit; }
        .search-form input:focus { outline: none; border-color: #c9152f; }

        /* Filter row */
        .filters-section { display: flex; gap: 8px; align-items: flex-end; flex-wrap: wrap; }
        .filter-group { display: flex; flex-direction: column; gap: 3px; }
        .filter-group label { font-size: 11px; font-weight: 600; color: #777; text-transform: uppercase; letter-spacing: 0.3px; }
        .filter-group input, .filter-group select { padding: 7px 10px; border: 1px solid #ccc; border-radius: 3px; font-size: 13px; background: #fff; font-family: inherit; }
        .filter-group input:focus, .filter-group select:focus { outline: none; border-color: #c9152f; }
        .filter-actions { display: flex; gap: 6px; align-items: flex-end; padding-bottom: 1px; }

        .divider { border: none; border-top: 1px solid #eee; margin: 2px 0; }

        /* Filter / Clear buttons */
        .btn-filter {
            padding: 7px 14px;
            background: #c9152f;
            color: #fff;
            border: none;
            border-radius: 3px;
            font-size: 13px;
            font-family: inherit;
            font-weight: 600;
            cursor: pointer;
            white-space: nowrap;
        }
        .btn-filter:hover { background: #a01026; }

        .btn-clear {
            padding: 7px 12px;
            background: #fff;
            color: #555;
            border: 1px solid #ccc;
            border-radius: 3px;
            font-size: 13px;
            font-family: inherit;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            white-space: nowrap;
        }
        .btn-clear:hover { border-color: #c9152f; color: #c9152f; text-decoration: none; }

        .status-badge { padding: 2px 8px; border-radius: 2px; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.3px; }
        .status-badge.confirmed { background: #e2f5e8; color: #1a5c2b; }
        .status-badge.cancelled { background: #fde8ec; color: #8b1a25; }
        .status-badge.completed { background: #e8f0fe; color: #1a4a8b; }

        .success-message { background: #e2f5e8; color: #1a5c2b; border: 1px solid #b8e0c4; border-radius: 3px; padding: 9px 12px; font-size: 13px; margin-bottom: 10px; }
        .error-message { background: #fde8ec; color: #8b1a25; border: 1px solid #f5c6cb; border-radius: 3px; padding: 9px 12px; font-size: 13px; margin-bottom: 10px; }

        @media (max-width: 900px) { .stats-row { grid-template-columns: 1fr 1fr; } }
    </style>
</head>
<body>
    <c:if test="${empty user || user.role != 'admin'}">
        <c:redirect url="login"/>
    </c:if>

    <jsp:include page="adminHeader.jsp" />

    <div class="admin-wrap">
        <div class="page-header">
            <h1>Bookings</h1>
            <p>All customer reservations</p>
        </div>

        <div class="stats-row">
            <div class="stat-box red">
                <div class="label">Total</div>
                <div class="value">${totalBookings}</div>
                <div class="sub">all time</div>
            </div>
            <div class="stat-box green">
                <div class="label">Confirmed</div>
                <div class="value">${confirmedBookings}</div>
                <div class="sub">successful</div>
            </div>
            <div class="stat-box orange">
                <div class="label">Cancelled</div>
                <div class="value">${cancelledBookings}</div>
                <div class="sub">refunded</div>
            </div>
            <div class="stat-box blue">
                <div class="label">Today</div>
                <div class="value">${todayBookings}</div>
                <div class="sub">bookings today</div>
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
            <div class="table-wrap" style="background:#fff;border:1px solid #ddd;border-radius:3px;overflow-x:auto;">
                <table class="data-table" data-paginate="true" data-rows-per-page="8">
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
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty bookings}">
                                <c:forEach var="booking" items="${bookings}">
                                    <tr>
                                        <td>${booking.bookingId}</td>
                                        <td>${booking.userName}</td>
                                        <td>${booking.movieTitle}</td>
                                        <td><fmt:formatDate value="${booking.bookingDate}" pattern="dd MMM yyyy HH:mm"/></td>
                                        <td>${booking.showTime}</td>
                                        <td>${booking.numberOfSeats}</td>
                                        <td>Rs. <fmt:formatNumber value="${booking.totalPrice}" pattern="#,##0.00"/></td>
                                        <td>
                                            <span class="status-badge ${booking.status.toLowerCase()}">${booking.status}</span>
                                        </td>
                                        <td style="white-space:nowrap">
                                            <form action="${pageContext.request.contextPath}/manageBookings" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="bookingId" value="${booking.bookingId}">
                                                <select name="status" onchange="this.form.submit()" style="padding:4px 8px;border:1px solid #ccc;border-radius:3px;font-size:12px;cursor:pointer;">
                                                    <option value="Confirmed" ${booking.status == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                                                    <option value="Cancelled" ${booking.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                                    <option value="Completed" ${booking.status == 'Completed' ? 'selected' : ''}>Completed</option>
                                                </select>
                                            </form>
                                            <a href="${pageContext.request.contextPath}/manageBookings?action=delete&id=${booking.bookingId}"
                                               onclick="return confirm('Delete this booking?')"
                                               class="btn-delete" style="text-decoration:none">Del</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="9" style="text-align:center;padding:28px;color:#aaa;font-size:13px;">No bookings found.</td></tr>
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
