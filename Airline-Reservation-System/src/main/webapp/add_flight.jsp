<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.io.*" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Flight</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f7f6;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 400px;
        }

        h2 {
            color: #4CAF50;
            text-align: center;
            font-size: 24px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            font-size: 16px;
            color: #333;
            display: block;
            margin-bottom: 5px;
        }

        .form-group input {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .btn {
            background-color: #4CAF50;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            width: 100%;
            cursor: pointer;
        }

        .btn:hover {
            background-color: #45a049;
        }

        .error {
            color: red;
            font-size: 14px;
            text-align: center;
        }

        .success {
            color: green;
            font-size: 16px;
            text-align: center;
        }
    </style>
</head>

<body>
    <div class="container">
        <h2>Add New Flight</h2>

        <form action="add_flight.jsp" method="post" id="addFlightForm">
            <div class="form-group">
                <label for="flightNumber">Flight Number:</label>
                <input type="text" id="flightNumber" name="flightNumber" required>
            </div>
            <div class="form-group">
                <label for="airlineName">Airline Name:</label>
                <input type="text" id="airlineName" name="airlineName" required>
            </div>
            <div class="form-group">
                <label for="source">Source:</label>
                <input type="text" id="source" name="source" required>
            </div>
            <div class="form-group">
                <label for="destination">Destination:</label>
                <input type="text" id="destination" name="destination" required>
            </div>
            <div class="form-group">
                <label for="totalSeats">Total Seats:</label>
                <input type="number" id="totalSeats" name="totalSeats" required>
            </div>
            <div class="form-group">
                <label for="availableSeats">Available Seats:</label>
                <input type="number" id="availableSeats" name="availableSeats" required>
            </div>
            <div class="form-group">
                <label for="price">Price (₹):</label>
                <input type="number" id="price" name="price" required>
            </div>
            <button type="submit" class="btn">Add Flight</button>
        </form>

        <% 
            // Check if the form was submitted
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String flightNumber = request.getParameter("flightNumber");
                String airlineName = request.getParameter("airlineName");
                String source = request.getParameter("source");
                String destination = request.getParameter("destination");
                int totalSeats = Integer.parseInt(request.getParameter("totalSeats"));
                int availableSeats = Integer.parseInt(request.getParameter("availableSeats"));
                double price = Double.parseDouble(request.getParameter("price"));

                // Database connection details
                String url = "jdbc:mysql://localhost:3306/airline";
                String username = "root";
                String password = "root";

                Connection conn = null;
                PreparedStatement stmt = null;

                try {
                    // Load the JDBC driver
                    Class.forName("com.mysql.cj.jdbc.Driver");

                    // Establish a connection to the database
                    conn = DriverManager.getConnection(url, username, password);

                    // Insert query
                    String query = "INSERT INTO flights1 (flightnumber, airline_name, source, destination, total_seats, available_seats, price) VALUES (?, ?, ?, ?, ?, ?, ?)";
                    stmt = conn.prepareStatement(query);
                    stmt.setString(1, flightNumber);
                    stmt.setString(2, airlineName);
                    stmt.setString(3, source);
                    stmt.setString(4, destination);
                    stmt.setInt(5, totalSeats);
                    stmt.setInt(6, availableSeats);
                    stmt.setDouble(7, price);

                    // Execute the query
                    int rowsAffected = stmt.executeUpdate();

                    if (rowsAffected > 0) {
        %>
                        <div class="success">Flight added successfully!</div>
        <% 
                    } else {
        %>
                        <div class="error">Failed to add the flight. Please try again.</div>
        <% 
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    %>
                    <div class="error">An error occurred: <%= e.getMessage() %></div>
                    <%
                } finally {
                    try {
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        %>

    </div>
</body>

</html>
