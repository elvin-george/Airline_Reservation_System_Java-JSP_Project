<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Flight</title>
    <link rel="stylesheet" href="css/style.css"> <!-- Link to your CSS -->
    <style>
        /* Optional inline style in case you need page-specific tweaks */
        .form-container {
            max-width: 600px;
            margin: 40px auto;
            padding: 25px;
            background: #ffffffdd;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            border-radius: 12px;
        }

        h2 {
            text-align: center;
            color: #333;
        }

        form label {
            display: block;
            margin: 10px 0 5px;
            color: #444;
        }

        form input {
            width: 100%;
            padding: 8px;
            margin-bottom: 12px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        button {
            width: 100%;
            padding: 10px;
            background-color: green;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background-color: green;
        }

        .message {
            text-align: center;
            margin-top: 15px;
            font-weight: bold;
            color: green;
        }

        .error {
            color: red;
        }
    </style>
</head>
<body>

    <div class="form-container">
        <h2>Edit Flight</h2>
        <%
            String flight_id = request.getParameter("flight_id");
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            if (flight_id != null) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airline", "root", "root");
                    stmt = conn.prepareStatement("SELECT * FROM flights WHERE flight_id = ?");
                    stmt.setInt(1, Integer.parseInt(flight_id));
                    rs = stmt.executeQuery();

                    if (rs.next()) {
        %>
        <form action="edit_flight.jsp" method="post">
            <input type="hidden" name="flight_id" value="<%= rs.getInt("flight_id") %>">
            <label>Flight Number:</label>
            <input type="text" name="flightnumber" value="<%= rs.getString("flightnumber") %>" required>
            
            <label>Airline Name:</label>
            <input type="text" name="airline_name" value="<%= rs.getString("airline_name") %>" required>
            
            <label>Source:</label>
            <input type="text" name="source" value="<%= rs.getString("source") %>" required>
            
            <label>Destination:</label>
            <input type="text" name="destination" value="<%= rs.getString("destination") %>" required>
            
            <label>Departure Time:</label>
            <input type="datetime-local" name="departure_time" value="<%= rs.getString("departure_time") %>" required>
            
            <label>Arrival Time:</label>
            <input type="datetime-local" name="arrival_time" value="<%= rs.getString("arrival_time") %>" required>
            
            <label>Total Seats:</label>
            <input type="number" name="total_seats" value="<%= rs.getInt("total_seats") %>" required>
            
            <label>Available Seats:</label>
            <input type="number" name="available_seats" value="<%= rs.getInt("available_seats") %>" required>
            
            <label>Price:</label>
            <input type="number" step="0.01" name="price" value="<%= rs.getDouble("price") %>" required>
            
            <button type="submit">Update Flight</button>
        </form>
        <%
                    }
                } catch (Exception e) {
                    out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                }
            }

            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String flightnumber = request.getParameter("flightnumber");
                String airline_name = request.getParameter("airline_name");
                String source = request.getParameter("source");
                String destination = request.getParameter("destination");
                String departure_time = request.getParameter("departure_time");
                String arrival_time = request.getParameter("arrival_time");
                int total_seats = Integer.parseInt(request.getParameter("total_seats"));
                int available_seats = Integer.parseInt(request.getParameter("available_seats"));
                double price = Double.parseDouble(request.getParameter("price"));

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airline", "root", "root");
                    stmt = conn.prepareStatement("UPDATE flights SET flightnumber=?, airline_name=?, source=?, destination=?, departure_time=?, arrival_time=?, total_seats=?, available_seats=?, price=? WHERE flight_id=?");
                    stmt.setString(1, flightnumber);
                    stmt.setString(2, airline_name);
                    stmt.setString(3, source);
                    stmt.setString(4, destination);
                    stmt.setString(5, departure_time);
                    stmt.setString(6, arrival_time);
                    stmt.setInt(7, total_seats);
                    stmt.setInt(8, available_seats);
                    stmt.setDouble(9, price);
                    stmt.setInt(10, Integer.parseInt(flight_id));

                    int rows = stmt.executeUpdate();
                    if (rows > 0) {
                        out.println("<p class='message'>Flight updated successfully!</p>");
                    }
                } catch (Exception e) {
                    out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
                } finally {
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                }
            }
        %>
    </div>
</body>
</html>
