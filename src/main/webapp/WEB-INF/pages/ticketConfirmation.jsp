<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Confirmed | MovieMint</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* ===== Ticket Confirmation Page Styles ===== */
        .confirmation-wrapper {
            min-height: 100vh;
            background: linear-gradient(135deg, #1a0000 0%, #3d0000 50%, #1a0000 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        .ticket-card {
            background: #fff;
            border-radius: 20px;
            max-width: 620px;
            width: 100%;
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.5);
            overflow: hidden;
            position: relative;
        }

        /* Ticket top header strip */
        .ticket-header {
            background: linear-gradient(135deg, #dc143c, #9b0c0c);
            padding: 32px 40px 28px;
            color: white;
            text-align: center;
            position: relative;
        }

        .ticket-header::after {
            content: '';
            position: absolute;
            bottom: -1px;
            left: 0;
            right: 0;
            height: 24px;
            background: white;
            border-radius: 50% 50% 0 0 / 100% 100% 0 0;
        }

        .checkmark-circle {
            width: 64px;
            height: 64px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            margin: 0 auto 16px;
            border: 3px solid rgba(255, 255, 255, 0.5);
        }

        .ticket-header h1 {
            font-size: 1.6rem;
            font-weight: 800;
            margin: 0 0 6px;
            letter-spacing: 0.02em;
        }

        .ticket-header p {
            font-size: 0.9rem;
            opacity: 0.85;
            margin: 0;
        }

        /* Dashed tear line separator */
        .tear-line {
            display: flex;
            align-items: center;
            padding: 0 32px;
            margin: 8px 0;
        }

        .tear-circle-left,
        .tear-circle-right {
            width: 28px;
            height: 28px;
            background: linear-gradient(135deg, #1a0000, #3d0000);
            border-radius: 50%;
            flex-shrink: 0;
        }

        .tear-circle-left { margin-left: -44px; }
        .tear-circle-right { margin-right: -44px; }

        .tear-dash {
            flex: 1;
            border-top: 2px dashed #e0e0e0;
            margin: 0 8px;
        }

        /* Ticket body */
        .ticket-body {
            padding: 24px 40px 32px;
        }

        .movie-title-row {
            text-align: center;
            margin-bottom: 24px;
        }

        .movie-title-row h2 {
            font-size: 1.4rem;
            font-weight: 800;
            color: #141d23;
            margin: 0 0 8px;
        }

        .badge-row {
            display: flex;
            gap: 8px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .badge {
            display: inline-block;
            padding: 3px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .badge-order { background: #e8f4f8; color: #2980b9; }
        .badge-format { background: #fef9e7; color: #f39c12; }

        /* Info grid */
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 24px;
        }

        .info-item {
            background: #f9fbfd;
            border: 1px solid #e8edf2;
            border-radius: 10px;
            padding: 14px 16px;
        }

        .info-item.full-width {
            grid-column: 1 / -1;
        }

        .info-label {
            font-size: 10px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.12em;
            color: #5c3f3f;
            margin-bottom: 5px;
        }

        .info-value {
            font-size: 0.97rem;
            font-weight: 700;
            color: #141d23;
        }

        .info-value.price {
            font-size: 1.25rem;
            color: #dc143c;
        }

        /* Seats display */
        .seats-display {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
            margin-top: 4px;
        }

        .seat-chip {
            background: #dc143c;
            color: white;
            padding: 3px 10px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 700;
        }

        /* QR section */
        .qr-section {
            text-align: center;
            border-top: 1px dashed #e0e0e0;
            padding-top: 24px;
            margin-bottom: 8px;
        }

        .qr-label {
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.12em;
            color: #5c3f3f;
            margin-bottom: 12px;
        }

        .qr-image {
            display: inline-block;
            background: white;
            padding: 8px;
            border: 2px solid #e8edf2;
            border-radius: 12px;
        }

        .qr-image img {
            display: block;
            width: 120px;
            height: 120px;
        }

        /* Footer notice */
        .ticket-footer {
            background: #f9fbfd;
            border-top: 1px solid #e8edf2;
            padding: 16px 40px;
            text-align: center;
        }

        .ticket-footer p {
            font-size: 12px;
            color: #5d5f5f;
            margin: 0 0 4px;
        }

        .ticket-actions {
            display: flex;
            gap: 12px;
            justify-content: center;
            margin-top: 16px;
            flex-wrap: wrap;
        }

        .btn-print {
            background: #dc143c;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 10px 24px;
            font-weight: 700;
            font-size: 0.88rem;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: background 0.2s;
        }

        .btn-print:hover { background: #b71c1c; }

        .btn-home {
            background: white;
            color: #dc143c;
            border: 2px solid #dc143c;
            border-radius: 8px;
            padding: 10px 24px;
            font-weight: 700;
            font-size: 0.88rem;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.2s;
        }

        .btn-home:hover { background: #dc143c; color: white; }

        @media print {
            .ticket-actions, .confirmation-wrapper > *:not(.ticket-card) { display: none; }
            .confirmation-wrapper { background: white; padding: 0; }
            .ticket-card { box-shadow: none; }
        }
    </style>
</head>
<body>

<div class="confirmation-wrapper">
    <div class="ticket-card">

        <%-- ===== TICKET HEADER ===== --%>
        <div class="ticket-header">
            <div class="checkmark-circle">&#10003;</div>
            <h1>Booking Confirmed!</h1>
            <p>Your tickets are ready. Show this at the cinema entrance.</p>
        </div>

        <%-- === TEAR LINE === --%>
        <div class="tear-line">
            <div class="tear-circle-left"></div>
            <div class="tear-dash"></div>
            <div class="tear-circle-right"></div>
        </div>

        <%-- ===== TICKET BODY ===== --%>
        <div class="ticket-body">

            <%-- Movie title and order ID --%>
            <div class="movie-title-row">
                <h2>${not empty booking ? booking.movieTitle : (not empty movie ? movie.title : 'Your Movie')}</h2>
                <div class="badge-row">
                    <c:if test="${not empty bookingId}">
                        <span class="badge badge-order">Order #${bookingId}</span>
                    </c:if>
                    <c:if test="${not empty movie and not empty movie.format}">
                        <span class="badge badge-format">${movie.format}</span>
                    </c:if>
                </div>
            </div>

            <%-- Booking detail grid --%>
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">Date</div>
                    <div class="info-value">${not empty showDate ? showDate : 'N/A'}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Show Time</div>
                    <div class="info-value">${not empty showTime ? showTime : 'N/A'}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Hall</div>
                    <div class="info-value">${not empty hall ? hall : 'Grand Hall'}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Seats Booked</div>
                    <div class="info-value">${not empty numberOfSeats ? numberOfSeats : '1'}</div>
                </div>
                <div class="info-item full-width">
                    <div class="info-label">Seat Numbers</div>
                    <div class="seats-display">
                        <c:choose>
                            <c:when test="${not empty seatIds}">
                                <c:forEach var="seat" items="${seatIds}">
                                    <span class="seat-chip">${seat}</span>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <span class="info-value">See counter for seat assignment</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="info-item full-width">
                    <div class="info-label">Total Amount Paid</div>
                    <div class="info-value price">Rs. ${not empty totalPrice ? totalPrice : '0.00'}</div>
                </div>
            </div>

            <%-- QR Code --%>
            <div class="qr-section">
                <div class="qr-label">Scan at Entrance</div>
                <div class="qr-image">
                    <%-- Generate QR using the Google Charts API with booking details --%>
                    <img
                        src="https://api.qrserver.com/v1/create-qr-code/?size=120x120&data=MOVMINT-BK${not empty bookingId ? bookingId : '0'}-${not empty showDate ? showDate : 'NA'}"
                        alt="Booking QR Code"
                        width="120"
                        height="120"
                    >
                </div>
            </div>

        </div>

        <%-- ===== TICKET FOOTER ===== --%>
        <div class="ticket-footer">
            <p>Please carry a photo ID along with this ticket.</p>
            <p>Doors open 30 minutes before showtime. No late entry.</p>
            <div class="ticket-actions">
                <button class="btn-print" onclick="window.print()">Print Ticket</button>
                <a href="${pageContext.request.contextPath}/userHome" class="btn-home">Back to Home</a>
                <a href="${pageContext.request.contextPath}/myBookings" class="btn-home">My Bookings</a>
            </div>
        </div>

    </div>
</div>

</body>
</html>
