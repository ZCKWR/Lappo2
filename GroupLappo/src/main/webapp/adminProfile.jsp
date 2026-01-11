<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="adminDAO.userDAO, java.util.Map" %>

<%
    // 1. Get the ID stored by your LoginController session
    Integer userId = (Integer) session.getAttribute("userID");
    
    // 2. Security Check: If session is null, redirect to Login
    if (userId == null) {
        response.sendRedirect("LoginPage.jsp");
        return;
    }

    // 3. Fetch the full user details using the DAO method we added
    userDAO uDao = new userDAO();
    Map<String, String> profile = uDao.getUserProfile(userId);
    
    // If for some reason the database record is missing
    if (profile.isEmpty()) {
        out.println("Error: User profile not found in database.");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Profile - Lappo</title>
    <link rel="stylesheet" href="CSS/AllAdminCSS.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>

    <div class="admin-wrapper">
        <nav class="sidebar">
            <div class="sidebar-header"> <i class="fas fa-laptop"></i> <span>Lappo Admin</span> </div>
            <div class="sidebar-nav">
               <a href="admin_dashboard.jsp">
                    <i class="fas fa-chart-pie"></i> <span>Dashboard</span>
                </a>
                <a href="admin_active_repair.jsp">
                    <i class="fas fa-wrench"></i> <span>Repairs</span>
                </a>
                <a href="admin_inventory.jsp">
                    <i class="fas fa-boxes"></i> <span>Inventory</span>
                </a>
                <a href="admin_users.jsp">
                    <i class="fas fa-users"></i> <span>Users</span>
                </a>
                <a href="adminProfile.jsp" class="active">
                    <i class="fas fa-user-circle"></i> <span>Profile</span>
                </a>
            </div>
            <div class="sidebar-footer">
                <button class="btn-logout" onclick="window.location.href='LoginPage.jsp'">
                    <i class="fas fa-sign-out-alt"></i> <span>Logout</span>
                </button>
            </div>
        </nav>

        <main class="main-content">
            <div class="profile-header">
                <h1>Admin Profile</h1>
                
                <%-- Display Success or Error Message --%>
                <% if(request.getParameter("status") != null) { %>
                    <div class="status-message" style="margin-top: 15px; padding: 10px; border-radius: 5px; 
                         <%= request.getParameter("status").equals("success") ? "background: #d4edda; color: #155724;" : "background: #f8d7da; color: #721c24;" %>">
                        <%= request.getParameter("status").equals("success") ? "Profile updated successfully!" : "Update failed. Please try again." %>
                    </div>
                <% } %>
            </div>

            <div class="profile-grid">
                <div class="card user-card">
                    <div class="large-avatar"><i class="fas fa-user-shield"></i></div>
                    <h2><%= profile.get("name") %></h2>
                    <p>System Manager</p>
                    <span class="role-badge"><%= profile.get("role") %></span>
                </div>

                <div class="card details-card">
                    <div class="details-header">
                        <h3>Account Details</h3>
                        <button type="submit" form="profileForm" class="btn-save">Update Profile</button>
                    </div>
                    
                    <form id="profileForm" action="UpdateProfile" method="POST">
                        <div class="info-group">
                            <div class="form-group">
                                <label>Full Name</label>
                                <input type="text" name="name" class="form-control" value="<%= profile.get("name") %>" required>
                            </div>
                            <div class="form-group">
                                <label>Admin ID</label>
                                <input type="text" class="form-control" value="ADM-<%= userId %>" readonly style="background-color: #f4f4f4; color: #666; cursor: not-allowed;">
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Email Address</label>
                            <input type="email" name="email" class="form-control" value="<%= profile.get("email") %>" required>
                        </div>

                        <div class="form-group">
                            <label>Phone Number</label>
                            <input type="text" name="phone" class="form-control" value="<%= (profile.get("phone") != null) ? profile.get("phone") : "" %>">
                        </div>

                        <div class="form-group">
                            <label>Address</label>
                            <textarea name="address" class="form-control" rows="2"><%= (profile.get("address") != null) ? profile.get("address") : "" %></textarea>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

</body>
</html>