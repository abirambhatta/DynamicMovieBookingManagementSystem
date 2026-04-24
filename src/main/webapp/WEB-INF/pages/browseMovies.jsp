<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
            <!-- Header / Status Tabs -->
            <div class="mb-6 flex flex-col md:flex-row items-start md:items-center gap-6 pb-2">
                <div class="flex items-center gap-6">
                    <a href="${pageContext.request.contextPath}/browseMovies?status=now_showing" class="flex items-center gap-2 text-2xl font-bold font-headline transition-colors ${currentStatus == 'now_showing' ? 'text-primary' : 'text-on-surface hover:text-primary/80'}">
                        <span class="material-symbols-outlined text-[28px] ${currentStatus == 'now_showing' ? 'text-primary' : 'text-secondary'}">smart_display</span>
                        Now Showing
                    </a>
                    <div class="w-px h-6 bg-surface-variant/50"></div>
                    <a href="${pageContext.request.contextPath}/browseMovies?status=coming_soon" class="flex items-center gap-2 text-2xl font-bold font-headline transition-colors ${currentStatus == 'coming_soon' ? 'text-primary' : 'text-secondary hover:text-primary/80'}">
                        <span class="material-symbols-outlined text-[28px] ${currentStatus == 'coming_soon' ? 'text-primary' : 'text-secondary'}">schedule</span>
                        Coming Soon
                    </a>
                </div>
            </div>

            <!-- Date Filters (Only visible if Now Showing) -->
            <c:if test="${currentStatus == 'now_showing'}">
                <div class="mb-10 overflow-x-auto pb-4 scrollbar-hide">
                    <div class="flex gap-3 min-w-max">
                        <c:forEach var="tab" items="${dateTabs}">
                            <a href="${pageContext.request.contextPath}/browseMovies?status=now_showing&date=${tab.value}${not empty param.genre ? '&genre=' += param.genre : ''}${not empty param.language ? '&language=' += param.language : ''}" 
                               class="px-5 py-3 text-sm font-bold transition-all rounded-lg ${currentDate == tab.value ? 'bg-surface-container-lowest border-b-2 border-primary text-primary shadow-sm' : 'bg-surface-container-high text-secondary hover:bg-surface-container-lowest hover:text-primary border-b-2 border-transparent'}">
                                ${tab.display}
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </c:if>
            
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
                            <c:forEach var="g" items="${genres}">
                                <option value="${g}" ${param.genre == g ? 'selected' : ''}>${g}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <!-- Language Filter -->
                    <div class="w-full md:w-48">
                        <label for="languageFilter" class="block text-[10px] font-bold text-secondary uppercase tracking-widest mb-2">Language</label>
                        <select name="language" id="languageFilter" class="w-full bg-surface-container-lowest border border-gray-300 text-on-surface rounded-lg focus:ring-2 focus:ring-primary focus:border-primary px-3 py-3 text-sm transition-all shadow-sm">
                            <option value="">All Languages</option>
                            <c:forEach var="entry" items="${languageMap}">
                                <option value="${entry.key}" ${param.language == entry.key ? 'selected' : ''}>${entry.value}</option>
                            </c:forEach>
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
                            <div class="bg-[#1c2331] rounded-xl overflow-hidden shadow-lg group flex flex-col h-full border border-surface-variant/20 cursor-pointer" onclick="window.location.href='${pageContext.request.contextPath}/movieDetails?id=${movie.movieId}'">
                                <div class="relative w-full aspect-[2/3] overflow-hidden bg-black">
                                    <img src="${pageContext.request.contextPath}/images/${movie.posterImage}" alt="${movie.title}" class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105" onerror="this.style.display='none'">
                                    
                                    <!-- Format and Age Rating Badges overlaid on poster -->
                                    <div class="absolute top-3 right-3 flex flex-col gap-2 items-end z-20">
                                        <c:if test="${not empty movie.format}">
                                            <span class="bg-white/90 backdrop-blur-sm text-primary-dark font-bold text-[10px] uppercase tracking-wider px-2.5 py-1 rounded shadow-sm">${movie.format}</span>
                                        </c:if>
                                        <c:if test="${not empty movie.ageRating}">
                                            <span class="bg-black/70 backdrop-blur-sm text-white font-bold text-[10px] uppercase tracking-wider px-2.5 py-1 rounded border border-white/20 shadow-sm">${movie.ageRating}</span>
                                        </c:if>
                                    </div>
                                    
                                    <!-- Gradient overlay to make buttons pop -->
                                    <div class="absolute inset-x-0 bottom-0 h-24 bg-gradient-to-t from-[#1c2331]/90 to-transparent z-0"></div>
                                    
                                    <!-- Hover/Bottom Overlay for Buttons -->
                                    <div class="absolute bottom-6 inset-x-0 flex flex-col items-center gap-3 px-6 z-10 opacity-0 translate-y-4 group-hover:opacity-100 group-hover:translate-y-0 transition-all duration-300">
                                        <a href="${pageContext.request.contextPath}/bookTicket?movieId=${movie.movieId}" class="w-full bg-white hover:bg-gray-100 text-primary py-3 rounded-lg flex items-center justify-center gap-2 font-bold shadow-md transition-colors">
                                            <span class="material-symbols-outlined text-[20px]">local_activity</span>
                                            Buy Ticket
                                        </a>
                                        <c:if test="${not empty movie.trailerUrl}">
                                            <button type="button" onclick="event.preventDefault(); event.stopPropagation(); openTrailer('${movie.trailerUrl}');" class="w-full bg-white hover:bg-gray-100 text-primary py-3 rounded-lg flex items-center justify-center gap-2 font-bold shadow-md transition-colors">
                                                <span class="material-symbols-outlined text-[20px]">play_circle</span>
                                                Play Trailer
                                            </button>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="p-5 flex flex-col flex-grow bg-[#1c2331]">
                                    <a href="${pageContext.request.contextPath}/movieDetails?id=${movie.movieId}" class="hover:underline">
                                        <h3 class="text-2xl font-bold font-headline text-white mb-1 leading-tight">${movie.title}</h3>
                                    </a>
                                    <fmt:parseNumber var="hours" integerOnly="true" type="number" value="${movie.duration / 60}" />
                                    <p class="text-[14px] text-gray-400 mb-2"><c:if test="${hours > 0}">${hours}h </c:if>${movie.duration % 60}m</p>
                                    <p class="text-[12px] font-bold text-gray-400 uppercase tracking-widest mb-6">${movie.genre}</p>
                                    
                                    <div class="grid grid-cols-2 lg:grid-cols-3 gap-2 mt-auto">
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
                                                            <span class="block text-center border border-red-500/30 text-red-400 bg-red-500/5 cursor-not-allowed rounded py-2 text-[13px] font-medium opacity-60" title="This show has already started">
                                                                ${show.showTime.toString().substring(0,5)}
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="${pageContext.request.contextPath}/bookTicket?movieId=${movie.movieId}&showId=${show.showTimeId}" class="block text-center border border-green-600/50 text-green-500 hover:bg-green-600/10 rounded py-2 text-[13px] font-medium transition-colors">
                                                                ${show.showTime.toString().substring(0,5)}
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="col-span-full py-2 text-center text-xs text-gray-500 italic">No shows scheduled today</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
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

    <!-- Trailer Modal -->
    <div id="trailerModal" class="fixed inset-0 z-[9999] hidden bg-black/90 backdrop-blur-sm flex items-center justify-center p-4 lg:p-12">
        <button type="button" onclick="closeTrailer()" class="absolute top-6 right-6 md:top-8 md:right-8 text-white hover:text-primary transition-colors flex items-center justify-center w-12 h-12 z-50 bg-white/10 hover:bg-white/20 rounded-full border border-white/20 backdrop-blur-sm" title="Close">
            <span class="material-symbols-outlined text-[28px]">close</span>
        </button>
        <div class="relative w-full max-w-5xl aspect-video bg-black rounded-2xl shadow-2xl border border-white/10">
            <div class="w-full h-full overflow-hidden rounded-2xl">
                <iframe id="trailerIframe" class="w-full h-full" src="" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
            </div>
        </div>
    </div>
    
    <script>
        function openTrailer(url) {
            let embedUrl = url;
            if (url.includes('watch?v=')) {
                let videoId = url.split('watch?v=')[1].split('&')[0];
                embedUrl = 'https://www.youtube.com/embed/' + videoId + '?autoplay=1';
            } else if (url.includes('youtu.be/')) {
                let videoId = url.split('youtu.be/')[1].split('?')[0];
                embedUrl = 'https://www.youtube.com/embed/' + videoId + '?autoplay=1';
            } else if (!url.includes('?autoplay=')) {
                // If it's already an embed link but missing autoplay
                if (url.includes('?')) {
                    embedUrl += '&autoplay=1';
                } else {
                    embedUrl += '?autoplay=1';
                }
            }
            document.getElementById('trailerIframe').src = embedUrl;
            document.getElementById('trailerModal').classList.remove('hidden');
        }
        
        function closeTrailer() {
            document.getElementById('trailerModal').classList.add('hidden');
            document.getElementById('trailerIframe').src = ""; // Stop playing
        }
    </script>
</body>
</html>
