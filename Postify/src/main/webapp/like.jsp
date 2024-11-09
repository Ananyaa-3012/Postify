<%@ include file="db.jsp" %>
<%@ page import="java.sql.*" %>

<%
    String postId = request.getParameter("post_id");
    String username = (String) session.getAttribute("user");

    if (postId == null || username == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    Connection conn = (Connection) application.getAttribute("dbConnection");

    // Check if the user has already liked the post
    String checkLikeQuery = "SELECT COUNT(*) FROM post_likes WHERE post_id = ? AND user_id = (SELECT id FROM users WHERE username = ?)";
    PreparedStatement checkPs = conn.prepareStatement(checkLikeQuery);
    checkPs.setString(1, postId);
    checkPs.setString(2, username);
    ResultSet rs = checkPs.executeQuery();
    rs.next();
    boolean hasLiked = rs.getInt(1) > 0;

    if (hasLiked) {
        // If the user has already liked the post, remove the like
        String deleteLikeQuery = "DELETE FROM post_likes WHERE post_id = ? AND user_id = (SELECT id FROM users WHERE username = ?)";
        PreparedStatement deletePs = conn.prepareStatement(deleteLikeQuery);
        deletePs.setString(1, postId);
        deletePs.setString(2, username);
        deletePs.executeUpdate();

        // Decrease the like count in the posts table
        String decreaseLikeQuery = "UPDATE posts SET likes = likes - 1 WHERE id = ?";
        PreparedStatement decreasePs = conn.prepareStatement(decreaseLikeQuery);
        decreasePs.setString(1, postId);
        decreasePs.executeUpdate();
    } else {
        // If the user hasn't liked the post, add the like
        String insertLikeQuery = "INSERT INTO post_likes (post_id, user_id) VALUES (?, (SELECT id FROM users WHERE username = ?))";
        PreparedStatement insertPs = conn.prepareStatement(insertLikeQuery);
        insertPs.setString(1, postId);
        insertPs.setString(2, username);
        insertPs.executeUpdate();

        // Increase the like count in the posts table
        String increaseLikeQuery = "UPDATE posts SET likes = likes + 1 WHERE id = ?";
        PreparedStatement increasePs = conn.prepareStatement(increaseLikeQuery);
        increasePs.setString(1, postId);
        increasePs.executeUpdate();
    }

    // Redirect back to the feed
    response.sendRedirect("index.jsp");
%>
