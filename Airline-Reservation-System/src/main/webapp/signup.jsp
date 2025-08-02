<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sign Up | Airline Reservation</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #fdfbfb, #ebedee, #e0f7fa, #f5f7fa);
            display: flex; justify-content: center; align-items: center;
            height: 100vh; text-align: center; color: #333;
        }
        .container {
            background: rgba(255, 255, 255, 0.8); padding: 50px; border-radius: 30px;
            box-shadow: 0 25px 40px rgba(0, 0, 0, 0.15); width: 90%; max-width: 500px;
            backdrop-filter: blur(10px); border: 1px solid rgba(255, 255, 255, 0.5);
        }
        h1 { font-size: 2rem; margin-bottom: 20px; color: #2c3e50; }
        input, select {
            width: 100%; padding: 12px; margin: 10px 0; border-radius: 8px;
            border: 1px solid #ccc; font-size: 1rem;
        }
        button {
            width: 100%; padding: 12px; background: linear-gradient(45deg, #81ecec, #74b9ff);
            color: #fff; font-size: 1rem; font-weight: bold; border-radius: 50px;
            transition: all 0.3s ease, transform 0.2s ease;
            border: none; cursor: pointer;
        }
        button:hover {
            background: linear-gradient(45deg, #74b9ff, #81ecec);
            transform: scale(1.1);
        }
        .error { color: red; font-size: 0.9rem; }
    </style>
    <script>
    function validateForm() {
        let email = document.getElementById("email").value;
        let confirmEmail = document.getElementById("confirm_email").value;
        let password = document.getElementById("password").value;
        let confirmPassword = document.getElementById("confirm_password").value;
        let userType = document.getElementById("user_type").value;
        let phone = document.getElementById("phone").value;

        if (email !== confirmEmail) {
            document.getElementById("email_error").innerText = "Emails do not match!";
            return false;
        } else {
            document.getElementById("email_error").innerText = "";
        }

        if (password !== confirmPassword) {
            document.getElementById("password_error").innerText = "Passwords do not match!";
            return false;
        } else {
            document.getElementById("password_error").innerText = "";
        }

        if (userType === "") {
            document.getElementById("user_type_error").innerText = "Please select a user type!";
            return false;
        } else {
            document.getElementById("user_type_error").innerText = "";
        }

        // Phone number validation: 10 digits only
        let phonePattern = /^\d{10}$/;
        if (!phonePattern.test(phone)) {
            document.getElementById("phone_error").innerText = "Phone number must be exactly 10 digits!";
            return false;
        } else {
            document.getElementById("phone_error").innerText = "";
        }

        return true;
    }

    </script>
</head>
<body>
    <div class="container">
        <h1>📝 Sign Up</h1>
        <form action="signup.jsp" method="post" onsubmit="return validateForm()">
            <input type="text" name="first_name" placeholder="First Name" required>
            <input type="text" name="middle_name" placeholder="Middle Name">
            <input type="text" name="last_name" placeholder="Last Name" required>
            <input type="email" name="email" id="email" placeholder="Email" required>
            <input type="email" name="confirm_email" id="confirm_email" placeholder="Confirm Email" required>
            <span class="error" id="email_error"></span>
            <input type="password" name="password" id="password" placeholder="Password" required>
            <input type="password" name="confirm_password" id="confirm_password" placeholder="Confirm Password" required>
            <span class="error" id="password_error"></span>
            <input type="text" name="phone" placeholder="Phone" required>
            <select name="user_type" id="user_type" required>
                <option value="">Select User Type</option>
                <option value="Passenger">Passenger</option>
                <option value="Admin">Admin</option>
            </select>
            <span class="error" id="user_type_error"></span>
            <button type="submit">Sign Up</button>
        </form>
        <p>Already have an account? <a href="login.jsp">Login</a></p>
    </div>

    <% 
        if (request.getMethod().equalsIgnoreCase("post")) {
            String firstName = request.getParameter("first_name");
            String middleName = request.getParameter("middle_name");
            String lastName = request.getParameter("last_name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");
            String userType = request.getParameter("user_type");

            Connection conn = null;
            PreparedStatement stmt = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airline", "root", "root");
                String sql = "INSERT INTO user (first_name, middle_name, last_name, email, password, phone, user_type) VALUES (?, ?, ?, ?, ?, ?, ?)";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, firstName);
                stmt.setString(2, middleName);
                stmt.setString(3, lastName);
                stmt.setString(4, email);
                stmt.setString(5, password);
                stmt.setString(6, phone);
                stmt.setString(7, userType);

                int rowsInserted = stmt.executeUpdate();
                if (rowsInserted > 0) {
    %>
                    <script>alert("Sign-up successful! Redirecting to login page."); window.location.href = "login.jsp";</script>
    <%
                }
            } catch (Exception e) {
    %>
                <p class='error'>Error: <%= e.getMessage() %></p>
    <%
            } finally {
                try { if (stmt != null) stmt.close(); if (conn != null) conn.close(); } catch (SQLException ignored) {}
            }
        }
    %>
</body>
</html>
