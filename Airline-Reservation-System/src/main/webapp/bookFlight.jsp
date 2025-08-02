<%@ page import="java.sql.*, java.util.*, javax.servlet.http.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Book Your Flight Seat</title>
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

        .flight-container {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .flight-details {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 15px;
            text-align: center;
        }

        .seat-container {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .row {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-bottom: 10px;
        }

        .seat {
            width: 40px;
            height: 40px;
            text-align: center;
            line-height: 40px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
        }

        .available { background-color: green; color: white; }
        .booked { background-color: red; color: white; cursor: not-allowed; }
        .selected { background-color: orange; color: white; }
        .window { border: 2px solid blue; }
        .aisle { width: 30px; background: transparent; }

        .confirm-button {
            background-color: green;
            color: white;
            border: none;
            padding: 15px 30px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            border-radius: 5px;
            margin-top: 20px;
            width: auto;
        }
    </style>
    <script>
        let selectedSeats = [];

        function toggleSeat(seatNumber) {
            let seatElement = document.getElementById("seat-" + seatNumber);
            if (seatElement.classList.contains("booked")) return;

            if (selectedSeats.includes(seatNumber)) {
                selectedSeats = selectedSeats.filter(seat => seat !== seatNumber);
                seatElement.classList.remove("selected");
                seatElement.classList.add("available");
            } else {
                selectedSeats.push(seatNumber);
                seatElement.classList.remove("available");
                seatElement.classList.add("selected");
            }
        }

        function confirmBooking() {
            if (selectedSeats.length === 0) {
                alert("Please select at least one seat!");
                return;
            }

            let flightId = "<%= request.getParameter("flight_id") != null ? request.getParameter("flight_id") : "" %>";
            let userId = "<%= session.getAttribute("user_id") != null ? session.getAttribute("user_id").toString() : "" %>";

            if (flightId === "" || userId === "") {
                alert("Error: Missing flight ID or user ID. Please try again.");
                return;
            }

            let selectedSeatsStr = selectedSeats.join(",");
            
            // Redirecting to payment.jsp with all necessary parameters
            window.location.href = "payment.jsp?flight_id=" + flightId + "&user_id=" + userId + "&seats=" + encodeURIComponent(selectedSeatsStr);
        }

    </script>
</head>
<body>

<%
    String flightIdParam = request.getParameter("flight_id");
    int flightId = 0;

    if (flightIdParam != null && !flightIdParam.isEmpty()) {
        try {
            flightId = Integer.parseInt(flightIdParam);
        } catch (NumberFormatException e) {
            out.println("<p style='color: red;'>Error: Invalid flight ID.</p>");
            return;
        }
    } else {
        out.println("<p style='color: red;'>Error: Flight ID is missing.</p>");
        return;
    }

    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/airline", "root", "root");

        // Get flight details
        pst = con.prepareStatement("SELECT flightnumber, airline_name, source, destination, total_seats FROM flights WHERE flight_id = ?");
        pst.setInt(1, flightId);
        rs = pst.executeQuery();

        String flightNumber = "", airlineName = "", source = "", destination = "";
        int totalSeats = 0;

        if (rs.next()) {
            flightNumber = rs.getString("flightnumber");
            airlineName = rs.getString("airline_name");
            source = rs.getString("source");
            destination = rs.getString("destination");
            totalSeats = rs.getInt("total_seats");
        } else {
            out.println("<p style='color: red;'>Error: Flight not found.</p>");
            return;
        }

        rs.close();
        pst.close();

        // Get booked seats
        Set<Integer> bookedSeats = new HashSet<>();
        pst = con.prepareStatement("SELECT seat_number FROM bookings WHERE flight_id = ?");
        pst.setInt(1, flightId);
        rs = pst.executeQuery();

        while (rs.next()) {
            bookedSeats.add(rs.getInt("seat_number"));
        }
%>

    <div class='flight-container'>
        <div class="flight-details">
            Flight: <%= airlineName %> (<%= flightNumber %>) <br>
            Route: <%= source %> → <%= destination %>
        </div>

        <div class='seat-container'>
<%
        int seatsPerRow = 6;
        int rows = totalSeats / seatsPerRow;
        int leftoverSeats = totalSeats % seatsPerRow;

        for (int i = 1; i <= rows; i++) {
            out.println("<div class='row'>");

            for (int j = 1; j <= seatsPerRow; j++) {
                int seatNumber = ((i - 1) * seatsPerRow) + j;
                String seatClass = bookedSeats.contains(seatNumber) ? "seat booked" : "seat available";
                String windowClass = (j == 1 || j == 6) ? " window" : "";

                if (j == 4) out.println("<div class='aisle'></div>"); // Aisle space
                
                out.println("<div id='seat-" + seatNumber + "' class='" + seatClass + windowClass + "' onclick='toggleSeat(" + seatNumber + ")'>" + seatNumber + "</div>");
            }
            out.println("</div>");
        }

        if (leftoverSeats > 0) {
            out.println("<div class='row'>");
            for (int j = 1; j <= leftoverSeats; j++) {
                int seatNumber = (rows * seatsPerRow) + j;
                String seatClass = bookedSeats.contains(seatNumber) ? "seat booked" : "seat available";
                out.println("<div id='seat-" + seatNumber + "' class='" + seatClass + "' onclick='toggleSeat(" + seatNumber + ")'>" + seatNumber + "</div>");
            }
            out.println("</div>");
        }
%>
        </div>
    </div>

    <button class="confirm-button" onclick="confirmBooking()">Proceed to Payment</button>

<%
    } catch (Exception e) {
        out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) rs.close();
        if (pst != null) pst.close();
        if (con != null) con.close();
    }
%>

</body>
</html>
