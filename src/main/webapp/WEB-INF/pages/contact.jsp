<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - MovieMint</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <c:set var="currentUser" value="${sessionScope.user}" />

    <!-- Check if user is logged in and include appropriate header -->
    <c:if test="${not empty currentUser}">
        <c:choose>
            <!-- If user is admin, show admin header -->
            <c:when test="${currentUser.role == 'admin'}">
                <jsp:include page="adminHeader.jsp" />
            </c:when>
            <!-- If user is regular user, show user header -->
            <c:otherwise>
                <jsp:include page="userHeader.jsp" />
            </c:otherwise>
        </c:choose>
    </c:if>
    
    <div class="main-content">
        <div class="contact-container">
            <h1>Contact Us</h1>
            
            <!-- Show success message if message was sent -->
            <c:if test="${not empty success}">
                <div class="success-message">${success}</div>
            </c:if>
            
            <!-- Show error message if sending failed -->
            <c:if test="${not empty error}">
                <div class="error-message">${error}</div>
            </c:if>
            
            <!-- Contact form -->
            <div class="contact-form">
                <form action="${pageContext.request.contextPath}/contact" method="post">
                    <!-- Name input field -->
                    <div class="form-group">
                        <label for="name">Name:</label>
                        <input type="text" id="name" name="name" value="${param.name}" required>
                    </div>
                    
                    <!-- Email input field -->
                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email" value="${param.email}" required>
                    </div>
                    
                    <!-- Subject input field -->
                    <div class="form-group">
                        <label for="subject">Subject:</label>
                        <input type="text" id="subject" name="subject" value="${param.subject}" required>
                    </div>
                    
                    <!-- Message textarea field -->
                    <div class="form-group">
                        <label for="message">Message:</label>
                        <textarea id="message" name="message" rows="5" required>${param.message}</textarea>
                    </div>
                    
                    <!-- Submit button to send message -->
                    <button type="submit" class="btn-primary">Send Message</button>
                </form>
            </div>
            
            <!-- Contact information section -->
            <div class="contact-info">
                <h2>Get In Touch</h2>
                <!-- Support email address -->
                <p><strong>Email:</strong> support@moviemint.com</p>
                <!-- Support phone number -->
                <p><strong>Phone:</strong> +1 234 567 8900</p>
                <!-- Office address -->
                <p><strong>Address:</strong> 123 Movie Street, Cinema City, CC 12345</p>
                <!-- Business hours -->
                <p><strong>Business Hours:</strong> Mon-Sun, 9:00 AM - 10:00 PM</p>
            </div>
        </div>
    </div>
</body>
</html>
