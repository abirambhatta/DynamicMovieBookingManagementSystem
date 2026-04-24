<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html class="light" lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Admin Dashboard - MovieMint</title>
            <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
            <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
            <link
                href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700;800&family=Inter:wght@400;500;600;700&display=swap"
                rel="stylesheet">
            <link
                href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
                rel="stylesheet">
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

                body {
                    font-family: 'Inter', sans-serif;
                }

                h1,
                h2,
                h3 {
                    font-family: 'Manrope', sans-serif;
                }

                .chart-bar {
                    transition: height 1s ease-out;
                }

                .line-path {
                    stroke-dasharray: 1000;
                    stroke-dashoffset: 1000;
                    animation: draw 2s forwards;
                }

                @keyframes draw {
                    to {
                        stroke-dashoffset: 0;
                    }
                }
            </style>
        </head>

        <body class="bg-surface text-on-surface">
            <c:if test="${empty user || user.role != 'admin'}">
                <c:redirect url="login" />
            </c:if>

            <jsp:include page="adminHeader.jsp" />

            <div class="main-content">
                <main class="p-8 min-h-screen">
                    <!-- Header -->
                    <header class="mb-10">
                        <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                            <div class="flex justify-between items-start">
                                <div>
                                    <h1 class="text-3xl font-bold tracking-tight text-on-surface mb-2">Daily Overview
                                    </h1>
                                    <p class="text-secondary">Welcome back, Director. Here is your cinema's performance.
                                    </p>
                                </div>
                                <div class="flex items-center gap-4">
                                    <div class="flex gap-2">
                                        <button
                                            onclick="window.location.href='${pageContext.request.contextPath}/adminHome?period=day'"
                                            id="filterDay"
                                            class="px-4 py-2 text-xs font-bold uppercase tracking-wider rounded ${selectedPeriod == 'day' ? 'bg-primary border-2 border-primary text-white' : 'bg-white border-2 border-gray-300 text-gray-700 hover:border-primary hover:text-primary'} transition-colors">Today</button>
                                        <button
                                            onclick="window.location.href='${pageContext.request.contextPath}/adminHome?period=week'"
                                            id="filterWeek"
                                            class="px-4 py-2 text-xs font-bold uppercase tracking-wider rounded ${selectedPeriod == 'week' ? 'bg-primary border-2 border-primary text-white' : 'bg-white border-2 border-gray-300 text-gray-700 hover:border-primary hover:text-primary'} transition-colors">Week</button>
                                        <button
                                            onclick="window.location.href='${pageContext.request.contextPath}/adminHome?period=month'"
                                            id="filterMonth"
                                            class="px-4 py-2 text-xs font-bold uppercase tracking-wider rounded ${selectedPeriod == 'month' ? 'bg-primary border-2 border-primary text-white' : 'bg-white border-2 border-gray-300 text-gray-700 hover:border-primary hover:text-primary'} transition-colors">Month</button>
                                        <button onclick="toggleCustomRange()" id="filterCustom"
                                            class="px-4 py-2 text-xs font-bold uppercase tracking-wider rounded ${selectedPeriod == 'custom' ? 'bg-primary border-2 border-primary text-white' : 'bg-white border-2 border-gray-300 text-gray-700 hover:border-primary hover:text-primary'} transition-colors flex items-center gap-2">
                                            <span class="material-symbols-outlined text-sm">calendar_month</span>
                                            Custom
                                        </button>
                                        <c:if test="${not empty selectedPeriod}">
                                            <button
                                                onclick="window.location.href='${pageContext.request.contextPath}/adminHome'"
                                                class="px-4 py-2 text-xs font-bold uppercase tracking-wider rounded bg-gray-200 border-2 border-gray-200 text-gray-700 hover:bg-gray-300 transition-colors">Clear</button>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                            <!-- Custom Date Range Picker -->
                            <div id="customRangePicker"
                                class="mt-4 p-4 bg-gray-50 rounded-lg border border-gray-200 hidden">
                                <div class="flex items-center gap-4">
                                    <div>
                                        <label class="text-xs font-bold text-gray-600 uppercase mb-1 block">Start
                                            Date</label>
                                        <input type="date" id="startDate"
                                            class="px-3 py-2 border border-gray-300 rounded text-sm text-gray-900 bg-white">
                                    </div>
                                    <div>
                                        <label class="text-xs font-bold text-gray-600 uppercase mb-1 block">End
                                            Date</label>
                                        <input type="date" id="endDate"
                                            class="px-3 py-2 border border-gray-300 rounded text-sm text-gray-900 bg-white">
                                    </div>
                                    <div>
                                        <label class="text-xs font-bold text-gray-600 uppercase mb-1 block">Group
                                            By</label>
                                        <select id="customGroup"
                                            class="px-3 py-2 border border-gray-300 rounded text-sm text-gray-900 bg-white">
                                            <option value="day" ${customGroup=='day' ? 'selected' : '' }>Day</option>
                                            <option value="week" ${customGroup=='week' ? 'selected' : '' }>Week</option>
                                            <option value="month" ${customGroup=='month' ? 'selected' : '' }>Month
                                            </option>
                                        </select>
                                    </div>
                                    <button onclick="applyCustomRange()"
                                        class="mt-5 px-6 py-2 bg-primary text-white text-xs font-bold uppercase rounded hover:bg-primary-dark transition-colors">Apply</button>
                                    <button onclick="toggleCustomRange()"
                                        class="mt-5 px-6 py-2 bg-gray-200 text-gray-700 text-xs font-bold uppercase rounded hover:bg-gray-300 transition-colors">Cancel</button>
                                </div>
                            </div>
                        </div>
                    </header>

                    <!-- Stats Grid -->
                    <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
                        <div
                            class="bg-surface-container-lowest p-6 rounded-xl border-l-4 border-primary shadow-[0_20px_40px_rgba(20,29,35,0.03)]">
                            <div class="flex justify-between items-start mb-4">
                                <span class="text-[10px] font-bold uppercase tracking-[0.2em] text-secondary">Total
                                    Movies</span>
                                <span class="material-symbols-outlined text-primary opacity-30">movie</span>
                            </div>
                            <div class="text-4xl font-bold font-headline tracking-tighter text-on-surface">
                                <c:out value="${totalMovies != null && totalMovies > 0 ? totalMovies : '0'}" />
                            </div>
                            <div class="mt-2 text-[10px] text-green-600 font-bold">Active in system</div>
                        </div>

                        <div
                            class="bg-surface-container-lowest p-6 rounded-xl border-l-4 border-[#3498db] shadow-[0_20px_40px_rgba(20,29,35,0.03)]">
                            <div class="flex justify-between items-start mb-4">
                                <span
                                    class="text-[10px] font-bold uppercase tracking-[0.2em] text-secondary">Users</span>
                                <span class="material-symbols-outlined text-primary opacity-30">group</span>
                            </div>
                            <div class="text-4xl font-bold font-headline tracking-tighter text-on-surface">
                                <c:out value="${totalUsers != null ? totalUsers : '0'}" />
                            </div>
                            <div class="mt-2 text-[10px] text-green-600 font-bold">Registered users</div>
                        </div>

                        <div
                            class="bg-surface-container-lowest p-6 rounded-xl border-l-4 border-[#f39c12] shadow-[0_20px_40px_rgba(20,29,35,0.03)]">
                            <div class="flex justify-between items-start mb-4">
                                <span
                                    class="text-[10px] font-bold uppercase tracking-[0.2em] text-secondary">Bookings</span>
                                <span
                                    class="material-symbols-outlined text-primary opacity-30">confirmation_number</span>
                            </div>
                            <div class="text-4xl font-bold font-headline tracking-tighter text-on-surface">
                                <c:out value="${totalBookings != null ? totalBookings : '0'}" />
                            </div>
                            <div class="mt-2 text-[10px] text-primary font-bold">Total bookings</div>
                        </div>

                        <div class="bg-primary text-white p-6 rounded-xl shadow-[0_20px_40px_rgba(220,20,60,0.15)]">
                            <div class="flex justify-between items-start mb-4">
                                <span class="text-[10px] font-bold uppercase tracking-[0.2em] opacity-80">Revenue</span>
                                <span class="material-symbols-outlined opacity-50">payments</span>
                            </div>
                            <div class="text-4xl font-bold font-headline tracking-tighter">
                                <c:out value="${totalRevenue != null ? 'Rs. '.concat(totalRevenue) : 'Rs. 0'}" />
                            </div>
                            <div class="mt-2 text-[10px] opacity-80 font-bold">Daily target: 94%</div>
                        </div>
                    </div>

                    <!-- Visual Data Charts Section -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8 mb-12">
                        <!-- Revenue Bar Chart -->
                        <div class="bg-white p-6 rounded-xl shadow-lg border border-gray-200">
                            <h2 class="text-lg font-bold font-headline tracking-tight text-on-surface mb-6">Revenue Over
                                Time</h2>
                            <div class="h-64 overflow-x-auto w-full" style="max-width: 100%;">
                                <div id="chartContainer" style="min-width: 100%; height: 100%;">
                                    <canvas id="revenueChart"></canvas>
                                </div>
                            </div>
                        </div>

                        <!-- All Movies Chart -->
                        <div
                            class="bg-surface-container-lowest p-6 rounded-xl border border-surface-container-high shadow-[0_20px_40px_rgba(20,29,35,0.03)]">
                            <div class="flex justify-between items-center mb-6">
                                <div>
                                    <h3 class="text-secondary text-[10px] font-bold uppercase tracking-widest">Movie
                                        Performance</h3>
                                    <p class="text-on-surface text-2xl font-bold font-headline">Booking Count</p>
                                </div>
                                <div class="flex gap-1">
                                    <div class="w-1 h-1 rounded-full bg-primary"></div>
                                    <div class="w-1 h-1 rounded-full bg-primary opacity-30"></div>
                                    <div class="w-1 h-1 rounded-full bg-primary opacity-30"></div>
                                </div>
                            </div>
                            <div class="h-48">
                                <canvas id="moviesChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <!-- Bento Layout for Content -->
                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                        <!-- Recent Bookings Table -->
                        <div class="lg:col-span-2 space-y-6">
                            <div class="flex justify-between items-center">
                                <h2 class="text-xl font-bold tracking-tight uppercase text-on-surface">Recent Bookings
                                </h2>
                                <a href="${pageContext.request.contextPath}/manageBookings"
                                    class="text-[10px] font-bold text-primary uppercase border-b-2 border-primary pb-0.5 tracking-widest hover:opacity-80">View
                                    All</a>
                            </div>
                            <div class="bg-surface-container-low rounded-xl overflow-hidden">
                                <div class="overflow-x-auto">
                                    <table class="w-full text-left" data-paginate="true" data-rows-per-page="8">
                                        <thead>
                                            <tr class="border-b border-gray-200 bg-gray-50/50">
                                                <th class="p-4 text-[11px] font-bold uppercase tracking-widest">Customer
                                                </th>
                                                <th class="p-4 text-[11px] font-bold uppercase tracking-widest">Movie
                                                </th>
                                                <th class="p-4 text-[11px] font-bold uppercase tracking-widest">Hall
                                                </th>
                                                <th class="p-4 text-[11px] font-bold uppercase tracking-widest">Time
                                                </th>
                                                <th
                                                    class="p-4 text-[11px] font-bold uppercase tracking-widest text-right">
                                                    Amount</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-gray-200">
                                            <c:choose>
                                                <c:when test="${empty recentBookings}">
                                                    <tr>
                                                        <td colspan="5" class="p-8 text-center text-secondary">No recent
                                                            bookings available</td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="booking" items="${recentBookings}">
                                                        <tr class="hover:bg-gray-50 transition-colors">
                                                            <td class="p-4">
                                                                <div class="flex items-center gap-3">
                                                                    <div
                                                                        class="w-8 h-8 rounded-md bg-gray-200 flex items-center justify-center text-xs font-bold text-gray-700">
                                                                        <c:out
                                                                            value="${booking.userName.substring(0, 2).toUpperCase()}" />
                                                                    </div>
                                                                    <span class="text-sm font-semibold">
                                                                        <c:out value="${booking.userName}" />
                                                                    </span>
                                                                </div>
                                                            </td>
                                                            <td class="p-4 text-sm font-medium">
                                                                <c:out value="${booking.movieTitle}" />
                                                            </td>
                                                            <td class="p-4 text-xs">
                                                                <c:choose>
                                                                    <c:when test="${booking.showTime.contains(' - ')}">
                                                                        <c:out
                                                                            value="${booking.showTime.substring(booking.showTime.indexOf(' - ') + 3)}" />
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <c:out value="${booking.showTime}" />
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td class="p-4 text-xs font-mono text-secondary">
                                                                <c:choose>
                                                                    <c:when test="${booking.showTime.contains(' - ')}">
                                                                        <c:out
                                                                            value="${booking.showTime.substring(11, 16)}" />
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <c:out value="${booking.showTime}" />
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td class="p-4 text-sm font-bold text-right">Rs.
                                                                <c:out
                                                                    value="${String.format('%.2f', booking.totalPrice)}" />
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- Top Movies -->
                        <div class="space-y-6">
                            <div class="flex justify-between items-center">
                                <h2 class="text-xl font-bold tracking-tight uppercase text-on-surface">Most Booked
                                    Movies</h2>
                                <span class="material-symbols-outlined text-secondary">more_horiz</span>
                            </div>
                            <div class="space-y-4">
                                <c:choose>
                                    <c:when test="${not empty topMovies}">
                                        <c:forEach var="movie" items="${topMovies}" varStatus="status">
                                            <c:if test="${status.index < 3}">
                                                <div
                                                    class="relative group cursor-pointer overflow-hidden rounded-xl bg-surface-container-low p-4 transition-all hover:bg-surface-container-highest">
                                                    <div class="flex gap-4">
                                                        <div
                                                            class="w-20 h-28 rounded-md bg-on-surface/10 overflow-hidden flex-shrink-0 relative group-hover:shadow-md transition-shadow">
                                                            <c:choose>
                                                                <c:when test="${not empty movie[3]}">
                                                                    <img src="${pageContext.request.contextPath}/images/${movie[3]}"
                                                                        alt="${movie[0]}"
                                                                        class="w-full h-full object-cover">
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div
                                                                        class="w-full h-full bg-gradient-to-br from-primary/20 to-primary/5 flex items-center justify-center text-primary font-bold text-2xl">
                                                                        ${status.index + 1}
                                                                    </div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                            <div
                                                                class="absolute top-1 left-1 w-6 h-6 bg-primary text-white rounded-full flex items-center justify-center text-[10px] font-bold shadow-sm">
                                                                ${status.index + 1}
                                                            </div>
                                                        </div>
                                                        <div class="flex flex-col justify-between py-1">
                                                            <div>
                                                                <h3 class="font-bold text-sm leading-tight mb-1">
                                                                    <c:out value="${movie[0]}" />
                                                                </h3>
                                                                <p
                                                                    class="text-[10px] font-bold text-primary uppercase tracking-widest">
                                                                    Bookings: ${movie[1]}</p>
                                                            </div>
                                                            <div class="flex gap-2">
                                                                <span
                                                                    class="px-2 py-1 bg-white rounded text-[10px] font-bold shadow-sm">Seats:
                                                                    ${movie[2]}</span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div
                                                        class="mt-3 w-full bg-surface-container-high h-1 rounded-full overflow-hidden">
                                                        <div class="bg-primary h-full" style="width: ${movie[1] * 10}%">
                                                        </div>
                                                    </div>
                                                    <div class="flex justify-between mt-1">
                                                        <span
                                                            class="text-[9px] font-bold text-secondary uppercase">Popularity</span>
                                                        <span class="text-[9px] font-bold text-on-surface">${movie[1]}
                                                            bookings</span>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-8 text-secondary">
                                            <p>No booking data available</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </main>
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
                    if (picker.classList.contains('hidden')) {
                        picker.classList.remove('hidden');
                        const today = new Date();
                        const lastMonth = new Date();
                        lastMonth.setMonth(lastMonth.getMonth() - 1);
                        document.getElementById('endDate').valueAsDate = today;
                        document.getElementById('startDate').valueAsDate = lastMonth;
                    } else {
                        picker.classList.add('hidden');
                    }
                }

                function applyCustomRange() {
                    const startDate = document.getElementById('startDate').value;
                    const endDate = document.getElementById('endDate').value;
                    const group = document.getElementById('customGroup').value;

                    if (!startDate || !endDate) {
                        alert('Please select both start and end dates');
                        return;
                    }

                    if (new Date(startDate) > new Date(endDate)) {
                        alert('Start date must be before end date');
                        return;
                    }

                    window.location.href = '${pageContext.request.contextPath}/adminHome?period=custom&startDate=' + startDate + '&endDate=' + endDate + '&group=' + group;
                }

                function createRevenueChart(data, labelType = 'date') {
                    const ctx = document.getElementById('revenueChart').getContext('2d');

                    if (revenueChart) {
                        revenueChart.destroy();
                    }

                    // Set dynamic width for horizontal scrolling
                    const minWidth = Math.max(100, data.length * 40); // 40px per bar
                    document.getElementById('chartContainer').style.minWidth = minWidth + 'px';

                    let labels = data.map(d => d.period); // Don't reverse, DAO returns ASC
                    let revenueVals = data.map(d => d.revenue);

                    // Format labels based on type
                    if (labelType === 'day') {
                        labels = labels.map(dateStr => {
                            const date = new Date(dateStr);
                            if (isNaN(date.getTime())) return dateStr;
                            return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
                        });
                    } else if (labelType === 'week_group') {
                        labels = labels.map(dateStr => {
                            const date = new Date(dateStr);
                            if (isNaN(date.getTime())) return dateStr;
                            const endDate = new Date(date);
                            endDate.setDate(endDate.getDate() + 6);
                            const startStr = date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
                            const endStr = endDate.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
                            return startStr + ' - ' + endStr;
                        });
                    } else if (labelType === 'month') {
                        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                        labels = labels.map(dateStr => {
                            const parts = dateStr.split('-'); // e.g. "2024-03"
                            if (parts.length >= 2) {
                                const monthIndex = parseInt(parts[1], 10) - 1;
                                if (monthIndex >= 0 && monthIndex < 12) {
                                    return months[monthIndex] + ' ' + parts[0];
                                }
                            }
                            return dateStr;
                        });
                    } else if (labelType === 'hour') {
                        labels = labels.map(dateStr => {
                            const parts = dateStr.split(' ');
                            if (parts.length === 2) return parts[1]; // e.g. "2024-03-01 14:00" -> "14:00"
                            return dateStr;
                        });
                    }

                    revenueChart = new Chart(ctx, {
                        type: 'bar',
                        data: {
                            labels: labels,
                            datasets: [{
                                label: 'Revenue (Rs.)',
                                data: revenueVals,
                                backgroundColor: '#dc143c',
                                borderRadius: 8,
                                borderWidth: 0
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: { display: false },
                                tooltip: {
                                    callbacks: {
                                        label: function (context) {
                                            return 'Revenue: Rs. ' + context.parsed.y.toLocaleString();
                                        }
                                    }
                                }
                            },
                            scales: {
                                y: {
                                    beginAtZero: true,
                                    ticks: {
                                        callback: function (value) {
                                            return 'Rs. ' + value.toLocaleString();
                                        }
                                    },
                                    grid: { color: 'rgba(0,0,0,0.05)' }
                                },
                                x: {
                                    grid: { display: false }
                                }
                            }
                        }
                    });
                }

                const selectedPeriod = '${selectedPeriod}';
                const customGroup = '${customGroup}';

                let chartType = 'day';
                if (selectedPeriod === 'day') chartType = 'hour';
                else if (selectedPeriod === 'week') chartType = 'day';
                else if (selectedPeriod === 'month') chartType = 'day';
                else if (selectedPeriod === 'custom') {
                    if (customGroup === 'week') chartType = 'week_group';
                    else if (customGroup === 'month') chartType = 'month';
                    else chartType = 'day';
                } else {
                    chartType = 'month';
                }

                createRevenueChart(chartRevenueData, chartType);



                const moviesCtx = document.getElementById('moviesChart').getContext('2d');
                new Chart(moviesCtx, {
                    type: 'bar',
                    data: {
                        labels: moviesData.map(d => d.title),
                        datasets: [{
                            label: 'Bookings',
                            data: moviesData.map(d => d.count),
                            backgroundColor: '#dc143c',
                            borderRadius: 6
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { display: false }
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: { stepSize: 1 }
                            }
                        }
                    }
                });
            </script>
            <script src="${pageContext.request.contextPath}/js/pagination.js"></script>
        </body>

        </html>