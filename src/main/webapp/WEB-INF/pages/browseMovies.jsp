<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Movies - MovieMint</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <script id="tailwind-config">
    tailwind.config = {
      darkMode: "class",
      theme: {
        extend: {
          "colors": {
            "primary": "#dc143c",
            "primary-dark": "#b71c1c",
            "secondary": "#5d5f5f",
            "surface": "#f6faff",
            "surface-container": "#e6eff8",
            "surface-container-low": "#ecf5fe",
            "surface-container-lowest": "#ffffff",
            "surface-container-high": "#e0e9f2",
            "surface-container-highest": "#dbe4ed",
            "on-surface": "#141d23",
            "on-surface-variant": "#5c3f3f"
          },
          "fontFamily": {
            "headline": ["Manrope"],
            "body": ["Inter"]
          }
        },
      },
    }
    </script>
    <style>
    .material-symbols-outlined {
        font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
    }
    body { font-family: 'Inter', sans-serif; }
    h1, h2, h3 { font-family: 'Manrope', sans-serif; }
    
    /* Search autocomplete styles tailored for Tailwind */
    .autocomplete-results {
        position: absolute;
        top: 100%;
        left: 0;
        right: 0;
        background: white;
        border: 1px solid #dbe4ed;
        border-top: none;
        max-height: 300px;
        overflow-y: auto;
        z-index: 1000;
        border-bottom-left-radius: 0.5rem;
        border-bottom-right-radius: 0.5rem;
        box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        display: none;
    }
    .autocomplete-results.show { display: block; }
    .autocomplete-item {
        padding: 12px;
        cursor: pointer;
        border-bottom: 1px solid #f6faff;
        display: flex;
        align-items: center;
        gap: 12px;
        transition: background-color 0.2s;
    }
    .autocomplete-item:last-child { border-bottom: none; }
    .autocomplete-item:hover { background-color: #ecf5fe; }
    </style>
</head>
<body class="bg-surface text-on-surface">
    <!-- Check if user is logged in, if not redirect to login page -->
    <c:if test="${empty user}">
        <c:redirect url="login"/>
    </c:if>
    
    <jsp:include page="userHeader.jsp" />
    
    <main class="p-8 min-h-screen">
        <div class="max-w-7xl mx-auto">
            <!-- Header section -->
            <div class="mb-10 flex flex-col md:flex-row justify-between items-start md:items-end gap-6 border-b border-surface-variant pb-6">
                <div>
                    <h1 class="text-3xl font-bold tracking-tight text-on-surface mb-2 font-headline uppercase">Browse Movies</h1>
                    <p class="text-secondary text-sm">Discover and book tickets for the latest releases</p>
                </div>
            </div>
            
            <!-- Search and Filter Section -->
            <div class="bg-white p-6 rounded-xl shadow-[0_10px_30px_rgba(20,29,35,0.03)] border border-surface-container mb-8">
                <form action="${pageContext.request.contextPath}/browseMovies" method="get" class="flex flex-col md:flex-row gap-4 items-end">
                    
                    <!-- Search Input -->
                    <div class="w-full md:flex-1 relative">
                        <label for="searchInput" class="block text-[10px] font-bold text-secondary uppercase tracking-widest mb-2">Search Title</label>
                        <div class="relative">
                            <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-secondary text-[20px]">search</span>
                            <input type="text" name="search" id="searchInput" placeholder="Search movies..." value="${param.search}" autocomplete="off" class="w-full pl-10 pr-4 py-3 bg-surface-container-lowest border border-gray-300 text-on-surface rounded-lg focus:ring-2 focus:ring-primary focus:border-primary text-sm transition-all shadow-sm">
                            <!-- Autocomplete results container -->
                            <div class="autocomplete-results" id="autocompleteResults"></div>
                        </div>
                    </div>
                    
                    <!-- Genre Filter -->
                    <div class="w-full md:w-48">
                        <label for="genreFilter" class="block text-[10px] font-bold text-secondary uppercase tracking-widest mb-2">Genre</label>
                        <select name="genre" id="genreFilter" class="w-full bg-surface-container-lowest border border-gray-300 text-on-surface rounded-lg focus:ring-2 focus:ring-primary focus:border-primary px-3 py-3 text-sm transition-all shadow-sm">
                            <option value="">All Genres</option>
                            <option value="Action" ${param.genre == 'Action' ? 'selected' : ''}>Action</option>
                            <option value="Comedy" ${param.genre == 'Comedy' ? 'selected' : ''}>Comedy</option>
                            <option value="Drama" ${param.genre == 'Drama' ? 'selected' : ''}>Drama</option>
                            <option value="Horror" ${param.genre == 'Horror' ? 'selected' : ''}>Horror</option>
                            <option value="Romance" ${param.genre == 'Romance' ? 'selected' : ''}>Romance</option>
                            <option value="Sci-Fi" ${param.genre == 'Sci-Fi' ? 'selected' : ''}>Sci-Fi</option>
                        </select>
                    </div>
                    
                    <!-- Language Filter -->
                    <div class="w-full md:w-48">
                        <label for="languageFilter" class="block text-[10px] font-bold text-secondary uppercase tracking-widest mb-2">Language</label>
                        <select name="language" id="languageFilter" class="w-full bg-surface-container-lowest border border-gray-300 text-on-surface rounded-lg focus:ring-2 focus:ring-primary focus:border-primary px-3 py-3 text-sm transition-all shadow-sm">
                            <option value="">All Languages</option>
                            <option value="English" ${param.language == 'English' ? 'selected' : ''}>English</option>
                            <option value="Hindi" ${param.language == 'Hindi' ? 'selected' : ''}>Hindi</option>
                            <option value="Nepali" ${param.language == 'Nepali' ? 'selected' : ''}>Nepali</option>
                        </select>
                    </div>
                    
                    <!-- Search Button -->
                    <div class="w-full md:w-auto">
                        <button type="submit" class="w-full md:w-auto px-6 py-3 bg-primary text-white text-xs font-bold uppercase tracking-wider rounded-lg hover:bg-primary-dark transition-colors shadow-md flex items-center justify-center gap-2 h-[46px]">
                            <span class="material-symbols-outlined text-[18px]">filter_list</span>
                            Filter
                        </button>
                    </div>
                </form>
            </div>
            
            <!-- Movies grid display -->
            <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-8">
                <c:choose>
                    <c:when test="${not empty movies}">
                        <c:forEach var="movie" items="${movies}">
                            <div class="bg-surface-container-lowest rounded-xl overflow-hidden shadow-[0_10px_30px_rgba(20,29,35,0.05)] border border-surface-container transition-transform hover:-translate-y-1 hover:shadow-[0_20px_40px_rgba(20,29,35,0.08)] group flex flex-col h-full">
                                <div class="relative w-full aspect-[2/3] overflow-hidden bg-surface-container-high">
                                    <img src="${pageContext.request.contextPath}/images/${movie.posterImage}" alt="${movie.title}" class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105" onerror="this.style.display='none'">
                                    
                                    <!-- Format and Age Rating Badges overlaid on poster -->
                                    <div class="absolute top-3 right-3 flex flex-col gap-2 items-end">
                                        <c:if test="${not empty movie.format}">
                                            <span class="bg-white/90 backdrop-blur-sm text-primary-dark font-bold text-[10px] uppercase tracking-wider px-2.5 py-1 rounded shadow-sm">${movie.format}</span>
                                        </c:if>
                                        <c:if test="${not empty movie.ageRating}">
                                            <span class="bg-black/70 backdrop-blur-sm text-white font-bold text-[10px] uppercase tracking-wider px-2.5 py-1 rounded border border-white/20 shadow-sm">${movie.ageRating}</span>
                                        </c:if>
                                    </div>
                                    
                                    <!-- Hover View Details Overlay -->
                                    <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300 flex items-end p-4">
                                        <span class="text-white text-xs font-bold uppercase tracking-widest border border-white/40 backdrop-blur-sm px-3 py-1 rounded bg-black/30">View Details</span>
                                    </div>
                                </div>
                                <div class="p-5 flex flex-col flex-grow justify-between">
                                    <div>
                                        <h3 class="text-lg font-bold font-headline text-on-surface mb-2 leading-tight">${movie.title}</h3>
                                        <div class="flex flex-wrap gap-2 mb-3">
                                            <span class="text-[10px] font-bold text-secondary uppercase tracking-widest bg-surface-container-highest px-2 py-1 rounded">${movie.genre}</span>
                                            <span class="text-[10px] font-bold text-secondary uppercase tracking-widest bg-surface-container-highest px-2 py-1 rounded">${movie.language}</span>
                                        </div>
                                        <p class="text-xs text-secondary flex items-center gap-1">
                                            <span class="material-symbols-outlined text-[14px]">schedule</span>
                                            ${movie.duration} mins
                                        </p>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/movieDetails?id=${movie.movieId}" class="mt-5 block w-full text-center px-4 py-2.5 bg-surface text-primary text-[11px] font-bold uppercase tracking-widest rounded border border-surface-variant hover:border-primary hover:bg-primary hover:text-white transition-all shadow-sm">Get Tickets</a>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-span-full py-16 flex flex-col items-center justify-center text-secondary bg-surface-container-low rounded-xl border border-surface-variant/50">
                            <span class="material-symbols-outlined text-5xl mb-4 opacity-50">search_off</span>
                            <p class="text-lg font-medium text-on-surface">No movies found</p>
                            <p class="text-sm opacity-80 mt-1">Try adjusting your search or filters.</p>
                            <a href="${pageContext.request.contextPath}/browseMovies" class="mt-4 text-primary text-sm font-bold border-b border-primary">Clear all filters</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>

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
            autocompleteResults.innerHTML = '<div class="p-3 text-center text-sm text-secondary">Searching...</div>';
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
                                html += '<div class="w-10 h-14 bg-surface-container-high rounded overflow-hidden flex-shrink-0"><img src="${pageContext.request.contextPath}/images/' + movie.posterImage + '" alt="' + movie.title + '" class="w-full h-full object-cover" onerror="this.style.display=\'none\'"></div>';
                                html += '<div class="flex-1">';
                                html += '<div class="font-bold text-sm text-on-surface">' + movie.title + '</div>';
                                html += '<div class="text-[10px] text-secondary uppercase tracking-wider mt-0.5">' + movie.genre + ' • ' + movie.language + '</div>';
                                html += '</div>';
                                html += '</a>';
                            });
                            autocompleteResults.innerHTML = html;
                        } else {
                            autocompleteResults.innerHTML = '<div class="p-3 text-center text-sm text-secondary">No movies found</div>';
                        }
                    })
                    .catch(err => {
                        console.error('Search error:', err);
                        autocompleteResults.innerHTML = '<div class="p-3 text-center text-sm text-red-500">Search failed</div>';
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
