<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - MovieMint</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
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
    body { font-family: 'Inter', sans-serif; }
    h1, h2, h3 { font-family: 'Manrope', sans-serif; }
    </style>
</head>
<body class="bg-surface text-on-surface">
    <!-- Check if user is logged in, if not redirect to login page -->
    <c:if test="${empty user}">
        <c:redirect url="login"/>
    </c:if>
    
    <jsp:include page="userHeader.jsp" />
    
    <main class="p-8 min-h-screen">
        <div class="max-w-3xl mx-auto">
            <!-- Header section -->
            <div class="mb-10 text-center">
                <div class="w-24 h-24 mx-auto bg-primary/10 rounded-full flex items-center justify-center text-primary mb-4 border-4 border-white shadow-sm">
                    <span class="material-symbols-outlined text-[40px]">person</span>
                </div>
                <h1 class="text-3xl font-bold tracking-tight text-on-surface mb-2 font-headline uppercase">My Profile</h1>
                <p class="text-secondary text-sm">Manage your personal information and account settings</p>
            </div>
            
            <div class="bg-white p-8 rounded-xl shadow-[0_20px_40px_rgba(20,29,35,0.03)] border border-surface-container-high">
                
                <c:if test="${not empty success}">
                    <div class="mb-6 p-4 bg-green-50 border border-green-200 text-green-700 rounded-lg flex items-center gap-3">
                        <span class="material-symbols-outlined">check_circle</span>
                        <span class="text-sm font-semibold">${success}</span>
                    </div>
                </c:if>
                
                <c:if test="${not empty error}">
                    <div class="mb-6 p-4 bg-red-50 border border-red-200 text-red-700 rounded-lg flex items-center gap-3">
                        <span class="material-symbols-outlined">error</span>
                        <span class="text-sm font-semibold">${error}</span>
                    </div>
                </c:if>
                
                <form action="${pageContext.request.contextPath}/userProfile" method="post" class="space-y-6">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Full Name -->
                        <div class="md:col-span-2">
                            <label for="fullName" class="block text-[11px] font-bold text-secondary uppercase tracking-widest mb-2 flex items-center gap-2">
                                <span class="material-symbols-outlined text-[16px]">person</span>
                                Full Name
                            </label>
                            <input type="text" id="fullName" name="fullName" value="${user.fullName}" required class="w-full bg-surface-container-lowest border border-gray-300 text-on-surface rounded-lg focus:ring-2 focus:ring-primary focus:border-primary p-3 text-sm transition-all shadow-sm">
                        </div>
                        
                        <!-- Email -->
                        <div>
                            <label for="email" class="block text-[11px] font-bold text-secondary uppercase tracking-widest mb-2 flex items-center gap-2">
                                <span class="material-symbols-outlined text-[16px]">mail</span>
                                Email Address
                            </label>
                            <input type="email" id="email" name="email" value="${user.email}" required class="w-full bg-surface-container-lowest border border-gray-300 text-on-surface rounded-lg focus:ring-2 focus:ring-primary focus:border-primary p-3 text-sm transition-all shadow-sm">
                        </div>
                        
                        <!-- Phone -->
                        <div>
                            <label for="phone" class="block text-[11px] font-bold text-secondary uppercase tracking-widest mb-2 flex items-center gap-2">
                                <span class="material-symbols-outlined text-[16px]">phone_iphone</span>
                                Phone Number
                            </label>
                            <input type="text" id="phone" name="phone" value="${user.phone}" maxlength="10" required class="w-full bg-surface-container-lowest border border-gray-300 text-on-surface rounded-lg focus:ring-2 focus:ring-primary focus:border-primary p-3 text-sm transition-all shadow-sm">
                        </div>
                    </div>
                    
                    <div class="pt-6 border-t border-gray-100 flex justify-end">
                        <button type="submit" class="px-8 py-3 bg-primary text-white text-xs font-bold uppercase tracking-wider rounded-lg hover:bg-primary-dark transition-colors shadow-md flex items-center gap-2">
                            <span class="material-symbols-outlined text-[18px]">save</span>
                            Save Changes
                        </button>
                    </div>
                </form>
            </div>
            
            <!-- Quick Stats -->
            <div class="mt-8 grid grid-cols-2 gap-4">
                <div class="bg-surface-container-low p-5 rounded-xl border border-surface-variant flex items-center gap-4">
                    <div class="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center text-primary">
                        <span class="material-symbols-outlined">confirmation_number</span>
                    </div>
                    <div>
                        <p class="text-[10px] font-bold text-secondary uppercase tracking-widest">Total Bookings</p>
                        <p class="text-xl font-bold font-headline text-on-surface">${user.bookingCount}</p>
                    </div>
                </div>
                
                <div class="bg-surface-container-low p-5 rounded-xl border border-surface-variant flex items-center gap-4">
                    <div class="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center text-primary">
                        <span class="material-symbols-outlined">payments</span>
                    </div>
                    <div>
                        <p class="text-[10px] font-bold text-secondary uppercase tracking-widest">Total Spent</p>
                        <p class="text-xl font-bold font-headline text-on-surface">Rs. ${String.format("%.2f", user.totalSpent)}</p>
                    </div>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
