<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Booking | Airline Reservation</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Poppins', sans-serif; text-align: center; padding: 50px; }
        .container { width: 50%; margin: auto; background: #f4f4f4; padding: 20px; border-radius: 10px; }
        input, select { width: 100%; padding: 10px; margin: 10px 0; border-radius: 5px; border: 1px solid #ccc; }
        button { padding: 10px 20px; background: #27ae60; color: white; border: none; cursor: pointer; }
        button:hover { background: #2ecc71; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Edit Booking</h2>

        <%
            int booking_id = Integer.parseInt(request.getParameter("booking_id"));
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airline", "root", "root");

                String sql = "SELECT * FROM bookings WHERE booking_id=?";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, booking_id);
                rs = stmt.executeQuery();

                if (rs.next()) {
                    int seat_number = rs.getInt("seat_number");
                    String status = rs.getString("status");
        %>

        <form action="update_booking.jsp" method="post">
            <input type="hidden" name="booking_id" value="<%= booking_id %>">

            <label>Seat Number:</label>
            <input type="number" name="seat_number" value="<%= seat_number %>" required>

            <label>Status:</label>
            <select name="status" required>
                <option value="Confirmed" <%= status.equals("Confirmed") ? "selected" : "" %>>Confirmed</option>
                <option value="Pending" <%= status.equals("Pending") ? "selected" : "" %>>Pending</option>
                <option value="Cancelled" <%= status.equals("Cancelled") ? "selected" : "" %>>Cancelled</option>
            </select>

            <button type="submit">Update Booking</button>
        </form>

        <%
                } else {
                    out.println("<p>Booking not found.</p>");
                }
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                try { if (rs != null) rs.close(); if (stmt != null) stmt.close(); if (conn != null) conn.close(); } catch (SQLException ignored) {}
            }
        %>
    </div>
</body>
</html>
