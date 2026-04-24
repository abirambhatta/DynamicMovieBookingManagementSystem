<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Movie Details - MovieMint</title>
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
    
    <main class="min-h-screen pb-12">
        <c:choose>
            <c:when test="${not empty movie}">
                
                <!-- Hero Banner Section -->
                <div class="relative w-full h-[350px] lg:h-[450px] bg-black">
                    <c:choose>
                        <c:when test="${not empty movie.trailerUrl}">
                            <!-- YouTube Thumbnail with Play Button -->
                            <div class="absolute inset-0 cursor-pointer group" onclick="openTrailer('${movie.trailerUrl}')">
                                <img id="bannerThumb" src="" alt="Trailer Thumbnail" class="w-full h-full object-cover opacity-60 transition-transform duration-700 group-hover:scale-105" onerror="this.src='${pageContext.request.contextPath}/images/${movie.posterImage}'; this.classList.add('blur-xl', 'opacity-40');">
                                <div class="absolute inset-0 flex items-center justify-center pb-12">
                                    <div class="w-20 h-20 bg-white/20 backdrop-blur-sm rounded-full flex items-center justify-center border-4 border-white/60 shadow-2xl group-hover:scale-110 transition-transform">
                                        <span class="material-symbols-outlined text-white text-[48px]" style="font-variation-settings: 'FILL' 1;">play_arrow</span>
                                    </div>
                                </div>
                            </div>
                            <script>
                                (function(){
                                    const url = '${movie.trailerUrl}';
                                    let videoId = '';
                                    if (url.includes('watch?v=')) videoId = url.split('watch?v=')[1].split('&')[0];
                                    else if (url.includes('youtu.be/')) videoId = url.split('youtu.be/')[1].split('?')[0];
                                    else if (url.includes('/embed/')) videoId = url.split('/embed/')[1].split('?')[0];
                                    if (videoId) document.getElementById('bannerThumb').src = 'https://img.youtube.com/vi/' + videoId + '/maxresdefault.jpg';
                                })();
                            </script>
                        </c:when>
                        <c:otherwise>
                            <!-- Blurred Poster -->
                            <img src="${pageContext.request.contextPath}/images/${movie.posterImage}" alt="Backdrop" class="w-full h-full object-cover blur-xl opacity-40">
                        </c:otherwise>
                    </c:choose>
                    
                    <!-- Gradient Fade at Bottom -->
                    <div class="absolute inset-x-0 bottom-0 h-48 bg-gradient-to-t from-black via-black/80 to-transparent pointer-events-none"></div>
                </div>

                <!-- Dark Content Wrapper -->
                <div class="w-full bg-black pb-12 relative z-10 shadow-[0_20px_40px_rgba(0,0,0,0.5)]">
                    <div class="max-w-7xl mx-auto w-full px-8 flex flex-col md:flex-row gap-8 items-start">
                        
                        <!-- Poster Container -->
                        <div class="w-48 lg:w-72 aspect-[2/3] rounded-xl overflow-hidden shadow-2xl flex-shrink-0 border-4 border-[#1c2331] bg-black -mt-24 md:-mt-48 z-20">
                            <img src="${pageContext.request.contextPath}/images/${movie.posterImage}" alt="${movie.title}" class="w-full h-full object-cover" onerror="this.style.display='none'">
                        </div>
                        
                        <!-- Title & Metadata -->
                        <div class="flex-1 mt-4 md:mt-2 z-20">
                            <h1 class="text-4xl lg:text-5xl font-bold tracking-tight text-white mb-2 font-headline leading-tight">${movie.title}</h1>
                            
                            <div class="w-10 h-0.5 bg-primary mb-4"></div>
                            
                            <div class="flex flex-wrap items-center gap-3 mb-6">
                                <c:if test="${not empty movie.format}">
                                    <span class="bg-primary text-white font-bold text-[11px] uppercase tracking-wider px-2 py-1 rounded shadow-sm">${movie.format}</span>
                                </c:if>
                                <c:if test="${not empty movie.ageRating}">
                                    <c:choose>
                                        <c:when test="${movie.ageRating == 'R' or movie.ageRating == 'NC-17'}">
                                            <span class="bg-red-900/80 border border-red-500 text-white font-bold text-[11px] uppercase tracking-wider px-2 py-1 rounded shadow-sm flex items-center gap-1">
                                                <span class="material-symbols-outlined text-[12px]">warning</span>
                                                ${movie.ageRating}
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="bg-white/10 text-white font-bold text-[11px] uppercase tracking-wider px-2 py-1 rounded border border-white/20 shadow-sm">${movie.ageRating}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                                
                                <div class="w-1 h-1 rounded-full bg-white/30 mx-1"></div>
                                <span class="text-white/80 text-sm font-medium flex items-center gap-1.5"><span class="material-symbols-outlined text-[16px] text-primary/80">category</span> ${movie.genre}</span>
                                
                                <div class="w-1 h-1 rounded-full bg-white/30 mx-1"></div>
                                <span class="text-white/80 text-sm font-medium flex items-center gap-1.5"><span class="material-symbols-outlined text-[16px] text-primary/80">language</span> 
                                <c:choose>
                                    <c:when test="${movie.language == 'BN'}">Bengali</c:when>
                                    <c:when test="${movie.language == 'EN'}">English</c:when>
                                    <c:when test="${movie.language == 'HI'}">Hindi</c:when>
                                    <c:when test="${movie.language == 'NE'}">Nepali</c:when>
                                    <c:otherwise>${movie.language}</c:otherwise>
                                </c:choose>
                                </span>
                                
                                <div class="w-1 h-1 rounded-full bg-white/30 mx-1"></div>
                                <span class="text-white/80 text-sm font-medium flex items-center gap-1.5"><span class="material-symbols-outlined text-[16px] text-primary/80">schedule</span> 
                                <fmt:parseNumber var="hours" integerOnly="true" type="number" value="${movie.duration / 60}" />
                                <c:if test="${hours > 0}">${hours}h </c:if>${movie.duration % 60}m
                                </span>
                            </div>
                            
                            <!-- Action Buttons -->
                            <div class="flex flex-wrap gap-4 mt-8">
                                <a href="${pageContext.request.contextPath}/bookTicket?movieId=${movie.movieId}" class="px-8 py-3 bg-primary hover:bg-primary-dark text-white text-sm font-bold uppercase tracking-wider rounded-md shadow-lg shadow-primary/20 transition-all hover:-translate-y-1 flex items-center justify-center gap-2 w-full md:w-auto">
                                    <span class="material-symbols-outlined text-[20px]">local_activity</span>
                                    Book Tickets Now
                                </a>
                                <c:if test="${not empty movie.trailerUrl}">
                                    <button type="button" onclick="openTrailer('${movie.trailerUrl}')" class="px-8 py-3 bg-white/10 hover:bg-white/20 backdrop-blur-md text-white border border-white/20 text-sm font-bold uppercase tracking-wider rounded-md transition-all hover:-translate-y-1 flex items-center justify-center gap-2 w-full md:w-auto">
                                        <span class="material-symbols-outlined text-[20px]">play_circle</span>
                                        Watch Trailer
                                    </button>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Main Details Section -->
                <div class="max-w-7xl mx-auto px-8 mt-8 md:mt-24">
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-12">
                        <!-- Left Column (Synopsis & Crew) -->
                        <div class="md:col-span-2 space-y-8">
                            <section class="bg-white p-8 rounded-2xl shadow-[0_20px_40px_rgba(20,29,35,0.03)] border border-surface-container">
                                <h2 class="text-xl font-bold tracking-tight uppercase text-on-surface font-headline mb-4 flex items-center gap-2">
                                    <span class="material-symbols-outlined text-primary">subject</span>
                                    Synopsis
                                </h2>
                                <p class="text-on-surface-variant leading-relaxed text-[15px]">${movie.description}</p>
                            </section>
                            
                            <section class="bg-surface-container-lowest p-8 rounded-2xl shadow-[0_20px_40px_rgba(20,29,35,0.03)] border border-surface-container">
                                <h2 class="text-xl font-bold tracking-tight uppercase text-on-surface font-headline mb-6 flex items-center gap-2">
                                    <span class="material-symbols-outlined text-primary">groups</span>
                                    Cast & Crew
                                </h2>
                                <div class="flex flex-col md:flex-row gap-8">
                                    <div class="flex items-center gap-4">
                                        <div class="w-12 h-12 rounded-full bg-surface-container-high flex items-center justify-center text-secondary border border-surface-variant shrink-0">
                                            <span class="material-symbols-outlined text-[24px]">movie_creation</span>
                                        </div>
                                        <div>
                                            <p class="text-[10px] font-bold text-secondary uppercase tracking-widest">Director</p>
                                            <p class="font-bold text-on-surface">${movie.director}</p>
                                        </div>
                                    </div>
                                    
                                    <c:if test="${not empty movie.castList}">
                                    <div class="flex items-center gap-4">
                                        <div class="w-12 h-12 rounded-full bg-surface-container-high flex items-center justify-center text-secondary border border-surface-variant shrink-0">
                                            <span class="material-symbols-outlined text-[24px]">recent_actors</span>
                                        </div>
                                        <div>
                                            <p class="text-[10px] font-bold text-secondary uppercase tracking-widest">Cast</p>
                                            <p class="font-medium text-on-surface leading-tight max-w-md">${movie.castList}</p>
                                        </div>
                                    </div>
                                    </c:if>
                                </div>
                            </section>
                        </div>
                        
                        <!-- Right Column (Sidebar Information) -->
                        <div class="md:col-span-1 space-y-6">
                            <div class="bg-surface-container-low p-6 rounded-2xl border border-surface-variant/50">
                                <h3 class="text-xs font-bold uppercase tracking-widest text-secondary mb-4 border-b border-surface-variant pb-2">Information</h3>
                                
                                <div class="space-y-4">
                                    <div>
                                        <p class="text-[10px] font-bold text-secondary uppercase tracking-widest">Release Format</p>
                                        <p class="font-medium text-on-surface">${not empty movie.format ? movie.format : 'Standard 2D'}</p>
                                    </div>
                                    <div>
                                        <p class="text-[10px] font-bold text-secondary uppercase tracking-widest">Language</p>
                                        <p class="font-medium text-on-surface">
                                            <c:choose>
                                                <c:when test="${movie.language == 'BN'}">Bengali</c:when>
                                                <c:when test="${movie.language == 'EN'}">English</c:when>
                                                <c:when test="${movie.language == 'HI'}">Hindi</c:when>
                                                <c:when test="${movie.language == 'NE'}">Nepali</c:when>
                                                <c:otherwise>${movie.language}</c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                    <div>
                                        <p class="text-[10px] font-bold text-secondary uppercase tracking-widest">Run Time</p>
                                        <p class="font-medium text-on-surface">
                                            <c:if test="${hours > 0}">${hours}h </c:if>${movie.duration % 60}m
                                        </p>
                                    </div>
                                    <div>
                                        <p class="text-[10px] font-bold text-secondary uppercase tracking-widest">Certification</p>
                                        <p class="font-medium text-on-surface">${not empty movie.ageRating ? movie.ageRating : 'Not Rated'}</p>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="bg-surface-container-low p-6 rounded-2xl border border-surface-variant flex flex-col items-center justify-center text-center">
                                <span class="material-symbols-outlined text-primary text-[32px] mb-2">theater_comedy</span>
                                <h3 class="font-bold font-headline text-on-surface mb-1">Experience it on the big screen</h3>
                                <p class="text-xs text-secondary mb-4">Secure your favorite seats today.</p>
                                <a href="${pageContext.request.contextPath}/bookTicket?movieId=${movie.movieId}" class="w-full py-2.5 bg-primary text-white text-[11px] font-bold uppercase tracking-widest rounded-lg hover:bg-primary-dark transition-colors shadow-sm text-center">Book Now</a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:when>
            
            <c:otherwise>
                <div class="max-w-7xl mx-auto px-8 py-20 flex flex-col items-center justify-center text-center">
                    <span class="material-symbols-outlined text-[64px] text-secondary/30 mb-4">broken_image</span>
                    <h1 class="text-2xl font-bold font-headline text-on-surface mb-2">Movie Not Found</h1>
                    <p class="text-secondary mb-6">The movie you are looking for does not exist or has been removed.</p>
                    <a href="${pageContext.request.contextPath}/browseMovies" class="px-6 py-2 bg-primary text-white text-xs font-bold uppercase tracking-wider rounded-lg hover:bg-primary-dark transition-colors shadow-sm">Browse Movies</a>
                </div>
            </c:otherwise>
        </c:choose>
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
