<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
    if (session.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp"); // Redirect if session is lost
        return;
    }

    // Database Connection Details
    String jdbcURL = "jdbc:mysql://localhost:3306/airline";
    String dbUser = "root";
    String dbPassword = "root";

    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    // Get session user_id
    Integer userId = (Integer) session.getAttribute("user_id");

    // Get parameters from payment.jsp
    String flightIdParam = request.getParameter("flight_id");
    String seatsParam = request.getParameter("seats");
    String amountParam = request.getParameter("amount");

    // Debugging Info (Print received data)
    out.println("<h3>DEBUG INFO:</h3>");
    out.println("<p>User ID: " + userId + "</p>");
    out.println("<p>Flight ID: " + flightIdParam + "</p>");
    out.println("<p>Seats: " + seatsParam + "</p>");
    out.println("<p>Amount: " + amountParam + "</p>");

    if (userId == null || flightIdParam == null || seatsParam == null || amountParam == null) {
        out.println("<h3 style='color:red;'>Error: Missing booking details. Please try again.</h3>");
        return;
    }

    int flightId = Integer.parseInt(flightIdParam);
    String[] selectedSeats = seatsParam.split(",");
    int totalAmount = Integer.parseInt(amountParam);

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
        con.setAutoCommit(false); // Start transaction

        // Insert booking details (Now including seat_number)
        String bookingSql = "INSERT INTO bookings (user_id, flight_id, booking_date, seat_number, status) VALUES (?, ?, NOW(), ?, 'Booked')";
        pst = con.prepareStatement(bookingSql, Statement.RETURN_GENERATED_KEYS);

        for (String seat : selectedSeats) {
            pst.setInt(1, userId);
            pst.setInt(2, flightId);
            pst.setString(3, seat); // Store seat number in `bookings` table
            pst.executeUpdate();
        }

        rs = pst.getGeneratedKeys();
        int bookingId = 0;
        if (rs.next()) {
            bookingId = rs.getInt(1);
        }

        // Insert tickets for each selected seat
        String ticketSql = "INSERT INTO tickets (booking_id, ticket_number, issued_date, status) VALUES (?, ?, NOW(), 'Active')";
        pst = con.prepareStatement(ticketSql);

        for (String seat : selectedSeats) {
            String ticketNumber = UUID.randomUUID().toString().substring(0, 8).toUpperCase(); // Generate unique ticket number
            pst.setInt(1, bookingId);
            pst.setString(2, ticketNumber);
            pst.executeUpdate();
        }

        // Insert payment details
        String paymentSql = "INSERT INTO payments (booking_id, amount_paid, payment_status, transaction_date) VALUES (?, ?, 'Success', NOW())";
        pst = con.prepareStatement(paymentSql);
        pst.setInt(1, bookingId);
        pst.setInt(2, totalAmount);
        pst.executeUpdate();

        // Update available seats in flights table
        String updateSeatsSql = "UPDATE flights SET available_seats = available_seats - ? WHERE flight_id = ?";
        pst = con.prepareStatement(updateSeatsSql);
        pst.setInt(1, selectedSeats.length);
        pst.setInt(2, flightId);
        pst.executeUpdate();

        con.commit(); // Commit transaction

        // Redirect to ticket display page
        response.sendRedirect("ticketDisplay.jsp?booking_id=" + bookingId);

    } catch (Exception e) {
        e.printStackTrace();
        if (con != null) {
            try {
                con.rollback(); // Rollback on error
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
        }
        out.println("<h3 style='color:red;'>Error processing your booking: " + e.getMessage() + "</h3>");
    } finally {
        try {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
