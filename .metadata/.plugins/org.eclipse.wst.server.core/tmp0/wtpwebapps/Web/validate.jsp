<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    // Simple hardcoded authentication (Replace this with database check)
    if ("user".equals(username) && "pass123".equals(password)) {
        // Store the user session
        session.setAttribute("username", username);
        response.sendRedirect("cart.jsp"); // Redirect to shopping cart page
    } else {
%>
        <h3 style="color:red;">Invalid username or password! Try again.</h3>
        <a href="login.jsp">Go back to login</a>
<%
    }
%>
