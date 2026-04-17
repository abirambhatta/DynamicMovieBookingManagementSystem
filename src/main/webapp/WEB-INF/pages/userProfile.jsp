<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - MovieMint</title>
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
            <h1>My Profile</h1>
            
            <!-- Show success message if profile was updated -->
            <c:if test="${not empty success}">
                <div class="success-message">${success}</div>
            </c:if>
            
            <!-- Show error message if update failed -->
            <c:if test="${not empty error}">
                <div class="error-message">${error}</div>
            </c:if>
            
            <!-- Profile update form -->
            <div class="profile-container">
                <form action="${pageContext.request.contextPath}/userProfile" method="post">
                    <!-- Full name input field -->
                    <div class="form-group">
                        <label for="fullName">Full Name:</label>
                        <input type="text" id="fullName" name="fullName" value="${user.fullName}" required>
                    </div>
                    
                    <!-- Email input field -->
                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email" value="${user.email}" required>
                    </div>
                    
                    <!-- Phone number input field (max 10 digits) -->
                    <div class="form-group">
                        <label for="phone">Phone:</label>
                        <input type="text" id="phone" name="phone" value="${user.phone}" maxlength="10" required>
                    </div>
                    
                    <!-- Submit button to save changes -->
                    <button type="submit" class="btn-primary">Update Profile</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
