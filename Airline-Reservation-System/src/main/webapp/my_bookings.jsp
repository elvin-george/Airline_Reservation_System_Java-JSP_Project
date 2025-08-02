<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // Retrieve user ID from session
    Object userIdObj = session.getAttribute("user_id");
    if (userIdObj == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = (int) userIdObj;
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
    <title>My Bookings | Airline Reservation</title>
    <style>
        body { 
            background: #E3F2FD;
            font-family: 'Poppins', sans-serif;
            padding: 20px;
            color: #0E4A7B;
        }
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
            background: #B90E0A; /* Red color */
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
            background: #990F02; /* Darker Red */
        }
        .container {
            max-width: 900px;
            margin: auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            color: #015C92;
        }
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
            background: #2D82B5;
            color: white;
        }
        .no-data {
            margin-top: 20px;
            text-align: center;
            color: red;
            font-size: 18px;
        }
        .btn-container {
            margin-top: 20px;
            text-align: center;
        }
        .btn {
            background: #2D82B5;
            color: white;
            padding: 10px 20px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            font-size: 16px;
            text-decoration: none;
        }
        .btn:hover {
            background: #015C92;
        }
    </style>
</head>
<body>

    <!-- Navbar Menu -->
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

    <div class="container">
        <h1>My Bookings</h1>

        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

                String query = "SELECT b.booking_id, f.flightnumber, f.source, f.destination, " +
                               "b.booking_date, b.seat_number, b.status " +
                               "FROM bookings b " +
                               "JOIN flights f ON b.flight_id = f.flight_id " +
                               "WHERE b.user_id = ? " +
                               "ORDER BY b.booking_date DESC";

                pst = con.prepareStatement(query);
                pst.setInt(1, userId);
                rs = pst.executeQuery();

                if (!rs.isBeforeFirst()) { // No bookings found
        %>
                    <p class="no-data">No bookings found.</p>
        <%
                } else {
        %>
        <table>
            <tr>
                <th>Booking ID</th>
                <th>Flight Number</th>
                <th>Source</th>
                <th>Destination</th>
                <th>Booking Date</th>
                <th>Seat Number</th>
                <th>Status</th>
            </tr>
        <%
                    while (rs.next()) {
        %>
            <tr>
                <td><%= rs.getInt("booking_id") %></td>
                <td><%= rs.getString("flightnumber") %></td>
                <td><%= rs.getString("source") %></td>
                <td><%= rs.getString("destination") %></td>
                <td><%= rs.getTimestamp("booking_date") %></td>
                <td><%= rs.getString("seat_number") %></td>
                <td><%= rs.getString("status") %></td>
            </tr>
        <%
                    }
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

        <div class="btn-container">
            <a href="passengerdash.jsp" class="btn">Back to Dashboard</a>
        </div>

    </div>

</body>
</html>
