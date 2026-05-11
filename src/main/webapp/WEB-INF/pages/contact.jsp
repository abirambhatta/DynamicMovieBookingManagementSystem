<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - MovieMint</title>
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
    <c:set var="currentUser" value="${sessionScope.user}" />

    <!-- Check if user is logged in and include appropriate header -->
    <c:if test="${not empty currentUser}">
        <c:choose>
            <c:when test="${currentUser.role == 'admin'}">
                <jsp:include page="adminHeader.jsp" />
            </c:when>
            <c:otherwise>
                <jsp:include page="userHeader.jsp" />
            </c:otherwise>
        </c:choose>
    </c:if>

    <main class="p-8 min-h-screen">
        <div class="max-w-4xl mx-auto">
            <!-- Header section -->
            <div class="mb-10 text-center">
                <h1 class="text-4xl font-bold tracking-tight text-on-surface mb-3 font-headline uppercase">Contact Us</h1>
                <p class="text-secondary">We're here to help. Send us a message and we'll respond as soon as possible.</p>
            </div>
            
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                <!-- Contact Form -->
                <div class="lg:col-span-2">
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
                        
                        <form action="${pageContext.request.contextPath}/contact" method="post" class="space-y-5">
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                                <div>
                                    <label for="name" class="block text-[11px] font-bold text-secondary uppercase tracking-widest mb-2">Name</label>
                                    <input type="text" id="name" name="name" value="${param.name}" required class="w-full bg-surface-container-lowest border border-gray-300 text-on-surface rounded-lg focus:ring-2 focus:ring-primary focus:border-primary p-3 text-sm transition-all shadow-sm">
                                </div>
                                <div>
                                    <label for="email" class="block text-[11px] font-bold text-secondary uppercase tracking-widest mb-2">Email</label>
                                    <input type="email" id="email" name="email" value="${param.email}" required class="w-full bg-surface-container-lowest border border-gray-300 text-on-surface rounded-lg focus:ring-2 focus:ring-primary focus:border-primary p-3 text-sm transition-all shadow-sm">
                                </div>
                            </div>
                            
                            <div>
                                <label for="subject" class="block text-[11px] font-bold text-secondary uppercase tracking-widest mb-2">Subject</label>
                                <input type="text" id="subject" name="subject" value="${param.subject}" required class="w-full bg-surface-container-lowest border border-gray-300 text-on-surface rounded-lg focus:ring-2 focus:ring-primary focus:border-primary p-3 text-sm transition-all shadow-sm">
                            </div>
                            
                            <div>
                                <label for="message" class="block text-[11px] font-bold text-secondary uppercase tracking-widest mb-2">Message</label>
                                <textarea id="message" name="message" rows="5" required class="w-full bg-surface-container-lowest border border-gray-300 text-on-surface rounded-lg focus:ring-2 focus:ring-primary focus:border-primary p-3 text-sm transition-all shadow-sm resize-y">${param.message}</textarea>
                            </div>
                            
                            <button type="submit" class="w-full md:w-auto px-8 py-3 bg-primary text-white text-xs font-bold uppercase tracking-wider rounded-lg hover:bg-primary-dark transition-colors shadow-md flex items-center justify-center gap-2">
                                <span class="material-symbols-outlined text-[18px]">send</span>
                                Send Message
                            </button>
                        </form>
                    </div>
                </div>
                
                <!-- Contact Info -->
                <div class="lg:col-span-1 space-y-6">
                    <div class="bg-surface-container-lowest p-6 rounded-xl border-l-4 border-primary shadow-[0_20px_40px_rgba(20,29,35,0.03)]">
                        <div class="flex items-center gap-4 mb-4">
                            <div class="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center text-primary">
                                <span class="material-symbols-outlined">mail</span>
                            </div>
                            <div>
                                <h3 class="text-xs font-bold text-secondary uppercase tracking-widest">Email</h3>
                                <p class="font-semibold text-on-surface">contact@moviemint.com.np</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="bg-surface-container-lowest p-6 rounded-xl border-l-4 border-primary shadow-[0_20px_40px_rgba(20,29,35,0.03)]">
                        <div class="flex items-center gap-4 mb-4">
                            <div class="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center text-primary">
                                <span class="material-symbols-outlined">call</span>
                            </div>
                            <div>
                                <h3 class="text-xs font-bold text-secondary uppercase tracking-widest">Phone</h3>
                                <p class="font-semibold text-on-surface">+977 1 4410123</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="bg-surface-container-lowest p-6 rounded-xl border-l-4 border-primary shadow-[0_20px_40px_rgba(20,29,35,0.03)]">
                        <div class="flex items-center gap-4 mb-4">
                            <div class="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center text-primary">
                                <span class="material-symbols-outlined">location_on</span>
                            </div>
                            <div>
                                <h3 class="text-xs font-bold text-secondary uppercase tracking-widest">Address</h3>
                                <p class="font-semibold text-on-surface text-sm">MovieMint Plaza, Durbarmarg<br>Kathmandu, Nepal</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="bg-surface-container-lowest p-6 rounded-xl border-l-4 border-primary shadow-[0_20px_40px_rgba(20,29,35,0.03)]">
                        <div class="flex items-center gap-4 mb-4">
                            <div class="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center text-primary">
                                <span class="material-symbols-outlined">schedule</span>
                            </div>
                            <div>
                                <h3 class="text-xs font-bold text-secondary uppercase tracking-widest">Business Hours</h3>
                                <p class="font-semibold text-on-surface text-sm">Mon-Sun<br>10:00 AM - 11:00 PM</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
