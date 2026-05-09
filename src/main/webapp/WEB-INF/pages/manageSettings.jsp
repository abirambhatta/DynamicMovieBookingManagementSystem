<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.Map, java.util.List" %>
<%@ page import="com.moviebooking.model.HallConfig" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings - MovieMint Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background: #f0f0f1; }

        .admin-wrap {
            max-width: 960px;
            margin: 0 auto;
            padding: 24px 20px 48px;
        }

        .page-header { margin-bottom: 20px; }
        .page-header h1 { font-size: 20px; font-weight: 700; color: #111; margin-bottom: 2px; }
        .page-header p { font-size: 13px; color: #666; }

        .settings-panel {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 3px;
            margin-bottom: 16px;
            overflow: hidden;
        }

        .panel-head {
            background: #fafafa;
            border-bottom: 1px solid #ddd;
            padding: 11px 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .panel-head h2 {
            font-size: 13px;
            font-weight: 700;
            color: #222;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }

        .panel-body { padding: 20px; }

        .info-note {
            background: #fffbf0;
            border-left: 3px solid #e09000;
            padding: 9px 13px;
            font-size: 12px;
            color: #555;
            margin-bottom: 16px;
            line-height: 1.6;
        }

        /* Pricing */
        .price-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 12px;
            margin-bottom: 16px;
        }

        .price-cell {
            border: 1px solid #ddd;
            border-radius: 3px;
            padding: 12px;
        }

        .price-cell label {
            display: block;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            color: #666;
            margin-bottom: 6px;
        }

        .price-type {
            display: inline-block;
            font-size: 10px;
            font-weight: 700;
            padding: 1px 6px;
            border-radius: 2px;
            margin-bottom: 6px;
            text-transform: uppercase;
        }

        .type-s { background: #e8f0fe; color: #1a4a8b; }
        .type-p { background: #e8f5ee; color: #1a5c2b; }
        .type-r { background: #fff5e0; color: #7a4800; }
        .type-v { background: #f5eeff; color: #5a1a8b; }

        .price-wrap { position: relative; }
        .price-pfx {
            position: absolute;
            left: 9px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 12px;
            font-weight: 700;
            color: #777;
            pointer-events: none;
        }

        .price-input {
            width: 100%;
            padding: 7px 8px 7px 36px;
            border: 1px solid #ccc;
            border-radius: 3px;
            font-size: 14px;
            font-weight: 600;
            font-family: inherit;
            color: #111;
        }

        .price-input:focus { outline: none; border-color: #c9152f; }

        /* Halls */
        .hall-item {
            border: 1px solid #ddd;
            border-radius: 3px;
            margin-bottom: 10px;
        }

        .hall-item-head {
            padding: 10px 14px;
            background: #fafafa;
            border-bottom: 1px solid #eee;
            display: flex;
            align-items: center;
            justify-content: space-between;
            cursor: pointer;
        }

        .hall-item-head h3 {
            font-size: 13px;
            font-weight: 700;
            color: #222;
        }

        .hall-meta { font-size: 12px; color: #999; margin-left: 10px; }

        .hall-item-body {
            display: none;
            padding: 16px;
            border-top: 1px solid #eee;
        }

        .hall-item-body.open { display: block; }

        .hall-note {
            font-size: 12px;
            color: #777;
            background: #fafafa;
            border: 1px solid #eee;
            border-radius: 3px;
            padding: 7px 11px;
            margin-bottom: 12px;
        }

        /* Grid builder */
        .grid-controls {
            display: flex;
            gap: 4px;
            margin-bottom: 10px;
            flex-wrap: wrap;
        }

        .btn-grid-ctrl {
            padding: 4px 10px;
            font-size: 12px;
            font-family: inherit;
            font-weight: 600;
            border: 1px solid #ccc;
            background: #f5f5f5;
            border-radius: 3px;
            cursor: pointer;
            color: #444;
        }

        .btn-grid-ctrl:hover { background: #e8e8e8; }

        .grid-canvas-wrap {
            overflow-x: auto;
            border: 1px solid #ddd;
            border-radius: 3px;
            padding: 10px;
            background: #fff;
            margin-bottom: 12px;
        }

        .layout-grid { display: inline-flex; flex-direction: column; gap: 3px; }
        .layout-row { display: flex; gap: 3px; align-items: center; }

        .layout-cell {
            width: 26px;
            height: 26px;
            border-radius: 2px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 10px;
            font-weight: 700;
            color: #fff;
            border: 1px solid #ccc;
            user-select: none;
        }

        .cell-S { background: #d0d0d0; color: #444; border-color: #bbb; }
        .cell-P { background: #90c4a0; color: #1a4a1a; border-color: #78b088; }
        .cell-R { background: #f0c070; color: #5a3000; border-color: #d8a855; }
        .cell-V { background: #c8a0d8; color: #3a0060; border-color: #b088c4; }
        .cell-_ { background: transparent; border: 1px dashed #ccc; }

        .row-label {
            width: 20px;
            font-size: 10px;
            font-weight: 700;
            color: #aaa;
            text-align: center;
            cursor: pointer;
            flex-shrink: 0;
        }

        .row-label:hover { color: #c9152f; }

        /* Brush palette */
        .brush-bar {
            display: flex;
            align-items: center;
            gap: 6px;
            margin-bottom: 10px;
            flex-wrap: wrap;
        }

        .brush-label {
            font-size: 11px;
            font-weight: 700;
            color: #888;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .brush-btn {
            display: flex;
            align-items: center;
            gap: 5px;
            padding: 4px 10px;
            border: 1px solid #ccc;
            border-radius: 3px;
            cursor: pointer;
            font-size: 11px;
            font-family: inherit;
            font-weight: 600;
            background: #fff;
            color: #444;
        }

        .brush-btn.active {
            border-color: #c9152f;
            background: #fde8ec;
            color: #c9152f;
        }

        .brush-dot {
            width: 12px;
            height: 12px;
            border-radius: 2px;
            flex-shrink: 0;
        }

        .bd-S { background: #d0d0d0; }
        .bd-P { background: #90c4a0; }
        .bd-R { background: #f0c070; }
        .bd-V { background: #c8a0d8; }
        .bd-_ { background: #fff; border: 1px dashed #ccc; }

        /* Seat type key */
        .type-key {
            display: flex;
            gap: 14px;
            flex-wrap: wrap;
            margin-bottom: 14px;
        }

        .type-key-item {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 12px;
            color: #555;
            font-weight: 600;
        }

        .hall-actions {
            display: flex;
            gap: 8px;
            align-items: center;
            margin-top: 4px;
        }

        /* Add hall form */
        .add-hall-row {
            display: flex;
            gap: 8px;
            margin-top: 14px;
            padding-top: 14px;
            border-top: 1px dashed #ddd;
            flex-wrap: wrap;
        }

        .add-hall-row input {
            flex: 1;
            min-width: 200px;
            padding: 7px 10px;
            border: 1px solid #ccc;
            border-radius: 3px;
            font-size: 13px;
            font-family: inherit;
        }

        .add-hall-row input:focus { outline: none; border-color: #c9152f; }

        .btn-add-hall {
            padding: 7px 16px;
            background: #218a3a;
            color: #fff;
            border: none;
            border-radius: 3px;
            font-size: 13px;
            font-family: inherit;
            font-weight: 600;
            cursor: pointer;
            white-space: nowrap;
        }

        .btn-add-hall:hover { background: #196b2d; }

        .btn-save-hall {
            padding: 6px 14px;
            background: #c9152f;
            color: #fff;
            border: none;
            border-radius: 3px;
            font-size: 12px;
            font-family: inherit;
            font-weight: 600;
            cursor: pointer;
        }

        .btn-save-hall:hover { background: #a01026; }

        .btn-del-hall {
            padding: 6px 14px;
            background: #fff;
            color: #c82333;
            border: 1px solid #f5c6cb;
            border-radius: 3px;
            font-size: 12px;
            font-family: inherit;
            font-weight: 600;
            cursor: pointer;
        }

        .btn-del-hall:hover { background: #c82333; color: #fff; border-color: #c82333; }

        .btn-save-prices {
            padding: 8px 18px;
            background: #c9152f;
            color: #fff;
            border: none;
            border-radius: 3px;
            font-size: 13px;
            font-family: inherit;
            font-weight: 600;
            cursor: pointer;
        }

        .btn-save-prices:hover { background: #a01026; }

        .btn-toggle-hall {
            padding: 3px 10px;
            font-size: 11px;
            font-family: inherit;
            font-weight: 600;
            border: 1px solid #ccc;
            background: #fff;
            border-radius: 3px;
            cursor: pointer;
            color: #555;
        }

        .msg-ok {
            background: #e2f5e8; color: #1a5c2b; border: 1px solid #b8e0c4;
            border-radius: 3px; padding: 9px 12px; font-size: 13px; margin-bottom: 14px;
        }

        .msg-err {
            background: #fde8ec; color: #8b1a25; border: 1px solid #f5c6cb;
            border-radius: 3px; padding: 9px 12px; font-size: 13px; margin-bottom: 14px;
        }

        @media (max-width: 700px) {
            .price-grid { grid-template-columns: 1fr 1fr; }
        }
    </style>
</head>
<body>
    <c:if test="${empty user || user.role != 'admin'}">
        <c:redirect url="login"/>
    </c:if>

    <%@ include file="adminHeader.jsp" %>

    <div class="admin-wrap">
        <div class="page-header">
            <h1>Settings</h1>
            <p>Ticket pricing and hall configuration</p>
        </div>

        <c:if test="${not empty param.success}">
            <div class="msg-ok">${param.success}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="msg-err">${param.error}</div>
        </c:if>

        <%
            Map<String, String> settings = (Map<String, String>) request.getAttribute("settings");
            String priceStandard = settings != null ? settings.getOrDefault("PRICE_STANDARD", "200.0") : "200.0";
            String pricePremium  = settings != null ? settings.getOrDefault("PRICE_PREMIUM",  "350.0") : "350.0";
            String priceRecliner = settings != null ? settings.getOrDefault("PRICE_RECLINER", "500.0") : "500.0";
            String priceVip      = settings != null ? settings.getOrDefault("PRICE_VIP",      "750.0") : "750.0";
        %>

        <%-- Ticket Pricing --%>
        <div class="settings-panel">
            <div class="panel-head">
                <h2>Ticket Pricing</h2>
            </div>
            <div class="panel-body">
                <div class="info-note">
                    Base prices for each seat type. Changes apply to all new bookings immediately.
                </div>
                <form method="post" action="${pageContext.request.contextPath}/manageSettings">
                    <input type="hidden" name="action" value="updatePrices">
                    <div class="price-grid">
                        <div class="price-cell">
                            <span class="price-type type-s">Standard</span>
                            <label for="ps">Standard seat (Rs.)</label>
                            <div class="price-wrap">
                                <span class="price-pfx">Rs.</span>
                                <input type="number" id="ps" name="PRICE_STANDARD" class="price-input" value="<%= priceStandard %>" min="1" step="0.5" required>
                            </div>
                        </div>
                        <div class="price-cell">
                            <span class="price-type type-p">Premium</span>
                            <label for="pp">Premium seat (Rs.)</label>
                            <div class="price-wrap">
                                <span class="price-pfx">Rs.</span>
                                <input type="number" id="pp" name="PRICE_PREMIUM" class="price-input" value="<%= pricePremium %>" min="1" step="0.5" required>
                            </div>
                        </div>
                        <div class="price-cell">
                            <span class="price-type type-r">Recliner</span>
                            <label for="pr">Recliner seat (Rs.)</label>
                            <div class="price-wrap">
                                <span class="price-pfx">Rs.</span>
                                <input type="number" id="pr" name="PRICE_RECLINER" class="price-input" value="<%= priceRecliner %>" min="1" step="0.5" required>
                            </div>
                        </div>
                        <div class="price-cell">
                            <span class="price-type type-v">VIP</span>
                            <label for="pv">VIP seat (Rs.)</label>
                            <div class="price-wrap">
                                <span class="price-pfx">Rs.</span>
                                <input type="number" id="pv" name="PRICE_VIP" class="price-input" value="<%= priceVip %>" min="1" step="0.5" required>
                            </div>
                        </div>
                    </div>
                    <button type="submit" class="btn-save-prices">Save prices</button>
                </form>
            </div>
        </div>

        <%-- Hall Management --%>
        <div class="settings-panel">
            <div class="panel-head">
                <h2>Hall Management</h2>
            </div>
            <div class="panel-body">
                <div class="info-note">
                    Click a hall to configure its seat layout. Paint seats by selecting a brush type then clicking or dragging on the grid.
                </div>

                <div class="type-key">
                    <div class="type-key-item"><span class="brush-dot bd-S"></span> Standard (S)</div>
                    <div class="type-key-item"><span class="brush-dot bd-P"></span> Premium (P)</div>
                    <div class="type-key-item"><span class="brush-dot bd-R"></span> Recliner (R)</div>
                    <div class="type-key-item"><span class="brush-dot bd-V"></span> VIP (V)</div>
                    <div class="type-key-item"><span class="brush-dot bd-_"></span> Aisle (_)</div>
                </div>

                <div class="brush-bar">
                    <span class="brush-label">Brush:</span>
                    <button type="button" id="brush_S" class="brush-btn active" onclick="setBrush('S')"><span class="brush-dot bd-S"></span> Standard</button>
                    <button type="button" id="brush_P" class="brush-btn" onclick="setBrush('P')"><span class="brush-dot bd-P"></span> Premium</button>
                    <button type="button" id="brush_R" class="brush-btn" onclick="setBrush('R')"><span class="brush-dot bd-R"></span> Recliner</button>
                    <button type="button" id="brush_V" class="brush-btn" onclick="setBrush('V')"><span class="brush-dot bd-V"></span> VIP</button>
                    <button type="button" id="brush__" class="brush-btn" onclick="setBrush('_')"><span class="brush-dot bd-_"></span> Aisle</button>
                </div>

                <c:forEach var="hall" items="${hallConfigs}">
                    <div class="hall-item">
                        <div class="hall-item-head" onclick="toggleHall('hall_${hall.hallName.replace(' ', '_')}')">
                            <h3>${hall.hallName} <span class="hall-meta">${hall.totalSeats} seats</span></h3>
                            <button type="button" class="btn-toggle-hall">Configure</button>
                        </div>
                        <div class="hall-item-body" id="hall_${hall.hallName.replace(' ', '_')}">
                            <form method="post" action="${pageContext.request.contextPath}/manageSettings">
                                <input type="hidden" name="action" value="saveHallConfig">
                                <input type="hidden" name="hallName" value="${hall.hallName}">

                                <div class="hall-note">
                                    Total seats = rows × columns. Currently: <strong>${hall.totalSeats} seats</strong>. Click a row letter to fill the whole row.
                                </div>

                                <div class="grid-controls">
                                    <button type="button" class="btn-grid-ctrl" onclick="addLayoutRow('${hall.hallName}')">+ Row</button>
                                    <button type="button" class="btn-grid-ctrl" onclick="removeLayoutRow('${hall.hallName}')">- Row</button>
                                    <button type="button" class="btn-grid-ctrl" onclick="addLayoutCol('${hall.hallName}')">+ Col</button>
                                    <button type="button" class="btn-grid-ctrl" onclick="removeLayoutCol('${hall.hallName}')">- Col</button>
                                </div>

                                <div class="grid-canvas-wrap">
                                    <input type="hidden" id="layoutMap_${hall.hallName.replace(' ', '_')}" name="layoutMap" value="${not empty hall.layoutMap ? hall.layoutMap : 'S S S S S S S S S S S S|S S S S S S S S S S S S|P P P P P P P P P P P P'}">
                                    <div id="grid_${hall.hallName.replace(' ', '_')}" class="layout-grid"></div>
                                </div>

                                <div class="hall-actions">
                                    <button type="submit" class="btn-save-hall">Save layout</button>
                                    <button type="button" class="btn-del-hall"
                                        onclick="if(confirm('Remove ${hall.hallName}? This cannot be undone.')) { document.getElementById('delForm_${hall.hallName.replace(' ', '_')}').submit(); }">
                                        Delete hall
                                    </button>
                                </div>
                            </form>
                            <form id="delForm_${hall.hallName.replace(' ', '_')}" method="post" action="${pageContext.request.contextPath}/manageSettings" style="display:none;">
                                <input type="hidden" name="action" value="deleteHall">
                                <input type="hidden" name="hallName" value="${hall.hallName}">
                            </form>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty hallConfigs}">
                    <p style="color:#aaa;font-size:13px;margin-bottom:12px;">No halls configured yet.</p>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/manageSettings" class="add-hall-row">
                    <input type="hidden" name="action" value="addHall">
                    <input type="text" name="newHallName" placeholder="New hall name e.g. Audi 04" required>
                    <button type="submit" class="btn-add-hall">+ Add hall</button>
                </form>
                <p style="font-size:11px;color:#aaa;margin-top:8px;">New halls start with a default 3-row standard layout.</p>
            </div>
        </div>

    </div>

    <script>
        function toggleHall(id) {
            var body = document.getElementById(id);
            if (body) body.classList.toggle('open');
        }

        let currentBrush = 'S';
        let isMouseDown = false;

        document.addEventListener('mousedown', () => isMouseDown = true);
        document.addEventListener('mouseup', () => isMouseDown = false);

        function setBrush(type) {
            currentBrush = type;
            document.querySelectorAll('.brush-btn').forEach(b => b.classList.remove('active'));
            document.getElementById('brush_' + type).classList.add('active');
        }

        function parseLayout(str) {
            if (!str) return [];
            return str.split('|').map(r => r.split(' '));
        }

        function stringifyLayout(rows) {
            return rows.map(r => r.join(' ')).join('|');
        }

        function paintSeat(hallId, rowIndex, colIndex, cellElement) {
            const input = document.getElementById('layoutMap_' + hallId);
            let rows = parseLayout(input.value);
            if (rows[rowIndex][colIndex] === currentBrush) return;
            rows[rowIndex][colIndex] = currentBrush;
            input.value = stringifyLayout(rows);
            if (cellElement) {
                cellElement.className = 'layout-cell cell-' + currentBrush;
                cellElement.innerText = currentBrush === '_' ? '' : currentBrush;
            } else {
                renderGrid(hallId);
            }
        }

        function addLayoutRow(rawHallName) {
            let hallId = rawHallName.replace(/ /g, '_');
            const input = document.getElementById('layoutMap_' + hallId);
            let rows = parseLayout(input.value);
            let cols = rows.length > 0 ? rows[0].length : 12;
            rows.push(Array(cols).fill('S'));
            input.value = stringifyLayout(rows);
            renderGrid(hallId);
        }

        function removeLayoutRow(rawHallName) {
            let hallId = rawHallName.replace(/ /g, '_');
            const input = document.getElementById('layoutMap_' + hallId);
            let rows = parseLayout(input.value);
            if (rows.length > 1) { rows.pop(); input.value = stringifyLayout(rows); renderGrid(hallId); }
            else alert('Cannot remove the last row.');
        }

        function addLayoutCol(rawHallName) {
            let hallId = rawHallName.replace(/ /g, '_');
            const input = document.getElementById('layoutMap_' + hallId);
            let rows = parseLayout(input.value);
            rows.forEach(r => r.push('S'));
            input.value = stringifyLayout(rows);
            renderGrid(hallId);
        }

        function removeLayoutCol(rawHallName) {
            let hallId = rawHallName.replace(/ /g, '_');
            const input = document.getElementById('layoutMap_' + hallId);
            let rows = parseLayout(input.value);
            if (rows[0] && rows[0].length > 1) { rows.forEach(r => r.pop()); input.value = stringifyLayout(rows); renderGrid(hallId); }
            else alert('Cannot remove the last column.');
        }

        function renderGrid(hallId) {
            const input = document.getElementById('layoutMap_' + hallId);
            const container = document.getElementById('grid_' + hallId);
            if (!input || !container) return;
            container.innerHTML = '';

            // Screen bar
            let screenDiv = document.createElement('div');
            screenDiv.style.cssText = 'width:100%;height:4px;background:#ccc;border-radius:2px;margin-bottom:16px;position:relative;';
            let screenLbl = document.createElement('span');
            screenLbl.innerText = 'SCREEN';
            screenLbl.style.cssText = 'position:absolute;top:8px;left:50%;transform:translateX(-50%);font-size:9px;font-weight:700;color:#bbb;letter-spacing:0.2em;';
            screenDiv.appendChild(screenLbl);
            container.appendChild(screenDiv);

            let rows = parseLayout(input.value);

            function fillRow(hallId, rIdx) {
                const inp = document.getElementById('layoutMap_' + hallId);
                let rs = parseLayout(inp.value);
                rs[rIdx] = rs[rIdx].map(() => currentBrush);
                inp.value = stringifyLayout(rs);
                renderGrid(hallId);
            }

            rows.forEach((row, rIdx) => {
                let rowDiv = document.createElement('div');
                rowDiv.className = 'layout-row';

                let rowLabel = document.createElement('div');
                rowLabel.className = 'row-label';
                rowLabel.innerText = String.fromCharCode(65 + rIdx);
                rowLabel.title = 'Fill row with ' + currentBrush;
                rowLabel.onclick = () => fillRow(hallId, rIdx);
                rowDiv.appendChild(rowLabel);

                row.forEach((cell, cIdx) => {
                    let cellDiv = document.createElement('div');
                    cellDiv.className = 'layout-cell cell-' + cell;
                    cellDiv.innerText = cell === '_' ? '' : cell;
                    cellDiv.onmousedown = (e) => { e.preventDefault(); paintSeat(hallId, rIdx, cIdx, cellDiv); };
                    cellDiv.onmouseenter = () => { if (isMouseDown) paintSeat(hallId, rIdx, cIdx, cellDiv); };
                    rowDiv.appendChild(cellDiv);
                });
                container.appendChild(rowDiv);
            });
        }

        document.addEventListener('DOMContentLoaded', () => {
            <c:forEach var="hall" items="${hallConfigs}">
            renderGrid('${hall.hallName.replace(' ', '_')}');
            </c:forEach>
        });
    </script>
</body>
</html>
