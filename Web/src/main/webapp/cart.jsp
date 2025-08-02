<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    // Check if user is logged in
    String user = (String) session.getAttribute("username");
    if (user == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
    }
%>
<html>
<head>
    <title>Shopping Cart</title>
</head>
<body>
    <h2>Welcome, <%= user %>! Here is your shopping cart:</h2>
    <ul>
        <li>Product 1 - $10</li>
        <li>Product 2 - $20</li>
        <li>Product 3 - $30</li>
    </ul>
    <br>
    <a href="logout.jsp">Logout</a>
</body>
</html>
