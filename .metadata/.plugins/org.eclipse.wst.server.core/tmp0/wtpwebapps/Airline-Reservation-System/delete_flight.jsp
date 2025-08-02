<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Delete Flight</title>
</head>
<body>
    <h2>Delete Flight</h2>
    <%
        String flight_id = request.getParameter("flight_id");

        if (flight_id != null) {
            Connection conn = null;
            PreparedStatement stmt = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airline", "root", "root");
                stmt = conn.prepareStatement("DELETE FROM flights WHERE flight_id = ?");
                stmt.setInt(1, Integer.parseInt(flight_id));

                int rows = stmt.executeUpdate();
                if (rows > 0) {
                    out.println("<p>Flight deleted successfully!</p>");
                } else {
                    out.println("<p>Flight not found.</p>");
                }
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        } else {
            out.println("<p>No flight selected for deletion.</p>");
        }
    %>
    <a href="manage_flights.jsp">Back to Flight Management</a>
</body>
</html>
