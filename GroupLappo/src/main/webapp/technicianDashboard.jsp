<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
 import="java.util.List, techModel.jobView" import="java.text.SimpleDateFormat"  import="java.sql.*, java.util.*"
import="javax.naming.*, javax.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lappo Technician - Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <%
    // Retrieve the count from the session
    Integer count = (Integer) session.getAttribute("assignedJobsCount");
    int totalJobs = (count != null) ? count : 0;
%>
    

    
    <style>
        /* --- 1. Variables & Resets (Matching your Landing Page) --- */
        :root {
            --primary-color: #2b6cb0; 
            --secondary-color: #4c68ff;
            --text-color: #333;
            --light-text-color: #666;
            --font-family: Arial, sans-serif;
            --sidebar-bg: #1c2130; /* Same as footer background */
            --sidebar-text: #b0b5c4; 
            --bg-light: #f4f7fa; /* Slightly gray background for dashboard */
            --border-color: #e1e4e8;
            --success-color: #28a745;
            --danger-color: #dc3545;
            --warning-color: #ffc107;
        }

        body {
            margin: 0;
            font-family: var(--font-family);
            color: var(--text-color);
            background-color: var(--bg-light);
            line-height: 1.6;
        }

        * {
            box-sizing: border-box;
        }

        /* --- 2. Admin Layout Structure --- */
        .admin-wrapper {
            display: flex;
            min-height: 100vh;
        }

        /* --- Sidebar Styling --- */
        .sidebar {
            width: 260px;
            background-color: var(--sidebar-bg);
            color: var(--sidebar-text);
            display: flex;
            flex-direction: column;
            position: fixed; /* Keeps sidebar fixed while scrolling */
            height: 100%;
            left: 0;
            top: 0;
        }

        .sidebar-header {
            padding: 20px;
            font-size: 1.5em;
            font-weight: bold;
            color: #fff;
            border-bottom: 1px solid #2d3342;
            display: flex;
            align-items: center;
        }

        .sidebar-header i {
            color: var(--secondary-color);
            margin-right: 10px;
        }

        .sidebar-nav {
            padding: 20px 0;
            flex-grow: 1;
        }

        .sidebar-nav a {
            display: flex;
            align-items: center;
            padding: 15px 25px;
            color: var(--sidebar-text);
            text-decoration: none;
            transition: all 0.3s;
            border-left: 4px solid transparent;
        }

        .sidebar-nav a i {
            width: 25px;
            margin-right: 10px;
            text-align: center;
        }

        .sidebar-nav a:hover, 
        .sidebar-nav a.active {
            background-color: rgba(76, 104, 255, 0.1);
            color: #fff;
            border-left-color: var(--secondary-color);
        }

        .sidebar-footer {
            padding: 20px;
            border-top: 1px solid #2d3342;
        }

        .btn-logout {
            background: none;
            border: none;
            color: var(--sidebar-text);
            cursor: pointer;
            font-size: 1em;
            display: flex;
            align-items: center;
            width: 100%;
            padding: 10px 0;
        }

        .btn-logout:hover {
            color: var(--danger-color);
        }

        /* --- Main Content Area --- */
        .main-content {
            margin-left: 260px; /* Offset for fixed sidebar */
            flex-grow: 1;
            padding: 30px;
            width: calc(100% - 260px);
        }

        /* --- Header Styling --- */
        .top-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .top-header h1 {
            margin: 0;
            font-size: 1.8em;
            color: var(--text-color);
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .avatar-circle {
            width: 40px;
            height: 40px;
            background-color: var(--secondary-color);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }

        /* --- Stats Grid (Cards) --- */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            border: 1px solid var(--border-color);
        }

        .stat-info h3 {
            margin: 0;
            font-size: 0.9em;
            color: var(--light-text-color);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stat-info .number {
            font-size: 2em;
            font-weight: bold;
            color: var(--text-color);
            margin: 5px 0;
        }

        .stat-info .trend {
            font-size: 0.85em;
        }

        .trend.up { color: var(--success-color); }
        .trend.down { color: var(--danger-color); }

        .stat-icon {
            padding: 10px;
            border-radius: 8px;
            background-color: #f0f4ff;
            color: var(--secondary-color);
            font-size: 1.5em;
        }

        /* --- Tables --- */
        .panel {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            border: 1px solid var(--border-color);
            margin-bottom: 30px;
            overflow: hidden;
        }

        .panel-header {
            padding: 20px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .panel-header h2 {
            margin: 0;
            font-size: 1.2em;
            color: var(--text-color);
        }

        .badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.75em;
            font-weight: bold;
        }

        .badge-warning { background-color: #fff3cd; color: #856404; }
        .badge-success { background-color: #d4edda; color: #155724; }
        .badge-danger { background-color: #f8d7da; color: #721c24; }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        .data-table th {
            background-color: #f8f9fa;
            padding: 15px 20px;
            font-size: 0.85em;
            color: var(--light-text-color);
            text-transform: uppercase;
            border-bottom: 1px solid var(--border-color);
        }

        .data-table td {
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            font-size: 0.95em;
        }

        .data-table tr:last-child td {
            border-bottom: none;
        }

        /* --- Action Buttons --- */
        .btn-sm {
            padding: 6px 12px;
            font-size: 0.85em;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            color: white;
            margin-right: 5px;
        }

        .btn-approve { background-color: var(--success-color); }
        .btn-reject { background-color: var(--danger-color); }
        .btn-edit { background-color: var(--primary-color); }

        .btn-sm:hover { opacity: 0.9; }

        /* --- Responsive Design --- */
        @media (max-width: 1024px) {
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
        }
        
        @media (max-width: 768px) {
            .sidebar { width: 70px; }
            .sidebar-header span, .sidebar-nav span, .btn-logout span { display: none; }
            .sidebar-nav a { justify-content: center; padding: 20px; }
            .sidebar-nav a i { margin: 0; font-size: 1.2em; }
            .main-content { margin-left: 70px; width: calc(100% - 70px); }
            .stats-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div class="admin-wrapper">
    <% String technicianName = (String) session.getAttribute("username"); %>
        
        <!-- SIDEBAR -->
        <nav class="sidebar">
            <div class="sidebar-header">
           <i class="fas fa-laptop"></i> <p>Welcome, <span><%= technicianName %></span></p>
            </div>
            
            <div class="sidebar-nav">
                <a href="jobController" class="active">
                    <i class="fas fa-chart-pie"></i> <span>Dashboard</span>
                </a>
                <a href="jobServlet">
                    <i class="fas fa-wrench"></i> <span>Job</span>
                </a>
                <a href="requestPart">
                    <i class="fas fa-boxes"></i> <span>Request</span>
                </a>
                <a href="techUpdate">
                    <i class="fas fa-user-circle"></i> <span>Profile</span>
                </a>
            </div>

            <div class="sidebar-footer">
                <button class="btn-logout" onclick="window.location.href='index.html'">
                    <i class="fas fa-sign-out-alt"></i> <span>Logout</span>
                </button>
            </div>
        </nav>

        <!-- MAIN CONTENT -->
        <main class="main-content">
            
            <!-- Header -->
            <header class="top-header">
                <div>
                    <h1>System Overview</h1>
                  
                   <!--   <p style="color: var(--light-text-color); margin-top: 5px;">Welcome back, Tech Amir.</p>-->
                </div>
                <div class="user-profile" onclick="window.location.href='technicianProfile.jsp'">
                    <i class="far fa-bell" style="font-size: 1.2em; color: var(--light-text-color); cursor: pointer; margin-right: 15px;" onclick="event.stopPropagation()"></i>
                    <div class="avatar-circle"><i class="fas fa-user"></i></div>
                </div>
            </header>

            <!-- Dashboard Statistics -->
            <div class="stats-grid">
                <!-- Stat Card 1 -->
                <div class="stat-card">
                    <div class="stat-info">
                        <h3>Assigned Job</h3>
                         <p class="number"><%= totalJobs %></p>
                        
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-tools"></i>
                    </div>
                </div>

                <!-- Stat Card 2 -->
                <div class="stat-card">
                    <div class="stat-info">
                        <h3>Completed repairs</h3>
                        <p class="number"><%= request.getAttribute("completedCount") %></p>
                        <span class="trend" style="color: var(--light-text-color);">This Month</span>
                    </div>
                    <div class="stat-icon" style="color: var(--success-color);">
                        <i class="fas fa-check-circle"></i>
                    </div>
                </div>
            </div>

            <!-- Table: Verification Queue -->
            <div class="panel"> 
                <div class="panel-header">
                    <h2>Job Queue</h2>
                    <span class="badge badge-warning">3 Pending</span>
                </div>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>User</th>
                            <th>Approved Date</th>
                            <th>Description</th>
                            <th>Status</th>
                            <th>Note</th>
                        </tr>
                    </thead>
                    <tbody>  
            <%
            // 1. Manually retrieve the list from the request
           List<jobView> list = (List<jobView>) session.getAttribute("job");
            
            // 2. Check if the list exists and loop through it
            if (list != null && !list.isEmpty()) {
                for (jobView s : list) {
               
        	%>
        	
                        <tr>
                            <td><strong><%= s.getUsername() %></strong></td>
                            <td><%= s.getApproveDate() %></td>
                            <td><%= s.getRepairDesc() %></td>
                            <td><span class="badge badge-warning"><%= s.getCurrentStatus() %></span></td>
                            <td>
                                <p> <%= s.getTechRemarks() %> </p>
                            </td>
                        </tr>
                        <% 
                }
            } else {
        	%>
                <tr><td colspan="3">No data received from Servlet.</td></tr>
       	 	<% 
           	 } 
       		 %> 
                    </tbody>
                </table>
            </div>
        </main>
    </div>

</body>
</html>