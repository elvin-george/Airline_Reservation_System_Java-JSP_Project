<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.io.*" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Schedule Flight</title>
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
        <h2>Schedule Flight</h2>

        <form action="schedule_flight.jsp" method="post">
            <div class="form-group">
                <label for="flightNumber">Select Flight:</label>
                <select id="flightNumber" name="flightNumber" required>
                    <% 
                        // Declare connection variables here to prevent duplication
                        Connection conn = null;
                        Statement stmt = null;
                        ResultSet rs = null;
                        
                        try {
                            // Database connection
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airline", "root", "root");
                            stmt = conn.createStatement();
                            rs = stmt.executeQuery("SELECT DISTINCT flightnumber FROM flights1");
                            
                            while (rs.next()) {
                                String flightNumber = rs.getString("flightnumber");
                    %>
                                <option value="<%= flightNumber %>"><%= flightNumber %></option>
                    <% 
                            }
                        } catch (SQLException e) {
                            e.printStackTrace();
                    %>
                            <option disabled>Error fetching flight numbers</option>
                    <% 
                        } finally {
                            try {
                                if (rs != null) rs.close();
                                if (stmt != null) stmt.close();
                                if (conn != null) conn.close();
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        }
                    %>
                </select>
            </div>

            <div class="form-group">
                <label for="departureDate">Departure Date:</label>
                <input type="date" id="departureDate" name="departureDate" required>
            </div>
            <div class="form-group">
                <label for="departureTime">Departure Time:</label>
                <input type="time" id="departureTime" name="departureTime" required>
            </div>

            <div class="form-group">
                <label for="arrivalDate">Arrival Date:</label>
                <input type="date" id="arrivalDate" name="arrivalDate" required>
            </div>
            <div class="form-group">
                <label for="arrivalTime">Arrival Time:</label>
                <input type="time" id="arrivalTime" name="arrivalTime" required>
            </div>
            
            <button type="submit" class="btn">Add Schedule</button>
        </form>
    </div>

    <%
        // Handle form submission logic in a single block
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String flightNumber = request.getParameter("flightNumber");
            String departureDate = request.getParameter("departureDate");
            String departureTime = request.getParameter("departureTime");
            String arrivalDate = request.getParameter("arrivalDate");
            String arrivalTime = request.getParameter("arrivalTime");

            try {
                // Re-initialize connection variables in the same block
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airline", "root", "root");
                stmt = conn.createStatement();

                // Fetch flight details from flights1 table
                rs = stmt.executeQuery("SELECT * FROM flights1 WHERE flightnumber = '" + flightNumber + "'");
                
                if (rs.next()) {
                    // Get the details from flights1 table
                    String airlineName = rs.getString("airline_name");
                    String source = rs.getString("source");
                    String destination = rs.getString("destination");
                    int totalSeats = rs.getInt("total_seats");
                    int availableSeats = rs.getInt("available_seats");
                    double price = rs.getDouble("price");

                    // Combine the arrival and departure dates and times
                    String departureDateTime = departureDate + " " + departureTime;
                    String arrivalDateTime = arrivalDate + " " + arrivalTime;

                    // Insert into the original flights table
                    String insertQuery = "INSERT INTO flights (flightnumber, airline_name, source, destination, departure_time, arrival_time, total_seats, available_seats, price) "
                            + "VALUES ('" + flightNumber + "', '" + airlineName + "', '" + source + "', '" + destination + "', '" + departureDateTime + "', '" + arrivalDateTime + "', " 
                            + totalSeats + ", " + availableSeats + ", " + price + ")";

                    int rowsAffected = stmt.executeUpdate(insertQuery);
                    
                    if (rowsAffected > 0) {
                        out.println("<p>Flight schedule added successfully!</p>");
                    } else {
                        out.println("<p>Error adding flight schedule.</p>");
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<p>Error occurred: " + e.getMessage() + "</p>");
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    %>
</body>

</html>
