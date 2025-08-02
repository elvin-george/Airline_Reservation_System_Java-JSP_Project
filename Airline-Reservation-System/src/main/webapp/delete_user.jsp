<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    int userId = Integer.parseInt(request.getParameter("user_id"));

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airline", "root", "root");

        String sql = "DELETE FROM user WHERE user_id=?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, userId);
        stmt.executeUpdate();

        response.sendRedirect("manage_users.jsp");
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        try { if (stmt != null) stmt.close(); if (conn != null) conn.close(); } catch (SQLException ignored) {}
    }
%>
