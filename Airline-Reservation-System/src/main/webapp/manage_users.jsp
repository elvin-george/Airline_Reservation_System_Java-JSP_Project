<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Users | Admin Panel</title>
    <style>
        body { 
            font-family: Arial, sans-serif;
            background: #BCEDFF;
            color: #0E4A7B;
            text-align: center;
            padding: 20px;
        }
        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            background: white;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
        }
        th {
            background: #007bff;
            color: white;
        }
        .btn {
            padding: 8px 12px;
            text-decoration: none;
            border-radius: 4px;
            border: none;
            cursor: pointer;
        }
        .btn-blue {
            background-color: #007bff;
            color: white;
        }
        .btn-blue:hover {
            background-color: #0056b3;
        }
        .top-controls {
            width: 80%;
            margin: 20px auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .search-form input[type="text"] {
            padding: 8px;
            width: 200px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
    </style>
</head>
<body>

<h2>Manage Users</h2>

<!-- Back Button + Search Form -->
<div class="top-controls">
    <div>
        <a href="admindash.jsp" class="btn btn-blue">← Back to Dashboard</a>
    </div>
    <div class="search-form">
        <form method="get" action="manage_users.jsp">
            <input type="text" name="searchQuery" placeholder="Search Users...">
            <button type="submit" class="btn btn-blue">Search</button>
        </form>
    </div>
</div>

<table>
    <tr>
        <th>User ID</th>
        <th>First Name</th>
        <th>Middle Name</th>
        <th>Last Name</th>
        <th>Email</th>
        <th>User Type</th>
    </tr>

    <%
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airline", "root", "root");

            String searchQuery = request.getParameter("searchQuery");
            String sql = "SELECT user_id, first_name, middle_name, last_name, email, user_type FROM user WHERE user_type != 'admin'";
            
            if (searchQuery != null && !searchQuery.trim().equals("")) {
                sql += " AND (first_name LIKE ? OR middle_name LIKE ? OR last_name LIKE ? OR email LIKE ?)";
            }

            stmt = conn.prepareStatement(sql);
            
            if (searchQuery != null && !searchQuery.trim().equals("")) {
                String pattern = "%" + searchQuery + "%";
                stmt.setString(1, pattern);
                stmt.setString(2, pattern);
                stmt.setString(3, pattern);
                stmt.setString(4, pattern);
            }

            rs = stmt.executeQuery();

            while (rs.next()) {
    %>
    <tr>
        <td><%= rs.getInt("user_id") %></td>
        <td><%= rs.getString("first_name") %></td>
        <td><%= rs.getString("middle_name") %></td>
        <td><%= rs.getString("last_name") %></td>
        <td><%= rs.getString("email") %></td>
        <td><%= rs.getString("user_type") %></td>
    </tr>
    <%
            }
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        } finally {
            try { if (rs != null) rs.close(); if (stmt != null) stmt.close(); if (conn != null) conn.close(); } catch (SQLException ignored) {}
        }
    %>
</table>

</body>
</html>
