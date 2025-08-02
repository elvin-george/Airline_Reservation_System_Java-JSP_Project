<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Flights</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; padding: 20px; background: #BCEDFF; color: #0E4A7B; }
        .container { background: white; padding: 20px; border-radius: 10px; box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1); }
        h2 { text-align: center; color: #015C92; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 10px; border: 1px solid #ddd; text-align: center; }
        th { background: #007bff; color: white; }
        .btn { display: inline-block; padding: 10px 15px; margin: 5px; border-radius: 5px; text-decoration: none; color: white; font-weight: bold; text-align: center; border: none; cursor: pointer; }
        .btn-back { background: #17a2b8; }
        .btn-add { background: #28a745; }
        .btn-schedule { background: #28a745; }
        .btn-search { background: #007bff; padding: 10px 15px; border: none; cursor: pointer; color: white; }
        .btn:hover { opacity: 0.8; }
        .filter-section { text-align: center; margin-bottom: 20px; }
        select, input[type='date'] { padding: 10px; margin: 5px; border-radius: 5px; border: 1px solid #ddd; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Manage Flights</h2>
        
        <!-- Filter Section -->
        <form method="GET" action="manage_flights.jsp" class="filter-section">
            <select name="source">
                <option value="">Source</option>
                <% 
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airline", "root", "root");
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT DISTINCT source FROM flights");
                    while (rs.next()) { %>
                        <option value="<%= rs.getString("source") %>" 
                            <%= (request.getParameter("source") != null && request.getParameter("source").equals(rs.getString("source"))) ? "selected" : "" %>>
                            <%= rs.getString("source") %>
                        </option>
                <% } rs.close(); %>
            </select>
            
            <select name="destination">
                <option value="">Destination</option>
                <% 
                    rs = stmt.executeQuery("SELECT DISTINCT destination FROM flights");
                    while (rs.next()) { %>
                        <option value="<%= rs.getString("destination") %>" 
                            <%= (request.getParameter("destination") != null && request.getParameter("destination").equals(rs.getString("destination"))) ? "selected" : "" %>>
                            <%= rs.getString("destination") %>
                        </option>
                <% } rs.close(); %>
            </select>
            
            <input type="date" name="date" value="<%= request.getParameter("date") != null ? request.getParameter("date") : "" %>">
            <button type="submit" class="btn-search">Search</button>
        </form>
        
        <a href="admindash.jsp" class="btn btn-back">Back To Dash</a>
        <a href="add_flight.jsp" class="btn btn-add">Add Flight</a>
        <a href="schedule_flight.jsp" class="btn btn-schedule">Schedule Flight</a>
        
        
        <table>
            <tr>
                <th>Flight ID</th>
                <th>Flight Number</th>
                <th>Airline Name</th>
                <th>Source</th>
                <th>Destination</th>
                <th>Departure Time</th>
                <th>Arrival Time</th>
                <th>Total Seats</th>
                <th>Available Seats</th>
                <th>Price</th>
                <th>Actions</th>
            </tr>
            <%
                String sourceFilter = request.getParameter("source");
                String destinationFilter = request.getParameter("destination");
                String dateFilter = request.getParameter("date");

                String query = "SELECT * FROM flights WHERE 1=1"; 
                if (sourceFilter != null && !sourceFilter.isEmpty()) {
                    query += " AND source=?";
                }
                if (destinationFilter != null && !destinationFilter.isEmpty()) {
                    query += " AND destination=?";
                }
                if (dateFilter != null && !dateFilter.isEmpty()) {
                    query += " AND DATE(departure_time) = ?";
                }

                PreparedStatement pstmt = conn.prepareStatement(query);
                int paramIndex = 1;
                if (sourceFilter != null && !sourceFilter.isEmpty()) {
                    pstmt.setString(paramIndex++, sourceFilter);
                }
                if (destinationFilter != null && !destinationFilter.isEmpty()) {
                    pstmt.setString(paramIndex++, destinationFilter);
                }
                if (dateFilter != null && !dateFilter.isEmpty()) {
                    pstmt.setString(paramIndex++, dateFilter);
                }

                rs = pstmt.executeQuery();
                while (rs.next()) { %>
                    <tr>
                        <td><%= rs.getInt("flight_id") %></td>
                        <td><%= rs.getString("flightnumber") %></td>
                        <td><%= rs.getString("airline_name") %></td>
                        <td><%= rs.getString("source") %></td>
                        <td><%= rs.getString("destination") %></td>
                        <td><%= rs.getString("departure_time") %></td>
                        <td><%= rs.getString("arrival_time") %></td>
                        <td><%= rs.getInt("total_seats") %></td>
                        <td><%= rs.getInt("available_seats") %></td>
                        <td><%= rs.getDouble("price") %></td>
                        <td>
                            <a href="edit_flight.jsp?flight_id=<%= rs.getInt("flight_id") %>" class="btn btn-edit" style="background: #ffc107;">Edit</a>
                            <a href="delete_flight.jsp?flight_id=<%= rs.getInt("flight_id") %>" class="btn btn-delete" style="background: #dc3545;">Delete</a>
                        </td>
                    </tr>
            <% } 
                rs.close();
                pstmt.close();
                stmt.close();
                conn.close();
            %>
        </table>
    </div>
</body>
</html>
