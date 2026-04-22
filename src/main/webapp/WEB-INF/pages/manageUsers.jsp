<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - MovieMint Admin</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: white; padding: 24px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); border-left: 4px solid #dc143c; }
        .stat-card h3 { margin: 0 0 8px 0; font-size: 14px; color: #6c757d; font-weight: 500; text-transform: uppercase; letter-spacing: 0.5px; }
        .stat-card .stat-value { font-size: 32px; font-weight: 700; color: #2c3e50; margin: 0; }
        .stat-card.admins { border-left-color: #e74c3c; }
        .stat-card.new-users { border-left-color: #3498db; }
        .stat-card.active { border-left-color: #2ecc71; }
        .action-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; gap: 16px; flex-wrap: wrap; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .search-section { flex: 1; min-width: 300px; margin-bottom: 16px; }
        .search-form { display: flex; gap: 8px; }
        .search-form input { flex: 1; min-width: 250px; padding: 10px 14px; border: 1px solid #ced4da; border-radius: 6px; font-size: 15px; }
        .search-form input:focus { outline: none; border-color: #dc143c; box-shadow: 0 0 0 3px rgba(220, 20, 60, 0.1); }
        .divider { width: 100%; height: 1px; background: #e9ecef; margin: 0; }
        .filters-section { display: flex; gap: 12px; flex-wrap: wrap; align-items: flex-end; width: 100%; margin-top: 16px; }
        .filter-group { display: flex; flex-direction: column; gap: 6px; }
        .filter-group label { font-size: 13px; font-weight: 600; color: #495057; }
        .filter-group select, .filter-group input[type="date"] { padding: 10px 14px; border: 1px solid #ced4da; border-radius: 6px; font-size: 14px; cursor: pointer; background: white; min-width: 150px; }
        .filter-group select:focus, .filter-group input[type="date"]:focus { outline: none; border-color: #dc143c; box-shadow: 0 0 0 3px rgba(220, 20, 60, 0.1); }
        .filter-actions { display: flex; gap: 8px; align-items: flex-end; }
        .btn-filter { padding: 10px 20px; background: #dc143c; color: white; border: none; border-radius: 6px; font-size: 14px; font-weight: 500; cursor: pointer; white-space: nowrap; height: 42px; }
        .btn-filter:hover { background: #b8102f; }
        .btn-clear-filter { padding: 10px 20px; background: #6c757d; color: white; border: none; border-radius: 6px; font-size: 14px; font-weight: 500; cursor: pointer; white-space: nowrap; text-decoration: none; display: inline-block; height: 42px; line-height: 22px; }
        .btn-clear-filter:hover { background: #5a6268; }
        .sort-options { display: flex; gap: 8px; flex-wrap: wrap; }
        .btn-sort { padding: 10px 16px; background: white; color: #6c757d; border: 1px solid #ced4da; border-radius: 6px; text-decoration: none; font-size: 14px; font-weight: 500; transition: all 0.2s; user-select: none; }
        .btn-sort:hover { background: #f8f9fa; border-color: #adb5bd; color: #495057; }
        .btn-sort.active { background: #dc143c; color: white; border-color: #dc143c; }
        .role-select { padding: 6px 10px; border: 1px solid #ced4da; border-radius: 4px; font-size: 13px; cursor: pointer; background: white; transition: all 0.2s; }
        .role-select:hover { border-color: #dc143c; }
        .role-select:focus { outline: none; border-color: #dc143c; box-shadow: 0 0 0 3px rgba(220, 20, 60, 0.1); }
        .role-badge { padding: 4px 10px; border-radius: 12px; font-size: 12px; font-weight: 600; text-transform: uppercase; }
        .role-badge.admin { background: #fde8e8; color: #c0392b; }
        .role-badge.user { background: #e8f4f8; color: #2980b9; }
        .status-badge { padding: 4px 10px; border-radius: 12px; font-size: 11px; font-weight: 600; text-transform: uppercase; }
        .status-badge.active { background: #d4edda; color: #155724; }
        .status-badge.inactive { background: #f8d7da; color: #721c24; }
        .table-actions { display: flex; gap: 6px; align-items: center; }
        .btn-view { padding: 6px 12px; background: #3498db; color: white; border: none; border-radius: 4px; font-size: 13px; cursor: pointer; text-decoration: none; display: inline-block; }
        .btn-view:hover { background: #2980b9; }
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); }
        .modal-content { background: white; margin: 5% auto; padding: 0; border-radius: 12px; width: 90%; max-width: 600px; box-shadow: 0 4px 20px rgba(0,0,0,0.3); }
        .modal-header { padding: 20px 24px; border-bottom: 1px solid #dee2e6; display: flex; justify-content: space-between; align-items: center; }
        .modal-header h2 { margin: 0; font-size: 20px; color: #2c3e50; }
        .modal-close { font-size: 28px; font-weight: 300; color: #adb5bd; cursor: pointer; border: none; background: none; }
        .modal-close:hover { color: #495057; }
        .modal-body { padding: 24px; max-height: 60vh; overflow-y: auto; }
        .detail-row { display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid #f1f3f5; }
        .detail-row:last-child { border-bottom: none; }
        .detail-label { font-weight: 600; color: #6c757d; }
        .detail-value { color: #2c3e50; }
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
            <h1>Manage Users</h1>
            
            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <h3>Total Users</h3>
                    <p class="stat-value">${totalUsers}</p>
                </div>
                <div class="stat-card admins">
                    <h3>Admins</h3>
                    <p class="stat-value">${totalAdmins}</p>
                </div>
                <div class="stat-card new-users">
                    <h3>New This Month</h3>
                    <p class="stat-value">${newUsersThisMonth}</p>
                </div>
                <div class="stat-card active">
                    <h3>Active Users</h3>
                    <p class="stat-value">${activeUsers}</p>
                </div>
            </div>
            
            <!-- Show success message if action was successful -->
            <c:if test="${not empty param.success}">
                <div class="success-message">${param.success}</div>
            </c:if>
            
            <!-- Show error message if action failed -->
            <c:if test="${not empty param.error}">
                <div class="error-message">${param.error}</div>
            </c:if>
            
            <!-- Action bar with search and filters -->
            <div class="action-bar">
                <!-- Search section -->
                <div class="search-section">
                    <form action="${pageContext.request.contextPath}/manageUsers" method="get" class="search-form">
                        <input type="text" name="search" placeholder="Search by name or email..." value="${param.search}">
                        <button type="submit" class="btn-filter">Search</button>
                        <c:if test="${not empty param.search}">
                            <a href="${pageContext.request.contextPath}/manageUsers" class="btn-secondary" style="padding: 10px 16px; margin: 0;">Clear</a>
                        </c:if>
                    </form>
                </div>
                
                <div class="divider"></div>
                
                <!-- Filter and Sort Section -->
                <form action="${pageContext.request.contextPath}/manageUsers" method="get" class="filters-section">
                    <div class="filter-group">
                        <label>Role</label>
                        <select name="role" id="roleSelect">
                            <option value="all" ${param.role == 'all' || empty param.role ? 'selected' : ''}>All Roles</option>
                            <option value="admin" ${param.role == 'admin' ? 'selected' : ''}>Admin Only</option>
                            <option value="user" ${param.role == 'user' ? 'selected' : ''}>User Only</option>
                        </select>
                    </div>
                    
                    <div class="filter-group">
                        <label>Registration Period</label>
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
                        <label>Sort By</label>
                        <select name="sort">
                            <option value="" ${empty param.sort ? 'selected' : ''}>Default</option>
                            <option value="name" ${param.sort == 'name' ? 'selected' : ''}>Name (A-Z)</option>
                            <option value="bookings" ${param.sort == 'bookings' ? 'selected' : ''}>Most Bookings</option>
                        </select>
                    </div>
                    
                    <div class="filter-actions">
                        <button type="submit" class="btn-filter">Apply Filters</button>
                        <c:if test="${not empty param.role || not empty param.period || not empty param.sort || not empty param.startDate}">
                            <a href="${pageContext.request.contextPath}/manageUsers" class="btn-clear-filter">Clear All</a>
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
                    }
                }
            </script>
            
            <!-- Users table -->
            <div class="table-container">
                <table class="data-table">
                    <!-- Table header -->
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Full Name</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Phone</th>
                            <th>Registered</th>
                            <th>Bookings</th>
                            <th>Total Spent</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <!-- Table body -->
                    <tbody>
                        <!-- Check if users list has data -->
                        <c:choose>
                            <c:when test="${not empty users}">
                                <!-- Loop through each user -->
                                <c:forEach var="u" items="${users}">
                                    <tr>
                                        <td>${u.userId}</td>
                                        <td>${u.fullName}</td>
                                        <td>${u.email}</td>
                                        <td><span class="role-badge ${u.role}">${u.role}</span></td>
                                        <td>${u.phone}</td>
                                        <td><fmt:formatDate value="${u.registrationDate}" pattern="MMM dd, yyyy"/></td>
                                        <td>${u.bookingCount}</td>
                                        <td>Rs. <fmt:formatNumber value="${u.totalSpent}" pattern="#,##0.00"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${u.bookingCount > 0}">
                                                    <span class="status-badge active">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge inactive">Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="table-actions">
                                                <button onclick="viewUserDetails(${u.userId}, '${u.fullName}', '${u.email}', '${u.phone}', '${u.role}', '<fmt:formatDate value="${u.registrationDate}" pattern="MMM dd, yyyy"/>', ${u.bookingCount}, ${u.totalSpent})" class="btn-view">View</button>
                                                <select onchange="changeRole(${u.userId}, this.value, '${u.fullName}')" class="role-select">
                                                    <option value="">Change Role</option>
                                                    <option value="user" ${u.role == 'user' ? 'disabled' : ''}>Make User</option>
                                                    <option value="admin" ${u.role == 'admin' ? 'disabled' : ''}>Make Admin</option>
                                                </select>
                                                <a href="${pageContext.request.contextPath}/manageUsers?action=delete&id=${u.userId}" class="btn-delete" onclick="return confirm('Are you sure you want to delete ${u.fullName}?')">Delete</a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="10">No users found.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <!-- User Details Modal -->
    <div id="userModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>User Details</h2>
                <button class="modal-close" onclick="closeModal()">&times;</button>
            </div>
            <div class="modal-body">
                <div class="detail-row">
                    <span class="detail-label">User ID:</span>
                    <span class="detail-value" id="modal-userId"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Full Name:</span>
                    <span class="detail-value" id="modal-fullName"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Email:</span>
                    <span class="detail-value" id="modal-email"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Phone:</span>
                    <span class="detail-value" id="modal-phone"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Role:</span>
                    <span class="detail-value" id="modal-role"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Registered:</span>
                    <span class="detail-value" id="modal-registered"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Total Bookings:</span>
                    <span class="detail-value" id="modal-bookings"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Total Spent:</span>
                    <span class="detail-value" id="modal-spent"></span>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        function changeRole(userId, newRole, userName) {
            if (!newRole) return;
            
            const roleText = newRole === 'admin' ? 'Admin' : 'User';
            if (confirm('Change ' + userName + ' to ' + roleText + '?')) {
                window.location.href = '${pageContext.request.contextPath}/manageUsers?action=changeRole&id=' + userId + '&role=' + newRole;
            } else {
                event.target.value = '';
            }
        }
        
        function viewUserDetails(userId, fullName, email, phone, role, registered, bookings, spent) {
            document.getElementById('modal-userId').textContent = userId;
            document.getElementById('modal-fullName').textContent = fullName;
            document.getElementById('modal-email').textContent = email;
            document.getElementById('modal-phone').textContent = phone;
            document.getElementById('modal-role').textContent = role.toUpperCase();
            document.getElementById('modal-registered').textContent = registered;
            document.getElementById('modal-bookings').textContent = bookings;
            document.getElementById('modal-spent').textContent = 'Rs. ' + spent.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,');
            document.getElementById('userModal').style.display = 'block';
        }
        
        function closeModal() {
            document.getElementById('userModal').style.display = 'none';
        }
        
        window.onclick = function(event) {
            const modal = document.getElementById('userModal');
            if (event.target == modal) {
                closeModal();
            }
        }
    </script>
</body>
</html>
