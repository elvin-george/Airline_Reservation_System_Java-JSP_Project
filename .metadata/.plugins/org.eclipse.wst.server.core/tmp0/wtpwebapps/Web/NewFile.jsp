<%@ page import="java.sql.*" %>
<%@ page import="java.util.logging.Level, java.util.logging.Logger" %>
<html>
<head>
    <title>Customer Records</title>
</head>
<body>
    <h2>Customer Records</h2>
    <%
        String URL = "jdbc:mysql://localhost:3306/e";
        String USER = "root";
        String PASSWORD = "root";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
                 Statement st = con.createStatement()) {
                out.println("<p>Connection successful!</p>");

                // Clearing and inserting data
                st.executeUpdate("DELETE FROM customer_tbl;");
                st.executeUpdate("INSERT INTO customer_tbl VALUES (102, 'Fathima', 'Panthalakattu House', 96784644);");
                st.executeUpdate("INSERT INTO customer_tbl VALUES (103, 'Elvin', 'St George House', 746723547);");
                st.executeUpdate("INSERT INTO customer_tbl VALUES (104, 'Elona', 'Elona House', 836428745);");
                st.executeUpdate("INSERT INTO customer_tbl VALUES (105, 'Jacob', 'Johnson House', 527562756);");
                st.executeUpdate("INSERT INTO customer_tbl VALUES (106, 'Sathish', 'Thoman House', 98754366);");
                
                // Fetch and display all records
                out.println("<h3>All Customers:</h3>");
                out.println("<table border='1'><tr><th>ID</th><th>Name</th><th>Address</th><th>Phone</th></tr>");
                try (ResultSet rs = st.executeQuery("SELECT * FROM customer_tbl")) {
                    while (rs.next()) {
                        out.println("<tr><td>" + rs.getInt("customer_id") + "</td>"
                                + "<td>" + rs.getString("name") + "</td>"
                                + "<td>" + rs.getString("address") + "</td>"
                                + "<td>" + rs.getInt("phone") + "</td></tr>");
                    }
                }
                out.println("</table>");
                
                // Fetch and display customers with names starting with 'S'
                out.println("<h3>Customers whose names start with 'S':</h3>");
                out.println("<table border='1'><tr><th>ID</th><th>Name</th><th>Address</th><th>Phone</th></tr>");
                try (ResultSet rs = st.executeQuery("SELECT * FROM customer_tbl WHERE name LIKE 'S%';")) {
                    while (rs.next()) {
                        out.println("<tr><td>" + rs.getInt("customer_id") + "</td>"
                                + "<td>" + rs.getString("name") + "</td>"
                                + "<td>" + rs.getString("address") + "</td>"
                                + "<td>" + rs.getInt("phone") + "</td></tr>");
                    }
                }
                out.println("</table>");
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger("JSPPage").log(Level.SEVERE, "JDBC Driver not found", ex);
            out.println("<p>Error: JDBC Driver not found</p>");
        } catch (SQLException ex) {
            Logger.getLogger("JSPPage").log(Level.SEVERE, "SQL Exception", ex);
            out.println("<p>Error: SQL Exception</p>");
        }
    %>
</body>
</html>
