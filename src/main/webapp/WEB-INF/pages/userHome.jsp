<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - MovieMint</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background: #f4f4f5; }

        .page-wrap {
            max-width: 1200px;
            margin: 0 auto;
            padding: 24px 20px;
        }

        .user-bar {
            background: #fff;
            border: 1px solid #ddd;
            border-left: 3px solid #c9152f;
            border-radius: 5px;
            padding: 16px 20px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px;
        }

        .user-bar h1 {
            font-size: 18px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 2px;
        }

        .user-bar small {
            font-size: 13px;
            color: #666;
        }

        .user-bar-actions {
            display: flex;
            gap: 8px;
        }

        .user-bar-actions a {
            padding: 7px 14px;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 500;
            text-decoration: none;
        }

        .btn-browse {
            background: #c9152f;
            color: #fff;
        }

        .btn-browse:hover { background: #a01026; }

        .btn-bookings {
            background: #fff;
            color: #333;
            border: 1px solid #ccc;
        }

        .btn-bookings:hover {
            border-color: #c9152f;
            color: #c9152f;
        }

        .section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 14px;
        }

        .section-header h2 {
            font-size: 16px;
            font-weight: 600;
            color: #1a1a1a;
        }

        .section-header a {
            font-size: 13px;
            color: #c9152f;
        }

        /* Movie card grid */
        .movie-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 16px;
        }

        .movie-item {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 5px;
            overflow: hidden;
            cursor: pointer;
        }

        .movie-item:hover { border-color: #bbb; }

        .movie-item:hover .movie-poster-img { opacity: 0.92; }

        .movie-poster-img {
            width: 100%;
            aspect-ratio: 2/3;
            object-fit: cover;
            display: block;
            background: #e4e4e4;
            transition: opacity 0.15s;
        }

        .movie-poster-placeholder {
            width: 100%;
            aspect-ratio: 2/3;
            background: #e4e4e4;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #aaa;
            font-size: 13px;
        }

        .movie-badges {
            position: absolute;
            top: 8px;
            right: 8px;
            display: flex;
            flex-direction: column;
            gap: 4px;
            align-items: flex-end;
        }

        .movie-poster-wrap {
            position: relative;
        }

        .badge {
            font-size: 10px;
            font-weight: 700;
            padding: 2px 6px;
            border-radius: 3px;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .badge-format {
            background: rgba(255,255,255,0.92);
            color: #a01026;
        }

        .badge-rating {
            background: rgba(0,0,0,0.65);
            color: #fff;
        }

        .movie-info {
            padding: 12px;
        }

        .movie-title {
            font-size: 14px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 2px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .movie-meta {
            font-size: 12px;
            color: #888;
            margin-bottom: 8px;
        }

        .show-times {
            display: flex;
            flex-wrap: wrap;
            gap: 4px;
        }

        /* Green available / Red past showtime pills */
        .show-time-btn {
            font-size: 11px;
            font-weight: 600;
            padding: 3px 9px;
            border-radius: 3px;
            border: 1px solid #1a7a35;
            color: #1a7a35;
            background: #eaf7ee;
            text-decoration: none;
            display: inline-block;
            transition: background 0.15s;
        }

        .show-time-btn:hover {
            background: #c8ead2;
            text-decoration: none;
            color: #1a7a35;
        }

        .show-time-past {
            font-size: 11px;
            font-weight: 600;
            padding: 3px 9px;
            border-radius: 3px;
            border: 1px solid #c82333;
            color: #c82333;
            background: #fde8ec;
            cursor: not-allowed;
            text-decoration: line-through;
            opacity: 0.7;
        }

        /* Hover overlay: Book Ticket + Watch Trailer */
        .movie-hover-overlay {
            position: absolute;
            inset: 0;
            background: rgba(0,0,0,0.55);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 8px;
            opacity: 0;
            transition: opacity 0.2s;
            padding: 12px;
        }

        .movie-item:hover .movie-hover-overlay { opacity: 1; }

        .overlay-btn {
            width: 100%;
            padding: 8px 0;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 600;
            text-align: center;
            text-decoration: none;
            cursor: pointer;
            border: none;
            display: block;
        }

        .overlay-btn-book {
            background: #c9152f;
            color: #fff;
        }

        .overlay-btn-book:hover { background: #a01026; color: #fff; text-decoration: none; }

        .overlay-btn-trailer {
            background: rgba(255,255,255,0.9);
            color: #1a1a1a;
        }

        .overlay-btn-trailer:hover { background: #fff; color: #1a1a1a; text-decoration: none; }

        .no-shows {
            font-size: 11px;
            color: #aaa;
            font-style: italic;
        }

        .empty-state {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 48px;
            text-align: center;
            color: #888;
        }

        .empty-state p { margin-bottom: 6px; }

        /* Trailer modal */
        #trailerModal {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 999;
            background: rgba(0,0,0,0.85);
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        #trailerModal.open { display: flex; }

        .trailer-inner {
            position: relative;
            width: 100%;
            max-width: 900px;
            aspect-ratio: 16/9;
            background: #000;
            border-radius: 4px;
        }

        .trailer-inner iframe {
            width: 100%;
            height: 100%;
            border: none;
            border-radius: 4px;
        }

        .trailer-close {
            position: absolute;
            top: -36px;
            right: 0;
            background: none;
            border: none;
            color: #fff;
            font-size: 20px;
            cursor: pointer;
            padding: 4px 8px;
            opacity: 0.8;
        }

        .trailer-close:hover { opacity: 1; }
    </style>
</head>
<body>
    <c:if test="${empty user}"><c:redirect url="login"/></c:if>

    <jsp:include page="userHeader.jsp" />

    <div class="page-wrap">
        <div class="user-bar">
            <div>
                <h1>Welcome back, ${user.fullName}</h1>
                <small>${user.email}</small>
            </div>
            <div class="user-bar-actions">
                <a href="${pageContext.request.contextPath}/browseMovies" class="btn-browse">Browse movies</a>
                <a href="${pageContext.request.contextPath}/myBookings" class="btn-bookings">My bookings</a>
            </div>
        </div>

        <div class="section-header">
            <h2>Now showing</h2>
            <a href="${pageContext.request.contextPath}/browseMovies">View all →</a>
        </div>

        <c:choose>
            <c:when test="${not empty recentMovies}">
                <div class="movie-grid">
                    <c:forEach var="movie" items="${recentMovies}">
                        <div class="movie-item" onclick="window.location.href='${pageContext.request.contextPath}/movieDetails?id=${movie.movieId}'">
                            <div class="movie-poster-wrap">
                                <c:choose>
                                    <c:when test="${not empty movie.posterImage}">
                                        <img class="movie-poster-img" src="${pageContext.request.contextPath}/images/${movie.posterImage}" alt="${movie.title}" onerror="this.parentNode.innerHTML='<div class=movie-poster-placeholder>No image</div>'">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="movie-poster-placeholder">No image</div>
                                    </c:otherwise>
                                </c:choose>
                                <div class="movie-badges">
                                    <c:if test="${not empty movie.format}">
                                        <span class="badge badge-format">${movie.format}</span>
                                    </c:if>
                                    <c:if test="${not empty movie.ageRating}">
                                        <span class="badge badge-rating">${movie.ageRating}</span>
                                    </c:if>
                                </div>
                                <div class="movie-hover-overlay">
                                    <a href="${pageContext.request.contextPath}/movieDetails?id=${movie.movieId}#viewingTimes" class="overlay-btn overlay-btn-book" onclick="event.stopPropagation()">Book Ticket</a>
                                    <c:if test="${not empty movie.trailerUrl}">
                                        <button type="button" class="overlay-btn overlay-btn-trailer" onclick="event.stopPropagation(); openTrailer('${movie.trailerUrl}');">Watch Trailer</button>
                                    </c:if>
                                </div>
                            </div>
                            <div class="movie-info">
                                <div class="movie-title" title="${movie.title}">${movie.title}</div>
                                <fmt:parseNumber var="hours" integerOnly="true" value="${movie.duration / 60}" />
                                <div class="movie-meta">${movie.genre} &middot; <c:if test="${hours > 0}">${hours}h </c:if>${movie.duration % 60}m</div>

                                <div class="show-times">
                                    <c:set var="shows" value="${showTimesMap[movie.movieId]}" />
                                    <c:choose>
                                        <c:when test="${not empty shows}">
                                            <jsp:useBean id="now" class="java.util.Date" />
                                            <fmt:formatDate var="currentDate" value="${now}" pattern="yyyy-MM-dd" />
                                            <fmt:formatDate var="currentTime" value="${now}" pattern="HH:mm:ss" />
                                            <c:forEach var="show" items="${shows}">
                                                <c:set var="isPast" value="${show.showDate < currentDate || (show.showDate == currentDate && show.showTime.toString() < currentTime)}" />
                                                <c:choose>
                                                    <c:when test="${isPast}">
                                                        <span class="show-time-past" title="Show has passed">${show.showTime.toString().substring(0,5)}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="${pageContext.request.contextPath}/bookTicket?movieId=${movie.movieId}&showId=${show.showTimeId}" class="show-time-btn" onclick="event.stopPropagation()">${show.showTime.toString().substring(0,5)}</a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="no-shows">No shows today</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <p>No movies are currently scheduled.</p>
                    <small>Check back soon.</small>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <div id="trailerModal">
        <div class="trailer-inner">
            <button class="trailer-close" onclick="closeTrailer()">✕ Close</button>
            <iframe id="trailerIframe" src="" allowfullscreen allow="autoplay"></iframe>
        </div>
    </div>

    <script>
        function openTrailer(url) {
            let embed = url;
            if (url.includes('watch?v=')) {
                embed = 'https://www.youtube.com/embed/' + url.split('watch?v=')[1].split('&')[0] + '?autoplay=1';
            } else if (url.includes('youtu.be/')) {
                embed = 'https://www.youtube.com/embed/' + url.split('youtu.be/')[1].split('?')[0] + '?autoplay=1';
            }
            document.getElementById('trailerIframe').src = embed;
            document.getElementById('trailerModal').classList.add('open');
        }
        function closeTrailer() {
            document.getElementById('trailerModal').classList.remove('open');
            document.getElementById('trailerIframe').src = '';
        }
    </script>
</body>
</html>
