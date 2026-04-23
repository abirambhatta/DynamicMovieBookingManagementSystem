<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Manage Users | CinemaDirector Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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
        .headlines\:font-\['Manrope'\] { font-family: 'Manrope', sans-serif; }
    </style>
</head>
<body style="background-color: #f8f9fa; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; color: #212529;">
    <c:if test="${empty user || user.role != 'admin'}">
        <c:redirect url="login"/>
    </c:if>

    <jsp:include page="adminHeader.jsp" />

    <div class="main-content">
    <main class="min-h-screen p-8">
        <div class="flex justify-between items-end mb-10">
            <div>
                <h1 class="text-3xl font-bold tracking-tight" style="color: #212529;">User Directory</h1>
                <p class="mt-1" style="color: #6c757d;">Manage administrators, staff, and customers.</p>
            </div>
        </div>

        <!-- Stats Bento Grid -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-10">
            <div class="p-6 rounded-xl" style="background-color: white; border: 1px solid #e9ecef; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">
                <p class="text-xs font-bold uppercase tracking-widest mb-2" style="color: #6c757d;">Total Users</p>
                <h3 class="text-4xl font-bold leading-none" style="color: #212529;">${totalUsers}</h3>
                <div class="mt-4 flex items-center text-xs font-bold" style="color: #dc143c;">
                    <span class="material-symbols-outlined text-sm mr-1">group</span>
                    Registered members
                </div>
            </div>
            <div class="p-6 rounded-xl" style="background-color: white; border: 1px solid #e9ecef; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">
                <p class="text-xs font-bold uppercase tracking-widest mb-2" style="color: #6c757d;">Admins</p>
                <h3 class="text-4xl font-bold leading-none" style="color: #212529;">${totalAdmins}</h3>
                <div class="mt-4 flex items-center text-xs font-bold" style="color: #6c757d;">
                    <span class="material-symbols-outlined text-sm mr-1">admin_panel_settings</span>
                    System administrators
                </div>
            </div>
            <div class="p-6 rounded-xl" style="background-color: white; border: 1px solid #e9ecef; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">
                <p class="text-xs font-bold uppercase tracking-widest mb-2" style="color: #6c757d;">Active Users</p>
                <h3 class="text-4xl font-bold leading-none" style="color: #212529;">${activeUsers}</h3>
                <div class="mt-4 flex items-center text-xs font-bold" style="color: #28a745;">
                    <span class="material-symbols-outlined text-sm mr-1">check_circle</span>
                    With recent bookings
                </div>
            </div>
            <div class="p-6 rounded-xl flex flex-col justify-between" style="background-color: #dc143c; color: white;">
                <div>
                    <p class="text-xs font-bold uppercase tracking-widest mb-2" style="opacity: 0.9;">New Registrations</p>
                    <h3 class="text-4xl font-bold leading-none">${newUsersThisMonth}</h3>
                </div>
                <div class="mt-4 text-xs font-bold flex items-center" style="opacity: 0.9;">
                    <span class="material-symbols-outlined text-sm mr-1">trending_up</span> This month
                </div>
            </div>
        </div>

        <c:if test="${not empty param.success}">
            <div class="p-4 rounded-lg mb-6 font-semibold" style="background-color: #d4edda; color: #155724; border-left: 4px solid #28a745;">
                ${param.success}
            </div>
        </c:if>
        
        <c:if test="${not empty param.error}">
            <div class="p-4 rounded-lg mb-6 font-semibold" style="background-color: #f8d7da; color: #721c24; border-left: 4px solid #dc3545;">
                ${param.error}
            </div>
        </c:if>

        <!-- Search and Filters -->
        <div class="p-6 rounded-xl mb-6" style="background-color: white; border: 1px solid #e9ecef; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">
            <form action="${pageContext.request.contextPath}/manageUsers" method="get" class="flex flex-col md:flex-row gap-4 items-end">
                <div class="flex-1 w-full relative">
                    <label class="text-[10px] font-bold uppercase tracking-widest mb-1 block" style="color: #6c757d;">Search Users</label>
                    <div class="relative">
                        <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-lg" style="color: #6c757d;">search</span>
                        <input type="text" name="search" placeholder="Search by name or email..." value="${param.search}" class="w-full pl-10 pr-4 py-3 rounded-lg text-sm" style="background-color: white; border: 1px solid #ced4da;" onfocus="this.style.borderColor='#dc143c'; this.style.boxShadow='0 0 0 3px rgba(220, 20, 60, 0.1)';" onblur="this.style.borderColor='#ced4da'; this.style.boxShadow='none';">
                    </div>
                </div>
                
                <div class="w-full md:w-auto">
                    <label class="text-[10px] font-bold uppercase tracking-widest mb-1 block" style="color: #6c757d;">Role Filter</label>
                    <select name="role" class="w-full py-3 px-4 pr-8 rounded-lg text-sm cursor-pointer" style="background-color: white; border: 1px solid #ced4da;">
                        <option value="all" ${param.role == 'all' || empty param.role ? 'selected' : ''}>All Roles</option>
                        <option value="admin" ${param.role == 'admin' ? 'selected' : ''}>Admin Only</option>
                        <option value="user" ${param.role == 'user' ? 'selected' : ''}>User Only</option>
                    </select>
                </div>

                <div class="w-full md:w-auto">
                    <label class="text-[10px] font-bold uppercase tracking-widest mb-1 block" style="color: #6c757d;">Sort By</label>
                    <select name="sort" class="w-full py-3 px-4 pr-8 rounded-lg text-sm cursor-pointer" style="background-color: white; border: 1px solid #ced4da;">
                        <option value="" ${empty param.sort ? 'selected' : ''}>Default</option>
                        <option value="name" ${param.sort == 'name' ? 'selected' : ''}>Name (A-Z)</option>
                        <option value="bookings" ${param.sort == 'bookings' ? 'selected' : ''}>Most Bookings</option>
                    </select>
                </div>

                <div class="flex gap-2 w-full md:w-auto mt-4 md:mt-0">
                    <button type="submit" class="px-6 py-3 rounded-lg text-[11px] font-bold uppercase tracking-widest w-full md:w-auto" style="background-color: #dc143c; color: white;" onmouseover="this.style.backgroundColor='#b71c1c';" onmouseout="this.style.backgroundColor='#dc143c';">Search</button>
                    <c:if test="${not empty param.search || not empty param.role || not empty param.sort}">
                        <a href="${pageContext.request.contextPath}/manageUsers" class="px-6 py-3 rounded-lg text-[11px] font-bold uppercase tracking-widest flex items-center justify-center w-full md:w-auto" style="background-color: #f8f9fa; color: #212529; border: 1px solid #ced4da;">Clear</a>
                    </c:if>
                </div>
            </form>
        </div>

        <!-- User Table Section -->
        <div class="rounded-xl overflow-hidden" style="background-color: white; border: 1px solid #e9ecef; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse min-w-[800px]">
                    <thead>
                        <tr style="background-color: #dc143c; color: white;">
                            <th class="px-6 py-4 text-[11px] font-bold uppercase tracking-[0.1em]">User Identity</th>
                            <th class="px-6 py-4 text-[11px] font-bold uppercase tracking-[0.1em]">Contact & Date</th>
                            <th class="px-6 py-4 text-[11px] font-bold uppercase tracking-[0.1em]">Activity</th>
                            <th class="px-6 py-4 text-[11px] font-bold uppercase tracking-[0.1em]">Status & Role</th>
                            <th class="px-6 py-4 text-[11px] font-bold uppercase tracking-[0.1em] text-right">Actions</th>
                        </tr>
                    </thead>
                    <tbody style="border-top: 1px solid #e9ecef;">
                        <c:choose>
                            <c:when test="${not empty users}">
                                <c:forEach var="u" items="${users}">
                                    <tr style="border-bottom: 1px solid #e9ecef;" onmouseover="this.style.backgroundColor='#f8f9fa';" onmouseout="this.style.backgroundColor='white';">
                                        <td class="px-6 py-4">
                                            <div class="flex items-center gap-4">
                                                <div class="w-10 h-10 rounded-md flex items-center justify-center font-bold shrink-0" style="background-color: rgba(220, 20, 60, 0.1); color: #dc143c;">
                                                    <c:choose>
                                                        <c:when test="${u.fullName.length() >= 2}">
                                                            ${u.fullName.substring(0, 2).toUpperCase()}
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${u.fullName.toUpperCase()}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="min-w-0">
                                                    <p class="font-bold truncate" style="color: #212529;">${u.fullName}</p>
                                                    <p class="text-xs truncate" style="color: #6c757d;">ID: ${u.userId}</p>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4">
                                            <p class="text-sm font-medium truncate" style="color: #212529;">${u.email}</p>
                                            <p class="text-xs mt-0.5" style="color: #6c757d;">${u.phone}</p>
                                            <p class="text-[10px] mt-1 uppercase tracking-wider" style="color: #6c757d;">Joined: <fmt:formatDate value="${u.registrationDate}" pattern="MMM dd, yyyy"/></p>
                                        </td>
                                        <td class="px-6 py-4">
                                            <p class="text-sm font-bold" style="color: #212529;">${u.bookingCount} Bookings</p>
                                            <p class="text-xs mt-0.5 font-medium" style="color: #6c757d;">Rs. <fmt:formatNumber value="${u.totalSpent}" pattern="#,##0.00"/></p>
                                        </td>
                                        <td class="px-6 py-4">
                                            <div class="flex flex-col gap-2 items-start">
                                                <c:choose>
                                                    <c:when test="${u.role == 'admin'}">
                                                        <span class="px-2.5 py-1 rounded text-[10px] font-bold uppercase tracking-wider" style="background-color: rgba(220, 20, 60, 0.1); color: #dc143c; border: 1px solid rgba(220, 20, 60, 0.2);">Admin</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="px-2.5 py-1 rounded text-[10px] font-bold uppercase tracking-wider" style="background-color: #f8f9fa; color: #6c757d; border: 1px solid #e9ecef;">User</span>
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:choose>
                                                    <c:when test="${u.active}">
                                                        <div class="flex items-center gap-1.5 font-bold text-[10px] uppercase tracking-wider" style="color: #28a745;">
                                                            <span class="w-1.5 h-1.5 rounded-full" style="background-color: #28a745;"></span> Active
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="flex items-center gap-1.5 font-bold text-[10px] uppercase tracking-wider" style="color: #6c757d;">
                                                            <span class="w-1.5 h-1.5 rounded-full" style="background-color: #6c757d;"></span> Inactive
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 text-right">
                                            <div class="flex justify-end gap-2">
                                                <div class="relative inline-block text-left group/dropdown">
                                                    <button class="p-2 rounded-md flex items-center justify-center" style="background-color: white; color: #6c757d; border: 1px solid #ced4da;" onmouseover="this.style.borderColor='#dc143c'; this.style.color='#dc143c';" onmouseout="this.style.borderColor='#ced4da'; this.style.color='#6c757d';">
                                                        <span class="material-symbols-outlined text-[18px]">manage_accounts</span>
                                                    </button>
                                                    <div class="absolute right-0 bottom-full mb-2 w-32 rounded-md overflow-hidden hidden group-hover/dropdown:block z-10" style="background-color: white; border: 1px solid #e9ecef; box-shadow: 0 4px 12px rgba(0,0,0,0.15);">
                                                        <c:if test="${u.role != 'admin'}">
                                                            <a href="${pageContext.request.contextPath}/manageUsers?action=changeRole&id=${u.userId}&role=admin" onclick="return confirm('Make ${u.fullName} an Admin?')" class="block px-4 py-2 text-[11px] font-bold uppercase tracking-wider text-left" style="color: #212529;" onmouseover="this.style.backgroundColor='#f8f9fa';" onmouseout="this.style.backgroundColor='white';">Make Admin</a>
                                                        </c:if>
                                                        <c:if test="${u.role != 'user'}">
                                                            <a href="${pageContext.request.contextPath}/manageUsers?action=changeRole&id=${u.userId}&role=user" onclick="return confirm('Make ${u.fullName} a User?')" class="block px-4 py-2 text-[11px] font-bold uppercase tracking-wider text-left" style="color: #212529;" onmouseover="this.style.backgroundColor='#f8f9fa';" onmouseout="this.style.backgroundColor='white';">Make User</a>
                                                        </c:if>
                                                    </div>
                                                </div>
                                                
                                                <button onclick="viewUserDetails(${u.userId}, '${u.fullName.replace("'", "\\'")}', '${u.email}', '${u.phone}', '${u.role}', '<fmt:formatDate value="${u.registrationDate}" pattern="MMM dd, yyyy"/>', ${u.bookingCount}, ${u.totalSpent})" class="p-2 rounded-md flex items-center justify-center" style="background-color: white; color: #6c757d; border: 1px solid #ced4da;" onmouseover="this.style.borderColor='#dc143c'; this.style.color='#dc143c';" onmouseout="this.style.borderColor='#ced4da'; this.style.color='#6c757d';">
                                                    <span class="material-symbols-outlined text-[18px]">visibility</span>
                                                </button>
                                                
                                                <a href="${pageContext.request.contextPath}/manageUsers?action=delete&id=${u.userId}" onclick="return confirm('Are you sure you want to delete ${u.fullName.replace("'", "\\'")}?')" class="p-2 rounded-md flex items-center justify-center" style="background-color: white; color: #dc3545; border: 1px solid rgba(220, 53, 69, 0.2);" onmouseover="this.style.backgroundColor='#dc3545'; this.style.color='white';" onmouseout="this.style.backgroundColor='white'; this.style.color='#dc3545';">
                                                    <span class="material-symbols-outlined text-[18px]">delete</span>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" class="px-6 py-12 text-center" style="color: #6c757d;">
                                        <span class="material-symbols-outlined text-4xl mb-2" style="opacity: 0.5;">person_search</span>
                                        <p>No users found matching your criteria.</p>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
    </div>

    <!-- User Details Modal (Retained and styled) -->
    <div id="userModal" class="hidden fixed inset-0 z-50 overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
        <div class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
            <div class="fixed inset-0 transition-opacity" style="background-color: rgba(0,0,0,0.5);" aria-hidden="true" onclick="closeModal()"></div>
            <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
            
            <div class="inline-block align-bottom rounded-xl text-left overflow-hidden transform transition-all sm:my-8 sm:align-middle sm:max-w-lg w-full" style="background-color: white; box-shadow: 0 4px 12px rgba(0,0,0,0.15);">
                <div class="px-4 pt-5 pb-4 sm:p-6 sm:pb-4" style="background-color: white; border-bottom: 1px solid #e9ecef;">
                    <div class="flex justify-between items-center mb-5">
                        <h3 class="text-lg leading-6 font-bold" style="color: #212529;" id="modal-title">User Details</h3>
                        <button onclick="closeModal()" style="color: #6c757d;" onmouseover="this.style.color='#212529';" onmouseout="this.style.color='#6c757d';">
                            <span class="material-symbols-outlined">close</span>
                        </button>
                    </div>
                    
                    <div class="space-y-4">
                        <div class="flex justify-between pb-3" style="border-bottom: 1px solid #f8f9fa;">
                            <span class="text-[11px] font-bold uppercase tracking-widest" style="color: #6c757d;">User ID</span>
                            <span class="font-semibold" style="color: #212529;" id="modal-userId"></span>
                        </div>
                        <div class="flex justify-between pb-3" style="border-bottom: 1px solid #f8f9fa;">
                            <span class="text-[11px] font-bold uppercase tracking-widest" style="color: #6c757d;">Full Name</span>
                            <span class="font-semibold" style="color: #212529;" id="modal-fullName"></span>
                        </div>
                        <div class="flex justify-between pb-3" style="border-bottom: 1px solid #f8f9fa;">
                            <span class="text-[11px] font-bold uppercase tracking-widest" style="color: #6c757d;">Email</span>
                            <span class="font-semibold" style="color: #212529;" id="modal-email"></span>
                        </div>
                        <div class="flex justify-between pb-3" style="border-bottom: 1px solid #f8f9fa;">
                            <span class="text-[11px] font-bold uppercase tracking-widest" style="color: #6c757d;">Phone</span>
                            <span class="font-semibold" style="color: #212529;" id="modal-phone"></span>
                        </div>
                        <div class="flex justify-between pb-3" style="border-bottom: 1px solid #f8f9fa;">
                            <span class="text-[11px] font-bold uppercase tracking-widest" style="color: #6c757d;">Role</span>
                            <span class="font-bold uppercase" style="color: #dc143c;" id="modal-role"></span>
                        </div>
                        <div class="flex justify-between pb-3" style="border-bottom: 1px solid #f8f9fa;">
                            <span class="text-[11px] font-bold uppercase tracking-widest" style="color: #6c757d;">Registered</span>
                            <span class="font-semibold" style="color: #212529;" id="modal-registered"></span>
                        </div>
                        <div class="flex justify-between pb-3" style="border-bottom: 1px solid #f8f9fa;">
                            <span class="text-[11px] font-bold uppercase tracking-widest" style="color: #6c757d;">Total Bookings</span>
                            <span class="font-semibold" style="color: #212529;" id="modal-bookings"></span>
                        </div>
                        <div class="flex justify-between pb-1">
                            <span class="text-[11px] font-bold uppercase tracking-widest" style="color: #6c757d;">Total Spent</span>
                            <span class="font-semibold" style="color: #212529;" id="modal-spent"></span>
                        </div>
                    </div>
                </div>
                <div class="px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse" style="background-color: #f8f9fa;">
                    <button type="button" onclick="closeModal()" class="w-full inline-flex justify-center rounded-md px-4 py-2 text-base font-medium uppercase tracking-wider font-bold sm:ml-3 sm:w-auto sm:text-sm" style="background-color: #dc143c; color: white; border: none; box-shadow: 0 1px 3px rgba(0,0,0,0.1);" onmouseover="this.style.backgroundColor='#b71c1c';" onmouseout="this.style.backgroundColor='#dc143c';">
                        Close
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        function viewUserDetails(userId, fullName, email, phone, role, registered, bookings, spent) {
            document.getElementById('modal-userId').textContent = userId;
            document.getElementById('modal-fullName').textContent = fullName;
            document.getElementById('modal-email').textContent = email;
            document.getElementById('modal-phone').textContent = phone;
            document.getElementById('modal-role').textContent = role;
            document.getElementById('modal-registered').textContent = registered;
            document.getElementById('modal-bookings').textContent = bookings;
            document.getElementById('modal-spent').textContent = 'Rs. ' + parseFloat(spent).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,');
            
            document.getElementById('userModal').classList.remove('hidden');
        }
        
        function closeModal() {
            document.getElementById('userModal').classList.add('hidden');
        }
    </script>
</body>
</html>
