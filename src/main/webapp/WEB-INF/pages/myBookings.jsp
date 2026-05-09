<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookings - MovieMint</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background: #f4f4f5; }

        .page-wrap {
            max-width: 860px;
            margin: 0 auto;
            padding: 24px 20px;
        }

        .page-heading {
            font-size: 20px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 20px;
        }

        .section-label {
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #888;
            margin-bottom: 10px;
            padding-bottom: 6px;
            border-bottom: 1px solid #e8e8e8;
        }

        /* Upcoming bookings - larger card */
        .booking-upcoming {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 18px;
            display: flex;
            gap: 16px;
            margin-bottom: 12px;
            align-items: flex-start;
        }

        .booking-poster {
            width: 72px;
            flex-shrink: 0;
        }

        .booking-poster img {
            width: 72px;
            height: 100px;
            object-fit: cover;
            border-radius: 4px;
            border: 1px solid #e0e0e0;
            display: block;
        }

        .booking-poster-placeholder {
            width: 72px;
            height: 100px;
            background: #e8e8e8;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 10px;
            color: #aaa;
        }

        .booking-body {
            flex: 1;
            min-width: 0;
        }

        .booking-ref {
            font-size: 11px;
            color: #aaa;
            margin-bottom: 3px;
        }

        .booking-title {
            font-size: 17px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 8px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .booking-meta-row {
            display: flex;
            flex-wrap: wrap;
            gap: 14px;
            font-size: 13px;
            color: #555;
            margin-bottom: 12px;
        }

        .booking-meta-row span { white-space: nowrap; }

        .badge-confirmed {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 3px;
            font-size: 11px;
            font-weight: 600;
            background: #e2f5e8;
            color: #1a5c2b;
            border: 1px solid #b8e0c4;
        }

        .btn-view-ticket {
            display: inline-block;
            padding: 7px 14px;
            background: #c9152f;
            color: #fff;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 500;
            text-decoration: none;
        }

        .btn-view-ticket:hover { background: #a01026; text-decoration: none; color: #fff; }

        /* Past bookings - compact list */
        .past-section { margin-top: 28px; }

        .booking-past {
            background: #fff;
            border: 1px solid #e4e4e4;
            border-radius: 5px;
            padding: 12px 16px;
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 6px;
        }

        .booking-past-thumb {
            width: 36px;
            height: 48px;
            object-fit: cover;
            border-radius: 3px;
            background: #e8e8e8;
            flex-shrink: 0;
        }

        .booking-past-title {
            font-size: 14px;
            font-weight: 600;
            color: #1a1a1a;
            flex: 1;
            min-width: 0;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .booking-past-time {
            font-size: 12px;
            color: #888;
            white-space: nowrap;
        }

        .badge-cancelled {
            display: inline-block;
            padding: 2px 7px;
            border-radius: 3px;
            font-size: 11px;
            font-weight: 600;
            background: #fde8ec;
            color: #8b1a25;
            border: 1px solid #f5c6cb;
            white-space: nowrap;
        }

        .badge-completed {
            display: inline-block;
            padding: 2px 7px;
            border-radius: 3px;
            font-size: 11px;
            font-weight: 600;
            background: #f0f0f0;
            color: #555;
            border: 1px solid #ddd;
            white-space: nowrap;
        }

        .past-actions {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .past-actions a {
            font-size: 12px;
            color: #666;
            text-decoration: none;
        }

        .past-actions a:hover { color: #c9152f; }

        .empty-notice {
            font-size: 13px;
            color: #999;
            font-style: italic;
            padding: 12px 0;
        }

        .empty-state {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 48px;
            text-align: center;
            color: #888;
        }

        .empty-state h2 { font-size: 18px; font-weight: 600; margin-bottom: 8px; color: #444; }
        .empty-state p { font-size: 14px; margin-bottom: 16px; }
        .empty-state a {
            display: inline-block;
            padding: 8px 18px;
            background: #c9152f;
            color: #fff;
            border-radius: 4px;
            text-decoration: none;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <c:if test="${empty user}"><c:redirect url="login"/></c:if>

    <jsp:include page="userHeader.jsp" />

    <div class="page-wrap">
        <h1 class="page-heading">My Bookings</h1>

        <c:choose>
            <c:when test="${not empty bookings}">

                <%-- Upcoming --%>
                <div class="section-label">Upcoming</div>

                <c:set var="hasUpcoming" value="false" />
                <c:forEach var="booking" items="${bookings}">
                    <c:if test="${booking.status == 'Confirmed'}">
                        <c:set var="hasUpcoming" value="true" />
                        <div class="booking-upcoming">
                            <div class="booking-poster">
                                <c:choose>
                                    <c:when test="${not empty booking.moviePoster}">
                                        <img src="${pageContext.request.contextPath}/images/${booking.moviePoster}" alt="${booking.movieTitle}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="booking-poster-placeholder">—</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="booking-body">
                                <div class="booking-ref">Booking #${booking.bookingId} &nbsp;<span class="badge-confirmed">Confirmed</span></div>
                                <div class="booking-title">${booking.movieTitle}</div>
                                <div class="booking-meta-row">
                                    <span>Time: <c:out value="${booking.showTime}" /></span>
                                    <span>Seats: ${booking.numberOfSeats}</span>
                                    <span>Total: Rs. ${booking.totalPrice}</span>
                                </div>
                                <a href="${pageContext.request.contextPath}/ticketConfirmation?bookingId=${booking.bookingId}" class="btn-view-ticket">View Ticket</a>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
                <c:if test="${!hasUpcoming}">
                    <p class="empty-notice">No upcoming bookings.</p>
                </c:if>

                <%-- Past / Cancelled --%>
                <div class="past-section">
                    <div class="section-label">Past &amp; Cancelled</div>

                    <c:set var="hasPast" value="false" />
                    <c:forEach var="booking" items="${bookings}">
                        <c:if test="${booking.status == 'Cancelled' || booking.status == 'Completed'}">
                            <c:set var="hasPast" value="true" />
                            <div class="booking-past">
                                <c:choose>
                                    <c:when test="${not empty booking.moviePoster}">
                                        <img class="booking-past-thumb" src="${pageContext.request.contextPath}/images/${booking.moviePoster}" alt="${booking.movieTitle}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="booking-past-thumb" style="background:#e4e4e4; border-radius:3px;"></div>
                                    </c:otherwise>
                                </c:choose>

                                <div class="booking-past-title">${booking.movieTitle}</div>
                                <div class="booking-past-time">#${booking.bookingId}</div>

                                <c:choose>
                                    <c:when test="${booking.status == 'Cancelled'}">
                                        <span class="badge-cancelled">Cancelled</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-completed">Completed</span>
                                    </c:otherwise>
                                </c:choose>

                                <div class="past-actions">
                                    <a href="${pageContext.request.contextPath}/ticketConfirmation?bookingId=${booking.bookingId}">Details</a>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                    <c:if test="${!hasPast}">
                        <p class="empty-notice">No past bookings.</p>
                    </c:if>
                </div>

            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <h2>No bookings yet</h2>
                    <p>You haven't booked any tickets so far.</p>
                    <a href="${pageContext.request.contextPath}/browseMovies">Browse movies</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
