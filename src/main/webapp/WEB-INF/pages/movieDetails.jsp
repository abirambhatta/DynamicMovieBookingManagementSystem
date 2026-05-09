<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:choose><c:when test="${not empty movie}">${movie.title} - MovieMint</c:when><c:otherwise>Movie Details - MovieMint</c:otherwise></c:choose></title>
    <meta name="description" content="${not empty movie ? movie.description : 'Movie details on MovieMint'}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background: #0d0d0d; color: #fff; }

        /* ── HERO BANNER ── */
        .hero {
            position: relative;
            width: 100%;
            height: 420px;
            background: #000;
            overflow: hidden;
        }

        .hero-bg {
            position: absolute;
            inset: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            opacity: 0.45;
            filter: blur(2px);
            transform: scale(1.05);
        }

        .hero-gradient {
            position: absolute;
            inset: 0;
            background: linear-gradient(to bottom, rgba(13,13,13,0.1) 0%, rgba(13,13,13,0.6) 60%, #0d0d0d 100%);
            pointer-events: none;
        }

        .hero-play-btn {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -60%);
            width: 72px;
            height: 72px;
            background: rgba(255,255,255,0.15);
            border: 3px solid rgba(255,255,255,0.6);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: transform 0.2s, background 0.2s;
            backdrop-filter: blur(4px);
            text-decoration: none;
        }

        .hero-play-btn:hover {
            transform: translate(-50%, -60%) scale(1.1);
            background: rgba(201,21,47,0.4);
            text-decoration: none;
        }

        .hero-play-icon {
            width: 0;
            height: 0;
            border-style: solid;
            border-width: 14px 0 14px 24px;
            border-color: transparent transparent transparent #fff;
            margin-left: 4px;
        }

        /* ── MOVIE CARD SECTION ── */
        .movie-section {
            max-width: 1100px;
            margin: 0 auto;
            padding: 0 24px 60px;
            position: relative;
        }

        .movie-top {
            display: flex;
            gap: 32px;
            align-items: flex-start;
            margin-top: -90px;
            position: relative;
            z-index: 10;
        }

        .poster-wrap {
            flex-shrink: 0;
            width: 200px;
        }

        .poster-wrap img {
            width: 200px;
            height: 300px;
            object-fit: cover;
            border-radius: 8px;
            border: 3px solid rgba(255,255,255,0.1);
            box-shadow: 0 20px 60px rgba(0,0,0,0.6);
            display: block;
        }

        .poster-placeholder {
            width: 200px;
            height: 300px;
            background: #1a1a1a;
            border-radius: 8px;
            border: 3px solid rgba(255,255,255,0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #555;
            font-size: 13px;
        }

        .movie-meta {
            flex: 1;
            padding-top: 100px;
        }

        .movie-title {
            font-size: 36px;
            font-weight: 800;
            letter-spacing: -0.5px;
            line-height: 1.15;
            margin-bottom: 10px;
            color: #fff;
        }

        .movie-badges {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-bottom: 20px;
            align-items: center;
        }

        .badge {
            font-size: 11px;
            font-weight: 700;
            padding: 3px 9px;
            border-radius: 3px;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }

        .badge-format { background: var(--red); color: #fff; }
        .badge-rating { background: rgba(255,255,255,0.12); color: rgba(255,255,255,0.85); border: 1px solid rgba(255,255,255,0.2); }
        .badge-rating-r { background: rgba(180,20,20,0.5); color: #fff; border: 1px solid rgba(255,80,80,0.4); }

        .meta-pills {
            display: flex;
            flex-wrap: wrap;
            gap: 14px;
            font-size: 13px;
            color: rgba(255,255,255,0.65);
            margin-bottom: 28px;
        }

        .meta-pills span { display: flex; align-items: center; gap: 4px; }

        .meta-dot { color: rgba(255,255,255,0.25); }

        .action-row {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
        }

        .btn-book {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 28px;
            background: var(--red);
            color: #fff;
            font-size: 14px;
            font-weight: 700;
            border-radius: 5px;
            text-decoration: none;
            letter-spacing: 0.3px;
            transition: background 0.15s, transform 0.15s;
            border: none;
            cursor: pointer;
        }

        .btn-book:hover {
            background: var(--red-dark);
            text-decoration: none;
            color: #fff;
            transform: translateY(-1px);
        }

        .btn-trailer {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            background: rgba(255,255,255,0.1);
            color: #fff;
            font-size: 14px;
            font-weight: 600;
            border-radius: 5px;
            border: 1px solid rgba(255,255,255,0.2);
            cursor: pointer;
            transition: background 0.15s, transform 0.15s;
            backdrop-filter: blur(4px);
            text-decoration: none;
        }

        .btn-trailer:hover {
            background: rgba(255,255,255,0.18);
            transform: translateY(-1px);
            text-decoration: none;
            color: #fff;
        }

        /* ── DETAILS GRID ── */
        .details-grid {
            display: grid;
            grid-template-columns: 1fr 300px;
            gap: 28px;
            margin-top: 40px;
        }

        .detail-panel {
            background: #161616;
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 8px;
            padding: 28px;
            margin-bottom: 20px;
        }

        .detail-panel h2 {
            font-size: 13px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            color: var(--red);
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* ── VIEWING TIMES ── */
        .viewing-times-section {
            margin-top: 40px;
            background: #0b1021;
            border-radius: 8px;
            padding: 24px;
            border: 1px solid rgba(255,255,255,0.05);
        }

        .vt-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 20px;
        }

        .vt-title-area h2 {
            font-size: 26px;
            font-weight: 400;
            color: #fff;
            margin-bottom: 12px;
            display: flex;
            align-items: flex-end;
            gap: 6px;
        }
        .vt-title-area h2::after {
            content: '';
            display: block;
            width: 4px;
            height: 4px;
            background: #ff3b30;
            border-radius: 50%;
            margin-bottom: 8px;
        }

        .vt-legend {
            display: flex;
            gap: 16px;
            font-size: 11px;
            font-weight: 700;
            color: rgba(255,255,255,0.4);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .vt-legend span {
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .vt-dot { width: 10px; height: 10px; border-radius: 50%; border: 2px solid; background: transparent; }
        .vt-dot.sold { border-color: #e50914; }
        .vt-dot.booked { border-color: #f5b50a; }
        .vt-dot.avail { border-color: #2e8b57; }

        .vt-dates {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        .vt-date-btn {
            background: rgba(255,255,255,0.05);
            color: #fff;
            border: none;
            padding: 8px 16px;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            border-radius: 4px;
            transition: background 0.2s;
        }
        .vt-date-btn:hover { background: rgba(255,255,255,0.1); }
        .vt-date-btn.active {
            background: transparent;
            border-bottom: 2px solid #e50914;
            border-radius: 4px 4px 0 0;
            padding-bottom: 6px;
            color: #e50914;
        }

        .vt-hall-row {
            display: flex;
            background: rgba(255,255,255,0.03);
            border-radius: 8px;
            margin-bottom: 12px;
            overflow: hidden;
            flex-direction: column;
        }

        @media (min-width: 600px) {
            .vt-hall-row { flex-direction: row; }
        }

        .vt-hall-name {
            width: 140px;
            background: #da3232;
            color: #fff;
            font-weight: 700;
            font-size: 15px;
            display: flex;
            align-items: center;
            padding: 16px 20px;
            flex-shrink: 0;
        }

        .vt-times {
            flex: 1;
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            padding: 16px 20px;
        }

        .vt-time-btn {
            border: 1px solid rgba(255,255,255,0.3);
            background: transparent;
            color: rgba(255,255,255,0.8);
            border-radius: 12px;
            padding: 12px 24px;
            font-size: 13px;
            font-weight: 600;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-flex;
            flex-direction: column;
            align-items: center;
            line-height: 1.4;
        }
        .vt-time-btn:hover {
            border-color: #fff;
            color: #fff;
            background: rgba(255,255,255,0.05);
            text-decoration: none;
        }
        .vt-time-btn span { font-size: 11px; font-weight: 500; opacity: 0.7; }

        .detail-panel p {
            font-size: 14px;
            line-height: 1.75;
            color: rgba(255,255,255,0.72);
        }

        .crew-row {
            display: flex;
            gap: 32px;
            flex-wrap: wrap;
        }

        .crew-item .crew-label {
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            color: rgba(255,255,255,0.4);
            margin-bottom: 4px;
        }

        .crew-item .crew-val {
            font-size: 14px;
            font-weight: 600;
            color: rgba(255,255,255,0.9);
        }

        /* ── SIDEBAR ── */
        .info-list { list-style: none; }

        .info-list li {
            padding: 11px 0;
            border-bottom: 1px solid rgba(255,255,255,0.07);
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 13px;
        }

        .info-list li:last-child { border-bottom: none; }

        .info-list .ikey {
            color: rgba(255,255,255,0.4);
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }

        .info-list .ival {
            font-weight: 600;
            color: rgba(255,255,255,0.9);
            text-align: right;
        }

        .sidebar-book-box {
            background: linear-gradient(135deg, #1e0a12 0%, #160a0a 100%);
            border: 1px solid rgba(201,21,47,0.3);
            border-radius: 8px;
            padding: 24px;
            text-align: center;
        }

        .sidebar-book-box h3 {
            font-size: 15px;
            font-weight: 700;
            color: #fff;
            margin-bottom: 6px;
        }

        .sidebar-book-box p {
            font-size: 12px;
            color: rgba(255,255,255,0.5);
            margin-bottom: 18px;
        }

        .sidebar-book-box .btn-book {
            width: 100%;
            justify-content: center;
        }

        /* ── TRAILER MODAL ── */
        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.92);
            z-index: 9999;
            align-items: center;
            justify-content: center;
            padding: 24px;
        }

        .modal-overlay.open { display: flex; }

        .modal-frame-wrap {
            position: relative;
            width: 100%;
            max-width: 880px;
            aspect-ratio: 16/9;
            background: #000;
            border-radius: 10px;
            overflow: hidden;
            border: 1px solid rgba(255,255,255,0.1);
            box-shadow: 0 40px 80px rgba(0,0,0,0.7);
        }

        .modal-frame-wrap iframe {
            width: 100%;
            height: 100%;
            border: none;
        }

        .modal-close {
            position: absolute;
            top: -48px;
            right: 0;
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            color: #fff;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            font-size: 20px;
            line-height: 1;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background 0.15s;
        }

        .modal-close:hover { background: rgba(201,21,47,0.5); }

        /* ── NOT FOUND ── */
        .not-found-wrap {
            max-width: 500px;
            margin: 80px auto;
            text-align: center;
            padding: 24px;
        }

        .not-found-wrap h1 { font-size: 24px; color: #fff; margin-bottom: 10px; }
        .not-found-wrap p { font-size: 14px; color: rgba(255,255,255,0.5); margin-bottom: 24px; }

        /* ── RESPONSIVE ── */
        @media (max-width: 768px) {
            .hero { height: 280px; }
            .movie-top { flex-direction: column; gap: 20px; margin-top: -60px; }
            .poster-wrap { width: 140px; }
            .poster-wrap img { width: 140px; height: 210px; }
            .movie-meta { padding-top: 0; }
            .movie-title { font-size: 24px; }
            .details-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <c:if test="${empty user}">
        <c:redirect url="login"/>
    </c:if>

    <jsp:include page="userHeader.jsp" />

    <c:choose>
        <c:when test="${not empty movie}">

            <%-- Calculate hours and minutes for duration safely --%>
            <fmt:parseNumber var="durHoursInt" integerOnly="true" value="${movie.duration / 60}" />
            <c:set var="durMins" value="${movie.duration % 60}" />

            <%-- Hero Banner --%>
            <div class="hero">
                <c:choose>
                    <c:when test="${not empty movie.trailerUrl}">
                        <%-- YouTube Thumbnail as backdrop --%>
                        <img id="heroBg" class="hero-bg" src="" alt="Movie backdrop"
                             onerror="this.src='${pageContext.request.contextPath}/images/${movie.posterImage}'; this.style.filter='blur(8px)';">
                        <script>
                            (function(){
                                var url = '${movie.trailerUrl}';
                                var vid = '';
                                if (url.indexOf('watch?v=') !== -1) vid = url.split('watch?v=')[1].split('&')[0];
                                else if (url.indexOf('youtu.be/') !== -1) vid = url.split('youtu.be/')[1].split('?')[0];
                                else if (url.indexOf('/embed/') !== -1) vid = url.split('/embed/')[1].split('?')[0];
                                if (vid) document.getElementById('heroBg').src = 'https://img.youtube.com/vi/' + vid + '/maxresdefault.jpg';
                            })();
                        </script>
                        <div class="hero-gradient"></div>
                        <button class="hero-play-btn" onclick="openTrailer('${movie.trailerUrl}')" title="Watch Trailer">
                            <div class="hero-play-icon"></div>
                        </button>
                    </c:when>
                    <c:otherwise>
                        <img class="hero-bg" src="${pageContext.request.contextPath}/images/${movie.posterImage}" alt="${movie.title}">
                        <div class="hero-gradient"></div>
                    </c:otherwise>
                </c:choose>
            </div>

            <%-- Main Content --%>
            <div class="movie-section">
                <div class="movie-top">
                    <%-- Poster --%>
                    <div class="poster-wrap">
                        <img src="${pageContext.request.contextPath}/images/${movie.posterImage}"
                             alt="${movie.title} Poster"
                             onerror="this.outerHTML='<div class=\'poster-placeholder\'>No Image</div>'">
                    </div>

                    <%-- Meta Info --%>
                    <div class="movie-meta">
                        <h1 class="movie-title">${movie.title}</h1>

                        <div class="movie-badges">
                            <c:if test="${not empty movie.format}">
                                <span class="badge badge-format">${movie.format}</span>
                            </c:if>
                            <c:if test="${not empty movie.ageRating}">
                                <c:choose>
                                    <c:when test="${movie.ageRating == 'R' or movie.ageRating == 'NC-17'}">
                                        <span class="badge badge-rating-r">${movie.ageRating}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-rating">${movie.ageRating}</span>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                        </div>

                        <div class="meta-pills">
                            <c:if test="${not empty movie.genre}">
                                <span>${movie.genre}</span>
                                <span class="meta-dot">·</span>
                            </c:if>
                            <span>
                                <c:choose>
                                    <c:when test="${movie.language == 'BN'}">Bengali</c:when>
                                    <c:when test="${movie.language == 'EN'}">English</c:when>
                                    <c:when test="${movie.language == 'HI'}">Hindi</c:when>
                                    <c:when test="${movie.language == 'NE'}">Nepali</c:when>
                                    <c:otherwise>${movie.language}</c:otherwise>
                                </c:choose>
                            </span>
                            <span class="meta-dot">·</span>
                            <span>
                                <c:if test="${durHoursInt > 0}">${durHoursInt}h </c:if>${durMins}m
                            </span>
                            <c:if test="${not empty movie.releaseDate}">
                                <span class="meta-dot">·</span>
                                <span><fmt:formatDate value="${movie.releaseDate}" pattern="yyyy"/></span>
                            </c:if>
                        </div>

                        <div class="action-row">
                            <a href="#viewingTimes" class="btn-book">
                                🎟 Book Tickets Now
                            </a>
                            <c:if test="${not empty movie.trailerUrl}">
                                <button type="button" onclick="openTrailer('${movie.trailerUrl}')" class="btn-trailer">
                                    ▶ Watch Trailer
                                </button>
                            </c:if>
                        </div>
                    </div>
                </div>

                <%-- Viewing Times Section --%>
                <div id="viewingTimes" class="viewing-times-section">
                    <div class="vt-header">
                        <div class="vt-title-area">
                            <h2>Viewing Times</h2>
                            <div class="vt-legend">
                                <span><div class="vt-dot sold"></div> SOLD</span>
                                <span><div class="vt-dot booked"></div> BOOKED</span>
                                <span><div class="vt-dot avail"></div> AVAILABLE</span>
                            </div>
                        </div>
                        <div class="vt-dates" id="vtDatesContainer">
                            <%-- Populated by JS --%>
                        </div>
                    </div>
                    <div id="vtHallsContainer">
                        <%-- Populated by JS --%>
                    </div>
                </div>

                <%-- Details Grid --%>
                <div class="details-grid">
                    <%-- Left Column --%>
                    <div>
                        <c:if test="${not empty movie.description}">
                            <div class="detail-panel">
                                <h2>📖 Synopsis</h2>
                                <p>${movie.description}</p>
                            </div>
                        </c:if>

                        <c:if test="${not empty movie.director or not empty movie.castList}">
                            <div class="detail-panel">
                                <h2>🎬 Cast & Crew</h2>
                                <div class="crew-row">
                                    <c:if test="${not empty movie.director}">
                                        <div class="crew-item">
                                            <div class="crew-label">Director</div>
                                            <div class="crew-val">${movie.director}</div>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty movie.castList}">
                                        <div class="crew-item">
                                            <div class="crew-label">Cast</div>
                                            <div class="crew-val">${movie.castList}</div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <%-- Right Sidebar --%>
                    <div>
                        <div class="detail-panel">
                            <h2>ℹ️ Information</h2>
                            <ul class="info-list">
                                <li>
                                    <span class="ikey">Format</span>
                                    <span class="ival">${not empty movie.format ? movie.format : '2D'}</span>
                                </li>
                                <li>
                                    <span class="ikey">Language</span>
                                    <span class="ival">
                                        <c:choose>
                                            <c:when test="${movie.language == 'BN'}">Bengali</c:when>
                                            <c:when test="${movie.language == 'EN'}">English</c:when>
                                            <c:when test="${movie.language == 'HI'}">Hindi</c:when>
                                            <c:when test="${movie.language == 'NE'}">Nepali</c:when>
                                            <c:otherwise>${movie.language}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </li>
                                <li>
                                    <span class="ikey">Run Time</span>
                                    <span class="ival">
                                        <c:if test="${durHoursInt > 0}">${durHoursInt}h </c:if>${durMins}m
                                    </span>
                                </li>
                                <li>
                                    <span class="ikey">Certification</span>
                                    <span class="ival">${not empty movie.ageRating ? movie.ageRating : 'Not Rated'}</span>
                                </li>
                                <c:if test="${not empty movie.genre}">
                                    <li>
                                        <span class="ikey">Genre</span>
                                        <span class="ival">${movie.genre}</span>
                                    </li>
                                </c:if>
                                <c:if test="${not empty movie.releaseDate}">
                                    <li>
                                        <span class="ikey">Release Date</span>
                                        <span class="ival"><fmt:formatDate value="${movie.releaseDate}" pattern="dd MMM yyyy"/></span>
                                    </li>
                                </c:if>
                            </ul>
                        </div>

                        <div class="sidebar-book-box">
                            <h3>Experience it on the big screen</h3>
                            <p>Secure your favorite seats today.</p>
                            <a href="#viewingTimes" class="btn-book">
                                Book Now
                            </a>
                        </div>
                    </div>
                </div>
            </div>

        </c:when>
        <c:otherwise>
            <div class="not-found-wrap">
                <h1>Movie Not Found</h1>
                <p>The movie you are looking for doesn't exist or has been removed.</p>
                <a href="${pageContext.request.contextPath}/browseMovies" class="btn-book">Browse Movies</a>
            </div>
        </c:otherwise>
    </c:choose>

    <%-- Trailer Modal --%>
    <div id="trailerModal" class="modal-overlay">
        <div style="position:relative; width:100%; max-width:880px;">
            <button class="modal-close" onclick="closeTrailer()" title="Close">✕</button>
            <div class="modal-frame-wrap">
                <iframe id="trailerIframe" src="" title="Trailer" allowfullscreen
                        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture">
                </iframe>
            </div>
        </div>
    </div>

    <script>
        function openTrailer(url) {
            var embedUrl = url;
            if (url.indexOf('watch?v=') !== -1) {
                var vid = url.split('watch?v=')[1].split('&')[0];
                embedUrl = 'https://www.youtube.com/embed/' + vid + '?autoplay=1';
            } else if (url.indexOf('youtu.be/') !== -1) {
                var vid = url.split('youtu.be/')[1].split('?')[0];
                embedUrl = 'https://www.youtube.com/embed/' + vid + '?autoplay=1';
            } else if (url.indexOf('/embed/') !== -1 && url.indexOf('autoplay') === -1) {
                embedUrl += url.indexOf('?') !== -1 ? '&autoplay=1' : '?autoplay=1';
            }
            document.getElementById('trailerIframe').src = embedUrl;
            document.getElementById('trailerModal').classList.add('open');
        }

        function closeTrailer() {
            document.getElementById('trailerModal').classList.remove('open');
            document.getElementById('trailerIframe').src = '';
        }

        // Close on backdrop click
        document.getElementById('trailerModal').addEventListener('click', function(e) {
            if (e.target === this) closeTrailer();
        });

        // Close on Escape key
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') closeTrailer();
        });

        // ── VIEWING TIMES LOGIC ──
        <c:if test="${not empty movie}">
        const rawShowTimes = ${showTimesJson};
        const movieId = ${movie.movieId};
        const contextPath = '${pageContext.request.contextPath}';

        const stGrouped = {};
        rawShowTimes.forEach(st => {
            if (!stGrouped[st.date]) stGrouped[st.date] = [];
            stGrouped[st.date].push(st);
        });

        // Sort dates
        const sortedDates = Object.keys(stGrouped).sort();

        function renderVTDates() {
            const container = document.getElementById('vtDatesContainer');
            if (!container) return;
            
            if (sortedDates.length === 0) {
                container.innerHTML = '<span style="color:#888; font-size:13px;">No upcoming showtimes available.</span>';
                document.getElementById('vtHallsContainer').innerHTML = '';
                return;
            }

            container.innerHTML = '';
            
            const today = new Date();
            const todayStr = today.getFullYear() + '-' + String(today.getMonth()+1).padStart(2,'0') + '-' + String(today.getDate()).padStart(2,'0');
            
            const tomm = new Date(today);
            tomm.setDate(tomm.getDate() + 1);
            const tommStr = tomm.getFullYear() + '-' + String(tomm.getMonth()+1).padStart(2,'0') + '-' + String(tomm.getDate()).padStart(2,'0');

            sortedDates.forEach(ds => {
                const btn = document.createElement('button');
                btn.className = 'vt-date-btn';
                btn.dataset.date = ds;
                
                let label = '';
                if (ds === todayStr) {
                    label = 'Today';
                } else if (ds === tommStr) {
                    label = 'Tomm';
                } else {
                    const d = new Date(ds + 'T00:00:00');
                    label = d.getDate() + d.toLocaleString('en-US',{month:'short'});
                }
                
                btn.innerText = label;
                btn.onclick = () => selectVTDate(ds);
                container.appendChild(btn);
            });
            
            // Select first date by default
            if (sortedDates.length > 0) {
                selectVTDate(sortedDates[0]);
            }
        }

        function selectVTDate(ds) {
            document.querySelectorAll('.vt-date-btn').forEach(btn => {
                if (btn.dataset.date === ds) btn.classList.add('active');
                else btn.classList.remove('active');
            });
            
            renderVTHalls(ds);
        }

        function renderVTHalls(ds) {
            const container = document.getElementById('vtHallsContainer');
            if (!container) return;
            container.innerHTML = '';
            
            const times = stGrouped[ds] || [];
            
            // Group by hall
            const byHall = {};
            times.forEach(st => {
                if (!byHall[st.hall]) byHall[st.hall] = [];
                byHall[st.hall].push(st);
            });
            
            for (const hall in byHall) {
                const row = document.createElement('div');
                row.className = 'vt-hall-row';
                
                const nameDiv = document.createElement('div');
                nameDiv.className = 'vt-hall-name';
                nameDiv.innerText = hall;
                row.appendChild(nameDiv);
                
                const timesDiv = document.createElement('div');
                timesDiv.className = 'vt-times';
                
                // Sort times
                byHall[hall].sort((a, b) => {
                    return new Date(a.date + ' ' + a.time) - new Date(b.date + ' ' + b.time);
                });
                
                byHall[hall].forEach(st => {
                    const tParts = st.time.split(' ');
                    const mainTime = tParts[0];
                    const ampm = tParts[1] || '';
                    
                    const a = document.createElement('a');
                    a.href = contextPath + '/bookTicket?movieId=' + movieId + '&showId=' + st.id;
                    a.className = 'vt-time-btn';
                    a.innerHTML = mainTime + (ampm ? ' <br><span>' + ampm + '</span>' : '');
                    timesDiv.appendChild(a);
                });
                
                row.appendChild(timesDiv);
                container.appendChild(row);
            }
        }

        // Initialize Viewing Times
        if (typeof rawShowTimes !== 'undefined') {
            renderVTDates();
        }
        </c:if>

    </script>
</body>
</html>
