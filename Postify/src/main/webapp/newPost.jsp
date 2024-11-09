<%@ include file="db.jsp" %>
<%@ page import="java.sql.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Post</title>
    <!-- Bootstrap CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">Postify</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ml-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="logout.jsp">Logout</a> <!-- Logout Button -->
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h2>Create a Post</h2>
                    </div>
                    <div class="card-body">
                        <form method="post">
                            <div class="form-group">
                                <textarea name="content" class="form-control" rows="5" placeholder="Write something..." required></textarea>
                            </div>
                            <button type="submit" class="btn btn-success">Post</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String content = request.getParameter("content");

        // Get the username from session (assuming user is logged in and stored in session)
        String username = (String) session.getAttribute("user");

        // Database insertion (assuming dbConnection is initialized in db.jsp)
        Connection conn = (Connection) application.getAttribute("dbConnection");
        String query = "INSERT INTO posts (user_id, content) VALUES ((SELECT id FROM users WHERE username = ?), ?)";

        try {
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, content);
            ps.executeUpdate();

            // Redirect to index page after successful post creation
            response.sendRedirect("index.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<div class='alert alert-danger mt-3'>Error: Unable to save post to the database.</div>");
        }
    }
%>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.2/dist/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
