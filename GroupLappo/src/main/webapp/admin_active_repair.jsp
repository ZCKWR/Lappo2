<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="adminDAO.repairDAO, adminDAO.userDAO, java.util.*, java.text.SimpleDateFormat" %>

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
<%
    // Initialize DAO and fetch data
    repairDAO dao = new repairDAO();
    List<Map<String, Object>> repairsList = dao.getAllRepairs();
    List<Map<String, String>> technicianList = dao.getTechnicians();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Lappo Admin - Active Repairs</title>
    <link rel="stylesheet" href="CSS/AllAdminCSS.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* Ensuring badges have enough contrast */
        .badge { padding: 4px 8px; border-radius: 4px; font-size: 0.85em; font-weight: bold; }
        .badge-pending { background: #f1c40f; color: #fff; }
        .badge-inprogress { background: #3498db; color: #fff; }
        .badge-completed { background: #2ecc71; color: #fff; }
        .badge-tech { background: #9b59b6; color: #fff; }
    </style>
</head>
<body>

    <div class="admin-wrapper">
        <nav class="sidebar">
            <div class="sidebar-header"><i class="fas fa-laptop"></i> <span>Lappo Admin</span></div>
            <div class="sidebar-nav">
                <a href="admin_dashboard.jsp"><i class="fas fa-chart-pie"></i> <span>Dashboard</span></a>
                <a href="admin_active_repair.jsp" class="active"><i class="fas fa-wrench"></i> <span>Repairs</span></a>
                <a href="admin_inventory.jsp"><i class="fas fa-boxes"></i> <span>Inventory</span></a>
                <a href="admin_users.jsp"><i class="fas fa-users"></i> <span>Users</span></a>
                <a href="adminProfile.jsp"><i class="fas fa-user-circle"></i> <span>Profile</span></a>
            </div>
        </nav>

        <main class="main-content">
            <header class="top-header">
                <h1>Active Repairs</h1>
                <% if(request.getParameter("status") != null) { %>
                    <div style="background: #d4edda; color: #155724; padding: 10px; border-radius: 5px; margin-top: 10px;">
                        Update Successful: <%= request.getParameter("status") %>
                    </div>
                <% } %>
            </header>

            <div class="filter-tabs">
                <div class="filter-tab active" onclick="filterTable('All', this)">All Repairs</div>
                <div class="filter-tab" onclick="filterTable('Pending', this)">Pending</div>
                <div class="filter-tab" onclick="filterTable('In Progress', this)">In Progress</div>
                <div class="filter-tab" onclick="filterTable('Completed', this)">Completed</div>
            </div>

            <div class="panel">
                <table class="data-table" id="repairTable">
                    <thead>
                        <tr>
                            <th>ID / Date</th>
                            <th>Customer</th>
                            <th>Device</th>
                            <th>Assigned Tech</th>
                            <th>Status</th>
                            <th>Total Price</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, hh:mm a");
                            for(Map<String, Object> r : repairsList) { 
                                String status = (r.get("status") != null) ? (String)r.get("status") : "Pending";
                                String techName = (r.get("techName") == null) ? "Unassigned" : (String)r.get("techName");
                                Object priceObj = r.get("price");
                                String displayPrice = (priceObj == null) ? "TBD" : "RM " + String.format("%.2f", priceObj);
                        %>
                        <tr class="repair-row" data-status="<%= status %>">
                            <td>
                                <strong>#REQ-<%= r.get("id") %></strong><br>
                                <span style="font-size: 0.85em; color: gray;"><%= sdf.format(r.get("date")) %></span>
                            </td>
                            <td>
                                <strong><%= r.get("customer") %></strong><br>
                                <small>ID: <%= r.get("customerId") %></small>
                            </td>
                            <td><strong><%= r.get("device") %></strong></td>
                            <td><span class="badge <%= techName.equals("Unassigned") ? "" : "badge-tech" %>"><%= techName %></span></td>
                            <td><span class="badge badge-<%= status.toLowerCase().replace(" ", "") %>"><%= status %></span></td>
                            <td><%= displayPrice %></td>
                            <td>
                                <% if(!status.equalsIgnoreCase("Completed")) { %>
                                    <button class="btn-sm" style="background:#3498db; color:white; border:none; padding:5px 10px; border-radius:4px; cursor:pointer;" onclick="openAssignModal('<%= r.get("id") %>')">
                                        <%= techName.equals("Unassigned") ? "Assign" : "Change Tech" %>
                                    </button>
                                <% } else { %>
                                    <span style="color: #2ecc71;"><i class="fas fa-check-circle"></i> Done</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

    <div id="assignModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Assign Technician</h2>
                <button class="close-btn" onclick="closeAssignModal()">&times;</button>
            </div>
            <form action="AssignTech" method="POST">
                <input type="hidden" name="repairId" id="jobIdInput">
                <div class="form-group">
                    <label>Select Technician</label>
                    <select name="techUserId" required style="width: 100%; padding: 8px; margin-top: 5px;">
                        <option value="">-- Choose a Technician --</option>
                        <% for(Map<String, String> tech : technicianList) { %>
                            <option value="<%= tech.get("id") %>"><%= tech.get("name") %></option>
                        <% } %>
                    </select>
                </div>
                <div class="modal-actions" style="margin-top: 20px; text-align: right;">
                    <button type="button" class="btn-cancel" onclick="closeAssignModal()">Cancel</button>
                    <button type="submit" class="btn-save" style="background:#27ae60; color:white; border:none; padding:8px 15px; border-radius:4px; cursor:pointer;">Update Technician</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function filterTable(status, element) {
            document.querySelectorAll('.filter-tab').forEach(tab => tab.classList.remove('active'));
            element.classList.add('active');
            document.querySelectorAll('.repair-row').forEach(row => {
                row.style.display = (status === 'All' || row.getAttribute('data-status') === status) ? '' : 'none';
            });
        }

        function openAssignModal(id) {
            document.getElementById('jobIdInput').value = id;
            document.getElementById('assignModal').style.display = 'flex';
        }
        function closeAssignModal() {
            document.getElementById('assignModal').style.display = 'none';
        }
    </script>
</body>
</html>