<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Movies - MovieMint</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background: #f4f4f5; }

        .page-wrap {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        /* Tab strip */
        .status-tabs {
            display: flex;
            gap: 0;
            border-bottom: 1px solid #ddd;
            margin-bottom: 16px;
        }

        .status-tab {
            padding: 10px 20px;
            font-size: 14px;
            font-weight: 500;
            color: #666;
            text-decoration: none;
            border-bottom: 2px solid transparent;
            margin-bottom: -1px;
        }

        .status-tab:hover { color: #333; text-decoration: none; }
        .status-tab.active { color: #c9152f; border-bottom-color: #c9152f; font-weight: 600; }

        /* Date tabs */
        .date-strip {
            display: flex;
            gap: 6px;
            overflow-x: auto;
            padding-bottom: 12px;
            margin-bottom: 16px;
        }

        .date-tab {
            flex-shrink: 0;
            padding: 6px 14px;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 500;
            text-decoration: none;
            background: #fff;
            border: 1px solid #ddd;
            color: #444;
        }

        .date-tab:hover { border-color: #c9152f; color: #c9152f; text-decoration: none; }
        .date-tab.active { background: #c9152f; border-color: #c9152f; color: #fff; }

        /* Filters */
        .filter-bar {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 14px 16px;
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
            align-items: flex-end;
            flex-wrap: wrap;
        }

        .filter-bar .field {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .filter-bar label {
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            color: #888;
        }

        .filter-bar input, .filter-bar select {
            padding: 7px 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 13px;
            font-family: inherit;
            height: 34px;
        }

        .filter-bar input:focus, .filter-bar select:focus {
            outline: none;
            border-color: #c9152f;
        }

        .filter-bar input { min-width: 200px; }

        .btn-filter {
            padding: 0 16px;
            height: 34px;
            background: #c9152f;
            color: #fff;
            border: none;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
        }

        .btn-filter:hover { background: #a01026; }

        /* Autocomplete */
        .search-wrap { position: relative; }

        .autocomplete-results {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: #fff;
            border: 1px solid #ccc;
            border-top: none;
            border-radius: 0 0 4px 4px;
            max-height: 280px;
            overflow-y: auto;
            z-index: 50;
            display: none;
        }

        .autocomplete-results.show { display: block; }

        .autocomplete-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 9px 12px;
            cursor: pointer;
            border-bottom: 1px solid #f4f4f5;
            text-decoration: none;
            color: inherit;
        }

        .autocomplete-item:hover { background: #f9f9f9; text-decoration: none; }
        .autocomplete-item:last-child { border-bottom: none; }

        .autocomplete-thumb {
            width: 32px;
            height: 44px;
            object-fit: cover;
            border-radius: 3px;
            background: #e4e4e4;
            flex-shrink: 0;
        }

        .autocomplete-title { font-size: 13px; font-weight: 600; color: #1a1a1a; }
        .autocomplete-meta { font-size: 11px; color: #888; margin-top: 1px; }

        /* Movie grid */
        .movie-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 14px;
        }

        .movie-item {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 5px;
            overflow: hidden;
            cursor: pointer;
        }

        .movie-item:hover { border-color: #bbb; }

        .movie-poster-wrap { position: relative; }

        .movie-poster-img {
            width: 100%;
            aspect-ratio: 2/3;
            object-fit: cover;
            display: block;
            background: #e4e4e4;
        }

        .movie-poster-placeholder {
            width: 100%;
            aspect-ratio: 2/3;
            background: #e4e4e4;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #aaa;
            font-size: 12px;
        }

        .movie-badges {
            position: absolute;
            top: 7px;
            right: 7px;
            display: flex;
            flex-direction: column;
            gap: 3px;
            align-items: flex-end;
        }

        .badge {
            font-size: 10px;
            font-weight: 700;
            padding: 2px 5px;
            border-radius: 3px;
            text-transform: uppercase;
        }

        .badge-format { background: rgba(255,255,255,0.92); color: #a01026; }
        .badge-rating { background: rgba(0,0,0,0.65); color: #fff; }

        .movie-info { padding: 11px; }

        .movie-title {
            font-size: 14px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 2px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .movie-meta { font-size: 12px; color: #888; margin-bottom: 8px; }

        .show-times { display: flex; flex-wrap: wrap; gap: 4px; }

        .show-time-btn {
            font-size: 11px;
            padding: 3px 8px;
            border: 1px solid #ccc;
            border-radius: 3px;
            color: #333;
            text-decoration: none;
            display: inline-block;
        }

        .show-time-btn:hover { border-color: #c9152f; color: #c9152f; text-decoration: none; }

        .show-time-past {
            font-size: 11px;
            padding: 3px 8px;
            border: 1px solid #ecd0d3;
            border-radius: 3px;
            color: #c0737a;
            background: #fdf5f6;
        }

        .no-shows { font-size: 11px; color: #aaa; font-style: italic; }

        /* Empty / error state */
        .empty-state {
            grid-column: 1 / -1;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 48px;
            text-align: center;
            color: #888;
        }

        .empty-state a { color: #c9152f; font-size: 13px; }

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
            max-width: 880px;
            aspect-ratio: 16/9;
            background: #000;
            border-radius: 4px;
        }

        .trailer-inner iframe { width: 100%; height: 100%; border: none; }

        .trailer-close {
            position: absolute;
            top: -34px;
            right: 0;
            background: none;
            border: none;
            color: #fff;
            font-size: 14px;
            cursor: pointer;
            opacity: 0.8;
        }

        .trailer-close:hover { opacity: 1; }
    </style>
</head>
<body>
    <c:if test="${empty user}"><c:redirect url="login"/></c:if>

    <jsp:include page="userHeader.jsp" />

    <div class="page-wrap">
        <div class="status-tabs">
            <a href="${pageContext.request.contextPath}/browseMovies?status=now_showing"
               class="status-tab ${currentStatus == 'now_showing' ? 'active' : ''}">Now Showing</a>
            <a href="${pageContext.request.contextPath}/browseMovies?status=coming_soon"
               class="status-tab ${currentStatus == 'coming_soon' ? 'active' : ''}">Coming Soon</a>
        </div>

        <c:if test="${currentStatus == 'now_showing'}">
            <div class="date-strip">
                <c:forEach var="tab" items="${dateTabs}">
                    <a href="${pageContext.request.contextPath}/browseMovies?status=now_showing&date=${tab.value}${not empty param.genre ? '&genre='.concat(param.genre) : ''}${not empty param.language ? '&language='.concat(param.language) : ''}"
                       class="date-tab ${currentDate == tab.value ? 'active' : ''}">${tab.display}</a>
                </c:forEach>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/browseMovies" method="get" class="filter-bar">
            <input type="hidden" name="status" value="${currentStatus}">

            <div class="field">
                <label for="searchInput">Search</label>
                <div class="search-wrap">
                    <input type="text" name="search" id="searchInput" placeholder="Title..." value="${param.search}" autocomplete="off">
                    <div class="autocomplete-results" id="autocompleteResults"></div>
                </div>
            </div>

            <div class="field">
                <label for="genreFilter">Genre</label>
                <select name="genre" id="genreFilter">
                    <option value="">All genres</option>
                    <c:forEach var="g" items="${genres}">
                        <option value="${g}" ${param.genre == g ? 'selected' : ''}>${g}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="field">
                <label for="langFilter">Language</label>
                <select name="language" id="langFilter">
                    <option value="">All languages</option>
                    <c:forEach var="entry" items="${languageMap}">
                        <option value="${entry.key}" ${param.language == entry.key ? 'selected' : ''}>${entry.value}</option>
                    </c:forEach>
                </select>
            </div>

            <button type="submit" class="btn-filter">Filter</button>
            <c:if test="${not empty param.search || not empty param.genre || not empty param.language}">
                <a href="${pageContext.request.contextPath}/browseMovies?status=${currentStatus}" style="font-size:13px;color:#888;align-self:center;">Clear</a>
            </c:if>
        </form>

        <div class="movie-grid">
            <c:choose>
                <c:when test="${not empty movies}">
                    <c:forEach var="movie" items="${movies}">
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
                            </div>
                            <div class="movie-info">
                                <div class="movie-title" title="${movie.title}">${movie.title}</div>
                                <fmt:parseNumber var="hrs" integerOnly="true" value="${movie.duration / 60}" />
                                <div class="movie-meta">${movie.genre} &middot; <c:if test="${hrs > 0}">${hrs}h </c:if>${movie.duration % 60}m</div>

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
                                                        <a href="${pageContext.request.contextPath}/bookTicket?movieId=${movie.movieId}&showId=${show.showTimeId}"
                                                           class="show-time-btn" onclick="event.stopPropagation()">${show.showTime.toString().substring(0,5)}</a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="no-shows">No shows available</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <p>No movies found for this filter.</p>
                        <a href="${pageContext.request.contextPath}/browseMovies">Clear filters</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div id="trailerModal">
        <div class="trailer-inner">
            <button class="trailer-close" onclick="closeTrailer()">✕ Close</button>
            <iframe id="trailerIframe" src="" allowfullscreen allow="autoplay"></iframe>
        </div>
    </div>

    <script>
        const searchInput = document.getElementById('searchInput');
        const autocompleteResults = document.getElementById('autocompleteResults');
        let searchTimeout = null;

        searchInput.addEventListener('input', function() {
            const q = this.value.trim();
            if (searchTimeout) clearTimeout(searchTimeout);
            if (q.length < 2) { autocompleteResults.classList.remove('show'); return; }

            autocompleteResults.innerHTML = '<div style="padding:10px;font-size:13px;color:#888;">Searching...</div>';
            autocompleteResults.classList.add('show');

            searchTimeout = setTimeout(() => {
                fetch('${pageContext.request.contextPath}/api/movies/search?q=' + encodeURIComponent(q))
                    .then(r => r.json())
                    .then(data => {
                        if (data.success && data.movies.length > 0) {
                            autocompleteResults.innerHTML = data.movies.map(m =>
                                `<a href="${pageContext.request.contextPath}/movieDetails?id=${m.movieId}" class="autocomplete-item">
                                    <img class="autocomplete-thumb" src="${pageContext.request.contextPath}/images/${m.posterImage}" onerror="this.style.display='none'" alt="">
                                    <div>
                                        <div class="autocomplete-title">${m.title}</div>
                                        <div class="autocomplete-meta">${m.genre} &middot; ${m.language}</div>
                                    </div>
                                </a>`
                            ).join('');
                        } else {
                            autocompleteResults.innerHTML = '<div style="padding:10px;font-size:13px;color:#888;">No results</div>';
                        }
                    })
                    .catch(() => {
                        autocompleteResults.innerHTML = '<div style="padding:10px;font-size:13px;color:#c9152f;">Search failed</div>';
                    });
            }, 280);
        });

        document.addEventListener('click', e => {
            if (!searchInput.contains(e.target) && !autocompleteResults.contains(e.target)) {
                autocompleteResults.classList.remove('show');
            }
        });

        function openTrailer(url) {
            let embed = url;
            if (url.includes('watch?v=')) embed = 'https://www.youtube.com/embed/' + url.split('watch?v=')[1].split('&')[0] + '?autoplay=1';
            else if (url.includes('youtu.be/')) embed = 'https://www.youtube.com/embed/' + url.split('youtu.be/')[1].split('?')[0] + '?autoplay=1';
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
