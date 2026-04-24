<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                            <div class="bg-surface-container-lowest rounded-xl overflow-hidden shadow-[0_10px_30px_rgba(20,29,35,0.05)] border border-surface-container transition-transform hover:-translate-y-1 hover:shadow-[0_20px_40px_rgba(20,29,35,0.08)] group flex flex-col h-full">
                                <div class="relative w-full aspect-[2/3] overflow-hidden bg-surface-container-high">
                                    <img src="${pageContext.request.contextPath}/images/${movie.posterImage}" alt="${movie.title}" class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105" onerror="this.style.display='none'">
                                    <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300 flex items-end p-4">
                                        <span class="text-white text-xs font-bold uppercase tracking-widest border border-white/40 backdrop-blur-sm px-3 py-1 rounded bg-black/30">View Details</span>
                                    </div>
                                </div>
                                <div class="p-5 flex flex-col flex-grow justify-between">
                                    <div>
                                        <h3 class="text-lg font-bold font-headline text-on-surface mb-2 leading-tight">${movie.title}</h3>
                                        <p class="text-xs font-medium text-secondary uppercase tracking-widest inline-block bg-surface-container-highest px-2 py-1 rounded text-primary">${movie.genre}</p>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/movieDetails?id=${movie.movieId}" class="mt-6 block w-full text-center px-4 py-2.5 bg-surface text-primary text-[11px] font-bold uppercase tracking-widest rounded border border-surface-variant hover:border-primary hover:bg-primary hover:text-white transition-all">Get Tickets</a>
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
</body>
</html>
