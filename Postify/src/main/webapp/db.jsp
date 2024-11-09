<%@page import="java.sql.*" %>
<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/postify";
        String user = "root";  // replace with your MySQL username
        String password = "3012";  // replace with your MySQL password
        Connection conn = DriverManager.getConnection(url, user, password);
        application.setAttribute("dbConnection", conn);  // store the connection in the application scope
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
