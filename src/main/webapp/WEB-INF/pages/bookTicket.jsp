<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>${movie.title} - Select Seats</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Epilogue:wght@700;800;900&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <script id="tailwind-config">
        tailwind.config = {
          darkMode: "class",
          theme: {
            extend: {
              "colors": {
                "primary": "#dc143c",
                "on-primary": "#ffffff",
                "secondary": "#1a1a1a",
                "surface": "#ffffff",
                "on-surface": "#1a1a1a",
                "surface-container": "#f5f5f5",
                "surface-container-low": "#fafafa",
                "surface-container-high": "#eeeeee",
                "surface-container-highest": "#e0e0e0",
                "outline": "#d1d1d1",
                "outline-variant": "#e5e5e5",
                "on-surface-variant": "#666666"
              },
              "fontFamily": {
                "headline": ["Epilogue"],
                "body": ["Manrope"],
                "label": ["Manrope"]
              }
            },
          },
        }
    </script>
    <style>
        body { font-family: 'Manrope', sans-serif; background-color: #ffffff; color: #1a1a1a; }
        .font-epilogue { font-family: 'Epilogue', sans-serif; }
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
        .curved-screen {
          height: 60px;
          width: 100%;
          background: linear-gradient(to bottom, #dc143c1a 0%, transparent 100%);
          border-top: 4px solid #dc143c;
          border-radius: 50% 50% 0 0 / 100% 100% 0 0;
        }
        .seat-grid {
          display: grid;
          grid-template-columns: repeat(16, minmax(0, 1fr));
          gap: 0.75rem;
        }
        .perspective-theater {
          perspective: 1000px;
        }
        .seat-map-container {
          transform: rotateX(15deg);
        }
        .custom-scrollbar::-webkit-scrollbar { width: 6px; }
        .custom-scrollbar::-webkit-scrollbar-track { background: #f5f5f5; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: #e0e0e0; border-radius: 10px; }
        .selected-seat { background-color: #dc143c !important; }
        .seat-base { transition: background-color 0.2s ease; }
    </style>
</head>
<body class="bg-surface text-on-surface antialiased overflow-hidden">
    <c:if test="${empty user}">
        <c:redirect url="login"/>
    </c:if>

    <main class="h-screen flex overflow-hidden">
        <!-- Left Canvas: Seat Selection -->
        <section class="flex-1 px-12 pb-12 flex flex-col items-center overflow-y-auto custom-scrollbar">
            <div class="w-full max-w-5xl mt-6">
                <!-- Header navigation -->
                <a href="${pageContext.request.contextPath}/movieDetails?id=${movie.movieId}" class="text-on-surface-variant hover:text-primary mb-6 flex items-center gap-1">
                    <span class="material-symbols-outlined text-sm">arrow_back</span>
                    <span class="text-sm font-bold uppercase">Back to Details</span>
                </a>
                
                <header class="mb-12 flex justify-between items-end">
                    <div>
                        <span id="selectedHallLabel" class="text-primary font-bold text-xs tracking-widest uppercase mb-2 block">Grand Hall 04</span>
                        <h1 class="text-5xl font-black font-epilogue tracking-tighter leading-none text-secondary">${movie.title}</h1>
                    </div>
                    <div class="flex space-x-6">
                        <div class="flex items-center space-x-2">
                            <div class="w-4 h-4 bg-surface-container-highest rounded-sm"></div>
                            <span class="text-xs text-on-surface-variant font-bold uppercase tracking-wider">Available</span>
                        </div>
                        <div class="flex items-center space-x-2">
                            <div class="w-4 h-4 bg-primary rounded-sm"></div>
                            <span class="text-xs text-on-surface-variant font-bold uppercase tracking-wider">Selected</span>
                        </div>
                        <div class="flex items-center space-x-2">
                            <div class="w-4 h-4 bg-surface-container border border-outline-variant rounded-sm"></div>
                            <span class="text-xs text-on-surface-variant font-bold uppercase tracking-wider">Reserved</span>
                        </div>
                    </div>
                </header>

                <!-- Screen Visual -->
                <div class="w-full mb-20">
                    <div class="curved-screen mx-auto max-w-3xl mb-4"></div>
                    <p class="text-center text-[10px] font-bold text-on-surface-variant tracking-[0.4em] uppercase">Cinema Screen Projection Area</p>
                </div>

                <!-- Seat Grid -->
                <div class="perspective-theater pb-20">
                    <div class="seat-map-container flex flex-col space-y-6" id="seatContainer">
                        <div class="flex flex-col space-y-3">
                            <!-- Seat Rows (Irregular Layout) -->
                            <div class="flex items-center space-x-8 row-container">
                                <span class="text-[10px] font-bold text-on-surface-variant w-4 text-center">A</span>
                                <div class="seat-grid flex-1">
                                    <div class="w-6 h-6 bg-surface-container border border-outline-variant rounded-sm"></div>
                                    <div class="w-6 h-6 bg-surface-container border border-outline-variant rounded-sm"></div>
                                    <div class="col-span-1"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="col-span-1"></div>
                                    <div class="w-6 h-6 bg-surface-container border border-outline-variant rounded-sm"></div>
                                    <div class="w-6 h-6 bg-surface-container border border-outline-variant rounded-sm"></div>
                                </div>
                            </div>
                            <div class="flex items-center space-x-8 row-container">
                                <span class="text-[10px] font-bold text-on-surface-variant w-4 text-center">B</span>
                                <div class="seat-grid flex-1">
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="col-span-1"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="col-span-1"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                </div>
                            </div>
                            <div class="flex items-center space-x-8 row-container">
                                <span class="text-[10px] font-bold text-on-surface-variant w-4 text-center">C</span>
                                <div class="seat-grid flex-1">
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="col-span-1"></div>
                                    <div class="w-6 h-6 bg-surface-container border border-outline-variant rounded-sm"></div>
                                    <div class="w-6 h-6 bg-surface-container border border-outline-variant rounded-sm"></div>
                                    <div class="w-6 h-6 bg-surface-container border border-outline-variant rounded-sm"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="col-span-1"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                </div>
                            </div>
                            <div class="flex items-center space-x-8 row-container">
                                <span class="text-[10px] font-bold text-on-surface-variant w-4 text-center">D</span>
                                <div class="seat-grid flex-1">
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="col-span-1"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="col-span-1"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                </div>
                            </div>
                            <div class="flex items-center space-x-8 pt-8 row-container">
                                <span class="text-[10px] font-bold text-on-surface-variant w-4 text-center">E</span>
                                <div class="seat-grid flex-1">
                                    <div class="w-6 h-6 border-2 border-primary rounded-sm bg-white hover:bg-primary/10 seat-base cursor-pointer transition-all"></div>
                                    <div class="w-6 h-6 border-2 border-primary rounded-sm bg-white hover:bg-primary/10 seat-base cursor-pointer transition-all"></div>
                                    <div class="col-span-1"></div>
                                    <div class="w-6 h-6 border-2 border-primary rounded-sm bg-white hover:bg-primary/10 seat-base cursor-pointer transition-all"></div>
                                    <div class="w-6 h-6 border-2 border-primary rounded-sm bg-white hover:bg-primary/10 seat-base cursor-pointer transition-all"></div>
                                    <div class="w-6 h-6 border-2 border-primary rounded-sm bg-white hover:bg-primary/10 seat-base cursor-pointer transition-all"></div>
                                    <div class="w-6 h-6 border-2 border-primary rounded-sm bg-white hover:bg-primary/10 seat-base cursor-pointer transition-all"></div>
                                    <div class="w-6 h-6 border-2 border-primary rounded-sm bg-white hover:bg-primary/10 seat-base cursor-pointer transition-all"></div>
                                    <div class="w-6 h-6 border-2 border-primary rounded-sm bg-white hover:bg-primary/10 seat-base cursor-pointer transition-all"></div>
                                    <div class="w-6 h-6 border-2 border-primary rounded-sm bg-white hover:bg-primary/10 seat-base cursor-pointer transition-all"></div>
                                    <div class="w-6 h-6 border-2 border-primary rounded-sm bg-white hover:bg-primary/10 seat-base cursor-pointer transition-all"></div>
                                    <div class="w-6 h-6 border-2 border-primary rounded-sm bg-white hover:bg-primary/10 seat-base cursor-pointer transition-all"></div>
                                    <div class="col-span-1"></div>
                                    <div class="w-6 h-6 border-2 border-primary rounded-sm bg-white hover:bg-primary/10 seat-base cursor-pointer transition-all"></div>
                                    <div class="w-6 h-6 border-2 border-primary rounded-sm bg-white hover:bg-primary/10 seat-base cursor-pointer transition-all"></div>
                                </div>
                            </div>
                            <div class="flex items-center space-x-8 row-container">
                                <span class="text-[10px] font-bold text-on-surface-variant w-4 text-center">F</span>
                                <div class="seat-grid flex-1">
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="col-span-1"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="col-span-1"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                    <div class="w-6 h-6 bg-surface-container-highest rounded-sm seat-base cursor-pointer"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Right Sidebar: Order Summary Form -->
        <form id="bookingForm" action="${pageContext.request.contextPath}/bookTicket" method="post" class="w-[420px] bg-surface-container-low border-l border-outline-variant flex flex-col z-10">
            <!-- Hidden Fields for Booking -->
            <input type="hidden" name="movieId" value="${movie.movieId}">
            <input type="hidden" name="finalShowTime" id="finalShowTimeInput" value="">
            <input type="hidden" name="numberOfSeats" id="numberOfSeatsInput" value="0">
            <input type="hidden" name="selectedSeatIds" id="selectedSeatIdsInput" value="">
            
            <div class="p-8 space-y-8 flex-1 overflow-y-auto custom-scrollbar">
                <!-- Data Error/Success -->
                <c:if test="${not empty error}">
                    <div class="bg-red-100 text-red-800 p-3 rounded text-sm font-bold">${error}</div>
                </c:if>

                <!-- Date Selection -->
                <section>
                    <h3 class="text-xs font-bold text-on-surface-variant uppercase tracking-widest mb-4">Date</h3>
                    <div id="dateContainer" class="flex flex-wrap gap-3">
                        <!-- Dates rendered here dynamically -->
                        <span class="text-xs text-on-surface-variant">Loading dates...</span>
                    </div>
                </section>

                <!-- Showtime Selection -->
                <section>
                    <h3 class="text-xs font-bold text-on-surface-variant uppercase tracking-widest mb-4">Showtime</h3>
                    <div id="timeContainer" class="flex flex-wrap gap-2">
                        <!-- Times rendered here dynamically -->
                        <span class="text-xs text-on-surface-variant">Select a date first</span>
                    </div>
                </section>

                <!-- Order Summary Detail -->
                <section class="bg-white border border-outline-variant rounded p-6 space-y-4">
                    <h3 class="text-xs font-bold text-on-surface-variant uppercase tracking-widest">Order Summary</h3>
                    <div class="flex justify-between items-start">
                        <div class="flex items-center space-x-4">
                            <div class="w-16 h-20 bg-surface-container rounded overflow-hidden relative border border-outline-variant">
                                <img class="w-full h-full object-cover" src="${pageContext.request.contextPath}/images/${movie.posterImage}" alt="${movie.title}"/>
                            </div>
                            <div>
                                <p class="text-sm font-bold text-secondary">${movie.title}</p>
                                <p class="text-xs text-on-surface-variant">${movie.language} • ${movie.duration} min</p>
                            </div>
                        </div>
                        <div class="text-right">
                            <p class="text-xs font-bold text-primary uppercase tracking-tighter" id="summaryHallName">Select Hall</p>
                        </div>
                    </div>
                    
                    <div class="pt-4 border-t border-outline-variant space-y-3">
                        <div class="flex justify-between text-sm">
                            <span class="text-on-surface-variant">Selected Seats (<span id="seatCountLabel">0</span>)</span>
                            <span class="font-bold text-secondary text-right" id="seatIdsLabel" style="word-break: break-all;">None</span>
                        </div>
                        <div class="flex justify-between text-sm">
                            <span class="text-on-surface-variant">Ticket Price</span>
                            <span class="font-bold text-secondary">Rs. <span id="unitPriceLabel">${standardPrice}</span></span>
                        </div>
                        <div class="flex justify-between text-sm text-primary font-bold">
                            <span>Selected Showtime</span>
                            <span id="selectedShowtimeLabel" class="text-right">Pick a time</span>
                        </div>
                    </div>
                </section>
            </div>

            <!-- Footer CTA -->
            <div class="p-8 bg-white border-t border-outline-variant">
                <div class="flex justify-between items-center mb-6">
                    <div>
                        <p class="text-xs font-bold text-on-surface-variant uppercase tracking-widest">Total Payable</p>
                        <p class="text-3xl font-black font-epilogue text-primary">Rs. <span id="totalPriceLabel">0.00</span></p>
                    </div>
                    <div class="text-right">
                        <p class="text-[10px] text-on-surface-variant uppercase">Includes Tax</p>
                    </div>
                </div>
                <!-- Submit visually disabled if invalid -->
                <button type="submit" id="submitBtn" class="w-full bg-surface-container-highest text-on-surface-variant py-4 rounded font-black font-epilogue tracking-tight text-lg shadow transition-all cursor-not-allowed">
                    BOOK TICKETS
                </button>
            </div>
        </form>
    </main>

    <script>
        // Constants & Data
        const standardPrice = ${standardPrice}; // Default price injected from backend
        // showTimesJson contains objects: { date: "YYYY-MM-DD", time: "18:00", hall: "Grand Hall 04" }
        const rawShowTimes = ${showTimesJson != null ? showTimesJson : '[]'};
        // bookedSeatsData maps finalShowTime to an array string of seats e.g. {"2026-10-24 14:30 - Grand Hall 01": "B10, B11"}
        const bookedSeatsData = ${bookedSeatsJson != null ? bookedSeatsJson : '{}'};
        
        const movieStartDateStr = "${movie.startDate}";
        const movieEndDateStr = "${movie.endDate}";
        
        let selectedSeatsMap = new Set();
        let currentSelectedDate = null;
        let currentSelectedTimeObj = null;

        // Group showtimes by Date: { "YYYY-MM-DD": [ { time: "18:00", hall: "..." } ] }
        const showTimesGrouped = {};
        rawShowTimes.forEach(st => {
            if (!showTimesGrouped[st.date]) showTimesGrouped[st.date] = [];
            showTimesGrouped[st.date].push(st);
        });

        // Generate dates directly from the movie's start AND end dates bounds
        const sortedDates = [];
        if (movieStartDateStr && movieEndDateStr) {
            let start = new Date(movieStartDateStr);
            let end = new Date(movieEndDateStr);
            while(start <= end) {
                sortedDates.push(start.toISOString().split('T')[0]);
                start.setDate(start.getDate() + 1);
            }
        } else {
            // fallback if dates are somehow missing
            sortedDates = Object.keys(showTimesGrouped).sort();
        }

        // Elements
        const dateContainer = document.getElementById('dateContainer');
        const timeContainer = document.getElementById('timeContainer');
        
        // Initializer
        function init() {
            initSeatGrid();
            renderDates();
            if (sortedDates.length > 0) {
                selectDate(sortedDates[0]);
            }
            updateSummary();
        }

        // Initialize seat interaction
        function initSeatGrid() {
            const rows = document.querySelectorAll('.row-container');
            rows.forEach(row => {
                const rowLabel = row.querySelector('span').innerText.trim();
                let seatIdx = 1;
                const seats = row.querySelectorAll('.w-6.h-6');
                seats.forEach(seat => {
                    // Skip gaps and reserved
                    if (seat.classList.contains('col-span-1')) return;
                    if (!seat.classList.contains('cursor-pointer')) return;

                    const seatId = rowLabel + seatIdx;
                    seat.dataset.id = seatId;
                    
                    // Add click handler
                    seat.addEventListener('click', function() {
                        // Skip if it is officially reserved (locked out)
                        if(this.classList.contains('locked-reserved')) return;
                        
                        if (selectedSeatsMap.has(seatId)) {
                            selectedSeatsMap.delete(seatId);
                            this.classList.remove('bg-primary', 'shadow-sm', 'text-white', 'selected-seat');
                            
                            // Restore base colors depending on row layout
                            if (seatId.startsWith('E')) {
                                this.classList.add('bg-white', 'border-2', 'border-primary', 'hover:bg-primary/10');
                            } else {
                                this.classList.add('bg-surface-container-highest', 'hover:bg-primary/20');
                            }
                        } else {
                            if (selectedSeatsMap.size >= 10) {
                                alert("You can select maximum 10 seats per booking.");
                                return;
                            }
                            selectedSeatsMap.add(seatId);
                            
                            // Strip all base colors and apply vibrant active selection colors
                            this.classList.remove('bg-surface-container-highest', 'bg-white', 'border-2', 'border-primary', 'hover:bg-primary/10', 'hover:bg-primary/20');
                            this.classList.add('bg-primary', 'shadow-sm', 'text-white', 'selected-seat');
                        }
                        updateSummary();
                    });
                    seatIdx++;
                });
            });
        }

        // Render Dates
        function renderDates() {
            if (sortedDates.length === 0) {
                dateContainer.innerHTML = '<span class="text-xs text-on-surface-variant font-bold">No upcoming showtimes available.</span>';
                return;
            }
            
            dateContainer.innerHTML = '';
            sortedDates.forEach(dateStr => {
                const dateObj = new Date(dateStr);
                const day = dateObj.getDate();
                const monthName = dateObj.toLocaleString('en-US', { month: 'short' });
                const dayName = dateObj.toLocaleString('en-US', { weekday: 'short' });

                const dateEl = document.createElement('div');
                // Using dataset for active state logic
                dateEl.dataset.date = dateStr;
                dateEl.className = 'date-btn flex flex-col items-center bg-white border border-outline-variant text-on-surface rounded w-14 py-3 cursor-pointer hover:bg-surface-container-high transition-colors';
                dateEl.innerHTML = `
                    <span class="text-[10px] font-bold uppercase">\${monthName}</span>
                    <span class="text-xl font-black font-epilogue">\${day}</span>
                    <span class="text-[10px] font-bold uppercase">\${dayName}</span>
                `;
                dateEl.onclick = () => selectDate(dateStr);
                dateContainer.appendChild(dateEl);
            });
        }

        function selectDate(dateStr) {
            currentSelectedDate = dateStr;
            currentSelectedTimeObj = null;

            // Update UI Active State
            document.querySelectorAll('.date-btn').forEach(el => {
                if (el.dataset.date === dateStr) {
                    el.className = 'date-btn flex flex-col items-center bg-primary text-white rounded w-14 py-3 cursor-pointer transition-colors';
                } else {
                    el.className = 'date-btn flex flex-col items-center bg-white border border-outline-variant text-on-surface rounded w-14 py-3 cursor-pointer hover:bg-surface-container-high transition-colors';
                }
            });

            renderTimes(dateStr);
            updateSummary();
        }

        function renderTimes(dateStr) {
            timeContainer.innerHTML = '';
            const times = showTimesGrouped[dateStr];
            if (!times || times.length === 0) {
                timeContainer.innerHTML = '<span class="text-[11px] font-bold text-on-surface-variant uppercase bg-surface-container py-1 px-3 rounded shadow-sm border border-outline-variant">No showtimes scheduled for this date.</span>';
                
                // Clear any leftover references
                document.getElementById('selectedHallLabel').innerText = "Select Hall";
                // Lock out the UI grid visually
                document.getElementById('seatContainer').style.opacity = '0.5';
                document.getElementById('seatContainer').style.pointerEvents = 'none';
                return;
            }
            
            // Re-enable grid
            document.getElementById('seatContainer').style.opacity = '1';
            document.getElementById('seatContainer').style.pointerEvents = 'auto';

            // Sort times sequentially
            times.sort((a,b) => a.time.localeCompare(b.time));

            times.forEach((st, idx) => {
                const btn = document.createElement('div');
                btn.className = 'flex flex-col gap-1';
                
                const timeBtn = document.createElement('button');
                timeBtn.type = 'button';
                timeBtn.className = 'time-btn bg-white border border-outline-variant py-2 px-4 rounded text-sm font-bold text-on-surface hover:bg-primary hover:text-white hover:border-primary transition-all';
                timeBtn.innerHTML = st.time;
                
                // Keep reference to object
                timeBtn.onclick = () => selectTime(timeBtn, st);
                
                const hallLabel = document.createElement('span');
                hallLabel.className = 'text-[10px] text-center font-bold text-on-surface-variant';
                hallLabel.innerText = st.hall;

                // Auto-select first time
                if(idx === 0 && !currentSelectedTimeObj) {
                    selectTime(timeBtn, st);
                }

                btn.appendChild(timeBtn);
                btn.appendChild(hallLabel);
                timeContainer.appendChild(btn);
            });
        }

        function selectTime(buttonEl, timeObj) {
            currentSelectedTimeObj = timeObj;
            
            // Update UI
            document.querySelectorAll('.time-btn').forEach(el => {
                el.className = 'time-btn bg-white border border-outline-variant py-2 px-4 rounded text-sm font-bold text-on-surface hover:bg-primary hover:text-white hover:border-primary transition-all';
            });
            buttonEl.className = 'time-btn bg-primary border border-primary py-2 px-4 rounded text-sm font-bold text-white transition-all';

            // Change Theater Title Layout
            document.getElementById('selectedHallLabel').innerText = timeObj.hall;
            
            checkReservations();
            updateSummary();
        }

        // Apply visual lockout for already booked seats based on backend JSON
        function checkReservations() {
            if (!currentSelectedTimeObj) return;

            const finalShowTimeStr = `\${currentSelectedDate} \${currentSelectedTimeObj.time} - \${currentSelectedTimeObj.hall}`;
            const reservedSeatString = bookedSeatsData[finalShowTimeStr];
            
            let reservedSet = new Set();
            if (reservedSeatString) {
                reservedSeatString.split(',').forEach(s => reservedSet.add(s.trim()));
            }

            // Loop through all seats in the grid
            document.querySelectorAll('.w-6.h-6').forEach(seat => {
                if(!seat.dataset.id) return; // skip placeholders

                const sId = seat.dataset.id;
                
                if (reservedSet.has(sId)) {
                    // This seat is officially BOOKED
                    // Forcefully remove cursor hover logic
                    seat.classList.replace('cursor-pointer', 'cursor-not-allowed');
                    seat.classList.replace('bg-surface-container-highest', 'bg-surface-container'); 
                    seat.classList.add('border', 'border-outline-variant', 'locked-reserved');
                    
                    // Clear user's local selection if it hits a conflict switch
                    if(selectedSeatsMap.has(sId)) {
                        selectedSeatsMap.delete(sId);
                    }
                    
                    // Cleanup any red background
                    seat.classList.remove('selected-seat', 'bg-primary');
                    // Remove dynamic styling overrides from default Tailwind base
                    seat.classList.remove('hover:bg-primary/20', 'hover:bg-primary/10', 'border-primary', 'border-2');
                } else if (seat.classList.contains('locked-reserved')) {
                    // This seat was locked for a DIFFERENT showtime, but is FREE for THIS showtime!
                    // Reset its state completely
                    seat.classList.replace('cursor-not-allowed', 'cursor-pointer');
                    seat.classList.replace('bg-surface-container', 'bg-surface-container-highest');
                    seat.classList.remove('border', 'border-outline-variant', 'locked-reserved');
                    
                    if (sId.startsWith('E')) { // Row E uses white special border
                         seat.classList.add('hover:bg-primary/10', 'border-2', 'border-primary', 'bg-white');
                         seat.classList.remove('bg-surface-container-highest');
                    } else {
                         seat.classList.add('hover:bg-primary/20');
                    }
                }
            });
        }

        function updateSummary() {
            const count = selectedSeatsMap.size;
            document.getElementById('seatCountLabel').innerText = count;
            
            const seatIdsArr = Array.from(selectedSeatsMap);
            const seatIdsStr = seatIdsArr.length > 0 ? seatIdsArr.join(', ') : 'None';
            document.getElementById('seatIdsLabel').innerText = seatIdsStr;

            const total = count * standardPrice;
            document.getElementById('totalPriceLabel').innerText = total.toFixed(2);

            const displayShowTime = currentSelectedTimeObj 
                ? `\${currentSelectedDate} \${currentSelectedTimeObj.time}` 
                : 'Pick a time';
            document.getElementById('selectedShowtimeLabel').innerText = displayShowTime;
            
            document.getElementById('summaryHallName').innerText = currentSelectedTimeObj ? currentSelectedTimeObj.hall : "Select Hall";

            // Bind hidden form values
            document.getElementById('numberOfSeatsInput').value = count;
            document.getElementById('selectedSeatIdsInput').value = seatIdsStr;
            
            if(currentSelectedTimeObj) {
                const combinedFinalShowTime = `\${currentSelectedDate} \${currentSelectedTimeObj.time} - \${currentSelectedTimeObj.hall}`;
                document.getElementById('finalShowTimeInput').value = combinedFinalShowTime;
            }

            // Enable/Disable Submit Button
            const submitBtn = document.getElementById('submitBtn');
            if (count > 0 && currentSelectedTimeObj) {
                submitBtn.disabled = false;
                submitBtn.className = "w-full bg-primary py-4 rounded text-white font-black font-epilogue tracking-tight text-lg shadow-lg hover:brightness-90 active:scale-[0.98] transition-all";
            } else {
                submitBtn.disabled = true;
                submitBtn.className = "w-full bg-surface-container-highest border border-outline-variant text-on-surface-variant py-4 rounded font-black font-epilogue tracking-tight text-lg shadow transition-all cursor-not-allowed";
            }
        }

        // Check if there are no dates at all, disable grid
        if (sortedDates.length === 0) {
            document.getElementById('seatContainer').style.opacity = '0.5';
            document.getElementById('seatContainer').style.pointerEvents = 'none';
        }

        // Initialize App
        window.onload = init;
    </script>
</body>
</html>
