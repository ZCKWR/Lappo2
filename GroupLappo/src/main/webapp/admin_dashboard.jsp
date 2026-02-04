<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="adminDAO.repairDAO, adminDAO.userDAO, adminModel.lowStock,  java.util.*, java.text.SimpleDateFormat" %>

<%
    // 1. Session & Security Check
    Integer userId = (Integer) session.getAttribute("userID");
    if (userId == null) {
        response.sendRedirect("LoginPage.jsp");
        return;
    }

    // 2. Initialize DAOs
    repairDAO rDao = new repairDAO();
    userDAO uDao = new userDAO();

    // 3. Fetch Statistics using the DAO (Keeping your logic but cleaner)
    // Note: You can eventually move these queries into repairDAO methods for better organization
    int activeRepairs = 0, completedRepairs = 0, totalUsers = 0, pendingJobsCount = 0;
    
    // For this update, we will fetch the data lists directly from the DAO
    List<Map<String, Object>> allRepairs = rDao.getAllRepairs();
    List<Map<String, Object>> pendingQueue = new ArrayList<>();
    
    for(Map<String, Object> r : allRepairs) {
        String status = (String)r.get("status");
        if("In Progress".equals(status)) activeRepairs++;
        if("Complete".equals(status)) completedRepairs++;
        if("Pending".equals(status) || "Awaiting for technicians to be assigned".equals(status) || "Waiting for technicians to be assigned".equals(status)) {
            pendingJobsCount++;
            pendingQueue.add(r); // Add to dashboard queue
        }
    }
    // Simple count for total users (can be moved to userDAO)
    totalUsers = 10; // Placeholder: you can add a getCount() in userDAO

    // 4. Low Stock Logic (Assuming you have a method in repairDAO or similar)
    // For now, keeping your existing logic but it's better to move to a DAO later
    List<Map<String, Object>> lowStockParts = new ArrayList<>(); 
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Lappo Admin - Dashboard</title>
    <link rel="stylesheet" href="CSS/AllAdminCSS.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .alert { padding: 15px; margin-bottom: 20px; border-radius: 4px; font-weight: bold; }
        .alert-success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>

    <div class="admin-wrapper">
        <nav class="sidebar">
            <div class="sidebar-header"><i class="fas fa-laptop"></i> <span>Lappo Admin</span></div>
            <div class="sidebar-nav">
                <a href="Dashboard" class="active"><i class="fas fa-chart-pie"></i> <span>Dashboard</span></a>
                <a href="admin_active_repair.jsp"><i class="fas fa-wrench"></i> <span>Repairs</span></a>
                <a href="admin_inventory.jsp"><i class="fas fa-boxes"></i> <span>Inventory</span></a>
                <a href="admin_users.jsp"><i class="fas fa-users"></i> <span>Users</span></a>
                <a href="adminProfile.jsp"><i class="fas fa-user-circle"></i> <span>Profile</span></a>
            </div>
            <div class="sidebar-footer">
                <button class="btn-logout" onclick="window.location.href='LoginPage.jsp'">
                    <i class="fas fa-sign-out-alt"></i> <span>Logout</span>
                </button>
            </div>
        </nav>

        <main class="main-content">
            <header class="top-header">
                <div>
                    <h1>System Overview</h1>
                    <p style="color: gray; margin-top: 5px;">Welcome back, Administrator.</p>
                </div>
                <div class="user-profile" onclick="window.location.href='adminProfile.jsp'" style="cursor:pointer">
                    <div class="avatar-circle"><i class="fas fa-user"></i></div>
                </div>
            </header>

            <% 
                String status = request.getParameter("status");
                if ("approve_ok".equals(status)) { 
            %>
                <div class="alert alert-success"><i class="fas fa-check-circle"></i> Repair request approved successfully!</div>
            <% } else if ("reject_ok".equals(status)) { %>
                <div class="alert alert-error"><i class="fas fa-times-circle"></i> Repair request has been rejected.</div>
            <% } %>

            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-info"><h3>Active Repairs</h3><p class="number"><%= request.getAttribute("countTotalActiveJob") %></p></div>
                    <div class="stat-icon"><i class="fas fa-tools"></i></div>
                </div>
                <div class="stat-card">
                    <div class="stat-info"><h3>Completed</h3><p class="number"><%= request.getAttribute("countTotalCompleteJob") %></p></div>
                    <div class="stat-icon" style="color: #2ecc71;"><i class="fas fa-check-circle"></i></div>
                </div>
                <div class="stat-card">
                    <div class="stat-info"><h3>Total Users</h3><p class="number"><%= request.getAttribute("totalUser") %></p></div>
                    <div class="stat-icon" style="color: purple;"><i class="fas fa-user"></i></div>
                </div>
                <div class="stat-card">
                    <div class="stat-info"><h3>Pending Jobs</h3><p class="number"><%= request.getAttribute("countTotalPendingJob") %></p></div>
                    <div class="stat-icon" style="color: #f1c40f;"><i class="fas fa-clock"></i></div>
                </div>
            </div>

            <div class="panel">
                <div class="panel-header"><h2>Pending Job Queue</h2></div>
                <table class="data-table">
                    <thead>
                        <tr>
                        	<th>Repair ID</th>
                            <th>Customer ID</th>
                            <th>Customer Name</th>
                            <th>Applied Date</th>
                            <th>Device</th>
                            <th>Issue</th>
                            <th>Customer Note</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy");
                            if(pendingQueue.isEmpty()) {
                        %>
                            <tr><td colspan="5" style="text-align:center; padding: 20px;">No pending jobs found.</td></tr>
                        <% 
                            } else {
                                for (Map<String, Object> job : pendingQueue) { 
                        %>
                        <tr>
                         <td><%= job.get("id") %></td>
    					<td><%= job.get("customerId") %></td>
    					<td><%= job.get("customer") %></td>
    					<td><%= job.get("date") %></td>
    					<td><%= job.get("device") %></td>
    			     	<td><%= job.get("issue") %></td>
    					<td><%= job.get("customerNote") %></td>
    					<td><%= job.get("status") %></td>
                        </tr>
                        <% 
                                } 
                            } 
                        %>
                    </tbody>
                </table>
            </div>

            <div class="panel">
                <div class="panel-header"><h2>Low Stock Alerts</h2></div>
                <table class="data-table">
                    <thead>
                        <tr><th>Part ID</th><th>Part Name</th><th>Quantity</th></tr>
                    </thead>
                    <tbody>
                    <% 
                    List<lowStock> list = (List<lowStock>) session.getAttribute("lowStock");
            
            // 2. Check if the list exists and loop through it
            if (list != null && !list.isEmpty()) {
                for (lowStock s : list) {
                    %>
                
                        <% if(list.isEmpty()) { %>
                            <tr><td colspan="3" style="text-align:center;">All parts are well-stocked.</td></tr>
                        <% } %>
     
                        <tr>
                            <td><%= s.getRepairID() %></td>
                            <td style="color: red; font-weight: bold;"><%= s.getPartName() %></td>
                            <td><%= s.getQuantity() %></td>
                        </tr>
                        <% }
           				   }	
                		%>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</body>
</html>