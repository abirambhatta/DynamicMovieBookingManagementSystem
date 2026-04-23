<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>CinemaDirector | Booking History</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Manrope:wght@600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "tertiary-fixed": "#95f2f1",
                        "secondary-container": "#dfe0e0",
                        "primary-container": "#dc143c",
                        "on-primary-container": "#fff1f0",
                        "secondary-fixed-dim": "#c6c6c7",
                        "on-tertiary": "#ffffff",
                        "secondary": "#5d5f5f",
                        "on-error": "#ffffff",
                        "surface-container-lowest": "#ffffff",
                        "surface-bright": "#f6faff",
                        "surface-variant": "#dbe4ed",
                        "on-secondary-container": "#616363",
                        "on-secondary-fixed-variant": "#454747",
                        "on-background": "#141d23",
                        "surface-container-highest": "#dbe4ed",
                        "primary": "#b1002c",
                        "on-tertiary-fixed-variant": "#004f4f",
                        "tertiary-container": "#007d7d",
                        "surface-container": "#e6eff8",
                        "on-tertiary-fixed": "#002020",
                        "primary-fixed": "#ffdad9",
                        "on-primary": "#ffffff",
                        "tertiary": "#006262",
                        "outline-variant": "#e6bdbc",
                        "on-surface-variant": "#5c3f3f",
                        "inverse-on-surface": "#e9f2fb",
                        "on-surface": "#141d23",
                        "on-primary-fixed": "#40000a",
                        "secondary-fixed": "#e2e2e2",
                        "outline": "#916f6e",
                        "surface-container-low": "#ecf5fe",
                        "tertiary-fixed-dim": "#78d6d5",
                        "surface-tint": "#bf0030",
                        "background": "#f6faff",
                        "on-secondary-fixed": "#1a1c1c",
                        "inverse-surface": "#293138",
                        "inverse-primary": "#ffb3b3",
                        "primary-fixed-dim": "#ffb3b3",
                        "error-container": "#ffdad6",
                        "on-primary-fixed-variant": "#920022",
                        "surface": "#f6faff",
                        "surface-dim": "#d2dbe4",
                        "surface-container-high": "#e0e9f2",
                        "on-tertiary-container": "#c9fffe",
                        "on-error-container": "#93000a",
                        "error": "#ba1a1a",
                        "on-secondary": "#ffffff"
                    },
                    "borderRadius": {
                        "DEFAULT": "0.125rem",
                        "lg": "0.25rem",
                        "xl": "0.5rem",
                        "full": "0.75rem"
                    },
                    "fontFamily": {
                        "headline": ["Manrope"],
                        "body": ["Inter"],
                        "label": ["Inter"]
                    }
                },
            },
        }
    </script>
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        body { font-family: 'Inter', sans-serif; background-color: #f6faff; color: #141d23; }
        h1, h2, h3, .headline { font-family: 'Manrope', sans-serif; }
    </style>
</head>
<body class="bg-surface">
    <c:if test="${empty user}">
        <c:redirect url="login"/>
    </c:if>

    <jsp:include page="userHeader.jsp" />

    <main class="mx-auto px-8 py-12 pt-12">
        <!-- Page Header -->
        <div class="mb-12">
            <h1 class="text-[3.5rem] font-bold leading-tight tracking-tight text-on-background headline mb-2">Booking History</h1>
            <p class="text-secondary text-lg">Keep track of your cinematic journeys and upcoming premieres.</p>
        </div>
        
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-8">
            <!-- Left Column: Upcoming & Past Lists -->
            <div class="lg:col-span-8 space-y-12">
                <c:choose>
                    <c:when test="${not empty bookings}">
                        <!-- Section: Upcoming Premieres -->
                        <section>
                            <div class="flex items-center gap-3 mb-6">
                                <span class="material-symbols-outlined text-primary" data-icon="event_upcoming" data-weight="fill" style="font-variation-settings: 'FILL' 1;">event_upcoming</span>
                                <h2 class="text-xl font-semibold headline">Upcoming Premieres</h2>
                            </div>
                            
                            <c:set var="hasUpcoming" value="false" />
                            <c:forEach var="booking" items="${bookings}">
                                <c:if test="${booking.status == 'Confirmed'}">
                                    <c:set var="hasUpcoming" value="true" />
                                    <!-- Bento Style Card for Upcoming -->
                                    <div class="bg-surface-container-highest rounded-xl p-6 flex flex-col md:flex-row gap-8 mb-6 group hover:bg-surface-container-high transition-colors">
                                        <div class="w-full md:w-48 aspect-[2/3] rounded-lg overflow-hidden shadow-xl shrink-0 bg-surface-variant flex items-center justify-center">
                                            <span class="material-symbols-outlined text-6xl text-secondary opacity-30">movie</span>
                                        </div>
                                        <div class="flex flex-col justify-between py-2 flex-grow">
                                            <div>
                                                <div class="flex justify-between items-start">
                                                    <span class="text-[10px] font-bold uppercase tracking-widest text-primary mb-2 inline-block">Booking #${booking.bookingId}</span>
                                                    <span class="bg-primary/10 text-primary px-3 py-1 rounded-full text-[10px] font-bold uppercase">Confirmed</span>
                                                </div>
                                                <h3 class="text-2xl font-bold headline mb-1">${booking.movieTitle}</h3>
                                                <div class="flex flex-wrap gap-4 mt-4 text-on-surface-variant font-medium text-sm">
                                                    <div class="flex items-center gap-2">
                                                        <span class="material-symbols-outlined text-primary text-[18px]">calendar_today</span>
                                                        <c:out value="${booking.showTime}" />
                                                    </div>
                                                    <div class="flex items-center gap-2">
                                                        <span class="material-symbols-outlined text-primary text-[18px]">chair</span>
                                                        ${booking.numberOfSeats} Seats
                                                    </div>
                                                    <div class="flex items-center gap-2">
                                                        <span class="material-symbols-outlined text-primary text-[18px]">payments</span>
                                                        Rs. ${booking.totalPrice}
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="flex gap-3 mt-6">
                                                <a href="${pageContext.request.contextPath}/ticketConfirmation?bookingId=${booking.bookingId}" class="bg-primary text-white px-6 py-3 rounded-md text-[11px] font-bold uppercase tracking-widest flex items-center gap-2 hover:brightness-110 transition-all inline-block text-center">
                                                    <span class="material-symbols-outlined text-[18px]">download</span>
                                                    Download Ticket
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                            <c:if test="${!hasUpcoming}">
                                <p class="text-secondary p-4 bg-surface-container-low rounded-lg text-center">No upcoming premieres scheduled.</p>
                            </c:if>
                        </section>

                        <!-- Section: Past Screenings -->
                        <section>
                            <div class="flex items-center gap-3 mb-6">
                                <span class="material-symbols-outlined text-secondary" data-icon="history" data-weight="fill" style="font-variation-settings: 'FILL' 1;">history</span>
                                <h2 class="text-xl font-semibold headline">Past Screenings</h2>
                            </div>
                            <div class="space-y-4">
                                <c:set var="hasPast" value="false" />
                                <c:forEach var="booking" items="${bookings}">
                                    <c:if test="${booking.status == 'Cancelled' || booking.status == 'Completed'}">
                                        <c:set var="hasPast" value="true" />
                                        <!-- Past Item -->
                                        <div class="bg-surface-container-low rounded-lg p-4 flex items-center gap-6 group hover:bg-surface-container transition-colors">
                                            <div class="w-16 h-20 rounded-md overflow-hidden shrink-0 bg-surface-variant flex items-center justify-center">
                                                <span class="material-symbols-outlined text-3xl text-secondary opacity-30">movie</span>
                                            </div>
                                            <div class="flex-grow grid grid-cols-1 md:grid-cols-3 gap-4">
                                                <div>
                                                    <h4 class="font-bold text-sm headline">${booking.movieTitle}</h4>
                                                    <p class="text-[11px] text-secondary">Booking #${booking.bookingId} • ${booking.numberOfSeats} Seats</p>
                                                </div>
                                                <div class="flex flex-col justify-center">
                                                    <p class="text-[11px] font-bold uppercase ${booking.status == 'Cancelled' ? 'text-error' : 'text-emerald-600'}">${booking.status}</p>
                                                    <p class="text-sm font-medium"><c:out value="${booking.showTime}" /></p>
                                                </div>
                                                <div class="flex items-center justify-end gap-4">
                                                    <c:if test="${booking.status == 'Completed'}">
                                                        <button class="text-primary hover:bg-primary/5 p-2 rounded-full transition-all" title="Download Receipt">
                                                            <span class="material-symbols-outlined">file_download</span>
                                                        </button>
                                                        <button class="text-secondary hover:text-primary transition-colors text-[11px] font-bold uppercase tracking-tight">Review</button>
                                                    </c:if>
                                                    <c:if test="${booking.status == 'Cancelled'}">
                                                        <button class="text-secondary hover:text-primary transition-colors text-[11px] font-bold uppercase tracking-tight" title="Booking Cancelled">Details</button>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${!hasPast}">
                                    <p class="text-secondary p-4 bg-surface-container-low rounded-lg text-center">No past screenings.</p>
                                </c:if>
                            </div>
                        </section>
                    </c:when>
                    <c:otherwise>
                        <div class="bg-surface-container-low rounded-xl p-12 text-center">
                            <span class="material-symbols-outlined text-6xl text-secondary opacity-50 mb-4">movie</span>
                            <h2 class="text-2xl font-bold headline mb-2">No Bookings Yet</h2>
                            <p class="text-secondary mb-6">You haven't made any cinematic journeys with us yet.</p>
                            <a href="${pageContext.request.contextPath}/browseMovies" class="inline-block bg-primary text-white px-6 py-3 rounded-md text-[11px] font-bold uppercase tracking-widest hover:bg-primary-container transition-colors">Browse Premieres</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- Right Column: Stats & Profile Quick Actions -->
            <div class="lg:col-span-4 space-y-8">
                <!-- Loyalty Stats Card -->
                <div class="bg-primary text-white rounded-xl p-8 relative overflow-hidden shadow-2xl">
                    <div class="relative z-10">
                        <p class="text-[11px] font-bold uppercase tracking-widest opacity-80 mb-4">Cine-Lover Member</p>
                        <h3 class="text-3xl font-bold headline mb-6">
                            <c:choose>
                                <c:when test="${not empty bookings}">${bookings.size()}</c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose> Movies <br/> 
                            <span class="opacity-60">This Year</span>
                        </h3>
                        <div class="space-y-4 mb-8">
                            <div class="flex justify-between items-center text-xs">
                                <span>Points to next reward</span>
                                <span class="font-bold">850 / 1000</span>
                            </div>
                            <div class="w-full bg-white/20 h-1.5 rounded-full">
                                <div class="bg-white h-full rounded-full" style="width: 85%"></div>
                            </div>
                        </div>
                        <button class="w-full bg-white text-primary py-3 rounded-md text-[11px] font-bold uppercase tracking-widest hover:bg-surface-bright transition-all">Redeem Points</button>
                    </div>
                    <!-- Decorative background element -->
                    <span class="material-symbols-outlined absolute -bottom-8 -right-8 text-[160px] opacity-10 rotate-12" data-icon="confirmation_number">confirmation_number</span>
                </div>
                
                <!-- Quick Filter Sidebar -->
                <div class="bg-surface-container-low rounded-xl p-6">
                    <h3 class="text-sm font-bold headline uppercase tracking-widest mb-6">Filter History</h3>
                    <div class="space-y-3">
                        <a href="${pageContext.request.contextPath}/myBookings" class="block w-full text-left px-4 py-3 rounded-lg bg-surface-container-highest text-primary font-bold text-sm flex justify-between items-center">
                            All Bookings
                            <span class="material-symbols-outlined text-[20px]">chevron_right</span>
                        </a>
                        <button onclick="alert('Client-side filtering to be implemented');" class="w-full text-left px-4 py-3 rounded-lg hover:bg-surface-container-high transition-colors text-on-surface-variant font-medium text-sm flex justify-between items-center">
                            Upcoming Only
                            <span class="material-symbols-outlined text-[20px]">chevron_right</span>
                        </button>
                        <button onclick="alert('Client-side filtering to be implemented');" class="w-full text-left px-4 py-3 rounded-lg hover:bg-surface-container-high transition-colors text-on-surface-variant font-medium text-sm flex justify-between items-center">
                            Canceled
                            <span class="material-symbols-outlined text-[20px]">chevron_right</span>
                        </button>
                    </div>
                    
                    <div class="mt-10">
                        <h3 class="text-sm font-bold headline uppercase tracking-widest mb-4">Account Settings</h3>
                        <div class="space-y-4">
                            <a class="flex items-center gap-3 text-secondary hover:text-primary transition-colors text-sm" href="#">
                                <span class="material-symbols-outlined text-[20px]">payments</span>
                                Payment Methods
                            </a>
                            <a class="flex items-center gap-3 text-secondary hover:text-primary transition-colors text-sm" href="${pageContext.request.contextPath}/userProfile">
                                <span class="material-symbols-outlined text-[20px]">person</span>
                                Profile Details
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Ad/Promo Card -->
                <div class="bg-surface-container-highest border-l-4 border-primary p-6 rounded-r-xl">
                    <p class="text-primary font-bold text-sm mb-2">Director's Cut Sale</p>
                    <p class="text-xs text-secondary leading-relaxed">Enjoy 30% off on all vintage screenings throughout October. Use code VINTAGE30 at checkout.</p>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
