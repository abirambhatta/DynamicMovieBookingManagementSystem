<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.Map, java.util.List" %>
<%@ page import="com.moviebooking.model.HallConfig" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Settings | MovieMint Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .settings-container { max-width: 980px; margin: 40px auto; padding: 0 20px; }
        .page-title { font-size: 1.8rem; font-weight: 800; color: #141d23; margin: 0 0 4px; }
        .page-subtitle { color: #5d5f5f; margin: 0 0 32px; font-size: 0.9rem; }

        .settings-section { background: #fff; border-radius: 10px; box-shadow: 0 2px 12px rgba(0,0,0,0.07); margin-bottom: 28px; overflow: hidden; }
        .section-header { background: #dc143c; color: white; padding: 16px 24px; }
        .section-header h2 { margin: 0; font-size: 1rem; font-weight: 800; letter-spacing: 0.06em; text-transform: uppercase; }
        .section-body { padding: 24px; }

        .info-box { background: #fff8f0; border-left: 4px solid #f39c12; border-radius: 0 8px 8px 0; padding: 12px 16px; margin-bottom: 20px; font-size: 0.85rem; color: #555; line-height: 1.6; }
        .info-box strong { color: #141d23; }

        /* Pricing grid */
        .price-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 16px; margin-bottom: 20px; }
        .price-card { border: 1px solid #e6bdbc; border-radius: 8px; padding: 16px; }
        .price-card label { display: block; font-size: 0.7rem; font-weight: 800; text-transform: uppercase; letter-spacing: 0.12em; color: #5c3f3f; margin-bottom: 8px; }
        .price-badge { display: inline-block; font-size: 0.65rem; font-weight: 700; padding: 2px 8px; border-radius: 20px; margin-bottom: 8px; text-transform: uppercase; }
        .badge-standard { background: #e8f4f8; color: #2980b9; }
        .badge-premium  { background: #f0f9eb; color: #27ae60; }
        .badge-recliner { background: #fef9e7; color: #f39c12; }
        .badge-vip      { background: #fdf2f8; color: #8e44ad; }
        .price-input-wrap { position: relative; }
        .price-prefix { position: absolute; left: 10px; top: 50%; transform: translateY(-50%); font-weight: 700; color: #5c3f3f; pointer-events: none; font-size: 0.85rem; }
        .price-input { width: 100%; padding: 9px 10px 9px 40px; border: 1px solid #e0e0e0; border-radius: 6px; font-size: 1.05rem; font-weight: 700; color: #141d23; }
        .price-input:focus { outline: none; border-color: #dc143c; }

        /* Hall list */
        .halls-list { display: flex; flex-direction: column; gap: 12px; margin-bottom: 20px; }
        .hall-card { border: 1px solid #e8edf2; border-radius: 10px; overflow: hidden; }
        .hall-card-header { background: #f9fbfd; padding: 14px 20px; display: flex; justify-content: space-between; align-items: center; cursor: pointer; }
        .hall-card-header h3 { margin: 0; font-size: 0.95rem; font-weight: 800; color: #141d23; }
        .hall-toggle-btn { background: none; border: 1px solid #e0e0e0; border-radius: 6px; padding: 4px 12px; font-size: 0.75rem; font-weight: 700; cursor: pointer; color: #555; }
        .hall-card-body { display: none; padding: 20px; border-top: 1px solid #e8edf2; }
        .hall-card-body.open { display: block; }

        .hall-form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 16px; }
        .hall-form-group label { display: block; font-size: 0.7rem; font-weight: 800; text-transform: uppercase; letter-spacing: 0.1em; color: #5c3f3f; margin-bottom: 6px; }
        .hall-form-group input { width: 100%; padding: 9px 12px; border: 1px solid #e0e0e0; border-radius: 6px; font-size: 0.9rem; }
        .hall-form-group input:focus { outline: none; border-color: #dc143c; }
        .hall-form-help { font-size: 11px; color: #888; margin-top: 4px; }
        .seat-info { background: #f9fbfd; border-radius: 6px; padding: 10px 14px; font-size: 12px; color: #555; margin-bottom: 14px; }
        .seat-info strong { color: #dc143c; }

        .hall-actions { display: flex; gap: 10px; flex-wrap: wrap; align-items: center; }
        .btn-save-hall { background: #dc143c; color: white; border: none; border-radius: 6px; padding: 9px 20px; font-weight: 700; font-size: 0.85rem; cursor: pointer; }
        .btn-save-hall:hover { background: #b71c1c; }
        .btn-delete-hall { background: white; border: 1px solid #dc3545; color: #dc3545; border-radius: 6px; padding: 9px 20px; font-weight: 700; font-size: 0.85rem; cursor: pointer; }
        .btn-delete-hall:hover { background: #dc3545; color: white; }
        .total-seats-label { font-size: 12px; color: #888; margin-left: auto; }

        /* Grid Builder */
        .layout-grid { display: inline-flex; flex-direction: column; gap: 4px; overflow-x: auto; padding: 10px 0; }
        .layout-row { display: flex; gap: 4px; }
        .layout-cell { width: 30px; height: 30px; border-radius: 6px; cursor: pointer; display: flex; align-items: center; justify-content: center; font-size: 11px; font-weight: bold; color: #fff; user-select: none; border: 1px solid #ccc; transition: all 0.2s; }
        .layout-cell:hover { transform: scale(1.1); box-shadow: 0 2px 5px rgba(0,0,0,0.2); }
        .cell-S { background: #e0e0e0; color: #555; }
        .cell-P { background: #c8e6c9; color: #2e7d32; border-color: #a5d6a7; }
        .cell-R { background: #ffe0b2; color: #e65100; border-color: #ffcc80; }
        .cell-V { background: #e1bee7; color: #6a1b9a; border-color: #ce93d8; }
        .cell-_ { background: transparent; border: 1px dashed #ccc; }
        .btn-grid-control { background: #f9fbfd; border: 1px solid #e0e0e0; border-radius: 4px; padding: 5px 10px; font-size: 11px; font-weight: bold; cursor: pointer; margin-right: 6px; color: #555; }
        .btn-grid-control:hover { background: #e8edf2; color: #141d23; }

        /* Add Hall form */
        .add-hall-form { display: flex; gap: 10px; flex-wrap: wrap; margin-top: 16px; padding-top: 16px; border-top: 1px dashed #e0e0e0; }
        .add-hall-input { flex: 1; min-width: 200px; padding: 10px 14px; border: 1px solid #e0e0e0; border-radius: 6px; font-size: 0.9rem; }
        .add-hall-input:focus { outline: none; border-color: #dc143c; }
        .btn-add-hall { background: #28a745; color: white; border: none; border-radius: 6px; padding: 10px 20px; font-weight: 700; font-size: 0.85rem; cursor: pointer; white-space: nowrap; }
        .btn-add-hall:hover { background: #218838; }

        /* Seat type key */
        .seat-type-key { display: flex; gap: 20px; flex-wrap: wrap; margin-bottom: 20px; }
        .type-item { display: flex; align-items: center; gap: 8px; font-size: 12px; font-weight: 700; color: #555; }
        .type-dot { width: 18px; height: 18px; border-radius: 4px; }
        .dot-standard { background: #e0e0e0; }
        .dot-premium  { background: #c8e6c9; }
        .dot-recliner { background: #ffe0b2; }
        .dot-vip      { background: #e1bee7; }

        /* Overall save button */
        .btn-save { background: #dc143c; color: white; border: none; border-radius: 8px; padding: 11px 28px; font-weight: 700; font-size: 0.9rem; cursor: pointer; }
        .btn-save:hover { background: #b71c1c; }

        .success-message { background: #d4edda; color: #155724; border-radius: 6px; padding: 12px 16px; margin-bottom: 20px; font-weight: 700; font-size: 0.88rem; }
        .error-message   { background: #f8d7da; color: #721c24; border-radius: 6px; padding: 12px 16px; margin-bottom: 20px; font-weight: 700; font-size: 0.88rem; }
    </style>
</head>
<body>
    <%@ include file="adminHeader.jsp" %>

    <div class="settings-container">
        <h1 class="page-title">System Settings</h1>
        <p class="page-subtitle">Configure ticket pricing, hall layouts, and seat categories for your cinema.</p>

        <c:if test="${not empty param.success}">
            <div class="success-message">${param.success}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="error-message">${param.error}</div>
        </c:if>

        <%
            Map<String, String> settings = (Map<String, String>) request.getAttribute("settings");
            String priceStandard = settings != null ? settings.getOrDefault("PRICE_STANDARD", "200.0") : "200.0";
            String pricePremium  = settings != null ? settings.getOrDefault("PRICE_PREMIUM",  "350.0") : "350.0";
            String priceRecliner = settings != null ? settings.getOrDefault("PRICE_RECLINER", "500.0") : "500.0";
            String priceVip      = settings != null ? settings.getOrDefault("PRICE_VIP",      "750.0") : "750.0";
        %>

        <%-- ===== 1. TICKET PRICING ===== --%>
        <div class="settings-section">
            <div class="section-header"><h2>Ticket Pricing</h2></div>
            <div class="section-body">
                <div class="info-box">
                    <strong>How it works:</strong> Set the base price for each seat type. Changes apply immediately to all new bookings.
                </div>
                <form method="post" action="${pageContext.request.contextPath}/manageSettings">
                    <input type="hidden" name="action" value="updatePrices">
                    <div class="price-grid">
                        <div class="price-card">
                            <span class="price-badge badge-standard">Standard</span>
                            <label for="ps">Standard Seat (Rs.)</label>
                            <div class="price-input-wrap">
                                <span class="price-prefix">Rs.</span>
                                <input type="number" id="ps" name="PRICE_STANDARD" class="price-input" value="<%= priceStandard %>" min="1" step="0.5" required>
                            </div>
                        </div>
                        <div class="price-card">
                            <span class="price-badge badge-premium">Premium</span>
                            <label for="pp">Premium Seat (Rs.)</label>
                            <div class="price-input-wrap">
                                <span class="price-prefix">Rs.</span>
                                <input type="number" id="pp" name="PRICE_PREMIUM" class="price-input" value="<%= pricePremium %>" min="1" step="0.5" required>
                            </div>
                        </div>
                        <div class="price-card">
                            <span class="price-badge badge-recliner">Recliner</span>
                            <label for="pr">Recliner Seat (Rs.)</label>
                            <div class="price-input-wrap">
                                <span class="price-prefix">Rs.</span>
                                <input type="number" id="pr" name="PRICE_RECLINER" class="price-input" value="<%= priceRecliner %>" min="1" step="0.5" required>
                            </div>
                        </div>
                        <div class="price-card">
                            <span class="price-badge badge-vip">VIP</span>
                            <label for="pv">VIP / Couple Seat (Rs.)</label>
                            <div class="price-input-wrap">
                                <span class="price-prefix">Rs.</span>
                                <input type="number" id="pv" name="PRICE_VIP" class="price-input" value="<%= priceVip %>" min="1" step="0.5" required>
                            </div>
                        </div>
                    </div>
                    <button type="submit" class="btn-save">Save Prices</button>
                </form>
            </div>
        </div>

        <%-- ===== 2. HALL MANAGEMENT ===== --%>
        <div class="settings-section">
            <div class="section-header"><h2>Hall Management &amp; Seat Layouts</h2></div>
            <div class="section-body">
                <div class="info-box">
                    <strong>How it works:</strong> Each hall has its own seat layout. Define how many seats per row and which row letters belong to which seat type (Standard, Premium, Recliner, VIP). Row letters are comma-separated (e.g. A,B,C). The booking page will automatically reflect your changes.
                </div>
                <div class="seat-type-key">
                    <div class="type-item"><div class="type-dot dot-standard"></div> Standard (S)</div>
                    <div class="type-item"><div class="type-dot dot-premium"></div> Premium (P)</div>
                    <div class="type-item"><div class="type-dot dot-recliner"></div> Recliner (R)</div>
                    <div class="type-item"><div class="type-dot dot-vip"></div> VIP (V)</div>
                    <div class="type-item"><div class="type-dot dot-empty"></div> Aisle (_)</div>
                </div>

                <div class="brush-palette" style="margin-bottom: 20px; padding: 15px; background: #fff; border: 1px solid #e0e0e0; border-radius: 8px; display: flex; align-items: center; gap: 15px;">
                    <span style="font-size: 13px; font-weight: 700; color: #555;">SELECTED BRUSH:</span>
                    <div id="brush_S" class="brush-tool active" onclick="setBrush('S')"><div class="type-dot dot-standard"></div>Standard (S)</div>
                    <div id="brush_P" class="brush-tool" onclick="setBrush('P')"><div class="type-dot dot-premium"></div>Premium (P)</div>
                    <div id="brush_R" class="brush-tool" onclick="setBrush('R')"><div class="type-dot dot-recliner"></div>Recliner (R)</div>
                    <div id="brush_V" class="brush-tool" onclick="setBrush('V')"><div class="type-dot dot-vip"></div>VIP (V)</div>
                    <div id="brush__" class="brush-tool" onclick="setBrush('_')"><div class="type-dot dot-empty"></div>Aisle (_)</div>
                    <div style="margin-left: auto; font-size: 11px; color: #888;">Tip: Click or Drag to paint seats</div>
                </div>

                <style>
                    .row-label:hover { background: #f0f0f0; color: #dc143c !important; }
                    .brush-tool {
                        display: flex; align-items: center; gap: 8px; padding: 6px 12px; border: 1px solid #ddd; border-radius: 6px; cursor: pointer; font-size: 12px; font-weight: 600; transition: all 0.2s;
                    }
                    .brush-tool:hover { background: #f8f9fa; border-color: #ccc; }
                    .brush-tool.active { background: #e8f0fe; border-color: #0d6efd; color: #0d6efd; box-shadow: 0 2px 4px rgba(13,110,253,0.1); }
                    .type-dot.dot-empty { background: #fff; border: 1px dashed #ccc; }
                </style>

                <div class="halls-list">
                    <c:forEach var="hall" items="${hallConfigs}">
                        <div class="hall-card">
                            <div class="hall-card-header" onclick="toggleHall('hall_${hall.hallName.replace(' ', '_')}')">
                                <h3>${hall.hallName}</h3>
                                <div style="display:flex; align-items:center; gap: 12px;">
                                    <span style="font-size:12px; color:#888;">${hall.totalSeats} seats total</span>
                                    <button type="button" class="hall-toggle-btn">Configure</button>
                                </div>
                            </div>
                            <div class="hall-card-body" id="hall_${hall.hallName.replace(' ', '_')}">
                                <form method="post" action="${pageContext.request.contextPath}/manageSettings">
                                    <input type="hidden" name="action" value="saveHallConfig">
                                    <input type="hidden" name="hallName" value="${hall.hallName}">
                                    <div class="seat-info">
                                        Total seats = (standard rows + premium rows + recliner rows + vip rows) x seats per row.
                                        Currently: <strong>${hall.totalSeats} seats</strong>
                                    </div>
                                    <div class="hall-layout-builder" style="margin-bottom: 20px;">
                                        <label style="display:block; font-size: 0.75rem; font-weight: 800; text-transform: uppercase; letter-spacing: 0.1em; color: #5c3f3f; margin-bottom: 6px;">Visual Seat Map Designer</label>
                                        <p class="hall-form-help" style="margin-bottom: 12px;">Click on a seat cell to cycle through its type (Standard -> Premium -> Recliner -> VIP -> Empty Space).</p>
                                        
                                        <div style="margin-bottom: 12px; padding: 10px; background: #f9fbfd; border-radius: 6px; border: 1px solid #e8edf2; display: inline-block;">
                                            <button type="button" class="btn-grid-control" onclick="addLayoutRow('${hall.hallName}')">+ Add Row</button>
                                            <button type="button" class="btn-grid-control" onclick="removeLayoutRow('${hall.hallName}')">- Remove Row</button>
                                            <button type="button" class="btn-grid-control" onclick="addLayoutCol('${hall.hallName}')">+ Add Col</button>
                                            <button type="button" class="btn-grid-control" onclick="removeLayoutCol('${hall.hallName}')">- Remove Col</button>
                                        </div>

                                        <div style="overflow-x: auto; max-width: 100%; border: 1px solid #e0e0e0; border-radius: 8px; padding: 10px; background: #fff;">
                                            <input type="hidden" id="layoutMap_${hall.hallName.replace(' ', '_')}" name="layoutMap" value="${not empty hall.layoutMap ? hall.layoutMap : 'S S S S S S S S S S S S|S S S S S S S S S S S S|P P P P P P P P P P P P'}">
                                            <div id="grid_${hall.hallName.replace(' ', '_')}" class="layout-grid"></div>
                                        </div>
                                    </div>
                                    <div class="hall-actions">
                                        <button type="submit" class="btn-save-hall">Save Layout</button>
                                        <button type="button" class="btn-delete-hall"
                                            onclick="if(confirm('Remove hall ${hall.hallName}? This will also remove it from all future schedules.')) { document.getElementById('delForm_${hall.hallName.replace(' ', '_')}').submit(); }">
                                            Delete Hall
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
                        <p style="color:#888; font-size:0.9rem;">No halls configured yet. Add one below.</p>
                    </c:if>
                </div>

                <%-- Add new hall --%>
                <form method="post" action="${pageContext.request.contextPath}/manageSettings" class="add-hall-form">
                    <input type="hidden" name="action" value="addHall">
                    <input type="text" name="newHallName" class="add-hall-input" placeholder="New hall name e.g. Audi 04" required>
                    <button type="submit" class="btn-add-hall">+ Add New Hall</button>
                </form>
                <p style="font-size:11px; color:#888; margin-top: 8px;">
                    A new hall is added with a default 3-row standard layout (A,B,C) and 1 VIP row (E), 12 seats per row. You can edit it above.
                </p>
            </div>
        </div>

    </div>

    <script>
        function toggleHall(id) {
            var body = document.getElementById(id);
            if (body) body.classList.toggle('open');
        }

        // --- Hall Layout Grid Builder Logic ---
        
        // currentBrush keeps track of which seat type we are currently "painting" with.
        // S = Standard, P = Premium, R = Recliner, V = VIP, _ = Empty Aisle
        let currentBrush = 'S'; 
        
        // isMouseDown helps us know when the user is dragging their mouse to paint multiple seats.
        let isMouseDown = false;

        function parseLayout(str) {
            if(!str) return [];
            return str.split('|').map(r => r.split(' '));
        }

        function stringifyLayout(rows) {
            return rows.map(r => r.join(' ')).join('|');
        }

        // Track mouse clicks for the "drag-to-paint" feature
        document.addEventListener('mousedown', () => isMouseDown = true);
        document.addEventListener('mouseup', () => isMouseDown = false);

        // This function runs when you click a seat type button in the palette.
        function setBrush(type) {
            currentBrush = type;
            // Highlight the selected button and remove highlight from others
            document.querySelectorAll('.brush-tool').forEach(b => b.classList.remove('active'));
            document.getElementById('brush_' + type).classList.add('active');
        }

        // This is the core function that changes a seat's type.
        // It updates the hidden text input (layoutMap) and the visual grid.
        function paintSeat(hallId, rowIndex, colIndex, cellElement) {
            const input = document.getElementById('layoutMap_' + hallId);
            let rows = parseLayout(input.value);
            if (rows[rowIndex][colIndex] === currentBrush) return;
            
            rows[rowIndex][colIndex] = currentBrush;
            input.value = stringifyLayout(rows);
            
            // Optimization: Update the cell element directly instead of re-rendering everything
            if (cellElement) {
                cellElement.className = 'layout-cell cell-' + currentBrush;
                cellElement.innerText = currentBrush === '_' ? '' : currentBrush;
                cellElement.title = "Click or drag to paint " + currentBrush;
            } else {
                renderGrid(hallId);
            }
        }

        function cycleSeatType(hallId, rowIndex, colIndex) {
            // Legacy click function - now just uses paintSeat with current brush
            paintSeat(hallId, rowIndex, colIndex);
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
            if(rows.length > 1) {
                rows.pop();
                input.value = stringifyLayout(rows);
                renderGrid(hallId);
            } else {
                alert("Cannot remove the last row.");
            }
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
            if(rows[0] && rows[0].length > 1) {
                rows.forEach(r => r.pop());
                input.value = stringifyLayout(rows);
                renderGrid(hallId);
            } else {
                alert("Cannot remove the last column.");
            }
        }

        function renderGrid(hallId) {
            const input = document.getElementById('layoutMap_' + hallId);
            const container = document.getElementById('grid_' + hallId);
            if(!input || !container) return;
            container.innerHTML = '';
            
            let rows = parseLayout(input.value);
            
            // Render screen indicator
            let screenDiv = document.createElement('div');
            screenDiv.style.cssText = "width: 100%; height: 6px; background: #ccc; border-radius: 4px; margin-bottom: 20px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); position: relative;";
            let screenLabel = document.createElement('span');
            screenLabel.innerText = "SCREEN";
            screenLabel.style.cssText = "position: absolute; top: 10px; left: 50%; transform: translateX(-50%); font-size: 10px; font-weight: bold; color: #888; letter-spacing: 0.2em;";
            screenDiv.appendChild(screenLabel);
            container.appendChild(screenDiv);
            
            // Helper function to fill an entire row with the current brush
            function fillRow(hallId, rIdx) {
                const input = document.getElementById('layoutMap_' + hallId);
                let rows = parseLayout(input.value);
                // Map every seat in this row to the selected type
                rows[rIdx] = rows[rIdx].map(() => currentBrush);
                input.value = stringifyLayout(rows);
                renderGrid(hallId);
            }

            rows.forEach((row, rIdx) => {
                let rowDiv = document.createElement('div');
                rowDiv.className = 'layout-row';
                
                // Row letter indicator (Click to fill row)
                let rowLabel = document.createElement('div');
                rowLabel.className = 'row-label';
                rowLabel.style.cssText = "width: 25px; display: flex; align-items: center; justify-content: center; font-size: 11px; font-weight: bold; color: #888; cursor: pointer; border-radius: 4px; margin-right: 5px;";
                rowLabel.innerText = String.fromCharCode(65 + rIdx);
                rowLabel.title = "Click to fill entire row with " + currentBrush;
                rowLabel.onclick = () => fillRow(hallId, rIdx);
                rowDiv.appendChild(rowLabel);

                row.forEach((cell, cIdx) => {
                    let cellDiv = document.createElement('div');
                    cellDiv.className = 'layout-cell cell-' + cell;
                    cellDiv.innerText = cell === '_' ? '' : cell;
                    
                    cellDiv.onmousedown = (e) => {
                        e.preventDefault();
                        paintSeat(hallId, rIdx, cIdx, cellDiv);
                    };
                    cellDiv.onmouseenter = () => {
                        if (isMouseDown) paintSeat(hallId, rIdx, cIdx, cellDiv);
                    };
                    
                    cellDiv.title = "Click or drag to paint " + currentBrush;
                    rowDiv.appendChild(cellDiv);
                });
                container.appendChild(rowDiv);
            });
        }

        // Initialize all grids on page load
        document.addEventListener('DOMContentLoaded', () => {
            <c:forEach var="hall" items="${hallConfigs}">
            renderGrid('${hall.hallName.replace(' ', '_')}');
            </c:forEach>
        });
    </script>
</body>
</html>
