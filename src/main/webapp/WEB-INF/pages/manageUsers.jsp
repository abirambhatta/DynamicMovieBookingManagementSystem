<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - MovieMint Admin</title>
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
            <h1>Manage Users</h1>
            
            <!-- Show success message if action was successful -->
            <c:if test="${not empty param.success}">
                <div class="success-message">${param.success}</div>
            </c:if>
            
            <!-- Show error message if action failed -->
            <c:if test="${not empty param.error}">
                <div class="error-message">${param.error}</div>
            </c:if>
            
            <!-- Search and sort section -->
            <div class="search-section">
                <!-- Search form to find users by name or email -->
                <form action="${pageContext.request.contextPath}/manageUsers" method="get">
                    <!-- Search input field -->
                    <input type="text" name="search" placeholder="Search users...">
                    <!-- Search button -->
                    <button type="submit" class="btn-search">Search</button>
                </form>
                
                <!-- Sort options -->
                <div class="sort-options">
                    <!-- Sort users by name -->
                    <a href="${pageContext.request.contextPath}/manageUsers?sort=name" class="btn-sort">Sort by Name</a>
                    <!-- Sort users by registration date -->
                    <a href="${pageContext.request.contextPath}/manageUsers?sort=date" class="btn-sort">Sort by Date</a>
                    <!-- Sort users by number of bookings -->
                    <a href="${pageContext.request.contextPath}/manageUsers?sort=bookings" class="btn-sort">Sort by Bookings</a>
                </div>
            </div>
            
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
                            <th>Bookings</th>
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
                                        <!-- User ID -->
                                        <td>${u.userId}</td>
                                        <!-- User full name -->
                                        <td>${u.fullName}</td>
                                        <!-- User email address -->
                                        <td>${u.email}</td>
                                        <!-- User role (admin or user) -->
                                        <td>${u.role}</td>
                                        <!-- User phone number -->
                                        <td>${u.phone}</td>
                                        <!-- Number of bookings made by user -->
                                        <td>${u.bookingCount}</td>
                                        <!-- Action buttons -->
                                        <td>
                                            <!-- Delete button with confirmation -->
                                            <a href="${pageContext.request.contextPath}/manageUsers?action=delete&id=${u.userId}" class="btn-delete" onclick="return confirm('Are you sure you want to delete this user?')">Delete</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <!-- Show message if no users found -->
                                <tr>
                                    <td colspan="7">No users found.</td>
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
