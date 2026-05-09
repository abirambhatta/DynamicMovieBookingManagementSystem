<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - MovieMint Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background: #f0f0f1; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; }

        .admin-wrap {
            max-width: 1160px;
            margin: 0 auto;
            padding: 24px 20px 40px;
        }

        .page-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 12px;
        }

        .page-header h1 {
            font-size: 20px;
            font-weight: 700;
            color: #111;
            margin-bottom: 2px;
        }

        .page-header p {
            font-size: 13px;
            color: #666;
        }

        .period-filters {
            display: flex;
            gap: 4px;
            align-items: center;
            flex-wrap: wrap;
        }

        .period-filters button, .period-filters a {
            padding: 5px 12px;
            font-size: 12px;
            font-weight: 500;
            border: 1px solid #ccc;
            background: #fff;
            color: #444;
            border-radius: 3px;
            cursor: pointer;
            text-decoration: none;
        }

        .period-filters button.active {
            background: #c9152f;
            border-color: #c9152f;
            color: #fff;
        }

        .period-filters button:hover:not(.active) { background: #f5f5f5; }

        .custom-range-bar {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 12px 16px;
            margin-bottom: 16px;
            display: none;
            align-items: flex-end;
            gap: 12px;
            flex-wrap: wrap;
        }

        .custom-range-bar.visible { display: flex; }

        .custom-range-bar label {
            font-size: 11px;
            font-weight: 600;
            color: #666;
            display: block;
            margin-bottom: 4px;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .custom-range-bar input, .custom-range-bar select {
            padding: 6px 10px;
            border: 1px solid #ccc;
            border-radius: 3px;
            font-size: 13px;
            background: #fff;
        }

        .stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 12px;
            margin-bottom: 20px;
        }

        .stat-box {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 16px;
        }

        .stat-box .label {
            font-size: 11px;
            font-weight: 600;
            color: #888;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            margin-bottom: 8px;
        }

        .stat-box .value {
            font-size: 26px;
            font-weight: 700;
            color: #111;
            line-height: 1;
        }

        .stat-box.highlight .value { color: #c9152f; }

        .stat-box .sub {
            font-size: 11px;
            color: #aaa;
            margin-top: 6px;
        }

        .charts-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 20px;
        }

        .chart-box {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 16px;
        }

        .chart-box h3 {
            font-size: 13px;
            font-weight: 600;
            color: #333;
            margin-bottom: 14px;
        }

        .chart-scroll {
            overflow-x: auto;
            height: 200px;
        }

        .chart-scroll canvas, .chart-box canvas {
            height: 200px !important;
        }

        .bottom-row {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 16px;
        }

        .panel {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .panel-header {
            padding: 12px 16px;
            border-bottom: 1px solid #eee;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .panel-header h3 {
            font-size: 13px;
            font-weight: 600;
            color: #222;
        }

        .panel-header a {
            font-size: 12px;
            color: #c9152f;
            text-decoration: none;
        }

        .panel-header a:hover { text-decoration: underline; }

        .bookings-table {
            width: 100%;
            border-collapse: collapse;
        }

        .bookings-table th {
            font-size: 11px;
            font-weight: 600;
            color: #777;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            padding: 9px 14px;
            text-align: left;
            border-bottom: 1px solid #eee;
            background: #fafafa;
        }

        .bookings-table td {
            padding: 9px 14px;
            font-size: 13px;
            color: #333;
            border-bottom: 1px solid #f0f0f0;
            vertical-align: middle;
        }

        .bookings-table tr:last-child td { border-bottom: none; }
        .bookings-table tr:hover td { background: #fafafa; }

        .user-initials {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 26px;
            height: 26px;
            background: #e8e8e8;
            border-radius: 3px;
            font-size: 10px;
            font-weight: 700;
            color: #555;
            margin-right: 6px;
            flex-shrink: 0;
            vertical-align: middle;
        }

        .top-movies-list { padding: 4px 0; }

        .top-movie-row {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 16px;
            border-bottom: 1px solid #f0f0f0;
        }

        .top-movie-row:last-child { border-bottom: none; }

        .rank-num {
            font-size: 11px;
            font-weight: 700;
            color: #bbb;
            width: 16px;
            flex-shrink: 0;
        }

        .top-movie-thumb {
            width: 32px;
            height: 44px;
            object-fit: cover;
            border-radius: 2px;
            background: #e4e4e4;
            flex-shrink: 0;
        }

        .top-movie-thumb-placeholder {
            width: 32px;
            height: 44px;
            background: #e4e4e4;
            border-radius: 2px;
            flex-shrink: 0;
        }

        .top-movie-info { flex: 1; min-width: 0; }

        .top-movie-title {
            font-size: 13px;
            font-weight: 600;
            color: #222;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .top-movie-count {
            font-size: 11px;
            color: #888;
            margin-top: 2px;
        }

        .progress-bar {
            height: 3px;
            background: #eee;
            border-radius: 1px;
            margin-top: 6px;
        }

        .progress-fill {
            height: 100%;
            background: #c9152f;
            border-radius: 1px;
        }

        .empty-row td {
            text-align: center;
            padding: 28px;
            color: #aaa;
            font-size: 13px;
        }

        @media (max-width: 900px) {
            .stats-row { grid-template-columns: 1fr 1fr; }
            .charts-row { grid-template-columns: 1fr; }
            .bottom-row { grid-template-columns: 1fr; }
        }

        @media (max-width: 540px) {
            .stats-row { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <c:if test="${empty user || user.role != 'admin'}">
        <c:redirect url="login" />
    </c:if>

    <jsp:include page="adminHeader.jsp" />

    <div class="admin-wrap">

        <div class="page-header">
            <div>
                <h1>Dashboard</h1>
                <p>Showing stats for: <strong>${not empty selectedPeriod ? selectedPeriod : 'all time'}</strong></p>
            </div>
            <div class="period-filters">
                <button onclick="window.location.href='${pageContext.request.contextPath}/adminHome?period=week'" class="${selectedPeriod == 'week' ? 'active' : ''}">Week</button>
                <button onclick="window.location.href='${pageContext.request.contextPath}/adminHome?period=month_year'" class="${selectedPeriod == 'month_year' ? 'active' : ''}">Month</button>
                <button onclick="window.location.href='${pageContext.request.contextPath}/adminHome?period=year'" class="${selectedPeriod == 'year' ? 'active' : ''}">Year</button>
                <button onclick="toggleCustomRange()" class="${selectedPeriod == 'custom' ? 'active' : ''}">Custom</button>
                <c:if test="${not empty selectedPeriod}">
                    <button onclick="window.location.href='${pageContext.request.contextPath}/adminHome'">Clear</button>
                </c:if>
            </div>
        </div>

        <div class="custom-range-bar ${selectedPeriod == 'custom' ? 'visible' : ''}" id="customRangePicker">
            <div>
                <label>From</label>
                <input type="date" id="startDate" value="${startDate}">
            </div>
            <div>
                <label>To</label>
                <input type="date" id="endDate" value="${endDate}">
            </div>
            <div>
                <label>Group by</label>
                <select id="customGroup">
                    <option value="day" ${customGroup=='day' ? 'selected' : ''}>Day</option>
                    <option value="week" ${customGroup=='week' ? 'selected' : ''}>Week</option>
                    <option value="month" ${customGroup=='month' ? 'selected' : ''}>Month</option>
                </select>
            </div>
            <button onclick="applyCustomRange()" class="active">Apply</button>
            <button onclick="toggleCustomRange()">Cancel</button>
        </div>

        <div class="stats-row">
            <div class="stat-box">
                <div class="label">Movies</div>
                <div class="value"><c:out value="${totalMovies != null ? totalMovies : 0}" /></div>
                <div class="sub">in system</div>
            </div>
            <div class="stat-box">
                <div class="label">Users</div>
                <div class="value"><c:out value="${totalUsers != null ? totalUsers : 0}" /></div>
                <div class="sub">registered</div>
            </div>
            <div class="stat-box">
                <div class="label">Bookings</div>
                <div class="value"><c:out value="${totalBookings != null ? totalBookings : 0}" /></div>
                <div class="sub">total</div>
            </div>
            <div class="stat-box highlight">
                <div class="label">Revenue</div>
                <div class="value">Rs. <c:out value="${totalRevenue != null ? totalRevenue : '0'}" /></div>
                <div class="sub">collected</div>
            </div>
        </div>

        <div class="charts-row">
            <div class="chart-box">
                <h3>Revenue over time</h3>
                <div class="chart-scroll">
                    <div id="chartContainer" style="min-width:100%;height:200px;">
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="chart-box">
                <h3>Bookings by movie</h3>
                <canvas id="moviesChart"></canvas>
            </div>
        </div>

        <div class="bottom-row">
            <div class="panel">
                <div class="panel-header">
                    <h3>Recent bookings</h3>
                    <a href="${pageContext.request.contextPath}/manageBookings">View all</a>
                </div>
                <table class="bookings-table" data-paginate="true" data-rows-per-page="8">
                    <thead>
                        <tr>
                            <th>Customer</th>
                            <th>Movie</th>
                            <th>Hall</th>
                            <th>Time</th>
                            <th style="text-align:right">Amount</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty recentBookings}">
                                <tr class="empty-row"><td colspan="5">No recent bookings</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="booking" items="${recentBookings}">
                                    <tr>
                                        <td>
                                            <span class="user-initials"><c:out value="${booking.userName.substring(0, 2).toUpperCase()}" /></span>
                                            <c:out value="${booking.userName}" />
                                        </td>
                                        <td><c:out value="${booking.movieTitle}" /></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${booking.showTime.contains(' - ')}">
                                                    <c:out value="${booking.showTime.substring(booking.showTime.indexOf(' - ') + 3)}" />
                                                </c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${booking.showTime.length() >= 16}">
                                                    <c:out value="${booking.showTime.substring(11, 16)}" />
                                                </c:when>
                                                <c:otherwise><c:out value="${booking.showTime}" /></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="text-align:right;font-weight:600">Rs. <c:out value="${String.format('%.2f', booking.totalPrice)}" /></td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <div class="panel">
                <div class="panel-header">
                    <h3>Most booked</h3>
                </div>
                <div class="top-movies-list">
                    <c:choose>
                        <c:when test="${not empty topMovies}">
                            <c:forEach var="movie" items="${topMovies}" varStatus="status">
                                <c:if test="${status.index < 5}">
                                    <div class="top-movie-row">
                                        <span class="rank-num">${status.index + 1}</span>
                                        <c:choose>
                                            <c:when test="${not empty movie[3]}">
                                                <img class="top-movie-thumb" src="${pageContext.request.contextPath}/images/${movie[3]}" alt="${movie[0]}">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="top-movie-thumb-placeholder"></div>
                                            </c:otherwise>
                                        </c:choose>
                                        <div class="top-movie-info">
                                            <div class="top-movie-title"><c:out value="${movie[0]}" /></div>
                                            <div class="top-movie-count">${movie[1]} bookings &middot; ${movie[2]} seats</div>
                                            <div class="progress-bar"><div class="progress-fill" style="width:${movie[1] > 10 ? 100 : movie[1] * 10}%"></div></div>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div style="padding:24px;text-align:center;color:#aaa;font-size:13px;">No data yet</div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.2/dist/chart.umd.min.js"></script>
    <script>
        const chartRevenueData = [
            <c:forEach var="rev" items="${chartRevenue}" varStatus="status">
                {period: '${rev[0]}', revenue: ${rev[1]}}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        const moviesData = [
            <c:forEach var="movie" items="${allMovies}" varStatus="status">
                {title: `${movie[0]}`, count: ${movie[1]}}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        let revenueChart;

        function toggleCustomRange() {
            const picker = document.getElementById('customRangePicker');
            picker.classList.toggle('visible');
            if (picker.classList.contains('visible')) {
                const today = new Date();
                const lastMonth = new Date();
                lastMonth.setMonth(lastMonth.getMonth() - 1);
                if (!document.getElementById('endDate').value) document.getElementById('endDate').valueAsDate = today;
                if (!document.getElementById('startDate').value) document.getElementById('startDate').valueAsDate = lastMonth;
            }
        }

        function applyCustomRange() {
            const s = document.getElementById('startDate').value;
            const e = document.getElementById('endDate').value;
            const g = document.getElementById('customGroup').value;
            if (!s || !e) { alert('Select both dates'); return; }
            if (new Date(s) > new Date(e)) { alert('Start must be before end'); return; }
            window.location.href = '${pageContext.request.contextPath}/adminHome?period=custom&startDate=' + s + '&endDate=' + e + '&group=' + g;
        }

        function createRevenueChart(data, labelType) {
            const ctx = document.getElementById('revenueChart').getContext('2d');
            if (revenueChart) revenueChart.destroy();

            const minWidth = Math.max(100, data.length * 40);
            document.getElementById('chartContainer').style.minWidth = minWidth + 'px';

            let labels = data.map(d => d.period);
            let vals = data.map(d => d.revenue);

            if (labelType === 'day') {
                labels = labels.map(s => { const d = new Date(s); return isNaN(d) ? s : d.toLocaleDateString('en-US', {month:'short', day:'numeric'}); });
            } else if (labelType === 'weekday') {
                labels = labels.map(s => { const d = new Date(s); return isNaN(d) ? s : d.toLocaleDateString('en-US', {weekday:'long'}); });
            } else if (labelType === 'month') {
                const mo = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
                labels = labels.map(s => { const p = s.split('-'); return p.length >= 2 ? mo[parseInt(p[1])-1] : s; });
            } else if (labelType === 'hour') {
                labels = labels.map(s => { const p = s.split(' '); return p.length === 2 ? p[1] : s; });
            } else if (labelType === 'week_group') {
                labels = labels.map(s => { const d = new Date(s); if (isNaN(d)) return s; const e = new Date(d); e.setDate(e.getDate()+6); return d.toLocaleDateString('en-US',{month:'short',day:'numeric'})+' – '+e.toLocaleDateString('en-US',{month:'short',day:'numeric'}); });
            }

            revenueChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Revenue (Rs.)',
                        data: vals,
                        backgroundColor: '#c9152f',
                        borderRadius: 2,
                        borderWidth: 0
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: { callbacks: { label: ctx => 'Rs. ' + ctx.parsed.y.toLocaleString() } }
                    },
                    scales: {
                        y: { beginAtZero: true, ticks: { callback: v => 'Rs. ' + v.toLocaleString() }, grid: { color: 'rgba(0,0,0,0.04)' } },
                        x: { grid: { display: false } }
                    }
                }
            });
        }

        const selectedPeriod = '${selectedPeriod}';
        const customGroup = '${customGroup}';
        let chartType = 'month';
        if (selectedPeriod === 'day') chartType = 'hour';
        else if (selectedPeriod === 'week') chartType = 'weekday';
        else if (selectedPeriod === 'month') chartType = 'day';
        else if (selectedPeriod === 'month_year') chartType = 'month';
        else if (selectedPeriod === 'year') chartType = 'year';
        else if (selectedPeriod === 'custom') {
            if (customGroup === 'week') chartType = 'week_group';
            else if (customGroup === 'month') chartType = 'month';
            else chartType = 'day';
        }

        createRevenueChart(chartRevenueData, chartType);

        new Chart(document.getElementById('moviesChart').getContext('2d'), {
            type: 'bar',
            data: {
                labels: moviesData.map(d => d.title),
                datasets: [{ label: 'Bookings', data: moviesData.map(d => d.count), backgroundColor: '#c9152f', borderRadius: 2 }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
            }
        });
    </script>
    <script src="${pageContext.request.contextPath}/js/pagination.js"></script>
</body>
</html>