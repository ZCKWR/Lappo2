<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>

<%
    // Database Connection Settings
    String dbURL = "jdbc:mysql://localhost:3306/lappo2";
    String dbUser = "root";
    String dbPass = "Zack1234!";

    // Variables for statistics
    int activeRepairs = 0, completedRepairs = 0, totalUsers = 0, pendingJobsCount = 0;
    
    // Lists to hold data for the tables
    List<Map<String, Object>> jobQueue = new ArrayList<>();
    List<Map<String, Object>> lowStockParts = new ArrayList<>();

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);

        // 1. Fetch Statistics (Works fine as long as table names match)
        String statQuery = "SELECT " +
            "(SELECT COUNT(*) FROM Repair WHERE CurrentStatus = 'In Progress') as active, " +
            "(SELECT COUNT(*) FROM Repair WHERE CurrentStatus = 'Completed') as completed, " +
            "(SELECT COUNT(*) FROM User) as users, " +
            "(SELECT COUNT(*) FROM Repair WHERE CurrentStatus = 'Pending') as pending";
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(statQuery);
        if(rs.next()){
            activeRepairs = rs.getInt("active");
            completedRepairs = rs.getInt("completed");
            totalUsers = rs.getInt("users");
            pendingJobsCount = rs.getInt("pending");
        }

        // 2. Fetch Job Queue (UPDATED: Studentid -> CustomerID)
        String queueQuery = "SELECT r.RepairID, u.Username, r.DateIssued, r.LaptopModel " +
                           "FROM Repair r JOIN User u ON r.CustomerID = u.UserID " +
                           "WHERE r.CurrentStatus = 'Pending' " +
                           "ORDER BY r.DateIssued ASC";
        ResultSet rsQueue = st.executeQuery(queueQuery);
        while(rsQueue.next()){
            Map<String, Object> job = new HashMap<>();
            job.put("id", rsQueue.getInt("RepairID"));
            job.put("name", rsQueue.getString("Username"));
            job.put("date", rsQueue.getTimestamp("DateIssued"));
            job.put("device", rsQueue.getString("LaptopModel"));
            jobQueue.add(job);
        }

        // 3. Fetch Low Stock Parts (Quantity < 5)
        String partQuery = "SELECT PartName, Quantity FROM Part WHERE Quantity < 5";
        ResultSet rsPart = st.executeQuery(partQuery);
        while(rsPart.next()){
            Map<String, Object> part = new HashMap<>();
            part.put("name", rsPart.getString("PartName"));
            part.put("qty", rsPart.getInt("Quantity"));
            lowStockParts.add(part);
        }
        
        con.close();
    } catch (Exception e) {
        out.println("<div style='color:red; background:white; padding:10px;'>System Error: " + e.getMessage() + "</div>");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Lappo Admin - Dashboard</title>
    <link rel="stylesheet" href="CSS/AllAdminCSS.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>

    <div class="admin-wrapper">
        <nav class="sidebar">
            <div class="sidebar-header"><i class="fas fa-laptop"></i> <span>Lappo Admin</span></div>
            <div class="sidebar-nav">
                <a href="admin_dashboard.jsp" class="active"><i class="fas fa-chart-pie"></i> <span>Dashboard</span></a>
                <a href="admin_active_repair.jsp"><i class="fas fa-wrench"></i> <span>Repairs</span></a>
                <a href="admin_inventory.jsp"><i class="fas fa-boxes"></i> <span>Inventory</span></a>
                <a href="admin_users.jsp"><i class="fas fa-users"></i> <span>Users</span></a>
                <a href="adminProfile.jsp"><i class="fas fa-user-circle"></i> <span>Profile</span></a>
            </div>
        </nav>

        <main class="main-content">
            <header class="top-header">
                <div>
                    <h1>System Overview</h1>
                    <p style="color: var(--light-text-color); margin-top: 5px;">Welcome back, Administrator.</p>
                </div>
                <div class="user-profile" onclick="window.location.href='adminProfile.jsp'">
                    <div class="avatar-circle"><i class="fas fa-user"></i></div>
                </div>
            </header>

            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-info"><h3>Active Repairs</h3><p class="number"><%= activeRepairs %></p></div>
                    <div class="stat-icon"><i class="fas fa-tools"></i></div>
                </div>
                <div class="stat-card">
                    <div class="stat-info"><h3>Completed</h3><p class="number"><%= completedRepairs %></p></div>
                    <div class="stat-icon" style="color: var(--success-color);"><i class="fas fa-check-circle"></i></div>
                </div>
                <div class="stat-card">
                    <div class="stat-info"><h3>Total Users</h3><p class="number"><%= totalUsers %></p></div>
                    <div class="stat-icon" style="color: purple;"><i class="fas fa-user"></i></div>
                </div>
                <div class="stat-card">
                    <div class="stat-info"><h3>Pending Jobs</h3><p class="number"><%= pendingJobsCount %></p></div>
                    <div class="stat-icon" style="color: var(--warning-color);"><i class="fas fa-clock"></i></div>
                </div>
            </div>

            <div class="panel">
                <div class="panel-header"><h2>Pending Job Queue</h2></div>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Customer</th>
                            <th>Applied Date</th>
                            <th>Device</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy");
                            for (Map<String, Object> job : jobQueue) { 
                        %>
                        <tr>
                            <td><strong><%= job.get("name") %></strong></td>
                            <td><%= (job.get("date") != null) ? sdf.format(job.get("date")) : "N/A" %></td>
                            <td><%= job.get("device") %></td>
                            <td><span class="badge badge-pending">Pending</span></td>
                            <td>
							    <button class="btn-sm btn-approve" onclick="location.href='ProcessRepair.jsp?id=<%= job.get("id") %>&action=approve'">Approve</button>
							    <button class="btn-sm btn-reject" onclick="if(confirm('Reject this repair request?')) location.href='ProcessRepair.jsp?id=<%= job.get("id") %>&action=reject'">Reject</button>
							</td>
                        </tr>
                        <% } %>
                        <% if(jobQueue.isEmpty()) { %>
                            <tr><td colspan="5" style="text-align:center;">No pending jobs found.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <div class="panel">
                <div class="panel-header"><h2>Low Stock Alerts</h2></div>
                <table class="data-table">
                    <thead>
                        <tr><th>Part Name</th><th>Stock Level</th><th>Status</th></tr>
                    </thead>
                    <tbody>
                        <% for (Map<String, Object> part : lowStockParts) { 
                            int qty = (Integer)part.get("qty");
                        %>
                        <tr>
                            <td><%= part.get("name") %></td>
                            <td style="color: red; font-weight: bold;"><%= qty %></td>
                            <td>
                                <span class="badge <%= (qty == 0) ? "badge-danger" : "badge-warning" %>">
                                    <%= (qty == 0) ? "Out of Stock" : "Low Stock" %>
                                </span>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</body>
</html>