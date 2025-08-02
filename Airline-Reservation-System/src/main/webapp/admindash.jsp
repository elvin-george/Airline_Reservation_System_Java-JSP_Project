<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Check if the admin is logged in
    String adminEmail = (String) session.getAttribute("userEmail");
    String userType = (String) session.getAttribute("userType");

    if (adminEmail == null || !"admin".equalsIgnoreCase(userType)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | Airline Reservation</title>
    <style>
* { 
    margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; 
}

body { 
    background: #BCEDFF; /* Light Blue Background */
    padding: 20px;
    color: #0E4A7B; /* Deep Blue Text for contrast */
}

/* Navbar Styling */
.navbar {
    background: #2D82B5; /* Lighter Blue */
    padding: 15px 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-radius: 10px;
}

.navbar a {
    color: white;
    text-decoration: none;
    font-size: 18px;
    margin-right: 15px;
    padding: 10px 15px;
    border-radius: 5px;
    transition: all 0.3s ease-in-out;
}

.navbar a:hover {
    background: rgba(255, 255, 255, 0.25);
}

.logout-btn {
    background: #B90E0A; /* Lighter Blue */
    color: white;
    border: none;
    padding: 10px 15px;
    font-size: 16px;
    font-weight: bold;
    border-radius: 6px;
    cursor: pointer;
    transition: all 0.3s ease-in-out;
}

.logout-btn:hover { 
    background: #990F02; /* Darker Blue */
}

/* Container */
.container {
    margin-top: 20px;
    padding: 30px;
    background: white;
    border-radius: 12px;
    box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
    text-align: center;
}

h1 {
    color: #015C92; /* Deep Blue */
    font-size: 28px;
}

p {
    font-size: 18px;
    color: #2D6B25; /* Dark Green Accent */
}

    </style>
</head>
<body>

    <div class="navbar">
        <div>
            <a href="admindash.jsp">Dashboard</a>
            <a href="manage_users.jsp">Manage Users</a>
            <a href="manage_flights.jsp">Manage Flights</a>
            <a href="manage_bookings.jsp">Manage Bookings</a>
            <a href="reports.jsp">Reports</a>
        </div>
        <form action="logout.jsp" method="post">
            <button type="submit" class="logout-btn">Logout</button>
        </form>
    </div>

    <div class="container">
        <h1>Welcome, Admin!</h1>
        <p>Use the navigation above to manage flights, users, and bookings.</p>
    </div>

</body>
</html>
