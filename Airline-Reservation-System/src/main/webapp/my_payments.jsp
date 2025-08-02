<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // Check if the user is logged in
    String passengerEmail = (String) session.getAttribute("userEmail");
    String userType = (String) session.getAttribute("userType");

    if (passengerEmail == null || !"passenger".equalsIgnoreCase(userType)) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = (int) session.getAttribute("user_id");
    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;
    String jdbcURL = "jdbc:mysql://localhost:3306/airline";
    String dbUser = "root";
    String dbPassword = "root";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Payments | Airline Reservation</title>
    <style>
        * { 
            margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; 
        }

        body { 
            background: #E3F2FD; /* Light Blue Background */
            padding: 20px;
            color: #0E4A7B; /* Deep Blue Text */
        }

        /* Navbar */
        .navbar {
            background: #2D82B5; /* Lighter Blue */
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-radius: 10px;
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
            background: #B91C1C; /* Dark Red */
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
            background: #991B1B;
        }

        /* Container */
        .container {
            margin-top: 20px;
            padding: 30px;
            background: white;
            border-radius: 12px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        h1 {
            color: #015C92; /* Deep Blue */
            font-size: 28px;
        }

        /* Table */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }

        th {
            background: #2D82B5; /* Dark Blue */
            color: white;
        }

        tr:nth-child(even) {
            background: #F3F3F3;
        }

        /* Back Button */
        .back-btn {
            background: #004274; /* Deep Blue */
            color: white;
            padding: 10px 15px;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
            display: inline-block;
            margin-top: 20px;
            transition: all 0.3s ease-in-out;
        }

        .back-btn:hover {
            background: #002A4D;
        }
    </style>
</head>
<body>

    <!-- Navbar -->
    <div class="navbar">
        <div>
            <a href="passengerdash.jsp">Dashboard</a>
            <a href="find_flights.jsp">Search Flights</a>
            <a href="my_bookings.jsp">My Bookings</a>
            <a href="my_payments.jsp">Payments</a>
            <a href="edit_profile.jsp">My Profile</a>
        </div>
        <form action="logout.jsp" method="post">
            <button type="submit" class="logout-btn">Logout</button>
        </form>
    </div>

    <!-- Payments Container -->
    <div class="container">
        <h1>My Payments</h1>

        <table>
            <tr>
                <th>Payment ID</th>
                <th>Flight Number</th>
                <th>Source</th>
                <th>Destination</th>
                <th>Amount Paid (₹)</th>
                <th>Status</th>
                <th>Transaction Date</th>
            </tr>

            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

                    String query = "SELECT p.payment_id, f.flightnumber, f.source, f.destination, " +
                                   "p.amount_paid, p.payment_status, p.transaction_date " +
                                   "FROM payments p " +
                                   "JOIN bookings b ON p.booking_id = b.booking_id " +
                                   "JOIN flights f ON b.flight_id = f.flight_id " +
                                   "WHERE b.user_id = ? " +
                                   "ORDER BY p.transaction_date DESC";

                    pst = con.prepareStatement(query);
                    pst.setInt(1, userId);
                    rs = pst.executeQuery();

                    while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("payment_id") %></td>
                <td><%= rs.getString("flightnumber") %></td>
                <td><%= rs.getString("source") %></td>
                <td><%= rs.getString("destination") %></td>
                <td>₹<%= rs.getDouble("amount_paid") %></td>
                <td><%= rs.getString("payment_status") %></td>
                <td><%= rs.getTimestamp("transaction_date") %></td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) try { rs.close(); } catch (Exception ignored) {}
                    if (pst != null) try { pst.close(); } catch (Exception ignored) {}
                    if (con != null) try { con.close(); } catch (Exception ignored) {}
                }
            %>
        </table>

        <a href="passengerdash.jsp" class="back-btn">Back to Dashboard</a>
    </div>

</body>
</html>
