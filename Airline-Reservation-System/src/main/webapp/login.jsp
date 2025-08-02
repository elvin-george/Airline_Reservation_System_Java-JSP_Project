<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login | Airline Reservation</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Poppins', sans-serif;
            background: url("resources/images/plane-desktop.jpg") no-repeat center center fixed;
            background-size: cover;
            display: flex; justify-content: center; align-items: center;
            height: 100vh; text-align: center; color: #333;
        }
        .container {
            background: rgba(255, 255, 255, 0.8); padding: 50px; border-radius: 30px;
            box-shadow: 0 25px 40px rgba(0, 0, 0, 0.15); width: 90%; max-width: 450px;
            backdrop-filter: blur(10px); border: 1px solid rgba(255, 255, 255, 0.5);
        }
        h1 { font-size: 2rem; margin-bottom: 20px; color: #2c3e50; }
        input {
            width: 100%; padding: 12px; margin: 10px 0; border-radius: 8px;
            border: 1px solid #ccc; font-size: 1rem;
        }
        button {
            width: 100%; padding: 12px; background: linear-gradient(45deg, #81ecec, #74b9ff);
            color: #fff; font-size: 1rem; font-weight: bold; border-radius: 50px;
            transition: all 0.3s ease, transform 0.2s ease;
            border: none; cursor: pointer;
        }
        button:hover { background: linear-gradient(45deg, #74b9ff, #81ecec); transform: scale(1.1); }
        .error { color: red; font-size: 0.9rem; }
        body { 
    background: #BCEDFF; /* Light Blue Background */
    padding: 20px;
    color: #0E4A7B; /* Deep Blue Text for contrast */
}
    </style>
</head>
<body>
    <div class="container">
        <h1>🔑 Login</h1>
        <form action="login.jsp" method="post">
            <input type="email" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Login</button>
        </form>
        <p>Don't have an account? <a href="signup.jsp">Sign Up</a></p>
    </div>

    <%
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airline", "root", "root");

                // Corrected query to fetch user_id, user_type
                String sql = "SELECT user_id, user_type, first_name, middle_name, last_name FROM user WHERE email=? AND password=?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, email);
                stmt.setString(2, password);
                rs = stmt.executeQuery();

                if (rs.next()) {
                    int userId = rs.getInt("user_id"); // Fetch user_id
                    String userType = rs.getString("user_type");

                    // Full Name Formatting
                    String fullName = rs.getString("first_name") + " " + 
                                      (rs.getString("middle_name") != null ? rs.getString("middle_name") + " " : "") + 
                                      rs.getString("last_name");

                    // Storing in session
                    session.setAttribute("user_id", userId);  // Store user_id
                    session.setAttribute("userEmail", email);
                    session.setAttribute("userType", userType);
                    session.setAttribute("fullName", fullName);

                    // Redirect based on user type
                    if ("Admin".equalsIgnoreCase(userType)) {
                        response.sendRedirect("admindash.jsp");
                    } else {
                        response.sendRedirect("passengerdash.jsp");
                    }
                    return; // Stop further execution
                } else {
    %>
                    <script>alert("Invalid email or password! Please try again.");</script>
    <%
                }
            } catch (Exception e) {
    %>
                <p class='error'>Error: <%= e.getMessage() %></p>
    <%
            } finally {
                try { if (rs != null) rs.close(); if (stmt != null) stmt.close(); if (conn != null) conn.close(); } catch (SQLException ignored) {}
            }
        }
    %>
</body>
</html>
