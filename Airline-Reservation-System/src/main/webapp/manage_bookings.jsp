<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Bookings | Admin Panel</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }

        body {
            background: #BCEDFF;
            padding: 20px;
            color: #0E4A7B;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .top-controls {
            width: 80%;
            max-width: 1000px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .btn {
            padding: 10px 15px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            font-size: 16px;
            transition: 0.3s ease;
        }

        .btn:hover {
            background-color: #0056b3;
        }

        .search-bar {
            display: flex;
            gap: 10px;
        }

        .search-bar input[type="text"] {
            padding: 10px;
            font-size: 16px;
            width: 250px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        .search-bar input[type="submit"] {
            padding: 10px 15px;
            background-color: #2D82B5;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            transition: 0.3s ease;
        }

        .search-bar input[type="submit"]:hover {
            background-color: #015C92;
        }

        .container {
            width: 80%;
            max-width: 1000px;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
        }

        h1 {
            color: #015C92;
            font-size: 28px;
            text-align: center;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
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

        .action-btns a {
            padding: 5px 10px;
            margin-right: 5px;
            text-decoration: none;
            color: white;
            border-radius: 5px;
        }

        .edit {
            background: #2ecc71;
        }

        .delete {
            background: #e74c3c;
        }
    </style>
</head>
<body>

    <!-- Top Controls: Back + Search -->
    <div class="top-controls">
        <a href="admindash.jsp" class="btn">← Back to Dashboard</a>
        <form class="search-bar" method="get">
            <input type="text" name="search" placeholder="Search by Booking ID, User ID or Flight ID" value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
            <input type="submit" value="Search">
        </form>
    </div>

    <div class="container">
        <h1>Manage Bookings</h1>
        <table>
            <tr>
                <th>Booking ID</th>
                <th>User ID</th>
                <th>Flight ID</th>
                <th>Booking Date</th>
                <th>Seat Number</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
            <%
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;
                String searchTerm = request.getParameter("search");

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airline", "root", "root");

                    String sql;
                    if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                        sql = "SELECT * FROM bookings WHERE CAST(booking_id AS CHAR) LIKE ? OR CAST(user_id AS CHAR) LIKE ? OR CAST(flight_id AS CHAR) LIKE ?";
                        stmt = conn.prepareStatement(sql);
                        String searchPattern = "%" + searchTerm + "%";
                        stmt.setString(1, searchPattern);
                        stmt.setString(2, searchPattern);
                        stmt.setString(3, searchPattern);
                    } else {
                        sql = "SELECT * FROM bookings";
                        stmt = conn.prepareStatement(sql);
                    }

                    rs = stmt.executeQuery();

                    while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("booking_id") %></td>
                <td><%= rs.getInt("user_id") %></td>
                <td><%= rs.getInt("flight_id") %></td>
                <td><%= rs.getDate("booking_date") %></td>
                <td><%= rs.getInt("seat_number") %></td>
                <td><%= rs.getString("status") %></td>
                <td class="action-btns">
                    <a href="edit_booking.jsp?booking_id=<%= rs.getInt("booking_id") %>" class="edit">Edit</a>
                    <a href="delete_booking.jsp?booking_id=<%= rs.getInt("booking_id") %>" class="delete" onclick="return confirm('Are you sure you want to delete this booking?');">Delete</a>
                </td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
            %>
                <tr><td colspan="7" style="color:red;">Error fetching bookings!</td></tr>
            <%
                } finally {
                    try { if (rs != null) rs.close(); if (stmt != null) stmt.close(); if (conn != null) conn.close(); } catch (SQLException ignored) {}
                }
            %>
        </table>
    </div>
</body>
</html>
