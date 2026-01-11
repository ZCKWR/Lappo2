<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="adminDAO.inventoryDAO, adminDAO.userDAO, java.util.*, java.sql.*, java.text.SimpleDateFormat" %>
<%
    // 1. Session & Security
    Integer userId = (Integer) session.getAttribute("userID");
    if (userId == null) {
        response.sendRedirect("LoginPage.jsp");
        return;
    }

    userDAO uDao = new userDAO();
    Map<String, String> profile = uDao.getUserProfile(userId);
    if (profile.isEmpty()) {
        out.println("Error: User profile not found.");
        return;
    }

    // 2. Fetch Inventory Stats
    inventoryDAO invDao = new inventoryDAO();
    List<Map<String, Object>> inventoryList = invDao.getAllInventory();
    
    int totalItems = 0;
    int lowStockCount = 0;
    int outOfStockCount = 0;
    double totalInventoryValue = 0.0;

    for(Map<String, Object> item : inventoryList) {
        int qty = (int)item.get("qty");
        double cost = (double)item.get("cost");
        totalItems += qty;
        totalInventoryValue += (qty * cost);
        if(qty == 0) outOfStockCount++;
        else if(qty <= 5) lowStockCount++;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Lappo Admin - Inventory</title>
    <link rel="stylesheet" href="CSS/AllAdminCSS.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .tab-nav { display: flex; gap: 10px; margin-bottom: 20px; border-bottom: 2px solid #eee; padding-bottom: 10px; }
        .tab-btn { padding: 10px 20px; border: none; background: #f4f4f4; cursor: pointer; border-radius: 5px; font-weight: bold; color: #666; transition: 0.3s; }
        .tab-btn.active { background: #3498db; color: white; }
        .hidden { display: none; }
        .badge { padding: 5px 10px; border-radius: 4px; font-size: 12px; font-weight: bold; }
        .badge-success { background: #2ecc71; color: white; }
        .badge-warning { background: #f1c40f; color: white; }
        .badge-danger { background: #e74c3c; color: white; }
        .approver-text { font-size: 10px; color: #888; margin-top: 4px; display: block; font-style: italic; }

        /* Modal Styles */
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); align-items: center; justify-content: center; }
        .modal-content { background: white; padding: 25px; border-radius: 8px; width: 400px; box-shadow: 0 5px 15px rgba(0,0,0,0.3); }
        .modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; border-bottom: 1px solid #eee; padding-bottom: 10px; }
        .modal-body label { display: block; margin-top: 10px; font-weight: bold; }
        .modal-body input { width: 100%; padding: 8px; margin-top: 5px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        .modal-footer { margin-top: 20px; text-align: right; }
        .btn-save { background: #2ecc71; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-weight: bold; }
        .btn-cancel { background: #95a5a6; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; margin-right: 5px; }
    </style>
</head>
<body>

    <div class="admin-wrapper">
        <nav class="sidebar">
            <div class="sidebar-header"><i class="fas fa-laptop"></i> <span>Lappo Admin</span></div>
            <div class="sidebar-nav">
                <a href="admin_dashboard.jsp"><i class="fas fa-chart-pie"></i> <span>Dashboard</span></a>
                <a href="admin_active_repair.jsp"><i class="fas fa-wrench"></i> <span>Repairs</span></a>
                <a href="admin_inventory.jsp" class="active"><i class="fas fa-boxes"></i> <span>Inventory</span></a>
                <a href="admin_users.jsp"><i class="fas fa-users"></i> <span>Users</span></a>
                <a href="adminProfile.jsp"><i class="fas fa-user-circle"></i> <span>Profile</span></a>
            </div>
        </nav>

        <main class="main-content">
            <header class="top-header">
                <h1>Inventory Management</h1>
                <% if(request.getParameter("status") != null) { %>
                    <div style="background: #d4edda; color: #155724; padding: 12px; border-radius: 5px; margin-top: 10px; border: 1px solid #c3e6cb;">
                        <i class="fas fa-check-circle"></i> <strong>Update Successful:</strong> <%= request.getParameter("status").replace("_", " ") %>
                    </div>
                <% } %>
            </header>

            <div class="tab-nav">
                <button class="tab-btn active" id="btnInv" onclick="switchTab('inventory')"><i class="fas fa-warehouse"></i> Inventory Stock</button>
                <button class="tab-btn" id="btnReq" onclick="switchTab('requests')"><i class="fas fa-file-invoice"></i> Part Requests</button>
            </div>

            <div id="inventory-section">
                <div class="stats-grid">
                    <div class="stat-card"><div class="stat-info"><h3>Total Items</h3><p class="number"><%= totalItems %></p></div></div>
                    <div class="stat-card"><div class="stat-info"><h3>Low Stock</h3><p class="number" style="color: #f1c40f;"><%= lowStockCount %></p></div></div>
                    <div class="stat-card"><div class="stat-info"><h3>Out of Stock</h3><p class="number" style="color: #e74c3c;"><%= outOfStockCount %></p></div></div>
                    <div class="stat-card"><div class="stat-info"><h3>Total Value</h3><p class="number">RM <%= String.format("%.2f", totalInventoryValue) %></p></div></div>
                </div>

                <div class="inventory-toolbar">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="invSearch" placeholder="Search Part Name..." onkeyup="filterInventory()">
                    </div>
                    <button class="btn-add" onclick="openModal('addItemModal')"><i class="fas fa-plus"></i> Add New Item</button>
                </div>

                <div class="panel">
                    <table class="data-table">
                        <thead>
                            <tr><th>Part Name</th><th>ID</th><th>Manufacturer</th><th>Stock</th><th>Unit Cost</th><th>Status</th><th>Action</th></tr>
                        </thead>
                        <tbody>
                            <% for(Map<String, Object> item : inventoryList) { 
                                int qty = (int)item.get("qty");
                                String statusClass = (qty == 0) ? "badge-danger" : (qty <= 5) ? "badge-warning" : "badge-success";
                            %>
                            <tr class="inv-row">
                                <td><strong><%= item.get("name") %></strong></td>
                                <td>#<%= item.get("id") %></td>
                                <td><%= item.get("brand") %></td>
                                <td style="font-weight: bold; <%= qty == 0 ? "color: red;" : "" %>"><%= qty %></td>
                                <td>RM <%= String.format("%.2f", (double)item.get("cost")) %></td>
                                <td><span class="badge <%= statusClass %>"><%= (qty == 0) ? "Out of Stock" : (qty <= 5) ? "Low Stock" : "In Stock" %></span></td>
                                <td>
                                    <button class="btn-sm" style="background:#3498db; color:white; border:none; padding:5px 10px; cursor:pointer; border-radius:4px;" onclick="openRestockModal('<%= item.get("id") %>', '<%= item.get("name") %>')">Restock</button>
                                    <button class="btn-sm" style="background:#f39c12; color:white; border:none; padding:5px 10px; cursor:pointer; border-radius:4px;" onclick="openEditModal('<%= item.get("id") %>', '<%= item.get("name") %>', '<%= item.get("brand") %>', '<%= qty %>', '<%= item.get("cost") %>')">Edit</button>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div id="requests-section" class="hidden">
                <div class="panel">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Req ID</th>
                                <th>Technician</th>
                                <th>Part Name</th>
                                <th>Qty</th>
                                <th>Repair ID</th>
                                <th>Status / Action</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            Connection conReq = null;
                            Statement stReq = null;
                            ResultSet rsReq = null;
                            try {
                                Class.forName("com.mysql.jdbc.Driver");
                                conReq = DriverManager.getConnection("jdbc:mysql://localhost:3306/lappo", "root", "12345");
                                
                                String sqlReq = "SELECT pr.*, p.PartName, u.Username AS Requester, adm.Username AS Approver " +
                                             "FROM partrequest pr " +
                                             "JOIN part p ON pr.PartID = p.PartID " +
                                             "JOIN User u ON pr.RequestedBy = u.UserID " +
                                             "LEFT JOIN User adm ON pr.ApprovedBy = adm.UserID " + 
                                             "ORDER BY pr.RequestID DESC"; 
                                
                                stReq = conReq.createStatement();
                                rsReq = stReq.executeQuery(sqlReq);
                                
                                boolean hasRequests = false;
                                while(rsReq.next()) {
                                    hasRequests = true;
                                    String status = rsReq.getString("ApprovalStatus");
                                    String statusBadge = "badge-warning";
                                    if("Approved".equalsIgnoreCase(status)) statusBadge = "badge-success";
                                    else if("Rejected".equalsIgnoreCase(status)) statusBadge = "badge-danger";
                        %>
                        <tr>
                            <td>#<%= rsReq.getInt("RequestID") %></td>
                            <td><%= rsReq.getString("Requester") %></td>
                            <td><%= rsReq.getString("PartName") %></td>
                            <td><%= rsReq.getInt("QuantityRequested") %></td>
                            <td>#REP-<%= rsReq.getInt("RepairID") %></td>
                            <td>
                                <% if ("Pending".equalsIgnoreCase(status)) { %>
                                    <a href="ApproveRequest?id=<%= rsReq.getInt("RequestID") %>&action=approve" 
                                       class="badge badge-success" style="text-decoration:none;">Approve</a>
                                    <a href="ApproveRequest?id=<%= rsReq.getInt("RequestID") %>&action=reject" 
                                       class="badge badge-danger" style="text-decoration:none; margin-left: 5px;">Reject</a>
                                <% } else { %>
                                    <span class="badge <%= statusBadge %>"><%= status %></span>
                                    <% if ("Approved".equalsIgnoreCase(status) && rsReq.getString("Approver") != null) { %>
                                        <span class="approver-text">By: <%= rsReq.getString("Approver") %></span>
                                    <% } %>
                                <% } %>
                            </td>
                        </tr>
                        <% } 
                            if(!hasRequests) { %>
                                <tr><td colspan="6" style="text-align:center;">No part requests found.</td></tr>
                        <%  }
                           } catch(Exception e) { e.printStackTrace(); } finally {
                               if(rsReq != null) rsReq.close();
                               if(stReq != null) stReq.close();
                               if(conReq != null) conReq.close();
                           }
                        %>
                    </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <div id="addItemModal" class="modal">
        <div class="modal-content">
            <div class="modal-header"><h2>Add New Part</h2><i class="fas fa-times" onclick="closeModal('addItemModal')" style="cursor:pointer"></i></div>
            <form action="InventoryController" method="POST">
                <input type="hidden" name="action" value="add">
                <div class="modal-body">
                    <label>Part Name</label><input type="text" name="name" required>
                    <label>Manufacturer</label><input type="text" name="brand" required>
                    <label>Initial Quantity</label><input type="number" name="qty" required>
                    <label>Unit Cost (RM)</label><input type="number" step="0.01" name="cost" required>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-cancel" onclick="closeModal('addItemModal')">Cancel</button>
                    <button type="submit" class="btn-save">Add Item</button>
                </div>
            </form>
        </div>
    </div>

    <div id="restockModal" class="modal">
        <div class="modal-content">
            <div class="modal-header"><h2>Restock Item</h2><i class="fas fa-times" onclick="closeModal('restockModal')" style="cursor:pointer"></i></div>
            <form action="InventoryController" method="POST">
                <input type="hidden" name="action" value="restock">
                <input type="hidden" name="partId" id="restockPartId">
                <div class="modal-body">
                    <label>Item Name</label><input type="text" id="restockItemName" readonly style="background:#f4f4f4;">
                    <label>Quantity to Add</label><input type="number" name="addQty" min="1" required>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-cancel" onclick="closeModal('restockModal')">Cancel</button>
                    <button type="submit" class="btn-save">Update Stock</button>
                </div>
            </form>
        </div>
    </div>

    <div id="editItemModal" class="modal">
        <div class="modal-content">
            <div class="modal-header"><h2>Edit Part Details</h2><i class="fas fa-times" onclick="closeModal('editItemModal')" style="cursor:pointer"></i></div>
            <form action="InventoryController" method="POST">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="partId" id="editItemSku">
                <div class="modal-body">
                    <label>Part Name</label><input type="text" name="name" id="editItemName" required>
                    <label>Manufacturer</label><input type="text" name="brand" id="editItemCategory" required>
                    <label>Stock Level</label><input type="number" name="qty" id="editItemStock" required>
                    <label>Unit Cost (RM)</label><input type="number" step="0.01" name="cost" id="editItemPrice" required>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-cancel" onclick="closeModal('editItemModal')">Cancel</button>
                    <button type="submit" class="btn-save">Save Changes</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function switchTab(tab) {
            if (tab === 'inventory') {
                document.getElementById('inventory-section').classList.remove('hidden');
                document.getElementById('requests-section').classList.add('hidden');
                document.getElementById('btnInv').classList.add('active');
                document.getElementById('btnReq').classList.remove('active');
            } else {
                document.getElementById('inventory-section').classList.add('hidden');
                document.getElementById('requests-section').classList.remove('hidden');
                document.getElementById('btnInv').classList.remove('active');
                document.getElementById('btnReq').classList.add('active');
            }
        }
        function filterInventory() {
            let input = document.getElementById('invSearch').value.toLowerCase();
            let rows = document.querySelectorAll('.inv-row');
            rows.forEach(row => { row.style.display = row.innerText.toLowerCase().includes(input) ? '' : 'none'; });
        }
        function openModal(id) { document.getElementById(id).style.display = 'flex'; }
        function closeModal(id) { document.getElementById(id).style.display = 'none'; }
        
        function openRestockModal(id, name) {
            document.getElementById('restockPartId').value = id;
            document.getElementById('restockItemName').value = name;
            openModal('restockModal');
        }
        
        function openEditModal(id, name, brand, qty, cost) {
            document.getElementById('editItemSku').value = id;
            document.getElementById('editItemName').value = name;
            document.getElementById('editItemCategory').value = brand;
            document.getElementById('editItemStock').value = qty;
            document.getElementById('editItemPrice').value = cost;
            openModal('editItemModal');
        }
    </script>
</body>
</html>