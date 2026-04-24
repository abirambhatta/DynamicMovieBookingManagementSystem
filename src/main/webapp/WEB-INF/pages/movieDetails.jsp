<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                
                <!-- Movie Backdrop / Hero Section -->
                <div class="relative w-full h-[400px] lg:h-[500px] overflow-hidden bg-black">
                    <!-- Blur backdrop -->
                    <div class="absolute inset-0 opacity-40">
                        <img src="${pageContext.request.contextPath}/images/${movie.posterImage}" alt="Backdrop" class="w-full h-full object-cover blur-xl scale-110" onerror="this.style.display='none'">
                    </div>
                    <!-- Gradient Overlays -->
                    <div class="absolute inset-0 bg-gradient-to-t from-surface via-surface/80 to-transparent"></div>
                    <div class="absolute inset-0 bg-gradient-to-r from-black/80 via-black/40 to-transparent"></div>
                    
                    <!-- Content Over Backdrop -->
                    <div class="absolute inset-0 flex items-end">
                        <div class="max-w-7xl mx-auto w-full px-8 pb-10 flex flex-col md:flex-row gap-8 items-end">
                            
                            <!-- Poster Container -->
                            <div class="relative w-48 lg:w-64 aspect-[2/3] rounded-xl overflow-hidden shadow-2xl flex-shrink-0 border-4 border-white/10 z-10 hidden md:block translate-y-16">
                                <img src="${pageContext.request.contextPath}/images/${movie.posterImage}" alt="${movie.title}" class="w-full h-full object-cover" onerror="this.style.display='none'">
                            </div>
                            
                            <!-- Title & Metadata -->
                            <div class="flex-1 z-10 mb-4 md:mb-0">
                                <h1 class="text-4xl lg:text-5xl font-bold tracking-tight text-white mb-4 font-headline leading-tight">${movie.title}</h1>
                                
                                <div class="flex flex-wrap items-center gap-3 mb-6">
                                    <c:if test="${not empty movie.format}">
                                        <span class="bg-primary text-white font-bold text-xs uppercase tracking-wider px-3 py-1.5 rounded shadow-sm">${movie.format}</span>
                                    </c:if>
                                    <c:if test="${not empty movie.ageRating}">
                                        <c:choose>
                                            <c:when test="${movie.ageRating == 'R' or movie.ageRating == 'NC-17'}">
                                                <span class="bg-red-900/80 border border-red-500 text-white font-bold text-xs uppercase tracking-wider px-3 py-1.5 rounded shadow-sm flex items-center gap-1">
                                                    <span class="material-symbols-outlined text-[14px]">warning</span>
                                                    ${movie.ageRating} &mdash; 18+ Only
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="bg-white/20 backdrop-blur-sm border border-white/30 text-white font-bold text-xs uppercase tracking-wider px-3 py-1.5 rounded shadow-sm">${movie.ageRating}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                    
                                    <div class="w-1.5 h-1.5 rounded-full bg-white/50 mx-1"></div>
                                    <span class="text-white/90 text-sm font-medium flex items-center gap-1"><span class="material-symbols-outlined text-[16px] text-primary">category</span> ${movie.genre}</span>
                                    
                                    <div class="w-1.5 h-1.5 rounded-full bg-white/50 mx-1"></div>
                                    <span class="text-white/90 text-sm font-medium flex items-center gap-1"><span class="material-symbols-outlined text-[16px] text-primary">language</span> ${movie.language}</span>
                                    
                                    <div class="w-1.5 h-1.5 rounded-full bg-white/50 mx-1"></div>
                                    <span class="text-white/90 text-sm font-medium flex items-center gap-1"><span class="material-symbols-outlined text-[16px] text-primary">schedule</span> ${movie.duration} mins</span>
                                </div>
                                
                                <!-- Mobile Actions -->
                                <div class="md:hidden mt-6">
                                    <a href="${pageContext.request.contextPath}/bookTicket?movieId=${movie.movieId}" class="inline-flex w-full justify-center px-8 py-3 bg-primary text-white text-sm font-bold uppercase tracking-wider rounded-lg shadow-lg shadow-primary/30 active:scale-95 transition-transform items-center gap-2">
                                        <span class="material-symbols-outlined text-[20px]">local_activity</span>
                                        Book Tickets Now
                                    </a>
                                </div>
                            </div>
                            
                            <!-- Desktop Actions -->
                            <div class="hidden md:flex flex-shrink-0 z-10 pb-4">
                                <a href="${pageContext.request.contextPath}/bookTicket?movieId=${movie.movieId}" class="px-8 py-4 bg-primary hover:bg-primary-dark text-white text-sm font-bold uppercase tracking-wider rounded-xl shadow-[0_10px_20px_rgba(220,20,60,0.3)] transition-all hover:-translate-y-1 hover:shadow-[0_15px_25px_rgba(220,20,60,0.4)] flex items-center gap-2">
                                    <span class="material-symbols-outlined text-[24px]">local_activity</span>
                                    Book Tickets Now
                                </a>
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
                                <div class="flex items-center gap-4">
                                    <div class="w-12 h-12 rounded-full bg-surface-container-high flex items-center justify-center text-secondary border border-surface-variant">
                                        <span class="material-symbols-outlined text-[24px]">person</span>
                                    </div>
                                    <div>
                                        <p class="text-[10px] font-bold text-secondary uppercase tracking-widest">Director</p>
                                        <p class="font-bold text-on-surface">${movie.director}</p>
                                    </div>
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
                                        <p class="font-medium text-on-surface">${movie.language}</p>
                                    </div>
                                    <div>
                                        <p class="text-[10px] font-bold text-secondary uppercase tracking-widest">Run Time</p>
                                        <p class="font-medium text-on-surface">${movie.duration} Minutes</p>
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
</body>
</html>
