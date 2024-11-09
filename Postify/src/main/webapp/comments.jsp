<%@ include file="db.jsp" %>
<%@ page import="java.sql.*" %>
<%
    String postId = request.getParameter("post_id");
    String username = (String) session.getAttribute("user");

    if (postId == null) {
        out.println("<p>No post selected</p>");
        return;
    }

    // Handling comment submission
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String commentText = request.getParameter("comment_text");
        if (commentText != null && !commentText.isEmpty()) {
            Connection conn = (Connection) application.getAttribute("dbConnection");
            String insertComment = "INSERT INTO comments (post_id, user_id, text) VALUES (?, (SELECT id FROM users WHERE username = ?), ?)";
            PreparedStatement psInsert = conn.prepareStatement(insertComment);
            psInsert.setString(1, postId);
            psInsert.setString(2, username);
            psInsert.setString(3, commentText);
            psInsert.executeUpdate();
        }
    }

    // Query to get all comments for the current post
    String query = "SELECT comments.text, users.username, comments.created_at FROM comments INNER JOIN users ON comments.user_id = users.id WHERE comments.post_id = ?";
    Connection conn = (Connection) application.getAttribute("dbConnection");
    PreparedStatement ps = conn.prepareStatement(query);
    ps.setString(1, postId);
    ResultSet rs = ps.executeQuery();
%>
<html>
<head>
    <title>Comments</title>
    <!-- Bootstrap CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-3">
         <form method="post">
            <div class="form-group">
                <textarea name="comment_text" class="form-control" placeholder="Write your comment..." required></textarea>
            </div>
            <button type="submit" class="btn btn-primary">Add Comment</button>
        </form>
        
        <hr>

        <% 
            boolean hasComments = rs.isBeforeFirst(); // Check if ResultSet has any data
            if (hasComments) { 
                while (rs.next()) { 
        %>
            <div class="card mb-2">
                <div class="card-body">
                    <h5 class="card-title"><%= rs.getString("username") %></h5>
                    <p class="card-text"><%= rs.getString("text") %></p>
                    <p class="card-text"><small class="text-muted">Posted on <%= rs.getString("created_at") %></small></p>
                </div>
            </div>
        <% 
                } 
            } else { 
        %>
            <p>No comments yet.</p>
        <% } %>
    </div>
</body>
</html>
