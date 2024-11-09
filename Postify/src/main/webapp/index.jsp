<%@ include file="db.jsp" %>
<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = (String) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feed</title>
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

    <div class="container mt-4">
        <h1>Welcome, <%= username %>!</h1>
        <div class="mb-3">
            <a href="newPost.jsp" class="btn btn-primary">Create a Post</a>
        </div>

        <div class="row">
            <!-- Posts Section -->
            <div class="col-md-6">
                <h2>Feed</h2>

                <%
                    String query = "SELECT posts.id, posts.content, posts.likes, users.username, posts.created_at, " +
                                   "(SELECT COUNT(*) FROM comments WHERE comments.post_id = posts.id) AS comment_count " +
                                   "FROM posts INNER JOIN users ON posts.user_id = users.id ORDER BY posts.created_at DESC";
                    Connection conn = (Connection) application.getAttribute("dbConnection");
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery(query);

                    boolean hasPosts = rs.isBeforeFirst(); // Check if there are any posts

                    if (!hasPosts) { 
                %>
                    <p>No posts yet.</p>
                <%
                    } else {
                        while (rs.next()) {
                            int commentCount = rs.getInt("comment_count");
                %>
                    <div class="card mb-3">
                        <div class="card-body">
                            <h5 class="card-title"><%= rs.getString("username") %></h5>
                            <p class="card-text"><small class="text-muted">Posted on <%= rs.getString("created_at") %></small></p>
                            <p class="card-text"><%= rs.getString("content") %></p>
                            <form method="post" action="like.jsp" class="d-inline">
                                <input type="hidden" name="post_id" value="<%= rs.getInt("id") %>">
                                <button type="submit" class="btn btn-outline-primary">Like (<%= rs.getInt("likes") %>)</button>
                            </form>
                            <a href="comments.jsp?post_id=<%= rs.getInt("id") %>" target="commentsFrame" class="btn btn-outline-secondary ml-2">
                                View Comments (<%= commentCount %>)
                            </a>
                        </div>
                    </div>
                <%
                        }
                    }
                %>
            </div>

            <!-- Comments Section -->
            <div class="col-md-6">
                <h2>Comments</h2>
                <!-- iFrame to load the comments dynamically -->
                <iframe name="commentsFrame" class="border" style="width: 100%; height: 500px;"></iframe>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.2/dist/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
