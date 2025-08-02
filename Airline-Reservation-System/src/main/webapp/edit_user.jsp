<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit User | Admin Panel</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f4f4;
            text-align: center;
        }
        form {
            width: 50%;
            margin: 50px auto;
            padding: 20px;
            background: white;
            box-shadow: 0px 0px 10px rgba(0,0,0,0.1);
            border-radius: 10px;
        }
        input, select {
            width: 90%;
            padding: 10px;
            margin: 10px 0;
        }
        button {
            background: #007bff;
            color: white;
            padding: 10px;
            border: none;
            cursor: pointer;
        }
    </style>
</head>
<body>

<h2>Edit User</h2>

<%
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    int userId = Integer.parseInt(request.getParameter("user_id"));
    String firstName = "", middleName = "", lastName = "", email = "", userType = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airline", "root", "root");

        String sql = "SELECT * FROM user WHERE user_id=?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, userId);
        rs = stmt.executeQuery();

        if (rs.next()) {
            firstName = rs.getString("first_name");
            middleName = rs.getString("middle_name");
            lastName = rs.getString("last_name");
            email = rs.getString("email");
            userType = rs.getString("user_type");
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        try { if (rs != null) rs.close(); if (stmt != null) stmt.close(); if (conn != null) conn.close(); } catch (SQLException ignored) {}
    }
%>

<form action="update_user.jsp" method="post">
    <input type="hidden" name="user_id" value="<%= userId %>">
    <input type="text" name="first_name" value="<%= firstName %>" required>
    <input type="text" name="middle_name" value="<%= middleName %>">
    <input type="text" name="last_name" value="<%= lastName %>" required>
    <input type="email" name="email" value="<%= email %>" required>
    <select name="user_type">
        <option value="admin" <%= userType.equals("admin") ? "selected" : "" %>>Admin</option>
        <option value="passenger" <%= userType.equals("passenger") ? "selected" : "" %>>Passenger</option>
    </select>
    <button type="submit">Update</button>
</form>

</body>
</html>
