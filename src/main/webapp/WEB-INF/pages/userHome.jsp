<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - MovieMint</title>
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
            <!-- Welcome message with user's name -->
        <div class="mb-10">
            <div class="bg-white p-8 rounded-xl shadow-[0_20px_40px_rgba(20,29,35,0.03)] border-l-4 border-primary">
                <h1 class="text-3xl font-bold tracking-tight text-on-surface mb-2 font-headline">Welcome back, ${user.fullName}!</h1>
                <p class="text-secondary font-medium flex items-center gap-2">
                    <span class="material-symbols-outlined text-[18px]">mail</span>
                    ${user.email}
                </p>
                
                <!-- Quick action buttons -->
                <div class="flex flex-wrap gap-4 mt-6">
                    <a href="${pageContext.request.contextPath}/browseMovies" class="inline-flex items-center gap-2 px-6 py-3 bg-primary text-white text-xs font-bold uppercase tracking-wider rounded-lg hover:bg-primary-dark transition-colors shadow-md">
                        <span class="material-symbols-outlined text-[18px]">movie</span>
                        Browse Premieres
                    </a>
                    <a href="${pageContext.request.contextPath}/myBookings" class="inline-flex items-center gap-2 px-6 py-3 bg-white border border-gray-300 text-gray-700 text-xs font-bold uppercase tracking-wider rounded-lg hover:border-primary hover:text-primary transition-colors shadow-sm">
                        <span class="material-symbols-outlined text-[18px]">confirmation_number</span>
                        My Bookings
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Section for recently added movies -->
        <section>
            <div class="flex justify-between items-center mb-6">
                <h2 class="text-2xl font-bold tracking-tight text-on-surface font-headline uppercase">Recently Added Movies</h2>
            </div>
            
            <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-8">
                <c:choose>
                    <c:when test="${not empty recentMovies}">
                        <c:forEach var="movie" items="${recentMovies}">
                            <div class="bg-[#1c2331] rounded-xl overflow-hidden shadow-lg group flex flex-col h-full border border-surface-variant/20 cursor-pointer" onclick="window.location.href='${pageContext.request.contextPath}/movieDetails?id=${movie.movieId}'">
                                <div class="relative w-full aspect-[2/3] overflow-hidden bg-black">
                                    <img src="${pageContext.request.contextPath}/images/${movie.posterImage}" alt="${movie.title}" class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105" onerror="this.style.display='none'">
                                    
                                    <!-- Format and Age Rating Badges -->
                                    <div class="absolute top-3 right-3 flex flex-col gap-2 items-end z-20">
                                        <c:if test="${not empty movie.format}">
                                            <span class="bg-white/90 backdrop-blur-sm text-primary-dark font-bold text-[10px] uppercase tracking-wider px-2.5 py-1 rounded shadow-sm">${movie.format}</span>
                                        </c:if>
                                        <c:if test="${not empty movie.ageRating}">
                                            <span class="bg-black/70 backdrop-blur-sm text-white font-bold text-[10px] uppercase tracking-wider px-2.5 py-1 rounded border border-white/20 shadow-sm">${movie.ageRating}</span>
                                        </c:if>
                                    </div>
                                    
                                    <!-- Gradient overlay -->
                                    <div class="absolute inset-x-0 bottom-0 h-24 bg-gradient-to-t from-[#1c2331]/90 to-transparent z-0"></div>
                                    
                                    <!-- Hover Buttons Overlay -->
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
                                                <c:forEach var="show" items="${shows}">
                                                    <a href="${pageContext.request.contextPath}/bookTicket?movieId=${movie.movieId}&showId=${show.showTimeId}" class="block text-center border border-green-600/50 text-green-500 hover:bg-green-600/10 rounded py-2 text-[13px] font-medium transition-colors">
                                                        ${show.showTime.toString().substring(0,5)}
                                                    </a>
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
                            <span class="material-symbols-outlined text-5xl mb-4 opacity-50">movie</span>
                            <p class="text-lg font-medium">No movies available at the moment.</p>
                            <p class="text-sm opacity-80 mt-1">Check back soon for new premieres.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
        </div>
    </main>
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
                embedUrl += url.includes('?') ? '&autoplay=1' : '?autoplay=1';
            }
            document.getElementById('trailerIframe').src = embedUrl;
            document.getElementById('trailerModal').classList.remove('hidden');
        }
        function closeTrailer() {
            document.getElementById('trailerModal').classList.add('hidden');
            document.getElementById('trailerIframe').src = '';
        }
    </script>
</body>
</html>
