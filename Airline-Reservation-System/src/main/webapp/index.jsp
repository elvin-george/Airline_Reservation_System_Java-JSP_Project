<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Landing Page | Airline Reservation System</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #fdfbfb, #ebedee, #e0f7fa, #f5f7fa);
            background-size: 400% 400%;
            animation: gradientBG 12s ease infinite;
            display: flex; justify-content: center; align-items: center;
            height: 100vh; text-align: center; color: #333;
        }
        @keyframes gradientBG {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        .container {
            background: rgba(255, 255, 255, 0.8); padding: 70px 60px; border-radius: 30px;
            box-shadow: 0 25px 40px rgba(0, 0, 0, 0.15); width: 95%; max-width: 650px;
            backdrop-filter: blur(10px); border: 1px solid rgba(255, 255, 255, 0.5);
            transition: transform 0.3s ease;
        }
        .container:hover {
            transform: scale(1.02); box-shadow: 0 30px 50px rgba(0, 0, 0, 0.2);
        }
        h1 {
            font-size: 3rem; margin-bottom: 20px; color: #2c3e50;
            text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.2);
        }
        p {
            font-size: 1.3rem; margin-bottom: 40px; color: #4a4a4a;
        }
        .login-btn {
            display: inline-block; text-decoration: none; padding: 16px 45px;
            background: linear-gradient(45deg, #81ecec, #74b9ff);
            color: #fff; font-size: 1.2rem; font-weight: bold; border-radius: 50px;
            box-shadow: 0 15px 30px rgba(116, 185, 255, 0.4);
            transition: all 0.3s ease, transform 0.2s ease;
        }
        .login-btn:hover {
            background: linear-gradient(45deg, #74b9ff, #81ecec);
            transform: scale(1.15); box-shadow: 0 20px 35px rgba(116, 185, 255, 0.6);
        }
        footer {
            margin-top: 35px; font-size: 1rem; color: #636e72;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>✈ Airline Reservation System</h1>
        <p>Access your account to book, search, or manage your flights with ease.</p>
        <a href="login.jsp" class="login-btn">🔑 Login</a>
        <footer>&copy; 2025 Airline Reservation System | All Rights Reserved</footer>
    </div>
</body>
</html>