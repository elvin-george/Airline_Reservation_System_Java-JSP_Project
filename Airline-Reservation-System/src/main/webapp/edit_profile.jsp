<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page session="true" %>

<%
    if (session.getAttribute("user_id") == null) {
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

    String firstName = "", middleName = "", lastName = "", phone = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
        String userQuery = "SELECT first_name, middle_name, last_name, phone FROM user WHERE user_id = ?";
        pst = con.prepareStatement(userQuery);
        pst.setInt(1, userId);
        rs = pst.executeQuery();

        if (rs.next()) {
            firstName = rs.getString("first_name");
            middleName = rs.getString("middle_name") != null ? rs.getString("middle_name") : "";
            lastName = rs.getString("last_name");
            phone = rs.getString("phone");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (pst != null) try { pst.close(); } catch (Exception ignored) {}
        if (con != null) try { con.close(); } catch (Exception ignored) {}
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Profile | Airline Reservation</title>
    <style>
        body {
    font-family: 'Poppins', sans-serif;
    background: #E3F2FD; /* Light Sky Blue */
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-top: 50px;
}
body { 
    background: #BCEDFF; /* Light Blue Background */
    padding: 20px;
    color: #0E4A7B; /* Deep Blue Text for contrast */
}
.container {
    width: 400px;
    background: white;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 0 10px rgba(0,0,0,0.1);
}
.form-group {
    margin-bottom: 15px;
}
label {
    display: block;
    font-weight: bold;
}
input {
    width: 100%;
    padding: 8px;
    margin-top: 5px;
    border: 1px solid #ddd;
    border-radius: 5px;
}
button {
    background: #004274; /* Deep Blue */
    color: white;
    padding: 10px;
    border: none;
    cursor: pointer;
    width: 100%;
    border-radius: 5px;
    transition: all 0.3s ease-in-out;
}
button:hover {
    background: #002A4D; /* Darker Blue */
}
.back-button {
    background: #B91C1C; /* Dark Red */
    margin-top: 10px;
}
.back-button:hover {
    background: #991B1B; /* Darker Red */
}

    </style>
</head>
<body>
    <div class="container">
        <h2>Edit Profile</h2>
        <form action="update_profile.jsp" method="post">
            <div class="form-group">
                <label>First Name:</label>
                <input type="text" name="first_name" value="<%= firstName %>" required>
            </div>
            <div class="form-group">
                <label>Middle Name:</label>
                <input type="text" name="middle_name" value="<%= middleName %>">
            </div>
            <div class="form-group">
                <label>Last Name:</label>
                <input type="text" name="last_name" value="<%= lastName %>" required>
            </div>
            <div class="form-group">
                <label>Phone:</label>
                <input type="text" name="phone" value="<%= phone %>" required>
            </div>
            <button type="submit">Update Profile</button>
        </form>
        <button class="back-button" onclick="window.location.href='passengerdash.jsp'">Back to Dashboard</button>
    </div>
</body>
</html>