<%@ page import="java.sql.*, java.util.*, javax.servlet.http.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Get flight ID and selected seats from request
    String flightId = request.getParameter("flight_id");
    String selectedSeats = request.getParameter("seats"); // Comma-separated seat numbers

    if (flightId == null || selectedSeats == null || selectedSeats.isEmpty()) {
        out.println("Invalid flight or seat selection.");
        return;
    }

    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;
    int pricePerTicket = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/airline", "root", "root");

        // Get ticket price from the flights table
        pst = con.prepareStatement("SELECT price FROM flights WHERE flight_id = ?");
        pst.setInt(1, Integer.parseInt(flightId));
        rs = pst.executeQuery();

        if (rs.next()) {
            pricePerTicket = rs.getInt("price");
        } else {
            out.println("Error fetching flight price.");
            return;
        }

        // Close result set and statement
        rs.close();
        pst.close();

        // Calculate total amount
        int totalSeats = selectedSeats.split(",").length;
        int totalAmount = totalSeats * pricePerTicket;

        // Redirect to payment page with necessary details
        response.sendRedirect("payment.jsp?flight_id=" + flightId + "&seats=" + selectedSeats + "&amount=" + totalAmount);

    } catch (Exception e) {
        out.println("Database error: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (pst != null) pst.close();
        if (con != null) con.close();
    }
%>
