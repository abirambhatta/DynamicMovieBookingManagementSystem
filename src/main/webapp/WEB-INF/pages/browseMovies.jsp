<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- Browse movies page. List of all movies. --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Movies - MovieMint</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* Search autocomplete styles */
        .search-form { position: relative; }
        .autocomplete-results {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: white;
            border: 1px solid #ddd;
            border-top: none;
            max-height: 300px;
            overflow-y: auto;
            z-index: 1000;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            display: none;
        }
        .autocomplete-results.show { display: block; }
        .autocomplete-item {
            padding: 12px;
            cursor: pointer;
            border-bottom: 1px solid #f0f0f0;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .autocomplete-item:hover { background: #f5f5f5; }
        .autocomplete-item img {
            width: 40px;
            height: 60px;
            object-fit: cover;
            border-radius: 4px;
        }
        .autocomplete-item-info { flex: 1; }
        .autocomplete-item-title { font-weight: 700; color: #1a1a1a; }
        .autocomplete-item-meta { font-size: 12px; color: #666; }
        .autocomplete-loading {
            padding: 12px;
            text-align: center;
            color: #999;
            font-size: 13px;
        }
    </style>
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
            <h1>Browse Movies</h1>
            
            <!-- Search and filter section -->
            <div class="search-filter-section">
                <!-- Search form to find movies by name -->
                <form action="${pageContext.request.contextPath}/browseMovies" method="get" class="search-form">
                    <!-- Search input field -->
                    <input type="text" name="search" id="searchInput" placeholder="Search movies..." value="${param.search}" autocomplete="off">
                    <!-- Autocomplete results container -->
                    <div class="autocomplete-results" id="autocompleteResults"></div>
                    <!-- Search button -->
                    <button type="submit" class="btn-search">Search</button>
                </form>
                
                <!-- Filter section for genre and language -->
                <div class="filter-section">
                    <!-- Genre filter dropdown -->
                    <label>Genre:</label>
                    <select name="genre" id="genreFilter">
                        <option value="">All Genres</option>
                        <option value="Action">Action</option>
                        <option value="Comedy">Comedy</option>
                        <option value="Drama">Drama</option>
                        <option value="Horror">Horror</option>
                        <option value="Romance">Romance</option>
                        <option value="Sci-Fi">Sci-Fi</option>
                    </select>
                    
                    <!-- Language filter dropdown -->
                    <label>Language:</label>
                    <select name="language" id="languageFilter">
                        <option value="">All Languages</option>
                        <option value="English">English</option>
                        <option value="Hindi">Hindi</option>
                        <option value="Nepali">Nepali</option>
                    </select>
                </div>
            </div>
            
            <!-- Movies grid display -->
            <div class="movies-grid">
                <!-- Check if movies list has data -->
                <c:choose>
                    <c:when test="${not empty movies}">
                        <!-- Loop through each movie -->
                        <c:forEach var="movie" items="${movies}">
                            <!-- Movie card -->
                            <div class="movie-card">
                                <!-- Movie poster image -->
                                <div class="movie-poster">
                                    <img src="${pageContext.request.contextPath}/images/${movie.posterImage}" alt="${movie.title}">
                                </div>
                                <!-- Movie details -->
                                <div class="movie-details">
                                    <!-- Movie title -->
                                    <h3>${movie.title}</h3>
                                    <!-- Format and Age Rating badges -->
                                    <div style="display:flex; gap:6px; flex-wrap:wrap; margin-bottom:8px;">
                                        <c:if test="${not empty movie.format}">
                                            <span style="background:#e8f4f8;color:#2980b9;padding:2px 10px;border-radius:12px;font-size:11px;font-weight:700;">${movie.format}</span>
                                        </c:if>
                                        <c:if test="${not empty movie.ageRating}">
                                            <c:choose>
                                                <c:when test="${movie.ageRating == 'R' or movie.ageRating == 'NC-17'}">
                                                    <span style="background:#fde8e8;color:#c0392b;padding:2px 10px;border-radius:12px;font-size:11px;font-weight:700;">${movie.ageRating}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="background:#fdf2f8;color:#8e44ad;padding:2px 10px;border-radius:12px;font-size:11px;font-weight:700;">${movie.ageRating}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:if>
                                    </div>
                                    <!-- Movie genre -->
                                    <p><strong>Genre:</strong> ${movie.genre}</p>
                                    <!-- Movie language -->
                                    <p><strong>Language:</strong> ${movie.language}</p>
                                    <!-- Movie duration in minutes -->
                                    <p><strong>Duration:</strong> ${movie.duration} mins</p>
                                    <!-- Link to view full movie details -->
                                    <a href="${pageContext.request.contextPath}/movieDetails?id=${movie.movieId}" class="btn-primary">View Details</a>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <!-- Show message if no movies found -->
                        <p class="no-results">No movies found.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script>
        // ===========================
        // MOVIE SEARCH AUTOCOMPLETE (REST API)
        // ===========================
        const searchInput = document.getElementById('searchInput');
        const autocompleteResults = document.getElementById('autocompleteResults');
        let searchTimeout = null;

        searchInput.addEventListener('input', function() {
            const query = this.value.trim();
            
            // Clear previous timeout
            if (searchTimeout) clearTimeout(searchTimeout);
            
            // Hide results if query is empty
            if (query.length < 2) {
                autocompleteResults.classList.remove('show');
                return;
            }
            
            // Show loading state
            autocompleteResults.innerHTML = '<div class="autocomplete-loading">Searching...</div>';
            autocompleteResults.classList.add('show');
            
            // Debounce: wait 300ms after user stops typing
            searchTimeout = setTimeout(() => {
                fetch('${pageContext.request.contextPath}/api/movies/search?q=' + encodeURIComponent(query))
                    .then(res => res.json())
                    .then(data => {
                        if (data.success && data.movies.length > 0) {
                            let html = '';
                            data.movies.forEach(movie => {
                                html += '<a href="${pageContext.request.contextPath}/movieDetails?id=' + movie.movieId + '" class="autocomplete-item">';
                                html += '<img src="${pageContext.request.contextPath}/images/' + movie.posterImage + '" alt="' + movie.title + '">';
                                html += '<div class="autocomplete-item-info">';
                                html += '<div class="autocomplete-item-title">' + movie.title + '</div>';
                                html += '<div class="autocomplete-item-meta">' + movie.genre + ' • ' + movie.language + '</div>';
                                html += '</div>';
                                html += '</a>';
                            });
                            autocompleteResults.innerHTML = html;
                        } else {
                            autocompleteResults.innerHTML = '<div class="autocomplete-loading">No movies found</div>';
                        }
                    })
                    .catch(err => {
                        console.error('Search error:', err);
                        autocompleteResults.innerHTML = '<div class="autocomplete-loading">Search failed</div>';
                    });
            }, 300);
        });

        // Hide autocomplete when clicking outside
        document.addEventListener('click', function(e) {
            if (!searchInput.contains(e.target) && !autocompleteResults.contains(e.target)) {
                autocompleteResults.classList.remove('show');
            }
        });
    </script>
</body>
</html>
