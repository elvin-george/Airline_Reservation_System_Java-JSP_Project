<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String jdbcURL = "jdbc:mysql://localhost:3306/airline";
    String dbUser = "root";
    String dbPass = "root";
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Integer userId = (Integer) session.getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        Integer bookingId = Integer.parseInt(request.getParameter("booking_id"));
        
        // Establish database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPass);
        
        // Fetch ticket and flight details
        String ticketQuery = "SELECT u.first_name, u.last_name, f.flightnumber, f.source, f.destination, GROUP_CONCAT(t.ticket_number) AS ticket_numbers, GROUP_CONCAT(b.seat_number) AS seat_numbers, COUNT(t.ticket_id) AS total_seats, b.booking_date " +
                             "FROM tickets t " +
                             "INNER JOIN bookings b ON t.booking_id = b.booking_id " +
                             "INNER JOIN flights f ON b.flight_id = f.flight_id " +
                             "INNER JOIN user u ON b.user_id = u.user_id " +
                             "WHERE b.booking_id = ? " +
                             "GROUP BY b.booking_id";
        
        pstmt = conn.prepareStatement(ticketQuery);
        pstmt.setInt(1, bookingId);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            String userName = rs.getString("first_name") + " " + rs.getString("last_name");
            String flightNumber = rs.getString("flightnumber");
            String source = rs.getString("source");
            String destination = rs.getString("destination");
            String seatNumbers = rs.getString("seat_numbers");
            String ticketNumbers = rs.getString("ticket_numbers");
            int totalSeats = rs.getInt("total_seats");
            String bookingDate = rs.getString("booking_date");
%>

<html>
<head>
    <title>Flight Ticket</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f4f8;
            text-align: center;
        }
        .ticket-container {
            width: 50%;
            margin: auto;
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.2);
            border: 2px solid #007bff;
            position: relative;
        }
        .ticket-header {
            font-size: 24px;
            font-weight: bold;
            color: #007bff;
            border-bottom: 2px dashed #007bff;
            padding-bottom: 10px;
            margin-bottom: 10px;
        }
        .ticket-section {
            font-size: 18px;
            text-align: left;
            padding: 10px 20px;
        }
        .label {
            font-weight: bold;
            color: #333;
        }
        .ticket-divider {
            border-top: 2px dashed #007bff;
            margin: 10px 0;
        }
        .button-container {
            margin-top: 20px;
        }
        .btn {
            padding: 12px 18px;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
            display: inline-block;
            transition: 0.3s;
        }
        .btn-print {
            background-color: #28a745;
            color: white;
            border: none;
            cursor: pointer;
        }
        .btn-print:hover {
            background-color: #218838;
        }
        .btn-back {
            background-color: #007bff;
            color: white;
            margin-left: 10px;
        }
        .btn-back:hover {
            background-color: #0056b3;
        }
        /* Ticket cut effect */
        .ticket-container::before,
        .ticket-container::after {
            content: "";
            position: absolute;
            width: 20px;
            height: 20px;
            background-color: white;
            border-radius: 50%;
            top: 50%;
            transform: translateY(-50%);
            border: 2px solid #007bff;
        }
        .ticket-container::before {
            left: -10px;
        }
        .ticket-container::after {
            right: -10px;
        }
    </style>
    <script>
        function printTicket() {
            window.print();
        }
    </script>
</head>
<body>
    <div class="ticket-container">
        <div class="ticket-header">Boarding Pass</div>
        <div class="ticket-section">
            <p><span class="label">Passenger:</span> <%= userName %></p>
            <p><span class="label">Flight:</span> <%= flightNumber %></p>
            <p><span class="label">Route:</span> <%= source %> ➝ <%= destination %></p>
            <p><span class="label">Seat(s):</span> <%= seatNumbers %> (<%= totalSeats %> seat(s))</p>
            <p><span class="label">Ticket Number(s):</span> <%= ticketNumbers %></p>
            <p><span class="label">Booking Date:</span> <%= bookingDate %></p>
        </div>
        <div class="ticket-divider"></div>
        <div class="button-container">
            <button class="btn btn-print" onclick="printTicket()">Print Ticket</button>
            <a class="btn btn-back" href="passengerdash.jsp">Back to Dashboard</a>
        </div>
    </div>
</body>
</html>

<%
        } else {
            out.println("<h3 style='color:red;'>No ticket found for this booking.</h3>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h3 style='color:red;'>Error retrieving ticket details.</h3>");
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
