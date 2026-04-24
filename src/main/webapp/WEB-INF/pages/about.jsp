<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - MovieMint</title>
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
    <c:set var="currentUser" value="${sessionScope.user}" />

    <c:if test="${not empty currentUser}">
        <c:choose>
            <c:when test="${currentUser.role == 'admin'}">
                <jsp:include page="adminHeader.jsp" />
            </c:when>
            <c:otherwise>
                <jsp:include page="userHeader.jsp" />
            </c:otherwise>
        </c:choose>
    </c:if>
    
    <main class="p-8 min-h-screen">
        <div class="max-w-4xl mx-auto">
            <!-- Header section -->
            <div class="mb-12 text-center">
                <div class="w-20 h-20 mx-auto bg-primary/10 rounded-full flex items-center justify-center text-primary mb-6">
                    <span class="material-symbols-outlined text-[40px]">movie</span>
                </div>
                <h1 class="text-4xl font-bold tracking-tight text-on-surface mb-4 font-headline uppercase">About MovieMint</h1>
                <p class="text-secondary max-w-2xl mx-auto leading-relaxed">We provide a seamless movie booking experience for cinema lovers. Our platform connects moviegoers with their favorite films, making ticket booking simple, fast, and convenient.</p>
            </div>
            
            <div class="space-y-8">
                <!-- Features Grid -->
                <section>
                    <div class="flex items-center gap-3 mb-6">
                        <span class="material-symbols-outlined text-primary">stars</span>
                        <h2 class="text-xl font-bold tracking-tight uppercase text-on-surface font-headline">Features</h2>
                    </div>
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <div class="bg-white p-6 rounded-xl shadow-[0_20px_40px_rgba(20,29,35,0.03)] border border-surface-container transition-transform hover:-translate-y-1">
                            <span class="material-symbols-outlined text-primary mb-4 opacity-80">view_comfy_alt</span>
                            <h3 class="font-bold text-on-surface mb-2">Browse Movies</h3>
                            <p class="text-sm text-secondary">Browse latest movies with detailed information and high-quality posters.</p>
                        </div>
                        
                        <div class="bg-white p-6 rounded-xl shadow-[0_20px_40px_rgba(20,29,35,0.03)] border border-surface-container transition-transform hover:-translate-y-1">
                            <span class="material-symbols-outlined text-primary mb-4 opacity-80">touch_app</span>
                            <h3 class="font-bold text-on-surface mb-2">Easy Booking</h3>
                            <p class="text-sm text-secondary">Effortless online ticket booking process with just a few clicks.</p>
                        </div>
                        
                        <div class="bg-white p-6 rounded-xl shadow-[0_20px_40px_rgba(20,29,35,0.03)] border border-surface-container transition-transform hover:-translate-y-1">
                            <span class="material-symbols-outlined text-primary mb-4 opacity-80">event_seat</span>
                            <h3 class="font-bold text-on-surface mb-2">Seat Selection</h3>
                            <p class="text-sm text-secondary">Multiple show times and visual seat options for your convenience.</p>
                        </div>
                        
                        <div class="bg-white p-6 rounded-xl shadow-[0_20px_40px_rgba(20,29,35,0.03)] border border-surface-container transition-transform hover:-translate-y-1">
                            <span class="material-symbols-outlined text-primary mb-4 opacity-80">payments</span>
                            <h3 class="font-bold text-on-surface mb-2">Secure Payments</h3>
                            <p class="text-sm text-secondary">Safe and secure payment processing for all your bookings.</p>
                        </div>
                        
                        <div class="bg-white p-6 rounded-xl shadow-[0_20px_40px_rgba(20,29,35,0.03)] border border-surface-container transition-transform hover:-translate-y-1">
                            <span class="material-symbols-outlined text-primary mb-4 opacity-80">history</span>
                            <h3 class="font-bold text-on-surface mb-2">Booking History</h3>
                            <p class="text-sm text-secondary">Easily access and manage your past and upcoming movie bookings.</p>
                        </div>
                        
                        <div class="bg-white p-6 rounded-xl shadow-[0_20px_40px_rgba(20,29,35,0.03)] border border-surface-container transition-transform hover:-translate-y-1">
                            <span class="material-symbols-outlined text-primary mb-4 opacity-80">devices</span>
                            <h3 class="font-bold text-on-surface mb-2">User Friendly</h3>
                            <p class="text-sm text-secondary">Clean, responsive, and intuitive interface across all devices.</p>
                        </div>
                    </div>
                </section>
                
                <!-- Why Choose Us -->
                <section class="bg-surface-container-low p-8 rounded-2xl border border-surface-variant/50">
                    <div class="flex items-center gap-3 mb-6">
                        <span class="material-symbols-outlined text-primary">verified</span>
                        <h2 class="text-xl font-bold tracking-tight uppercase text-on-surface font-headline">Why Choose Us?</h2>
                    </div>
                    
                    <ul class="space-y-4">
                        <li class="flex items-start gap-3">
                            <div class="w-6 h-6 rounded-full bg-primary/10 flex items-center justify-center flex-shrink-0 mt-0.5 text-primary">
                                <span class="material-symbols-outlined text-[14px]">check</span>
                            </div>
                            <span class="text-on-surface font-medium">24/7 online booking availability for all your cinematic cravings</span>
                        </li>
                        <li class="flex items-start gap-3">
                            <div class="w-6 h-6 rounded-full bg-primary/10 flex items-center justify-center flex-shrink-0 mt-0.5 text-primary">
                                <span class="material-symbols-outlined text-[14px]">check</span>
                            </div>
                            <span class="text-on-surface font-medium">Real-time seat availability to guarantee your perfect spot</span>
                        </li>
                        <li class="flex items-start gap-3">
                            <div class="w-6 h-6 rounded-full bg-primary/10 flex items-center justify-center flex-shrink-0 mt-0.5 text-primary">
                                <span class="material-symbols-outlined text-[14px]">check</span>
                            </div>
                            <span class="text-on-surface font-medium">Instant booking confirmation directly to your email</span>
                        </li>
                        <li class="flex items-start gap-3">
                            <div class="w-6 h-6 rounded-full bg-primary/10 flex items-center justify-center flex-shrink-0 mt-0.5 text-primary">
                                <span class="material-symbols-outlined text-[14px]">check</span>
                            </div>
                            <span class="text-on-surface font-medium">Dedicated customer support for any ticketing issues</span>
                        </li>
                        <li class="flex items-start gap-3">
                            <div class="w-6 h-6 rounded-full bg-primary/10 flex items-center justify-center flex-shrink-0 mt-0.5 text-primary">
                                <span class="material-symbols-outlined text-[14px]">check</span>
                            </div>
                            <span class="text-on-surface font-medium">Regular updates on new releases, trailers, and promotions</span>
                        </li>
                    </ul>
                </section>
                
            </div>
        </div>
    </main>
</body>
</html>
