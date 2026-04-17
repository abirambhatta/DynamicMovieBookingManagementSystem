<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - MovieMint</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <c:set var="currentUser" value="${sessionScope.user}" />

    <c:if test="${not empty currentUser}">
        <c:choose>
            <c:when test="${currentUser.role == 'admin'}">
                <jsp:include page="adminHeader.jsp" />
            </c:when>
            <c:otherwise>
                <jsp:include page="userHeader.jsp" />
            </c:otherwise>
        </c:choose>
    </c:if>
    
    <div class="main-content">
        <div class="about-container">
            <h1>About MovieMint System</h1>
            
            <div class="about-section">
                <h2>Our Mission</h2>
                <p>We provide a seamless movie booking experience for cinema lovers. Our platform connects moviegoers with their favorite films, making ticket booking simple, fast, and convenient.</p>
            </div>
            
            <div class="about-section">
                <h2>Features</h2>
                <ul>
                    <li>Browse latest movies with detailed information</li>
                    <li>Easy online ticket booking</li>
                    <li>Multiple show times and seat options</li>
                    <li>Secure payment processing</li>
                    <li>Booking history and management</li>
                    <li>User-friendly interface</li>
                </ul>
            </div>
            
            <div class="about-section">
                <h2>Why Choose Us?</h2>
                <ul>
                    <li>24/7 online booking availability</li>
                    <li>Real-time seat availability</li>
                    <li>Instant booking confirmation</li>
                    <li>Customer support</li>
                    <li>Regular updates on new releases</li>
                </ul>
            </div>
            
            <div class="about-section">
                <h2>Contact Information</h2>
                <p><strong>Email:</strong> support@moviemint.com</p>
                <p><strong>Phone:</strong> +1 234 567 8900</p>
                <p><strong>Address:</strong> 123 Movie Street, Cinema City, CC 12345</p>
            </div>
        </div>
    </div>
</body>
</html>
