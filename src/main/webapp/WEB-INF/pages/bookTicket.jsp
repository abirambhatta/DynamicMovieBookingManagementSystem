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
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f4f4f5;
            height: 100vh;
            overflow: hidden;
        }

        .booking-layout {
            display: flex;
            height: 100vh;
        }

        /* ── LEFT: Seat map ── */
        .seat-section {
            flex: 1;
            padding: 20px 32px;
            overflow-y: auto;
            background: #fff;
            border-right: 1px solid #e0e0e0;
        }

        .back-link {
            display: inline-block;
            font-size: 13px;
            color: #666;
            text-decoration: none;
            margin-bottom: 14px;
        }

        .back-link:hover { color: #c9152f; }

        .seat-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 24px;
        }

        .movie-h1 {
            font-size: 22px;
            font-weight: 700;
            color: #1a1a1a;
            line-height: 1.2;
        }

        .hall-label {
            display: block;
            font-size: 11px;
            font-weight: 600;
            color: #c9152f;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            margin-bottom: 4px;
        }

        .legend {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .legend-item {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 11px;
            color: #777;
        }

        .legend-dot {
            width: 14px;
            height: 14px;
            border-radius: 3px;
        }

        .legend-dot.standard  { background: #d4d4d4; }
        .legend-dot.premium   { background: #b9d9b9; }
        .legend-dot.recliner  { background: #f0d9b5; }
        .legend-dot.vip       { background: #d4c0e0; }
        .legend-dot.selected  { background: #c9152f; }
        .legend-dot.reserved  { background: #e9a0a8; border: 1px solid #c05060; }

        /* Screen */
        .screen-wrap {
            margin-bottom: 28px;
            text-align: center;
        }

        .cinema-screen {
            max-width: 520px;
            margin: 0 auto 4px;
            height: 40px;
            background: linear-gradient(to bottom, rgba(201,21,47,0.07), transparent);
            border-top: 3px solid #c9152f;
            border-radius: 50% 50% 0 0 / 100% 100% 0 0;
        }

        .screen-label {
            font-size: 10px;
            color: #bbb;
            text-transform: uppercase;
            letter-spacing: 0.4em;
        }

        /* Seats */
        .seat-map {
            display: flex;
            justify-content: center;
            padding-bottom: 40px;
        }

        .seat-rows-container {
            display: flex;
            flex-direction: column;
            gap: 7px;
        }

        .seat-row {
            display: flex;
            align-items: center;
            gap: 18px;
        }

        .row-label {
            font-size: 10px;
            color: #bbb;
            width: 14px;
            text-align: center;
            flex-shrink: 0;
        }

        .seats-in-row {
            display: flex;
            gap: 5px;
        }

        .seat {
            width: 26px;
            height: 26px;
            border-radius: 3px;
            cursor: pointer;
            border: none;
            display: inline-block;
            transition: opacity 0.1s;
        }

        .seat:hover { opacity: 0.75; }
        .seat.standard  { background: #d4d4d4; }
        .seat.premium   { background: #b9d9b9; }
        .seat.recliner  { background: #f0d9b5; }
        .seat.vip       { background: #d4c0e0; }
        .seat.selected  { background: #c9152f !important; }
        .seat.reserved  { background: #e9a0a8 !important; border: 1px solid #c05060; cursor: not-allowed; }
        .seat.reserved:hover { opacity: 1; }

        .row-type-separator { height: 10px; }

        /* ── RIGHT: Booking panel ── */
        .booking-panel {
            width: 340px;
            background: #fafafa;
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
        }

        .panel-body {
            flex: 1;
            overflow-y: auto;
            padding: 20px;
            display: flex;
            flex-direction: column;
            gap: 18px;
        }

        .panel-section-label {
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            color: #888;
            margin-bottom: 8px;
        }

        /* Date buttons */
        .date-row {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
        }

        .date-btn {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 7px 10px;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 4px;
            cursor: pointer;
            width: 52px;
            transition: border-color 0.15s;
        }

        .date-btn:hover { border-color: #c9152f; }

        .date-btn.active {
            background: #c9152f;
            border-color: #c9152f;
            color: #ffffff;
        }

        .d-month { font-size: 10px; font-weight: 600; text-transform: uppercase; color: inherit; opacity: 0.8; }
        .d-day   { font-size: 18px; font-weight: 700; line-height: 1.2; color: inherit; }
        .d-name  { font-size: 10px; font-weight: 500; text-transform: uppercase; color: inherit; opacity: 0.8; }

        /* Time buttons */
        .time-row { display: flex; flex-wrap: wrap; gap: 6px; }

        .time-btn {
            padding: 6px 12px;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
            cursor: pointer;
            transition: border-color 0.15s;
        }

        .time-btn:hover, .time-btn.active {
            border-color: #c9152f;
            color: #c9152f;
        }

        .time-btn.active {
            background: #c9152f;
            color: #fff;
        }

        .time-btn.expired {
            background: #f9f0f1;
            color: #cda0a5;
            border-color: #f0d0d3;
            cursor: not-allowed;
        }

        /* Summary */
        .summary-card {
            background: #fff;
            border: 1px solid #e4e4e4;
            border-radius: 4px;
            padding: 14px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            font-size: 13px;
            margin-bottom: 6px;
        }

        .summary-row .lbl { color: #888; }
        .summary-row .val { font-weight: 600; color: #1a1a1a; text-align: right; max-width: 55%; word-break: break-all; }
        .summary-row .val.hl { color: #c9152f; }

        .no-showtimes-msg {
            font-size: 12px;
            color: #aaa;
            font-style: italic;
        }

        .booking-error-msg {
            background: #fde8ec;
            color: #8b1a25;
            border: 1px solid #f5c6cb;
            border-radius: 4px;
            padding: 9px 12px;
            font-size: 13px;
        }

        /* Footer */
        .panel-footer {
            padding: 16px 20px;
            background: #fff;
            border-top: 1px solid #e4e4e4;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            align-items: baseline;
            margin-bottom: 12px;
        }

        .total-label { font-size: 12px; color: #888; }
        .total-amount { font-size: 22px; font-weight: 700; color: #c9152f; }

        .btn-book {
            width: 100%;
            padding: 11px;
            background: #ccc;
            color: #888;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 600;
            cursor: not-allowed;
            transition: background 0.15s;
        }

        .btn-book.ready {
            background: #c9152f;
            color: #fff;
            cursor: pointer;
        }

        .btn-book.ready:hover { background: #a01026; }

        /* ── NO SHOWTIMES STATE ── */
        .no-showtimes-panel {
            display: none;
            height: 100vh;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            text-align: center;
            padding: 40px 24px;
            background: #f4f4f5;
        }

        .no-showtimes-panel.visible { display: flex; }

        .no-showtimes-panel .ns-icon {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.3;
        }

        .no-showtimes-panel h2 {
            font-size: 22px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 8px;
        }

        .no-showtimes-panel p {
            font-size: 14px;
            color: #888;
            max-width: 380px;
            line-height: 1.6;
            margin-bottom: 28px;
        }

        .ns-back-btn {
            display: inline-block;
            padding: 11px 28px;
            background: var(--red);
            color: #fff;
            font-size: 14px;
            font-weight: 600;
            border-radius: 5px;
            text-decoration: none;
            transition: background 0.15s;
        }
        .ns-back-btn:hover { background: var(--red-dark); color: #fff; text-decoration: none; }
    </style>
</head>
<body>
    <c:if test="${empty user}"><c:redirect url="login"/></c:if>

    <%-- No Showtimes Fallback Panel --%>
    <div class="no-showtimes-panel" id="noShowtimesPanel">
        <div class="ns-icon">🎬</div>
        <h2>No Upcoming Showtimes</h2>
        <p>There are no available showtimes scheduled for <strong>${movie.title}</strong> right now. Check back later or browse other movies.</p>
        <a href="${pageContext.request.contextPath}/browseMovies" class="ns-back-btn">Browse Other Movies</a>
    </div>

    <div class="booking-layout" id="bookingLayout">

        <%-- LEFT: Seat Map --%>
        <section class="seat-section">
            <a href="javascript:history.back()" class="back-link">← Back</a>
            <div class="seat-header">
                <div>
                    <span class="hall-label" id="selectedHallLabel">Select a showtime</span>
                    <h1 class="movie-h1">${movie.title}</h1>
                </div>
                <div class="legend">
                    <div class="legend-item"><span class="legend-dot standard"></span> Standard (Rs. ${standardPrice})</div>
                    <div class="legend-item"><span class="legend-dot premium"></span> Premium (Rs. ${premiumPrice})</div>
                    <div class="legend-item"><span class="legend-dot recliner"></span> Recliner (Rs. ${reclinerPrice})</div>
                    <div class="legend-item"><span class="legend-dot vip"></span> VIP (Rs. ${vipPrice})</div>
                    <div class="legend-item"><span class="legend-dot selected"></span> Selected</div>
                    <div class="legend-item"><span class="legend-dot reserved"></span> Taken</div>
                </div>
            </div>
            <div class="screen-wrap">
                <div class="cinema-screen"></div>
                <p class="screen-label">Screen</p>
            </div>
            <div class="seat-map">
                <div class="seat-rows-container" id="seatContainer">
                    <p style="color:#bbb; font-size:14px; padding:32px;">Select a showtime to load seats.</p>
                </div>
            </div>
        </section>

        <%-- RIGHT: Booking Panel --%>
        <form id="bookingForm" action="${pageContext.request.contextPath}/bookTicket" method="post"
              class="booking-panel" onsubmit="return validateAndSubmit(event);">
            <input type="hidden" name="movieId" value="${movie.movieId}">
            <input type="hidden" name="finalShowTime" id="finalShowTimeInput" value="">
            <input type="hidden" name="numberOfSeats" id="numberOfSeatsInput" value="0">
            <input type="hidden" name="selectedSeatIds" id="selectedSeatIdsInput" value="">
            <input type="hidden" name="totalPrice" id="totalPriceInput" value="0">

            <div class="panel-body">
                <c:if test="${not empty error}">
                    <div class="booking-error-msg">${error}</div>
                </c:if>

                <div>
                    <div class="panel-section-label">Select date</div>
                    <div class="date-row" id="dateContainer"><span class="no-showtimes-msg">Loading...</span></div>
                </div>

                <div>
                    <div class="panel-section-label">Select showtime</div>
                    <div class="time-row" id="timeContainer"><span class="no-showtimes-msg">Pick a date first</span></div>
                </div>

                <div class="summary-card">
                    <div class="panel-section-label" style="margin-bottom:10px;">Summary</div>
                    <div class="summary-row">
                        <span class="lbl">${movie.title}</span>
                        <span class="val" id="summaryHallName" style="color:#888;">—</span>
                    </div>
                    <div class="summary-row">
                        <span class="lbl">Showtime</span>
                        <span class="val hl" id="selectedShowtimeLabel">—</span>
                    </div>
                    <div class="summary-row">
                        <span class="lbl">Seats (<span id="seatCountLabel">0</span>)</span>
                        <span class="val" id="seatIdsLabel">None</span>
                    </div>
                    <!-- Seat type breakdown -->
                    <div id="seatBreakdown" style="display:none; margin-top:10px; border-top:1px solid #ebebeb; padding-top:10px;">
                        <div class="panel-section-label" style="margin-bottom:6px;">Seat breakdown</div>
                        <div id="breakdownRows"></div>
                    </div>
                </div>
            </div>

            <div class="panel-footer">
                <div class="total-row">
                    <span class="total-label">Total</span>
                    <span class="total-amount">Rs. <span id="totalPriceLabel">0.00</span></span>
                </div>
                <button type="submit" id="submitBtn" class="btn-book" disabled>Book Tickets</button>
            </div>
        </form>
    </div>

    <script>
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

        let selectedSeats = new Map();
        let currentDate = null;
        let currentTime = null;

        const stGrouped = {};
        rawShowTimes.forEach(st => {
            if (!stGrouped[st.date]) stGrouped[st.date] = [];
            stGrouped[st.date].push(st);
        });

        // Only dates that have showtimes
        const sortedDates = [];
        if (movieStartDateStr && movieEndDateStr) {
            const now = new Date();
            const todayStr = now.getFullYear() + '-'
                + String(now.getMonth()+1).padStart(2,'0') + '-'
                + String(now.getDate()).padStart(2,'0');

            let s = new Date(movieStartDateStr), e = new Date(movieEndDateStr);
            while (s <= e) {
                const ds = s.toISOString().split('T')[0];
                if (ds >= todayStr && stGrouped[ds] && stGrouped[ds].length > 0) sortedDates.push(ds);
                s.setDate(s.getDate() + 1);
            }
        }

        function buildSeatGrid(hallName) {
            const container = document.getElementById('seatContainer');
            function norm(s) { return s.toLowerCase().replace(/\s+/g, ''); }
            let config = hallConfigs[hallName];
            if (!config) {
                for (const k in hallConfigs) {
                    if (norm(k) === norm(hallName)) { config = hallConfigs[k]; break; }
                }
            }
            if (!config) config = { seatsPerRow: 12, standardRows: 'A,B,C,D', premiumRows: 'E', reclinerRows: '', vipRows: 'F' };

            container.innerHTML = '';

            if (config.layoutMap && config.layoutMap.trim()) {
                config.layoutMap.split('|').forEach((row, rIdx) => {
                    const rowDiv = document.createElement('div');
                    rowDiv.className = 'seat-row';
                    const letter = String.fromCharCode(65 + rIdx);

                    const lbl = document.createElement('span');
                    lbl.className = 'row-label';
                    lbl.textContent = letter;
                    rowDiv.appendChild(lbl);

                    const seatsDiv = document.createElement('div');
                    seatsDiv.className = 'seats-in-row';

                    let n = 1;
                    row.split(' ').forEach(cell => {
                        if (cell === '_') {
                            const sp = document.createElement('div');
                            sp.style.cssText = 'width:26px;height:26px;';
                            seatsDiv.appendChild(sp);
                        } else {
                            const cls = cell === 'P' ? 'premium' : cell === 'R' ? 'recliner' : cell === 'V' ? 'vip' : 'standard';
                            const seat = makeSeat(letter + n, cls);
                            n++;
                            seatsDiv.appendChild(seat);
                        }
                    });
                    rowDiv.appendChild(seatsDiv);
                    container.appendChild(rowDiv);
                });
                return;
            }

            // Legacy row-based fallback
            let first = true;
            [
                { rows: config.standardRows, cls: 'standard' },
                { rows: config.premiumRows,  cls: 'premium' },
                { rows: config.reclinerRows, cls: 'recliner' },
                { rows: config.vipRows,      cls: 'vip' }
            ].forEach(type => {
                if (!type.rows || !type.rows.trim()) return;
                const letters = type.rows.split(',').map(r => r.trim()).filter(Boolean);
                if (!letters.length) return;
                if (!first) { const gap = document.createElement('div'); gap.className = 'row-type-separator'; container.appendChild(gap); }
                first = false;
                letters.forEach(letter => {
                    const rowDiv = document.createElement('div');
                    rowDiv.className = 'seat-row';
                    const lbl = document.createElement('span'); lbl.className = 'row-label'; lbl.textContent = letter;
                    rowDiv.appendChild(lbl);
                    const seatsDiv = document.createElement('div'); seatsDiv.className = 'seats-in-row';
                    for (let i = 1; i <= config.seatsPerRow; i++) seatsDiv.appendChild(makeSeat(letter + i, type.cls));
                    rowDiv.appendChild(seatsDiv);
                    container.appendChild(rowDiv);
                });
            });
        }

        function makeSeat(id, cls) {
            const el = document.createElement('div');
            el.className = 'seat ' + cls;
            el.dataset.id = id;
            el.dataset.type = cls;
            el.title = id + ' (' + cls + ')';
            el.addEventListener('click', function() {
                if (this.classList.contains('reserved')) return;
                if (selectedSeats.has(id)) {
                    selectedSeats.delete(id);
                    this.classList.remove('selected');
                } else {
                    if (selectedSeats.size >= 10) { alert('Maximum 10 seats per booking.'); return; }
                    selectedSeats.set(id, cls);
                    this.classList.add('selected');
                }
                updateSummary();
            });
            return el;
        }

        function renderDates() {
            const c = document.getElementById('dateContainer');
            if (!sortedDates.length) { c.innerHTML = '<span class="no-showtimes-msg">No upcoming dates available.</span>'; return; }
            c.innerHTML = '';
            sortedDates.forEach(ds => {
                const d = new Date(ds + 'T00:00:00');
                const el = document.createElement('div');
                el.className = 'date-btn'; el.dataset.date = ds;
                el.innerHTML = `<span class="d-month">${d.toLocaleString('en-US',{month:'short'})}</span><span class="d-day">${d.getDate()}</span><span class="d-name">${d.toLocaleString('en-US',{weekday:'short'})}</span>`;
                el.onclick = () => selectDate(ds);
                c.appendChild(el);
            });
        }

        function selectDate(ds) {
            currentDate = ds; currentTime = null;
            selectedSeats.clear();
            document.querySelectorAll('.date-btn').forEach(el => el.classList.toggle('active', el.dataset.date === ds));
            renderTimes(ds); updateSummary();
        }

        function renderTimes(ds) {
            const c = document.getElementById('timeContainer');
            const times = stGrouped[ds];
            if (!times || !times.length) {
                c.innerHTML = '<span class="no-showtimes-msg">No showtimes for this date.</span>';
                document.getElementById('seatContainer').innerHTML = '<p style="color:#bbb;font-size:14px;padding:32px;">No showtimes available.</p>';
                return;
            }
            c.innerHTML = '';
            times.sort((a,b) => a.time.localeCompare(b.time));

            const now = new Date();
            const todayStr = now.getFullYear() + '-' + String(now.getMonth()+1).padStart(2,'0') + '-' + String(now.getDate()).padStart(2,'0');
            const isToday = ds === todayStr;

            let firstAvail = null;
            times.forEach(st => {
                let expired = false;
                if (isToday) {
                    const [h, m] = st.time.split(':').map(Number);
                    if (Date.now() >= new Date(now.getFullYear(), now.getMonth(), now.getDate(), h, m).getTime() - 15*60000) expired = true;
                }
                const btn = document.createElement('button');
                btn.type = 'button';
                btn.innerText = st.time + ' · ' + st.hall;
                if (expired) {
                    btn.className = 'time-btn expired';
                    btn.disabled = true;
                    btn.title = 'Booking closed';
                } else {
                    btn.className = 'time-btn';
                    btn.onclick = () => selectTime(btn, st);
                    if (!firstAvail) firstAvail = { btn, st };
                }
                c.appendChild(btn);
            });

            if (firstAvail) selectTime(firstAvail.btn, firstAvail.st);
            else {
                c.innerHTML += '<span class="no-showtimes-msg" style="display:block;margin-top:6px;">All times for today have passed.</span>';
                document.getElementById('seatContainer').innerHTML = '<p style="color:#bbb;font-size:14px;padding:32px;">No bookable times today.</p>';
            }
        }

        function selectTime(btn, st) {
            currentTime = st;
            selectedSeats.clear();
            document.querySelectorAll('.time-btn').forEach(el => el.classList.remove('active'));
            btn.classList.add('active');
            document.getElementById('selectedHallLabel').innerText = st.hall;
            buildSeatGrid(st.hall);
            markReservedSeats();
            updateSummary();
        }

        function markReservedSeats() {
            if (!currentTime) return;
            const key = currentDate + ' ' + currentTime.time + ' - ' + currentTime.hall;
            const reserved = bookedSeatsData[key];
            if (!reserved) return;
            const rSet = new Set(reserved.split(',').map(s => s.trim()));
            document.querySelectorAll('.seat[data-id]').forEach(seat => {
                if (rSet.has(seat.dataset.id)) {
                    seat.classList.add('reserved');
                    seat.classList.remove('selected');
                    selectedSeats.delete(seat.dataset.id);
                }
            });
        }

        function updateSummary() {
            const count = selectedSeats.size;
            const ids = Array.from(selectedSeats.keys());
            let total = 0;
            selectedSeats.forEach(type => total += (prices[type] || prices.standard));

            document.getElementById('seatCountLabel').innerText = count;
            document.getElementById('seatIdsLabel').innerText = ids.length ? ids.join(', ') : 'None';
            document.getElementById('totalPriceLabel').innerText = total.toFixed(2);
            document.getElementById('selectedShowtimeLabel').innerText = currentTime ? currentDate + ' ' + currentTime.time : '—';
            document.getElementById('summaryHallName').innerText = currentTime ? currentTime.hall : '—';
            document.getElementById('numberOfSeatsInput').value = count;
            document.getElementById('selectedSeatIdsInput').value = ids.join(', ');
            document.getElementById('totalPriceInput').value = total.toFixed(2);
            if (currentTime) document.getElementById('finalShowTimeInput').value = currentDate + ' ' + currentTime.time + ' - ' + currentTime.hall;

            // Seat type breakdown
            const typeLabels = { standard: 'Standard', premium: 'Premium', recliner: 'Recliner', vip: 'VIP' };
            const typeCounts = {};
            selectedSeats.forEach(type => { typeCounts[type] = (typeCounts[type] || 0) + 1; });
            const breakdownEl = document.getElementById('seatBreakdown');
            const rowsEl = document.getElementById('breakdownRows');
            if (count > 0) {
                rowsEl.innerHTML = Object.entries(typeCounts).map(([type, n]) => {
                    const p = prices[type] || prices.standard;
                    return `<div style="display:flex;justify-content:space-between;font-size:12px;color:#555;margin-bottom:4px;">`
                        + `<span>${typeLabels[type] || type} &times; ${n}</span>`
                        + `<span>Rs. ${(p * n).toFixed(2)}</span>`
                        + `</div>`;
                }).join('');
                breakdownEl.style.display = 'block';
            } else {
                breakdownEl.style.display = 'none';
                rowsEl.innerHTML = '';
            }

            const btn = document.getElementById('submitBtn');
            if (count > 0 && currentTime) { btn.disabled = false; btn.classList.add('ready'); }
            else { btn.disabled = true; btn.classList.remove('ready'); }
        }

        function validateAndSubmit(event) {
            event.preventDefault();
            const showTime = document.getElementById('finalShowTimeInput').value;
            const seatIds = document.getElementById('selectedSeatIdsInput').value;
            if (!showTime || !seatIds || selectedSeats.size === 0) {
                alert('Please select a showtime and at least one seat.');
                return false;
            }

            const btn = document.getElementById('submitBtn');
            btn.disabled = true;
            btn.innerText = 'Checking availability...';

            const movieId = document.querySelector('input[name="movieId"]').value;
            fetch('${pageContext.request.contextPath}/api/bookings/validate', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'movieId=' + movieId + '&showTime=' + encodeURIComponent(showTime) + '&seatIds=' + encodeURIComponent(seatIds)
            })
            .then(r => r.json())
            .then(data => {
                if (data.success) {
                    btn.innerText = 'Booking...';
                    document.getElementById('bookingForm').submit();
                } else {
                    alert('Could not complete booking: ' + data.error);
                    btn.disabled = false;
                    btn.innerText = 'Book Tickets';
                    btn.classList.add('ready');
                    markReservedSeats();
                }
            })
            .catch(() => {
                alert('Network error. Please try again.');
                btn.disabled = false;
                btn.innerText = 'Book Tickets';
                btn.classList.add('ready');
            });
            return false;
        }

        window.onload = function() {
            if (sortedDates.length === 0) {
                document.getElementById('bookingLayout').style.display = 'none';
                document.getElementById('noShowtimesPanel').classList.add('visible');
                return;
            }

            renderDates();
            const preDate = "${preSelectedDate}";
            const preTime = "${preSelectedTime}";
            const preHall = "${preSelectedHall}";

            if (preDate && sortedDates.includes(preDate)) {
                selectDate(preDate);
                setTimeout(() => {
                    document.querySelectorAll('.time-btn:not(.expired)').forEach(btn => {
                        if (btn.innerText.includes(preTime) && btn.innerText.includes(preHall)) btn.click();
                    });
                }, 80);
            } else if (sortedDates.length > 0) {
                selectDate(sortedDates[0]);
            }
            updateSummary();
        };
    </script>
</body>
</html>
