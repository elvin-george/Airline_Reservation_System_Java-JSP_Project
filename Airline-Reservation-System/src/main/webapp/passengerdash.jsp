<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Check if the passenger is logged in
    String passengerEmail = (String) session.getAttribute("userEmail");
    String userType = (String) session.getAttribute("userType");
    
    if (passengerEmail == null || !"passenger".equalsIgnoreCase(userType)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    int userId = (int) session.getAttribute("user_id");
    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;
    String jdbcURL = "jdbc:mysql://localhost:3306/airline";
    String dbUser = "root";
    String dbPassword = "root";
    
    String firstName = "", middleName = "", lastName = "";
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
        String userQuery = "SELECT first_name, middle_name, last_name FROM user WHERE user_id = ?";
        pst = con.prepareStatement(userQuery);
        pst.setInt(1, userId);
        ResultSet userRs = pst.executeQuery();

        if (userRs.next()) {  
            firstName = userRs.getString("first_name");
            middleName = userRs.getString("middle_name") != null ? userRs.getString("middle_name") + " " : "";
            lastName = userRs.getString("last_name");
        }
        userRs.close();
        pst.close();
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (con != null) try { con.close(); } catch (Exception ignored) {}
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Passenger Dashboard | Airline Reservation</title>
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

/* Flights Table */
.flight-table {
    margin-top: 30px;
    width: 100%;
    border-collapse: collapse;
    background: white;
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    border-radius: 10px;
    overflow: hidden;
}

.flight-table th, .flight-table td {
    padding: 12px 15px;
    text-align: center;
    border-bottom: 1px solid #ddd;
}

.flight-table th {
    background-color: #2D82B5;
    color: white;
}

.flight-table tr:nth-child(even) {
    background-color: #f2f2f2;
}

.book-btn {
    background: #2D6B25;
    color: white;
    padding: 6px 12px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.book-btn:hover {
    background: #1E4E1F;
}
    </style>
</head>
<body>

    <div class="navbar">
        <div>
            <a href="passengerdash.jsp">Dashboard</a>
            <a href="find_flights.jsp">Search Flights</a>
            <a href="my_bookings.jsp">My Bookings</a>
            <a href="my_payments.jsp">Payments</a>
            <a href="edit_profile.jsp">My Profile</a>
        </div>
        <form action="logout.jsp" method="post">
            <button type="submit" class="logout-btn">Logout</button>
        </form>
    </div>

    <div class="container">
        <h1>Welcome, <%= firstName %> <%= middleName %> <%= lastName %>!</h1>
        <p>Find and book your next flight with ease.</p>
    </div>

    <div class="container">
        <h1>Available Flights</h1>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
                String query = "SELECT * FROM flights WHERE available_seats > 0 ORDER BY departure_time ASC";
                pst = con.prepareStatement(query);
                rs = pst.executeQuery();
        %>
        <table class="flight-table">
            <tr>
                <th>Flight No</th>
                <th>Airline</th>
                <th>From</th>
                <th>To</th>
                <th>Departure</th>
                <th>Arrival</th>
                <th>Price (₹)</th>
                <th>Seats Left</th>
                <th>Action</th>
            </tr>
        <%
            while(rs.next()) {
        %>
            <tr>
                <td><%= rs.getString("flightnumber") %></td>
                <td><%= rs.getString("airline_name") %></td>
                <td><%= rs.getString("source") %></td>
                <td><%= rs.getString("destination") %></td>
                <td><%= rs.getTimestamp("departure_time") %></td>
                <td><%= rs.getTimestamp("arrival_time") %></td>
                <td>₹<%= rs.getDouble("price") %></td>
                <td><%= rs.getInt("available_seats") %></td>
                <td>
                    <form action="bookFlight.jsp" method="get">
                        <input type="hidden" name="flight_id" value="<%= rs.getInt("flight_id") %>">
                        <button type="submit" class="book-btn">Book Now</button>
                    </form>
                </td>
            </tr>
        <%
            }
            rs.close();
            pst.close();
        } catch(Exception e) {
            out.println("<p style='color:red;'>Error loading flights.</p>");
            e.printStackTrace();
        } finally {
            if (con != null) try { con.close(); } catch (Exception ignored) {}
        }
        %>
        </table>
    </div>

</body>
</html>
