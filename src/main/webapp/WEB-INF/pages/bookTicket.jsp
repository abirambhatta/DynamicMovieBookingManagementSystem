<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Ticket - MovieMint</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <c:if test="${empty user}">
        <c:redirect url="login"/>
    </c:if>
    
    <div class="dashboard">
        <jsp:include page="userHeader.jsp" />
        
        <div class="main-content">
            <h1>Book Ticket</h1>
            
            <div class="booking-info">
                <h2>${movie.title}</h2>
            </div>
            
            <c:if test="${not empty error}">
                <p class="error-message">${error}</p>
            </c:if>
            
            <div class="booking-form">
                <form action="${pageContext.request.contextPath}/bookTicket" method="post">
                    <input type="hidden" name="movieId" value="${movie.movieId}">
                    
                    <div class="form-group">
                        <label>Show Time:</label>
                        <select name="showTime" required>
                            <option value="">Select Time</option>
                            <option value="10:00 AM" ${param.showTime == '10:00 AM' ? 'selected' : ''}>10:00 AM</option>
                            <option value="1:00 PM" ${param.showTime == '1:00 PM' ? 'selected' : ''}>1:00 PM</option>
                            <option value="4:00 PM" ${param.showTime == '4:00 PM' ? 'selected' : ''}>4:00 PM</option>
                            <option value="7:00 PM" ${param.showTime == '7:00 PM' ? 'selected' : ''}>7:00 PM</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label>Seat Type:</label>
                        <select name="seatType" id="seatType" required onchange="updatePrice()">
                            <option value="Standard">Standard - Rs. ${standardPrice}</option>
                            <option value="Premium">Premium - Rs. ${premiumPrice}</option>
                            <option value="Recliner">Recliner - Rs. ${reclinerPrice}</option>
                            <option value="VIP">VIP - Rs. ${vipPrice}</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label>Number of Seats:</label>
                        <input type="number" name="numberOfSeats" id="numberOfSeats" value="${param.numberOfSeats}" min="1" max="10" required onchange="updatePrice()">
                    </div>
                    
                    <div class="form-group">
                        <p><strong>Price per seat:</strong> <span id="pricePerSeat">Rs. ${standardPrice}</span></p>
                        <p><strong>Total Price:</strong> <span id="totalPrice">Rs. ${standardPrice}</span></p>
                    </div>
                    
                    <button type="submit" class="btn-primary">Confirm Booking</button>
                    <a href="${pageContext.request.contextPath}/movieDetails?id=${movie.movieId}" class="btn-secondary">Cancel</a>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        // Store prices for each seat type
        const prices = {
            'Standard': ${standardPrice},
            'Premium': ${premiumPrice},
            'Recliner': ${reclinerPrice},
            'VIP': ${vipPrice}
        };
        
        // Update price display when seat type or number of seats changes
        function updatePrice() {
            // Get selected seat type from dropdown
            const seatType = document.getElementById('seatType').value;
            // Get number of seats, default to 1 if empty
            const numberOfSeats = parseInt(document.getElementById('numberOfSeats').value) || 1;
            // Get price for selected seat type
            const pricePerSeat = prices[seatType];
            // Calculate total price
            const totalPrice = pricePerSeat * numberOfSeats;
            
            // Update price per seat display
            document.getElementById('pricePerSeat').textContent = 'Rs. ' + pricePerSeat;
            // Update total price display
            document.getElementById('totalPrice').textContent = 'Rs. ' + totalPrice;
        }
    </script>
</body>
</html>
