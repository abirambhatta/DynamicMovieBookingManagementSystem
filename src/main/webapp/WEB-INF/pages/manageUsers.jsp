<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Users - MovieMint Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background: #f0f0f1; }

        .admin-wrap {
            max-width: 1160px;
            margin: 0 auto;
            padding: 24px 20px 40px;
        }

        .page-header {
            margin-bottom: 18px;
        }

        .page-header h1 {
            font-size: 20px;
            font-weight: 700;
            color: #111;
            margin-bottom: 2px;
        }

        .page-header p { font-size: 13px; color: #666; }

        .stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 12px;
            margin-bottom: 16px;
        }

        .stat-box {
            background: #fff;
            border: 1px solid #ddd;
            border-left: 3px solid #ccc;
            border-radius: 3px;
            padding: 14px 16px;
        }

        .stat-box.red { border-left-color: #c9152f; }
        .stat-box.blue { border-left-color: #3498db; }
        .stat-box.green { border-left-color: #218a3a; }

        .stat-box .label {
            font-size: 11px;
            font-weight: 600;
            color: #888;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            margin-bottom: 6px;
        }

        .stat-box .value {
            font-size: 24px;
            font-weight: 700;
            color: #111;
        }

        .stat-box .sub { font-size: 11px; color: #aaa; margin-top: 4px; }

        .filter-bar {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 3px;
            padding: 12px 14px;
            margin-bottom: 12px;
        }

        .filter-form {
            display: flex;
            gap: 8px;
            align-items: flex-end;
            flex-wrap: wrap;
        }

        .filter-form .fg { display: flex; flex-direction: column; gap: 3px; }

        .filter-form label {
            font-size: 11px;
            font-weight: 600;
            color: #777;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .filter-form input,
        .filter-form select {
            padding: 7px 10px;
            border: 1px solid #ccc;
            border-radius: 3px;
            font-size: 13px;
            background: #fff;
            font-family: inherit;
        }

        .filter-form input { min-width: 220px; }
        .filter-form input:focus, .filter-form select:focus { outline: none; border-color: #c9152f; }

        .msg-ok {
            background: #e2f5e8; color: #1a5c2b; border: 1px solid #b8e0c4;
            border-radius: 3px; padding: 9px 12px; font-size: 13px; margin-bottom: 12px;
        }

        .msg-err {
            background: #fde8ec; color: #8b1a25; border: 1px solid #f5c6cb;
            border-radius: 3px; padding: 9px 12px; font-size: 13px; margin-bottom: 12px;
        }

        .table-wrap {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 3px;
            overflow-x: auto;
        }

        table { width: 100%; border-collapse: collapse; min-width: 700px; }

        thead th {
            background: #f5f5f5;
            font-size: 11px;
            font-weight: 600;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            padding: 9px 14px;
            text-align: left;
            border-bottom: 1px solid #ddd;
            white-space: nowrap;
        }

        tbody td {
            padding: 9px 14px;
            font-size: 13px;
            color: #333;
            border-bottom: 1px solid #f0f0f0;
            vertical-align: middle;
        }

        tbody tr:last-child td { border-bottom: none; }
        tbody tr:hover td { background: #fafafa; }

        .user-init {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 26px; height: 26px;
            background: #f0f0f0;
            border-radius: 3px;
            font-size: 10px;
            font-weight: 700;
            color: #555;
            margin-right: 6px;
            flex-shrink: 0;
        }

        .role-badge {
            display: inline-block;
            padding: 2px 7px;
            border-radius: 2px;
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .role-admin { background: #fde8ec; color: #c9152f; border: 1px solid #f5c6cb; }
        .role-user { background: #f0f0f0; color: #666; border: 1px solid #ddd; }

        .status-dot {
            display: inline-block;
            width: 6px; height: 6px;
            border-radius: 50%;
            margin-right: 5px;
            vertical-align: middle;
        }

        .status-active { background: #218a3a; }
        .status-inactive { background: #bbb; }

        .empty-row td { text-align: center; padding: 28px; color: #aaa; font-size: 13px; }

        /* Modal */
        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.4);
            z-index: 50;
            align-items: center;
            justify-content: center;
        }

        .modal-overlay.open { display: flex; }

        .modal-box {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 100%;
            max-width: 440px;
            overflow: hidden;
        }

        .modal-head {
            padding: 14px 18px;
            border-bottom: 1px solid #eee;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .modal-head h3 { font-size: 15px; font-weight: 700; color: #111; }
        .modal-head button { background: none; border: none; font-size: 18px; color: #888; cursor: pointer; line-height: 1; }
        .modal-head button:hover { color: #333; }

        .modal-body { padding: 16px 18px; }

        .modal-row {
            display: flex;
            justify-content: space-between;
            align-items: baseline;
            padding: 7px 0;
            border-bottom: 1px solid #f0f0f0;
            font-size: 13px;
        }

        .modal-row:last-child { border-bottom: none; }
        .modal-row .key { color: #888; font-size: 11px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.3px; }
        .modal-row .val { color: #222; font-weight: 600; }

        .modal-foot {
            padding: 10px 18px;
            border-top: 1px solid #eee;
            text-align: right;
            background: #fafafa;
        }

        @media (max-width: 900px) {
            .stats-row { grid-template-columns: 1fr 1fr; }
        }
    </style>
</head>
<body>
    <c:if test="${empty user || user.role != 'admin'}">
        <c:redirect url="login"/>
    </c:if>

    <jsp:include page="adminHeader.jsp" />

    <div class="admin-wrap">
        <div class="page-header">
            <h1>Users</h1>
            <p>Manage registered accounts</p>
        </div>

        <div class="stats-row">
            <div class="stat-box red">
                <div class="label">Total users</div>
                <div class="value">${totalUsers}</div>
                <div class="sub">registered</div>
            </div>
            <div class="stat-box blue">
                <div class="label">Admins</div>
                <div class="value">${totalAdmins}</div>
                <div class="sub">system admins</div>
            </div>
            <div class="stat-box green">
                <div class="label">Active users</div>
                <div class="value">${activeUsers}</div>
                <div class="sub">with bookings</div>
            </div>
            <div class="stat-box">
                <div class="label">New this month</div>
                <div class="value">${newUsersThisMonth}</div>
                <div class="sub">registrations</div>
            </div>
        </div>

        <c:if test="${not empty param.success}">
            <div class="msg-ok">${param.success}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="msg-err">${param.error}</div>
        </c:if>

        <div class="filter-bar">
            <form action="${pageContext.request.contextPath}/manageUsers" method="get" class="filter-form">
                <div class="fg">
                    <label>Search</label>
                    <input type="text" name="search" value="${param.search}" placeholder="Name or email...">
                </div>
                <div class="fg">
                    <label>Role</label>
                    <select name="role">
                        <option value="all" ${empty param.role || param.role == 'all' ? 'selected' : ''}>All roles</option>
                        <option value="admin" ${param.role == 'admin' ? 'selected' : ''}>Admin only</option>
                        <option value="user" ${param.role == 'user' ? 'selected' : ''}>User only</option>
                    </select>
                </div>
                <div class="fg">
                    <label>Sort</label>
                    <select name="sort">
                        <option value="" ${empty param.sort ? 'selected' : ''}>Default</option>
                        <option value="name" ${param.sort == 'name' ? 'selected' : ''}>Name A–Z</option>
                        <option value="bookings" ${param.sort == 'bookings' ? 'selected' : ''}>Most bookings</option>
                    </select>
                </div>
                <button type="submit" class="btn-search" style="align-self:flex-end;">Search</button>
                <c:if test="${not empty param.search || not empty param.role || not empty param.sort}">
                    <a href="${pageContext.request.contextPath}/manageUsers" class="btn-sort" style="align-self:flex-end;text-decoration:none;padding:5px 11px;font-size:12px;">Clear</a>
                </c:if>
            </form>
        </div>

        <div class="table-wrap">
            <table data-paginate="true" data-rows-per-page="10">
                <thead>
                    <tr>
                        <th>User</th>
                        <th>Email / Phone</th>
                        <th>Joined</th>
                        <th>Bookings</th>
                        <th>Spent</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty users}">
                            <c:forEach var="u" items="${users}">
                                <tr>
                                    <td>
                                        <span class="user-init"><c:out value="${u.fullName.length() >= 2 ? u.fullName.substring(0,2).toUpperCase() : u.fullName.toUpperCase()}" /></span>
                                        <strong><c:out value="${u.fullName}" /></strong>
                                        <div style="font-size:11px;color:#aaa;margin-left:32px">ID: ${u.userId}</div>
                                    </td>
                                    <td>
                                        <div>${u.email}</div>
                                        <div style="font-size:12px;color:#888">${u.phone}</div>
                                    </td>
                                    <td style="white-space:nowrap;color:#666"><fmt:formatDate value="${u.registrationDate}" pattern="dd MMM yyyy"/></td>
                                    <td>${u.bookingCount}</td>
                                    <td>Rs. <fmt:formatNumber value="${u.totalSpent}" pattern="#,##0.00"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.role == 'admin'}"><span class="role-badge role-admin">Admin</span></c:when>
                                            <c:otherwise><span class="role-badge role-user">User</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.active}"><span class="status-dot status-active"></span>Active</c:when>
                                            <c:otherwise><span class="status-dot status-inactive"></span>Inactive</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="white-space:nowrap">
                                        <c:choose>
                                            <c:when test="${u.role != 'admin'}">
                                                <a href="${pageContext.request.contextPath}/manageUsers?action=changeRole&id=${u.userId}&role=admin"
                                                   onclick="return confirm('Promote ${u.fullName} to admin?')"
                                                   class="btn-success" style="text-decoration:none">Promote</a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/manageUsers?action=changeRole&id=${u.userId}&role=user"
                                                   onclick="return confirm('Demote ${u.fullName} to user?')"
                                                   class="btn-block" style="text-decoration:none">Demote</a>
                                            </c:otherwise>
                                        </c:choose>
                                        <button class="btn-view"
                                            onclick="showUser(${u.userId}, '${u.fullName.replace("'", "\\'")}', '${u.email}', '${u.phone}', '${u.role}', '<fmt:formatDate value="${u.registrationDate}" pattern="dd MMM yyyy"/>', ${u.bookingCount}, ${u.totalSpent})">
                                            View
                                        </button>
                                        <a href="${pageContext.request.contextPath}/manageUsers?action=delete&id=${u.userId}"
                                           onclick="return confirm('Delete ${u.fullName.replace("'", "\\'")}?')"
                                           class="btn-delete" style="text-decoration:none">Delete</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr class="empty-row"><td colspan="8">No users found</td></tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <!-- User detail modal -->
    <div class="modal-overlay" id="userModal">
        <div class="modal-box">
            <div class="modal-head">
                <h3>User details</h3>
                <button onclick="closeModal()">×</button>
            </div>
            <div class="modal-body">
                <div class="modal-row"><span class="key">ID</span><span class="val" id="m-id"></span></div>
                <div class="modal-row"><span class="key">Name</span><span class="val" id="m-name"></span></div>
                <div class="modal-row"><span class="key">Email</span><span class="val" id="m-email"></span></div>
                <div class="modal-row"><span class="key">Phone</span><span class="val" id="m-phone"></span></div>
                <div class="modal-row"><span class="key">Role</span><span class="val" id="m-role"></span></div>
                <div class="modal-row"><span class="key">Registered</span><span class="val" id="m-reg"></span></div>
                <div class="modal-row"><span class="key">Bookings</span><span class="val" id="m-bookings"></span></div>
                <div class="modal-row"><span class="key">Total spent</span><span class="val" id="m-spent"></span></div>
            </div>
            <div class="modal-foot">
                <button class="btn-search" onclick="closeModal()">Close</button>
            </div>
        </div>
    </div>

    <script>
        function showUser(id, name, email, phone, role, reg, bookings, spent) {
            document.getElementById('m-id').textContent = id;
            document.getElementById('m-name').textContent = name;
            document.getElementById('m-email').textContent = email;
            document.getElementById('m-phone').textContent = phone;
            document.getElementById('m-role').textContent = role;
            document.getElementById('m-reg').textContent = reg;
            document.getElementById('m-bookings').textContent = bookings;
            document.getElementById('m-spent').textContent = 'Rs. ' + parseFloat(spent).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,');
            document.getElementById('userModal').classList.add('open');
        }

        function closeModal() {
            document.getElementById('userModal').classList.remove('open');
        }

        document.getElementById('userModal').addEventListener('click', function(e) {
            if (e.target === this) closeModal();
        });
    </script>
    <script src="${pageContext.request.contextPath}/js/pagination.js"></script>
</body>
</html>
