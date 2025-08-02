<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reports | Admin Panel</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f4f4;
            display: flex; flex-direction: column; align-items: center;
            padding: 20px;
        }
        .container {
            width: 80%; max-width: 1000px;
            background: white; padding: 20px; border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        h1 { text-align: center; margin-bottom: 20px; }
        table {
            width: 100%; border-collapse: collapse;
        }
        th, td {
            padding: 10px; text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th { background: #3498db; color: white; }
        tr:hover { background: #f1f1f1; }
        .action-btns a {
            padding: 5px 10px; margin-right: 5px;
            text-decoration: none; color: white; border-radius: 5px;
        }
        .details { background: #2ecc71; }
        .dashboard-link, .detailed-report {
            display: inline-block; margin: 10px 5px; padding: 10px 15px;
            text-decoration: none; border-radius: 5px; color: white;
        }
        .dashboard-link { background: #3498db; }
        .detailed-report { background: #e67e22; }
            <style>
* { 
    margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; 
}

body { 
    background: #BCEDFF; /* Light Blue Background */
    padding: 20px;
    color: #0E4A7B; /* Deep Blue Text for contrast */
}

/* Navbar Styling */
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
    background: #B90E0A; /* Lighter Blue */
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
    background: #990F02; /* Darker Blue */
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

p {
    font-size: 18px;
    color: #2D6B25; /* Dark Green Accent */
}

    </style>
</head>
<body>
    <div class="container">
        <h1>Reports</h1>
        
        <!-- Navigation Links -->
        <a href="admindash.jsp" class="dashboard-link">Back to Dashboard</a>
        <a href="detailed_report.jsp" class="detailed-report">View Detailed Report</a>
        
        <h2>Bookings Overview</h2>
        <table>
            <tr>
                <th>Booking ID</th>
                <th>User ID</th>
                <th>Flight ID</th>
                <th>Booking Date</th>
                <th>Seat Number</th>
                <th>Status</th>
            </tr>
            <%
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airline", "root", "root");
                    
                    String sql = "SELECT * FROM bookings";
                    stmt = conn.prepareStatement(sql);
                    rs = stmt.executeQuery();
                    
                    while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("booking_id") %></td>
                <td><%= rs.getInt("user_id") %></td>
                <td><%= rs.getInt("flight_id") %></td>
                <td><%= rs.getDate("booking_date") %></td>
                <td><%= rs.getInt("seat_number") %></td>
                <td><a href="manage_bookings.jsp" class="details"><%= rs.getString("status") %></a></td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try { if (rs != null) rs.close(); if (stmt != null) stmt.close(); if (conn != null) conn.close(); } catch (SQLException ignored) {}
                }
            %>
        </table>

        <h2>Payments Overview</h2>
        <table>
            <tr>
                <th>Payment ID</th>
                <th>Booking ID</th>
                <th>Amount Paid</th>
                <th>Payment Status</th>
                <th>Transaction Date</th>
            </tr>
            <%
                try {
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airline", "root", "root");
                    String sqlPayments = "SELECT * FROM payments";
                    stmt = conn.prepareStatement(sqlPayments);
                    rs = stmt.executeQuery();
                    
                    while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("payment_id") %></td>
                <td><%= rs.getInt("booking_id") %></td>
                <td><%= rs.getDouble("amount_paid") %></td>
                <td><a href="manage_payments.jsp" class="details"><%= rs.getString("payment_status") %></a></td>
                <td><%= rs.getDate("transaction_date") %></td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try { if (rs != null) rs.close(); if (stmt != null) stmt.close(); if (conn != null) conn.close(); } catch (SQLException ignored) {}
                }
            %>
        </table>
    </div>
</body>
</html>
