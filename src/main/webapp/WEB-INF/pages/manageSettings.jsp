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
                    <div class="type-item"><div class="type-dot dot-standard"></div> Standard (grey)</div>
                    <div class="type-item"><div class="type-dot dot-premium"></div> Premium (green)</div>
                    <div class="type-item"><div class="type-dot dot-recliner"></div> Recliner (orange)</div>
                    <div class="type-item"><div class="type-dot dot-vip"></div> VIP (purple)</div>
                </div>

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
                                    <div class="hall-form-grid">
                                        <div class="hall-form-group">
                                            <label for="spr_${hall.hallName}">Seats Per Row</label>
                                            <input type="number" id="spr_${hall.hallName}" name="seatsPerRow" value="${hall.seatsPerRow}" min="1" max="30" required>
                                            <p class="hall-form-help">Number of seats in each row (e.g. 12)</p>
                                        </div>
                                        <div class="hall-form-group">
                                            <label>Row Summary</label>
                                            <div style="padding: 9px 12px; background:#f9fbfd; border:1px solid #e0e0e0; border-radius:6px; font-size:12px; color:#555; line-height:1.8;">
                                                Standard: <strong>${not empty hall.standardRows ? hall.standardRows : 'none'}</strong><br>
                                                Premium: <strong>${not empty hall.premiumRows ? hall.premiumRows : 'none'}</strong><br>
                                                Recliner: <strong>${not empty hall.reclinerRows ? hall.reclinerRows : 'none'}</strong><br>
                                                VIP: <strong>${not empty hall.vipRows ? hall.vipRows : 'none'}</strong>
                                            </div>
                                        </div>
                                        <div class="hall-form-group">
                                            <label>Standard Rows</label>
                                            <input type="text" name="standardRows" value="${hall.standardRows}" placeholder="e.g. A,B,C,D">
                                            <p class="hall-form-help">Grey seats — regular pricing</p>
                                        </div>
                                        <div class="hall-form-group">
                                            <label>Premium Rows</label>
                                            <input type="text" name="premiumRows" value="${hall.premiumRows}" placeholder="e.g. E,F">
                                            <p class="hall-form-help">Green seats — premium view</p>
                                        </div>
                                        <div class="hall-form-group">
                                            <label>Recliner Rows</label>
                                            <input type="text" name="reclinerRows" value="${hall.reclinerRows}" placeholder="e.g. G (leave blank if none)">
                                            <p class="hall-form-help">Orange seats — reclining chairs</p>
                                        </div>
                                        <div class="hall-form-group">
                                            <label>VIP Rows</label>
                                            <input type="text" name="vipRows" value="${hall.vipRows}" placeholder="e.g. H (leave blank if none)">
                                            <p class="hall-form-help">Purple seats — premium foldable/couple</p>
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
    </script>
</body>
</html>
