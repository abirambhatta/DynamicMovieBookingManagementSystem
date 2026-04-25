<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${movie.title} - Book Tickets | MovieMint</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* ===== Book Ticket Page Styles ===== */
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f5f7fa; color: #1a1a1a; height: 100vh; overflow: hidden; }
        .booking-layout { display: flex; height: 100vh; overflow: hidden; }

        /* LEFT: Seat Selection */
        .seat-section { flex: 1; padding: 28px 48px; overflow-y: auto; background: #fff; }
        .back-link { display: inline-flex; align-items: center; gap: 6px; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.1em; color: #666; text-decoration: none; margin-bottom: 20px; }
        .back-link:hover { color: #dc143c; }
        .seat-header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 36px; }
        .hall-label { display: block; font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.15em; color: #dc143c; margin-bottom: 6px; }
        .movie-h1 { font-size: 2.8rem; font-weight: 900; color: #1a1a1a; line-height: 1; letter-spacing: -0.02em; }
        .legend { display: flex; gap: 16px; flex-wrap: wrap; }
        .legend-item { display: flex; align-items: center; gap: 6px; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.08em; color: #666; }
        .legend-dot { width: 16px; height: 16px; border-radius: 4px; }
        .legend-dot.standard  { background: #e0e0e0; }
        .legend-dot.premium   { background: #c8e6c9; }
        .legend-dot.recliner  { background: #ffe0b2; }
        .legend-dot.vip       { background: #e1bee7; }
        .legend-dot.selected  { background: #dc143c; }
        .legend-dot.reserved  { background: #ff6b6b; border: 2px solid #c92a2a; }

        /* Screen */
        .screen-wrap { width: 100%; margin-bottom: 48px; }
        .cinema-screen { max-width: 600px; margin: 0 auto 8px; height: 56px; background: linear-gradient(to bottom, rgba(220,20,60,0.12), transparent); border-top: 4px solid #dc143c; border-radius: 50% 50% 0 0 / 100% 100% 0 0; }
        .screen-label { text-align: center; font-size: 10px; font-weight: 700; letter-spacing: 0.35em; text-transform: uppercase; color: #999; }

        /* Seat grid */
        .seat-map { perspective: 1000px; padding-bottom: 60px; display: flex; justify-content: center; }
        .seat-rows-container { transform: rotateX(10deg); display: flex; flex-direction: column; gap: 10px; align-items: center; width: 100%; }
        .seat-row { display: flex; align-items: center; gap: 24px; justify-content: center; }
        .row-label { font-size: 10px; font-weight: 800; color: #999; width: 16px; text-align: center; flex-shrink: 0; }
        .seats-in-row { display: flex; gap: 6px; flex-wrap: wrap; justify-content: center; }
        .row-type-separator { height: 14px; }

        /* Seats */
        .seat { width: 28px; height: 28px; border-radius: 4px; cursor: pointer; transition: background 0.15s, transform 0.1s; border: none; display: inline-block; }
        .seat:hover { transform: scale(1.12); }
        .seat.standard  { background: #e0e0e0; }
        .seat.premium   { background: #c8e6c9; }
        .seat.recliner  { background: #ffe0b2; }
        .seat.vip       { background: #e1bee7; }
        .seat.standard:hover  { background: #bdbdbd; }
        .seat.premium:hover   { background: #a5d6a7; }
        .seat.recliner:hover  { background: #ffcc80; }
        .seat.vip:hover       { background: #ce93d8; }
        .seat.selected { background: #dc143c !important; }
        .seat.reserved { background: #ff6b6b !important; border: 2px solid #c92a2a; cursor: not-allowed; }
        .seat.reserved:hover { transform: none; }

        /* RIGHT: Booking Panel */
        .booking-panel { width: 400px; background: #f9fbfd; border-left: 1px solid #e8edf2; display: flex; flex-direction: column; z-index: 10; }
        .panel-body { flex: 1; overflow-y: auto; padding: 28px 28px 0; display: flex; flex-direction: column; gap: 24px; }
        .panel-label { font-size: 10px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.15em; color: #5c3f3f; margin-bottom: 12px; display: block; }

        /* Date & Time */
        .date-row { display: flex; flex-wrap: wrap; gap: 10px; }
        .date-btn { display: flex; flex-direction: column; align-items: center; padding: 10px 14px; background: #fff; border: 1px solid #e0e0e0; border-radius: 8px; cursor: pointer; width: 60px; transition: all 0.15s; user-select: none; }
        .date-btn:hover { border-color: #dc143c; }
        .date-btn.active { background: #dc143c; border-color: #dc143c; color: #fff; }
        .date-btn .d-month { font-size: 10px; font-weight: 800; text-transform: uppercase; user-select: none; }
        .date-btn .d-day   { font-size: 20px; font-weight: 900; line-height: 1.1; user-select: none; }
        .date-btn .d-name  { font-size: 10px; font-weight: 700; text-transform: uppercase; user-select: none; }
        .time-row { display: flex; flex-wrap: wrap; gap: 8px; }
        .time-btn { padding: 8px 16px; background: #fff; border: 1px solid #e0e0e0; border-radius: 6px; font-size: 13px; font-weight: 700; cursor: pointer; transition: all 0.15s; user-select: none; }
        .time-btn:hover, .time-btn.active { background: #dc143c; color: #fff; border-color: #dc143c; }
        .time-btn.expired { background: #fee2e2; color: #dc2626; border-color: #fecaca; cursor: not-allowed; opacity: 0.7; user-select: none; }

        /* Summary */
        .summary-card { background: #fff; border: 1px solid #e8edf2; border-radius: 10px; padding: 18px; }
        .summary-card h3 { font-size: 10px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.15em; color: #5c3f3f; margin-bottom: 14px; }
        .movie-thumb-row { display: flex; align-items: center; gap: 12px; margin-bottom: 14px; }
        .movie-thumb { width: 52px; height: 68px; border-radius: 6px; overflow: hidden; border: 1px solid #e8edf2; flex-shrink: 0; }
        .movie-thumb img { width: 100%; height: 100%; object-fit: cover; }
        .movie-meta p { font-size: 13px; font-weight: 700; color: #1a1a1a; }
        .movie-meta span { font-size: 11px; color: #666; }
        .summary-hall { font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.08em; color: #dc143c; }
        .summary-divider { border: none; border-top: 1px solid #f0f0f0; margin: 10px 0; }
        .summary-row { display: flex; justify-content: space-between; font-size: 13px; margin-bottom: 8px; }
        .summary-row .lbl { color: #666; }
        .summary-row .val { font-weight: 700; color: #1a1a1a; word-break: break-all; text-align: right; max-width: 55%; }
        .summary-row .val.highlight { color: #dc143c; }
        .booking-error { background: #fde8e8; color: #c0392b; padding: 10px 14px; border-radius: 6px; font-size: 13px; font-weight: 700; }
        
        /* Remove text cursor from non-input elements */
        .back-link, .hall-label, .movie-h1, .legend, .legend-item, .screen-label, .row-label, .panel-label, .summary-card h3, .movie-meta, .summary-hall, .summary-row, .total-label, .total-amount { user-select: none; cursor: default; }

        /* Footer */
        .panel-footer { padding: 20px 28px; background: #fff; border-top: 1px solid #e8edf2; }
        .total-row { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 16px; }
        .total-label { font-size: 10px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.12em; color: #5c3f3f; }
        .total-amount { font-size: 2rem; font-weight: 900; color: #dc143c; }
        .btn-book { width: 100%; padding: 14px; background: #e0e0e0; color: #999; border: none; border-radius: 8px; font-size: 1rem; font-weight: 900; text-transform: uppercase; letter-spacing: 0.08em; cursor: not-allowed; transition: all 0.2s; }
        .btn-book.ready { background: #dc143c; color: #fff; cursor: pointer; }
        .btn-book.ready:hover { background: #b71c1c; }
        .no-showtimes-msg { font-size: 11px; font-weight: 700; color: #666; background: #f5f5f5; border: 1px solid #e0e0e0; padding: 6px 12px; border-radius: 6px; }
    </style>
</head>
<body>
    <c:if test="${empty user}"><c:redirect url="login"/></c:if>

    <div class="booking-layout">

        <%-- ===== LEFT: SEAT MAP ===== --%>
        <section class="seat-section">
            <a href="javascript:history.back()" class="back-link" onclick="if(document.referrer === '') { window.location.href='${pageContext.request.contextPath}/userHome'; return false; }">&larr; Back</a>
            <div class="seat-header">
                <div>
                    <span class="hall-label" id="selectedHallLabel">Select a showtime</span>
                    <h1 class="movie-h1">${movie.title}</h1>
                </div>
                <div class="legend">
                    <div class="legend-item"><span class="legend-dot standard"></span> Standard</div>
                    <div class="legend-item"><span class="legend-dot premium"></span> Premium</div>
                    <div class="legend-item"><span class="legend-dot recliner"></span> Recliner</div>
                    <div class="legend-item"><span class="legend-dot vip"></span> VIP</div>
                    <div class="legend-item"><span class="legend-dot selected"></span> Selected</div>
                    <div class="legend-item"><span class="legend-dot reserved"></span> Reserved</div>
                </div>
            </div>
            <div class="screen-wrap">
                <div class="cinema-screen"></div>
                <p class="screen-label">Cinema Screen</p>
            </div>
            <%-- Seat grid rendered dynamically by JS --%>
            <div class="seat-map">
                <div class="seat-rows-container" id="seatContainer">
                    <p style="color:#999; text-align:center; padding:40px;">Select a showtime to view the seat layout.</p>
                </div>
            </div>
        </section>

        <%-- ===== RIGHT: BOOKING PANEL ===== --%>
        <form id="bookingForm" action="${pageContext.request.contextPath}/bookTicket" method="post" class="booking-panel" onsubmit="return validateBookingBeforeSubmit(event);">
            <input type="hidden" name="movieId" value="${movie.movieId}">
            <input type="hidden" name="finalShowTime" id="finalShowTimeInput" value="">
            <input type="hidden" name="numberOfSeats" id="numberOfSeatsInput" value="0">
            <input type="hidden" name="selectedSeatIds" id="selectedSeatIdsInput" value="">
            <input type="hidden" name="totalPrice" id="totalPriceInput" value="0">
            <div class="panel-body">
                <c:if test="${not empty error}"><div class="booking-error">${error}</div></c:if>

                <div><span class="panel-label">Select Date</span>
                    <div class="date-row" id="dateContainer"><span class="no-showtimes-msg">Loading...</span></div>
                </div>
                <div><span class="panel-label">Select Showtime</span>
                    <div class="time-row" id="timeContainer"><span class="no-showtimes-msg">Pick a date first</span></div>
                </div>

                <div class="summary-card">
                    <h3>Order Summary</h3>
                    <div class="movie-thumb-row">
                        <div class="movie-thumb"><img src="${pageContext.request.contextPath}/images/${movie.posterImage}" alt="${movie.title}"></div>
                        <div class="movie-meta">
                            <p>${movie.title}</p>
                            <span>${movie.language} - ${movie.duration} min</span><br>
                            <span class="summary-hall" id="summaryHallName">Select Hall</span>
                        </div>
                    </div>
                    <hr class="summary-divider">
                    <div class="summary-row"><span class="lbl">Seats (<span id="seatCountLabel">0</span>)</span><span class="val" id="seatIdsLabel">None</span></div>
                    <div class="summary-row"><span class="lbl">Standard Price</span><span class="val">Rs. ${standardPrice}</span></div>
                    <div class="summary-row"><span class="lbl highlight" style="color:#dc143c;font-weight:700;">Showtime</span><span class="val highlight" id="selectedShowtimeLabel">Pick a time</span></div>
                </div>
            </div>
            <div class="panel-footer">
                <div class="total-row">
                    <div><div class="total-label">Total Payable</div><div class="total-amount">Rs. <span id="totalPriceLabel">0.00</span></div></div>
                    <small style="color:#999;font-size:10px;">Includes Tax</small>
                </div>
                <button type="submit" id="submitBtn" class="btn-book" disabled>Book Tickets</button>
            </div>
        </form>
    </div>

    <script>
        // ===========================
        // SERVER DATA
        // ===========================
        const prices = {
            standard: ${standardPrice},
            premium:  ${premiumPrice},
            recliner: ${reclinerPrice},
            vip:      ${vipPrice}
        };
        const rawShowTimes    = ${showTimesJson != null ? showTimesJson : '[]'};
        const bookedSeatsData = ${bookedSeatsJson != null ? bookedSeatsJson : '{}'};
        const hallConfigs     = ${hallConfigsJson != null ? hallConfigsJson : '{}'};

        const movieStartDateStr = "${movie.startDate}";
        const movieEndDateStr   = "${movie.endDate}";

        let selectedSeats = new Map(); // seatId -> seatType (standard/premium/recliner/vip)
        let currentDate = null;
        let currentTime = null;

        // Group showtimes by date
        const stGrouped = {};
        rawShowTimes.forEach(st => { if (!stGrouped[st.date]) stGrouped[st.date] = []; stGrouped[st.date].push(st); });

        // Date range — only show today and future dates
        const sortedDates = [];
        if (movieStartDateStr && movieEndDateStr) {
            // Use local date string (YYYY-MM-DD) to avoid UTC timezone shift issues
            const now = new Date();
            const todayStr = now.getFullYear() + '-'
                + String(now.getMonth()+1).padStart(2,'0') + '-'
                + String(now.getDate()).padStart(2,'0');

            let s = new Date(movieStartDateStr), e = new Date(movieEndDateStr);
            while (s <= e) {
                const ds = s.toISOString().split('T')[0];
                if (ds >= todayStr) sortedDates.push(ds); // skip past dates
                s.setDate(s.getDate() + 1);
            }
        }

        // ===========================
        // DYNAMIC SEAT GRID
        // ===========================
        function buildSeatGrid(hallName) {
            const container = document.getElementById('seatContainer');

            // Fuzzy lookup: normalize both the requested hall name and config keys
            // so "audi01", "Audi 01", "audi 01" etc. all match
            function normalize(s) { return s.toLowerCase().replace(/\s+/g, ''); }
            let config = hallConfigs[hallName]; // try exact match first
            if (!config) {
                // try normalized match
                const normalizedName = normalize(hallName);
                for (const key in hallConfigs) {
                    if (normalize(key) === normalizedName) { config = hallConfigs[key]; break; }
                }
            }
            if (!config) {
                // Still not found - use a sensible default layout so booking still works
                config = { seatsPerRow: 12, standardRows: 'A,B,C,D', premiumRows: 'E', reclinerRows: '', vipRows: 'F' };
            }

            container.innerHTML = '';
            
            // USE LAYOUT MAP IF PRESENT
            if (config.layoutMap && config.layoutMap.trim() !== '') {
                const rows = config.layoutMap.split('|');
                rows.forEach((row, rIdx) => {
                    const cells = row.split(' ');
                    const rowDiv = document.createElement('div');
                    rowDiv.className = 'seat-row row-container';
                    const letter = String.fromCharCode(65 + rIdx);
                    
                    const label = document.createElement('span');
                    label.className = 'row-label';
                    label.textContent = letter;
                    rowDiv.appendChild(label);
                    
                    const seatsDiv = document.createElement('div');
                    seatsDiv.className = 'seats-in-row';
                    
                    let seatCounter = 1;
                    cells.forEach((cellType, cIdx) => {
                        if (cellType === '_') {
                            const space = document.createElement('div');
                            space.style.width = '28px';
                            space.style.height = '28px';
                            seatsDiv.appendChild(space);
                        } else {
                            let cls = 'standard';
                            if (cellType === 'P') cls = 'premium';
                            else if (cellType === 'R') cls = 'recliner';
                            else if (cellType === 'V') cls = 'vip';
                            
                            const seat = document.createElement('div');
                            seat.className = 'seat ' + cls;
                            const seatId = letter + seatCounter;
                            seatCounter++;
                            
                            seat.dataset.id = seatId;
                            seat.dataset.type = cls;
                            seat.title = seatId + ' (' + cls + ')';
                            seat.addEventListener('click', function() {
                                if (this.classList.contains('reserved')) return;
                                if (selectedSeats.has(seatId)) {
                                    selectedSeats.delete(seatId);
                                    this.classList.remove('selected');
                                } else {
                                    if (selectedSeats.size >= 10) { alert('Maximum 10 seats per booking.'); return; }
                                    selectedSeats.set(seatId, cls);
                                    this.classList.add('selected');
                                }
                                updateSummary();
                            });
                            seatsDiv.appendChild(seat);
                        }
                    });
                    rowDiv.appendChild(seatsDiv);
                    container.appendChild(rowDiv);
                });
                return;
            }

            // FALLBACK TO LEGACY SYSTEM
            const spr = config.seatsPerRow;
            const types = [
                { rows: config.standardRows, cls: 'standard' },
                { rows: config.premiumRows,  cls: 'premium' },
                { rows: config.reclinerRows, cls: 'recliner' },
                { rows: config.vipRows,      cls: 'vip' }
            ];

            let isFirst = true;
            types.forEach(type => {
                if (!type.rows || type.rows.trim() === '') return;
                const rowLetters = type.rows.split(',').map(r => r.trim()).filter(r => r);
                if (rowLetters.length === 0) return;

                // Add gap between seat type sections
                if (!isFirst) {
                    const gap = document.createElement('div');
                    gap.className = 'row-type-separator';
                    container.appendChild(gap);
                }
                isFirst = false;

                rowLetters.forEach(letter => {
                    const rowDiv = document.createElement('div');
                    rowDiv.className = 'seat-row row-container';
                    rowDiv.dataset.type = type.cls;

                    const label = document.createElement('span');
                    label.className = 'row-label';
                    label.textContent = letter;
                    rowDiv.appendChild(label);

                    const seatsDiv = document.createElement('div');
                    seatsDiv.className = 'seats-in-row';

                    for (let i = 1; i <= spr; i++) {
                        const seat = document.createElement('div');
                        seat.className = 'seat ' + type.cls;
                        const seatId = letter + i;
                        seat.dataset.id = seatId;
                        seat.dataset.type = type.cls;
                        seat.title = seatId + ' (' + type.cls + ')';
                        seat.addEventListener('click', function() {
                            if (this.classList.contains('reserved')) return;
                            if (selectedSeats.has(seatId)) {
                                selectedSeats.delete(seatId);
                                this.classList.remove('selected');
                            } else {
                                if (selectedSeats.size >= 10) { alert('Maximum 10 seats per booking.'); return; }
                                selectedSeats.set(seatId, type.cls);
                                this.classList.add('selected');
                            }
                            updateSummary();
                        });
                        seatsDiv.appendChild(seat);
                    }
                    rowDiv.appendChild(seatsDiv);
                    container.appendChild(rowDiv);
                });
            });
        }

        // ===========================
        // DATES
        // ===========================
        function renderDates() {
            const c = document.getElementById('dateContainer');
            if (!sortedDates.length) { c.innerHTML = '<span class="no-showtimes-msg">No upcoming dates.</span>'; return; }
            c.innerHTML = '';
            sortedDates.forEach(ds => {
                const d = new Date(ds), el = document.createElement('div');
                el.className = 'date-btn'; el.dataset.date = ds;
                el.innerHTML = '<span class="d-month">'+d.toLocaleString('en-US',{month:'short'})+'</span>'
                    +'<span class="d-day">'+d.getDate()+'</span>'
                    +'<span class="d-name">'+d.toLocaleString('en-US',{weekday:'short'})+'</span>';
                el.onclick = () => selectDate(ds);
                c.appendChild(el);
            });
        }

        function selectDate(ds) {
            currentDate = ds; currentTime = null;
            selectedSeats.clear();
            document.querySelectorAll('.date-btn').forEach(el => el.classList.toggle('active', el.dataset.date===ds));
            renderTimes(ds); updateSummary();
        }

        // ===========================
        // TIMES
        // ===========================
        function renderTimes(ds) {
            const c = document.getElementById('timeContainer');
            const times = stGrouped[ds];
            if (!times || !times.length) {
                c.innerHTML = '<span class="no-showtimes-msg">No showtimes for this date.</span>';
                document.getElementById('seatContainer').innerHTML = '<p style="color:#999;text-align:center;padding:40px;">No showtimes available.</p>';
                return;
            }
            c.innerHTML = '';
            times.sort((a,b) => a.time.localeCompare(b.time));

            // Check if this date is today — if so, apply 15-min cutoff
            const now = new Date();
            const todayStr = now.getFullYear() + '-'
                + String(now.getMonth()+1).padStart(2,'0') + '-'
                + String(now.getDate()).padStart(2,'0');
            const isToday = (ds === todayStr);

            let firstAvailable = null;
            times.forEach((st, i) => {
                // For today's date, check if showtime has passed (including 15-min buffer)
                let expired = false;
                if (isToday) {
                    const [h, m] = st.time.split(':').map(Number);
                    const showMs = new Date(now.getFullYear(), now.getMonth(), now.getDate(), h, m).getTime();
                    const cutoffMs = showMs - 15 * 60 * 1000; // 15 min before
                    if (now.getTime() >= cutoffMs) expired = true;
                }

                const btn = document.createElement('button');
                btn.type = 'button';
                btn.innerText = st.time + ' (' + st.hall + ')';
                if (expired) {
                    btn.className = 'time-btn expired';
                    btn.disabled = true;
                    btn.title = 'Booking closed for this showtime';
                } else {
                    btn.className = 'time-btn';
                    btn.onclick = () => selectTime(btn, st);
                    if (!firstAvailable) firstAvailable = { btn, st };
                }
                c.appendChild(btn);
            });

            if (firstAvailable) {
                selectTime(firstAvailable.btn, firstAvailable.st);
            } else {
                c.innerHTML += '<span class="no-showtimes-msg" style="margin-top:8px;display:block;">All showtimes for today have passed.</span>';
                document.getElementById('seatContainer').innerHTML = '<p style="color:#999;text-align:center;padding:40px;">No bookable showtimes available for this date.</p>';
            }
        }

        function selectTime(btn, st) {
            currentTime = st;
            selectedSeats.clear();
            document.querySelectorAll('.time-btn').forEach(el => el.classList.remove('active'));
            btn.classList.add('active');
            document.getElementById('selectedHallLabel').innerText = st.hall;
            buildSeatGrid(st.hall);
            checkReservations();
            updateSummary();
        }

        // ===========================
        // RESERVATIONS
        // ===========================
        function checkReservations() {
            if (!currentTime) return;
            const key = currentDate + ' ' + currentTime.time + ' - ' + currentTime.hall;
            const reserved = bookedSeatsData[key];
            const rSet = new Set();
            if (reserved) reserved.split(',').forEach(s => rSet.add(s.trim()));
            document.querySelectorAll('.seat[data-id]').forEach(seat => {
                if (rSet.has(seat.dataset.id)) { seat.classList.add('reserved'); seat.classList.remove('selected'); selectedSeats.delete(seat.dataset.id); }
            });
        }

        // ===========================
        // SUMMARY
        // ===========================
        function updateSummary() {
            const count = selectedSeats.size;
            const seatArr = Array.from(selectedSeats.keys());

            document.getElementById('seatCountLabel').innerText = count;
            document.getElementById('seatIdsLabel').innerText = seatArr.length ? seatArr.join(', ') : 'None';

            // Calculate total with per-type pricing
            let total = 0;
            selectedSeats.forEach((type, id) => { total += (prices[type] || prices.standard); });
            document.getElementById('totalPriceLabel').innerText = total.toFixed(2);

            document.getElementById('selectedShowtimeLabel').innerText = currentTime ? currentDate + ' ' + currentTime.time : 'Pick a time';
            document.getElementById('summaryHallName').innerText = currentTime ? currentTime.hall : 'Select Hall';

            document.getElementById('numberOfSeatsInput').value = count;
            document.getElementById('selectedSeatIdsInput').value = seatArr.join(', ');
            document.getElementById('totalPriceInput').value = total.toFixed(2);
            if (currentTime) document.getElementById('finalShowTimeInput').value = currentDate + ' ' + currentTime.time + ' - ' + currentTime.hall;

            const btn = document.getElementById('submitBtn');
            if (count > 0 && currentTime) { btn.disabled = false; btn.classList.add('ready'); }
            else { btn.disabled = true; btn.classList.remove('ready'); }
        }

        // ===========================
        // BOOKING VALIDATION (REST API)
        // ===========================
        function validateBookingBeforeSubmit(event) {
            event.preventDefault();
            
            const movieId = document.querySelector('input[name="movieId"]').value;
            const showTime = document.getElementById('finalShowTimeInput').value;
            const seatIds = document.getElementById('selectedSeatIdsInput').value;
            
            if (!showTime || !seatIds || selectedSeats.size === 0) {
                alert('Please select seats and showtime before booking.');
                return false;
            }
            
            const btn = document.getElementById('submitBtn');
            btn.disabled = true;
            btn.innerText = 'VALIDATING...';
            
            // Call REST API to validate booking
            fetch('${pageContext.request.contextPath}/api/bookings/validate', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'movieId=' + movieId + '&showTime=' + encodeURIComponent(showTime) + '&seatIds=' + encodeURIComponent(seatIds)
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    // Validation passed - submit the form
                    btn.innerText = 'BOOKING...';
                    document.getElementById('bookingForm').submit();
                } else {
                    // Validation failed - show error
                    alert('Booking validation failed: ' + data.error);
                    btn.disabled = false;
                    btn.innerText = 'BOOK TICKETS';
                    btn.classList.add('ready');
                    // Refresh seat availability
                    if (currentTime) checkReservations();
                }
            })
            .catch(err => {
                console.error('Validation error:', err);
                alert('Could not validate booking. Please try again.');
                btn.disabled = false;
                btn.innerText = 'BOOK TICKETS';
                btn.classList.add('ready');
            });
            
            return false;
        }

        // ===========================
        // BOOT
        // ===========================
        window.onload = function() {
            renderDates();
            
            // Check if there's a pre-selected showtime from URL parameter
            const preSelectedDate = "${preSelectedDate}";
            const preSelectedTime = "${preSelectedTime}";
            const preSelectedHall = "${preSelectedHall}";
            
            if (preSelectedDate && preSelectedDate !== "" && sortedDates.includes(preSelectedDate)) {
                // Auto-select the pre-selected date and time
                selectDate(preSelectedDate);
                
                // Wait for times to render, then select the matching time
                setTimeout(() => {
                    const timeButtons = document.querySelectorAll('.time-btn:not(.expired)');
                    timeButtons.forEach(btn => {
                        const btnText = btn.innerText;
                        if (btnText.includes(preSelectedTime) && btnText.includes(preSelectedHall)) {
                            btn.click();
                        }
                    });
                }, 100);
            } else if (sortedDates.length > 0) {
                selectDate(sortedDates[0]);
            }
            
            updateSummary();
        };
    </script>
</body>
</html>
