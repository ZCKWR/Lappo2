<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>

<%
    String dbURL = "jdbc:mysql://localhost:3306/lappo2";
    String dbUser = "root";
    String dbPass = "Zack1234!";

    List<Map<String, Object>> repairsList = new ArrayList<>();
    // Storing technicians as a Map to keep both ID and Name
    List<Map<String, String>> technicianList = new ArrayList<>();

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);
        
        // 1. Fetch Technicians (Need UserID for the dropdown value)
        Statement stTech = con.createStatement();
        ResultSet rsTech = stTech.executeQuery("SELECT UserID, Username FROM User WHERE UserType = 'Technician'");
        while(rsTech.next()){
            Map<String, String> t = new HashMap<>();
            t.put("id", rsTech.getString("UserID"));
            t.put("name", rsTech.getString("Username"));
            technicianList.add(t);
        }

        // 2. Fetch Repairs using your new column names (CustomerID, AssignedTech)
        String repairQuery = "SELECT r.RepairID, u.Username AS CustomerName, u.UserID AS CustomerID, " +
                            "r.LaptopModel, r.CurrentStatus, r.DateIssued, tech.Username AS TechName, " +
                            "(i.LabourCost + i.PartCost) AS CalculatedPrice " +
                            "FROM Repair r " +
                            "JOIN User u ON r.CustomerID = u.UserID " + 
                            "LEFT JOIN User tech ON r.AssignedTech = tech.UserID " +
                            "LEFT JOIN Invoice i ON r.RepairID = i.RepairID " + 
                            "ORDER BY r.DateIssued DESC";
        
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(repairQuery);
        while(rs.next()){
            Map<String, Object> repair = new HashMap<>();
            repair.put("id", rs.getInt("RepairID"));
            repair.put("customer", rs.getString("CustomerName"));
            repair.put("customerId", rs.getString("CustomerID"));
            repair.put("device", rs.getString("LaptopModel"));
            repair.put("techName", rs.getString("TechName")); 
            repair.put("status", rs.getString("CurrentStatus"));
            repair.put("date", rs.getTimestamp("DateIssued"));
            repair.put("price", rs.getObject("CalculatedPrice")); 
            repairsList.add(repair);
        }
        con.close();
    } catch (Exception e) {
        out.println("<div style='color:red; background:white; padding:10px;'>Database Error: " + e.getMessage() + "</div>");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Lappo Admin - Active Repairs</title>
    <link rel="stylesheet" href="CSS/AllAdminCSS.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
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
            <header class="top-header"><h1>Active Repairs</h1></header>

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
                                <span style="font-size: 0.85em; color: var(--light-text-color);"><%= sdf.format(r.get("date")) %></span>
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
                                    <button class="btn-sm btn-view" onclick="openAssignModal('<%= r.get("id") %>')">
                                        <%= techName.equals("Unassigned") ? "Assign" : "Change Tech" %>
                                    </button>
                                <% } else { %>
                                    <span class="locked-icon"><i class="fas fa-check-circle"></i></span>
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
            <form action="UpdateTech.jsp" method="POST">
                <input type="hidden" name="repairId" id="jobIdInput">
                <div class="form-group">
                    <label>Select Technician</label>
                    <select name="techUserId" required>
                        <option value="">-- Choose a Technician --</option>
                        <% for(Map<String, String> tech : technicianList) { %>
                            <option value="<%= tech.get("id") %>"><%= tech.get("name") %></option>
                        <% } %>
                    </select>
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn-cancel" onclick="closeAssignModal()">Cancel</button>
                    <button type="submit" class="btn-save">Update Technician</button>
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