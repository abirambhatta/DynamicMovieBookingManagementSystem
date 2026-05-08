<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Confirmed - MovieMint</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background: #f4f4f5; }

        .page-wrap {
            max-width: 560px;
            margin: 32px auto;
            padding: 0 16px 40px;
        }

        .ticket {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 6px;
            overflow: hidden;
        }

        .ticket-top {
            background: #c9152f;
            color: #fff;
            padding: 20px 24px;
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .checkmark {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: 2px solid rgba(255,255,255,0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            flex-shrink: 0;
        }

        .ticket-top-text h1 {
            font-size: 17px;
            font-weight: 700;
            margin-bottom: 2px;
        }

        .ticket-top-text p {
            font-size: 13px;
            opacity: 0.85;
        }

        .tear-line {
            border-top: 2px dashed #e0e0e0;
            margin: 0 -1px;
        }

        .ticket-body {
            padding: 20px 24px;
        }

        .movie-name {
            font-size: 20px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 4px;
        }

        .order-ref {
            font-size: 12px;
            color: #aaa;
            margin-bottom: 18px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-bottom: 16px;
        }

        .info-item {
            background: #f7f7f7;
            border: 1px solid #ebebeb;
            border-radius: 4px;
            padding: 10px 12px;
        }

        .info-item.full {
            grid-column: 1 / -1;
        }

        .info-label {
            font-size: 10px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            color: #999;
            margin-bottom: 3px;
        }

        .info-value {
            font-size: 14px;
            font-weight: 600;
            color: #1a1a1a;
        }

        .info-value.price {
            font-size: 18px;
            color: #c9152f;
        }

        .seats-list {
            display: flex;
            flex-wrap: wrap;
            gap: 5px;
            margin-top: 4px;
        }

        .seat-tag {
            background: #c9152f;
            color: #fff;
            padding: 2px 8px;
            border-radius: 3px;
            font-size: 12px;
            font-weight: 600;
        }

        .qr-section {
            border-top: 1px dashed #ddd;
            padding-top: 16px;
            margin-top: 4px;
            text-align: center;
        }

        .qr-label {
            font-size: 11px;
            color: #aaa;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            margin-bottom: 10px;
        }

        .qr-section img {
            display: inline-block;
            border: 1px solid #e0e0e0;
            padding: 6px;
            border-radius: 4px;
        }

        .ticket-footer {
            background: #fafafa;
            border-top: 1px solid #ebebeb;
            padding: 14px 24px;
        }

        .ticket-note {
            font-size: 12px;
            color: #888;
            margin-bottom: 12px;
            line-height: 1.6;
        }

        .ticket-actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .btn-print {
            padding: 8px 16px;
            background: #c9152f;
            color: #fff;
            border: none;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
        }

        .btn-print:hover { background: #a01026; }

        .btn-secondary {
            padding: 8px 16px;
            background: #fff;
            color: #333;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
        }

        .btn-secondary:hover { border-color: #c9152f; color: #c9152f; text-decoration: none; }

        @media print {
            body { background: white; }
            .ticket-actions { display: none; }
            .ticket { border: none; box-shadow: none; }
        }
    </style>
</head>
<body>

<div class="page-wrap">
    <div class="ticket">
        <div class="ticket-top">
            <div class="checkmark">✓</div>
            <div class="ticket-top-text">
                <h1>Booking Confirmed</h1>
                <p>Show this ticket at the cinema entrance</p>
            </div>
        </div>

        <div class="tear-line"></div>

        <div class="ticket-body">
            <div class="movie-name">${not empty booking ? booking.movieTitle : (not empty movie ? movie.title : 'Movie')}</div>
            <div class="order-ref">
                Booking #${not empty bookingId ? bookingId : '—'}
                <c:if test="${not empty movie && not empty movie.format}"> &middot; ${movie.format}</c:if>
            </div>

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
                    <div class="info-value">${not empty hall ? hall : '—'}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Seats</div>
                    <div class="info-value">${not empty numberOfSeats ? numberOfSeats : '—'}</div>
                </div>
                <div class="info-item full">
                    <div class="info-label">Seat Numbers</div>
                    <c:choose>
                        <c:when test="${not empty seatIds}">
                            <div class="seats-list">
                                <c:forEach var="seat" items="${seatIds}">
                                    <span class="seat-tag">${seat}</span>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="info-value">Assigned at counter</div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="info-item full">
                    <div class="info-label">Amount Paid</div>
                    <div class="info-value price">Rs. ${not empty totalPrice ? totalPrice : '0.00'}</div>
                </div>
            </div>

            <div class="qr-section">
                <div class="qr-label">Scan at entrance</div>
                <img src="https://api.qrserver.com/v1/create-qr-code/?size=110x110&data=MOVMINT-${not empty bookingId ? bookingId : '0'}-${not empty showDate ? showDate : 'NA'}"
                     alt="Booking QR" width="110" height="110">
            </div>
        </div>

        <div class="ticket-footer">
            <p class="ticket-note">Please carry a photo ID. Doors open 30 mins before showtime.</p>
            <div class="ticket-actions">
                <button class="btn-print" onclick="window.print()">Print</button>
                <a href="${pageContext.request.contextPath}/myBookings" class="btn-secondary">My Bookings</a>
                <a href="${pageContext.request.contextPath}/userHome" class="btn-secondary">Home</a>
            </div>
        </div>
    </div>
</div>

</body>
</html>
