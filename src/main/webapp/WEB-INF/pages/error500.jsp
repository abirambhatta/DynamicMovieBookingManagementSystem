<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Server Error</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="error-container">
        <h1>500</h1>
        <h2>Internal Server Error</h2>
        <p>Something went wrong. Please try again later.</p>
        <a href="${pageContext.request.contextPath}/logout" class="btn">Return to Login</a>
    </div>
</body>
</html>
