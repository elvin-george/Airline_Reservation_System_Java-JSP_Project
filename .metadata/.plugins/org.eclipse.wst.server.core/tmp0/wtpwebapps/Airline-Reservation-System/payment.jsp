<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.*" %>
<%
    if (session.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if session is lost
        return;
    }
%>

<%
    // Database connection details
    String jdbcURL = "jdbc:mysql://localhost:3306/airline";
    String dbUser = "root";
    String dbPassword = "root";

    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    // Get session user_id
    Integer userId = (Integer) session.getAttribute("user_id");
    String flightIdParam = request.getParameter("flight_id");
    String seatsParam = request.getParameter("seats");

    if (userId == null || flightIdParam == null || seatsParam == null) {
        out.println("<h3>Error: Missing required details!</h3>");
        return;
    }

    int flightId = Integer.parseInt(flightIdParam);
    String[] selectedSeats = seatsParam.split(",");
    int ticketCount = selectedSeats.length;

    String flightNumber = "", source = "", destination = "";
    double pricePerTicket = 0.0;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

        // Fetch flight details
        String sql = "SELECT flightnumber, source, destination, price FROM flights WHERE flight_id = ?";
        pst = con.prepareStatement(sql);
        pst.setInt(1, flightId);
        rs = pst.executeQuery();

        if (rs.next()) {
            flightNumber = rs.getString("flightnumber");
            source = rs.getString("source");
            destination = rs.getString("destination");
            pricePerTicket = rs.getDouble("price");
        }

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h3>Error: " + e.getMessage() + "</h3>");
    } finally {
        try {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Calculate total amount
    double totalAmount = pricePerTicket * ticketCount;
    DecimalFormat df = new DecimalFormat("#,##0.00");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment</title>
    <style>
    body {
        display: flex;
        justify-content: center;
        align-items: center;
        background-color: lightblue;
        margin: 0;
        height: 100vh;
        flex-direction: column;
    }
    .container {
        display: flex;
        width: 60%;
        background-color: #fff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.2);
    }
    .flight-details {
        flex: 1;
        padding: 20px;
        background-color: #fff;
        border-right: 2px solid #ddd;
    }
    .payment-box {
        flex: 1;
        padding: 20px;
        background-color: #fff;
    }
    h2 {
        color: #333;
        margin-bottom: 10px;
    }
    .info {
        font-size: 16px;
        margin-bottom: 8px;
    }
    .payment-box input {
        width: 100%;
        padding: 10px;
        margin-top: 8px;
        margin-bottom: 15px;
        border: 1px solid #ccc;
        border-radius: 5px;
        font-size: 16px;
    }
    .btn-pay {
        background-color: #007bff;
        color: white;
        border: none;
        padding: 12px;
        width: 100%;
        font-size: 16px;
        border-radius: 5px;
        cursor: pointer;
        transition: 0.3s;
    }
    .btn-pay:hover {
        background-color: #0056b3;
    }
</style>
</head>
<body>

    <div class="container">
        <!-- Flight & Ticket Details -->
        <div class="flight-details">
            <h2>Flight Details</h2>
            <p class="info"><strong>Flight Number:</strong> <%= flightNumber %></p>
            <p class="info"><strong>From:</strong> <%= source %></p>
            <p class="info"><strong>To:</strong> <%= destination %></p>
            <p class="info"><strong>Tickets:</strong> <%= ticketCount %></p>
            <p class="info"><strong>Seats:</strong> <%= seatsParam %></p>
            <p class="info"><strong>Price Per Ticket:</strong> Rs: <%= df.format(pricePerTicket) %></p>
            <p class="info"><strong>Total Amount:</strong> Rs: <%= df.format(totalAmount) %></p>
        </div>

        <!-- Payment Form -->
        <div class="payment-box">
            <h2>Payment Details</h2>
            <form action="confirmBooking.jsp" method="post" onsubmit="return validatePayment()">
                <input type="hidden" name="user_id" value="<%= userId %>">
                <input type="hidden" name="flight_id" value="<%= flightId %>">
                <input type="hidden" name="seats" value="<%= seatsParam %>">
                <input type="hidden" name="amount" value="<%= (int) totalAmount %>">

                <label>Card Number</label>
                <input type="text" name="card_number" maxlength="16" placeholder="Enter 16-digit card number" required oninput="this.value=this.value.replace(/[^0-9]/g,'');">

                <label>ATM PIN</label>
                <input type="password" name="atm_pin" maxlength="4" placeholder="Enter 4-digit PIN" required oninput="this.value=this.value.replace(/[^0-9]/g,'');">

                <button type="submit" class="btn-pay">Pay Rs: <%= df.format(totalAmount) %></button>
            </form>
        </div>
    </div>

    <script>
        function validatePayment() {
            let cardNumber = document.getElementsByName("card_number")[0].value;
            let atmPin = document.getElementsByName("atm_pin")[0].value;

            if (cardNumber.length !== 16) {
                alert("Card number must be exactly 16 digits.");
                return false;
            }
            if (atmPin.length !== 4) {
                alert("ATM PIN must be exactly 4 digits.");
                return false;
            }
            return true;
        }
    </script>

</body>
</html> 
