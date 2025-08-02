<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>  
<%@ page session="true" %>

<%
    if (session.getAttribute("user_id") == null) {
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

    String firstName = "", middleName = "", lastName = "", email = "", phone = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
        String userQuery = "SELECT first_name, middle_name, last_name, email, phone FROM user WHERE user_id = ?";
        pst = con.prepareStatement(userQuery);
        pst.setInt(1, userId);
        ResultSet userRs = pst.executeQuery();

        if (userRs.next()) {  
            firstName = userRs.getString("first_name");
            middleName = userRs.getString("middle_name") != null ? userRs.getString("middle_name") + " " : "";
            lastName = userRs.getString("last_name");
            email = userRs.getString("email");
            phone = userRs.getString("phone");
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
    <title>Find Flights | Airline Reservation</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: #BCEDFF;
            padding: 20px;
            color: #0E4A7B;
        }
        .btn-back { background: white; }
        .navbar {
            background: #2D82B5;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-radius: 10px;
        }
        .navbar .logo {
            font-size: 24px;
            font-weight: bold;
            color: white;
        }
        .navbar span {
            color: white;
            font-size: 18px;
            margin-right: 15px;
        }
        .logout-btn {
            background: #B90E0A;
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
            background: #990F02;
        }
        .container {
            margin-top: 20px;
            padding: 30px;
            background: white;
            border-radius: 12px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        .search-box {
            display: flex;
            gap: 10px;
            justify-content: center;
            margin-bottom: 20px;
        }
        .search-box select, .search-box input, .search-box button {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .search-box button {
            background: #0073A8;
            color: white;
            cursor: pointer;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 12px;
            text-align: center;
        }
                .book-button {
            padding: 10px 15px;
            background: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .book-button:hover {
            background: #218838;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="logo">Airline</div>
        <div>
            <span>Welcome, <%= firstName %> <%= middleName %> <%= lastName %></span>
            <button class="logout-btn" onclick="window.location.href='logout.jsp'">Logout</button>
        </div>
    </div>
	<br><br><a href="passengerdash.jsp" class="btn btn-back">Back To Dash</a>
    <div class="container">
    	<h3>Find Flights</h3>
        <form class="search-box" method="GET">
            <select name="source">
                <option value="">Source</option>
                <%
                    try {
                        con = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
                        String sourceQuery = "SELECT DISTINCT source FROM flights";
                        pst = con.prepareStatement(sourceQuery);
                        rs = pst.executeQuery();
                        while (rs.next()) {
                %>
                <option value="<%= rs.getString("source") %>"><%= rs.getString("source") %></option>
                <%
                        }
                        rs.close();
                        pst.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                %>
            </select>

            <select name="destination">
                <option value="">Destination</option>
                <%
                    try {
                        String destinationQuery = "SELECT DISTINCT destination FROM flights";
                        pst = con.prepareStatement(destinationQuery);
                        rs = pst.executeQuery();
                        while (rs.next()) {
                %>
                <option value="<%= rs.getString("destination") %>"><%= rs.getString("destination") %></option>
                <%
                        }
                        rs.close();
                        pst.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                %>
            </select>

            <input type="date" name="departure_time">
            <button type="submit">Search</button>
        </form>

        <table>
            <tr>
                <th>Flight No</th>
                <th>Airline</th>
                <th>Source</th>
                <th>Destination</th>
                <th>Departure</th>
                <th>Arrival</th>
                <th>Seats</th>
                <th>Price (₹)</th>
                <th>Action</th>
            </tr>
            <%
                try {
                    con = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
                    String baseQuery = "SELECT * FROM flights WHERE available_seats > 0";
                    String source = request.getParameter("source");
                    String destination = request.getParameter("destination");
                    String date = request.getParameter("departure_time");
                    StringBuilder queryBuilder = new StringBuilder(baseQuery);
                    if (source != null && !source.isEmpty()) queryBuilder.append(" AND source = ?");
                    if (destination != null && !destination.isEmpty()) queryBuilder.append(" AND destination = ?");
                    if (date != null && !date.isEmpty()) queryBuilder.append(" AND DATE(departure_time) = ?");
                    pst = con.prepareStatement(queryBuilder.toString());
                    int index = 1;
                    if (source != null && !source.isEmpty()) pst.setString(index++, source);
                    if (destination != null && !destination.isEmpty()) pst.setString(index++, destination);
                    if (date != null && !date.isEmpty()) pst.setString(index++, date);
                    rs = pst.executeQuery();
                    while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getString("flightnumber") %></td>
                <td><%= rs.getString("airline_name") %></td>
                <td><%= rs.getString("source") %></td>
                <td><%= rs.getString("destination") %></td>
                <td><%= rs.getString("departure_time") %></td>
                <td><%= rs.getString("arrival_time") %></td>
                <td><%= rs.getInt("available_seats") %></td>
                <td>₹<%= rs.getDouble("price") %></td>
                <td><button class="book-button" onclick="window.location.href='bookFlight.jsp?flight_id=<%= rs.getInt("flight_id") %>'">Book</button></td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
        </table>
    </div>
</body>
</html>
