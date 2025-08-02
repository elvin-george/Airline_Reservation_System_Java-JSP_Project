<%@ page import="java.sql.*" %>
<%
    int booking_id = Integer.parseInt(request.getParameter("booking_id"));

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airline", "root", "root");

        String sql = "DELETE FROM bookings WHERE booking_id=?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, booking_id);
        stmt.executeUpdate();

        response.sendRedirect("manage_bookings.jsp?msg=Booking deleted successfully");
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        try { if (stmt != null) stmt.close(); if (conn != null) conn.close(); } catch (SQLException ignored) {}
    }
%>
