<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    int userId = Integer.parseInt(request.getParameter("user_id"));
    String firstName = request.getParameter("first_name");
    String middleName = request.getParameter("middle_name");
    String lastName = request.getParameter("last_name");
    String email = request.getParameter("email");
    String userType = request.getParameter("user_type");

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airline", "root", "root");

        String sql = "UPDATE user SET first_name=?, middle_name=?, last_name=?, email=?, user_type=? WHERE user_id=?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, firstName);
        stmt.setString(2, middleName);
        stmt.setString(3, lastName);
        stmt.setString(4, email);
        stmt.setString(5, userType);
        stmt.setInt(6, userId);
        stmt.executeUpdate();

        response.sendRedirect("manage_users.jsp");
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        try { if (stmt != null) stmt.close(); if (conn != null) conn.close(); } catch (SQLException ignored) {}
    }
%>
