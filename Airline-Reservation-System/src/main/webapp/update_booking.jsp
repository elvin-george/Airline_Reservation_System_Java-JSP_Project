<%@ page import="java.sql.*" %>
<%
    int booking_id = Integer.parseInt(request.getParameter("booking_id"));
    int seat_number = Integer.parseInt(request.getParameter("seat_number"));
    String status = request.getParameter("status");

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airline", "root", "root");

        String sql = "UPDATE bookings SET seat_number=?, status=? WHERE booking_id=?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, seat_number);
        stmt.setString(2, status);
        stmt.setInt(3, booking_id);
        stmt.executeUpdate();

        response.sendRedirect("manage_bookings.jsp?msg=Booking updated successfully");
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        try { if (stmt != null) stmt.close(); if (conn != null) conn.close(); } catch (SQLException ignored) {}
    }
%>
