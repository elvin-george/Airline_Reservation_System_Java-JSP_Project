<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Detailed Report | Admin Panel</title>
    <style>
        * {
            margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif;
        }

        body {
            background: #BCEDFF;
            padding: 20px;
            color: #0E4A7B;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .navbar {
            background: #2D82B5;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-radius: 10px;
            width: 80%;
            max-width: 1000px;
        }

        .navbar a {
            color: white;
            text-decoration: none;
            font-size: 18px;
            margin-right: 15px;
            padding: 10px 15px;
            border-radius: 5px;
            transition: all 0.3s ease-in-out;
        }

        .navbar a:hover {
            background: rgba(255, 255, 255, 0.25);
        }

        .logout-btn {
            background: #B90E0A;
            color: white;
            border: none;
            padding: 10px 15px;
            font-size: 16px;
            font-weight: bold;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s ease-in-out;
        }

        .logout-btn:hover {
            background: #990F02;
        }

        .container {
            width: 80%;
            max-width: 1000px;
            margin-top: 20px;
            padding: 30px;
            background: white;
            border-radius: 12px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        h1, h2, h3 {
            color: #015C92;
            margin-top: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background: #3498db;
            color: white;
        }

        tr:hover {
            background: #f1f1f1;
        }

        .links {
            margin-top: 30px;
        }

        .links a {
            text-decoration: none;
            padding: 10px 15px;
            color: white;
            border-radius: 5px;
            margin-right: 10px;
        }

        .back {
            background: #2ecc71;
        }

        .reports {
            background: #e67e22;
        }
    </style>
</head>
<body>

    <div class="navbar">
        <div>
            <a href="admindash.jsp">Admin Dashboard</a>
            <a href="reports.jsp">Reports</a>
        </div>
        <form action="logout.jsp" method="post">
            <button class="logout-btn" type="submit">Logout</button>
        </form>
    </div>

    <div class="container">
        <h1>Detailed Report</h1>

        <%
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            int totalBookings = 0;
            int availableSeats = 0;
            double totalRevenue = 0.0;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airline", "root", "root");

                // Total Bookings
                stmt = conn.prepareStatement("SELECT COUNT(*) AS total FROM bookings");
                rs = stmt.executeQuery();
                if (rs.next()) {
                    totalBookings = rs.getInt("total");
                }
                rs.close();
                stmt.close();

                // Total Revenue
                stmt = conn.prepareStatement("SELECT SUM(amount_paid) AS revenue FROM payments WHERE payment_status = 'Completed'");
                rs = stmt.executeQuery();
                if (rs.next()) {
                    totalRevenue = rs.getDouble("revenue");
                }
                rs.close();
                stmt.close();

                // Available Seats
                stmt = conn.prepareStatement("SELECT SUM(available_seats) AS seats FROM flights");
                rs = stmt.executeQuery();
                if (rs.next()) {
                    availableSeats = rs.getInt("seats");
                }
                rs.close();
                stmt.close();
        %>

        <table>
            <tr>
                <th>Total Bookings</th>
                <th>Available Seats</th>
            </tr>
            <tr>
                <td><%= totalBookings %></td>
                <td><%= availableSeats %></td>
            </tr>
        </table>

        <h2>Recent Bookings</h2>
        <table>
            <tr>
                <th>Booking ID</th>
                <th>User ID</th>
                <th>Flight ID</th>
                <th>Seat Number</th>
                <th>Status</th>
            </tr>
            <%
                stmt = conn.prepareStatement("SELECT * FROM bookings ORDER BY booking_date DESC LIMIT 10");
                rs = stmt.executeQuery();
                while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("booking_id") %></td>
                <td><%= rs.getInt("user_id") %></td>
                <td><%= rs.getInt("flight_id") %></td>
                <td><%= rs.getInt("seat_number") %></td>
                <td><%= rs.getString("status") %></td>
            </tr>
            <%
                }
                rs.close();
                stmt.close();
            %>
        </table>

        <h2>Recent Payments</h2>
        <table>
            <tr>
                <th>Payment ID</th>
                <th>Booking ID</th>
                <th>Amount Paid</th>
                <th>Payment Status</th>
                <th>Transaction Date</th>
            </tr>
            <%
                stmt = conn.prepareStatement("SELECT * FROM payments ORDER BY transaction_date DESC LIMIT 10");
                rs = stmt.executeQuery();
                while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("payment_id") %></td>
                <td><%= rs.getInt("booking_id") %></td>
                <td>₹<%= rs.getDouble("amount_paid") %></td>
                <td><%= rs.getString("payment_status") %></td>
                <td><%= rs.getDate("transaction_date") %></td>
            </tr>
            <%
                }
                rs.close();
                stmt.close();
            %>

        <h2>Flight-wise Booking Details</h2>

        <%
            stmt = conn.prepareStatement("SELECT DISTINCT flight_id FROM bookings ORDER BY flight_id");
            rs = stmt.executeQuery();
            while (rs.next()) {
                int flightId = rs.getInt("flight_id");

                // Get flight details
                PreparedStatement flightStmt = conn.prepareStatement("SELECT flightnumber, airline_name FROM flights WHERE flight_id = ?");
                flightStmt.setInt(1, flightId);
                ResultSet flightRs = flightStmt.executeQuery();
                String flightNumber = "", airlineName = "";
                if (flightRs.next()) {
                    flightNumber = flightRs.getString("flightnumber");
                    airlineName = flightRs.getString("airline_name");
                }
                flightRs.close();
                flightStmt.close();
        %>

        <h3>Flight: <%= flightNumber %> | <%= airlineName %> (ID: <%= flightId %>)</h3>
        <table>
            <tr>
                <th>Booking ID</th>
                <th>Passenger Name</th>
                <th>Seat Number</th>
                <th>Booking Date</th>
                <th>Status</th>
            </tr>
            <%
                PreparedStatement bookingStmt = conn.prepareStatement(
                    "SELECT b.booking_id, u.first_name, u.last_name, b.seat_number, b.booking_date, b.status " +
                    "FROM bookings b JOIN user u ON b.user_id = u.user_id WHERE b.flight_id = ?");
                bookingStmt.setInt(1, flightId);
                ResultSet bookingRs = bookingStmt.executeQuery();
                while (bookingRs.next()) {
            %>
            <tr>
                <td><%= bookingRs.getInt("booking_id") %></td>
                <td><%= bookingRs.getString("first_name") %> <%= bookingRs.getString("last_name") %></td>
                <td><%= bookingRs.getInt("seat_number") %></td>
                <td><%= bookingRs.getDate("booking_date") %></td>
                <td><%= bookingRs.getString("status") %></td>
            </tr>
            <%
                }
                bookingRs.close();
                bookingStmt.close();
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        %>
        </table>

        <div class="links">
            <a href="admindash.jsp" class="back">Back to Dashboard</a>
            <a href="reports.jsp" class="reports">View Summary Reports</a>
        </div>
    </div>
</body>
</html>
