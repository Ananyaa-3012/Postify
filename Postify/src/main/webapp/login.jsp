<%@ include file="db.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Postify</title>
    <!-- Bootstrap CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="#">Postify</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ml-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="register.jsp">Register</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Login Form -->
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h2>Login</h2>
                    </div>
                    <div class="card-body">
                        <form method="post">
                            <div class="form-group">
                                <label for="username">Username</label>
                                <input type="text" class="form-control" id="username" name="username" placeholder="Enter username" required>
                            </div>
                            <div class="form-group">
                                <label for="password">Password</label>
                                <input type="password" class="form-control" id="password" name="password" placeholder="Enter password" required>
                            </div>
                            <button type="submit" class="btn btn-success btn-block">Login</button>
                        </form>

                        <% 
                            if (request.getMethod().equalsIgnoreCase("POST")) {
                                String username = request.getParameter("username");
                                String pass = request.getParameter("password");

                                String query = "SELECT * FROM Users WHERE username = ? AND password = ?";
                                Connection conn = (Connection) application.getAttribute("dbConnection");
                                PreparedStatement ps = conn.prepareStatement(query);
                                ps.setString(1, username);
                                ps.setString(2, pass);  // In real applications, passwords should be hashed
                                ResultSet rs = ps.executeQuery();

                                if (rs.next()) {
                                    session.setAttribute("user", rs.getString("username"));
                                    response.sendRedirect("index.jsp");
                                } else {
                        %>
                                <div class="alert alert-danger mt-3">Invalid credentials! Please try again.</div>
                        <%
                                }
                            }
                        %>

                        <div class="mt-3">
                            <p>Don't have an account? <a href="register.jsp">Register here</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

