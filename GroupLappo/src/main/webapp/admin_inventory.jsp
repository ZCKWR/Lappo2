<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>

<%
    String dbURL = "jdbc:mysql://localhost:3306/lappo2";
    String dbUser = "root";
    String dbPass = "Zack1234!";

    List<Map<String, Object>> inventoryList = new ArrayList<>();
    int totalItems = 0;
    int lowStockCount = 0;
    int outOfStockCount = 0;
    double totalInventoryValue = 0.0;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);
        
        // Fetch Inventory
        String query = "SELECT * FROM part ORDER BY PartName ASC";
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(query);

        while(rs.next()){
            Map<String, Object> item = new HashMap<>();
            int id = rs.getInt("PartID");
            String name = rs.getString("PartName");
            double cost = rs.getDouble("UnitCost");
            int qty = rs.getInt("Quantity");
            String brand = rs.getString("Manufacturer");

            item.put("id", id);
            item.put("name", name);
            item.put("cost", cost);
            item.put("qty", qty);
            item.put("brand", brand);
            
            totalItems += qty;
            totalInventoryValue += (qty * cost);
            if(qty == 0) outOfStockCount++;
            else if(qty <= 5) lowStockCount++;

            inventoryList.add(item);
        }
        con.close();
    } catch (Exception e) {
        out.println("<div style='color:red; background:white; padding:10px;'>DB Error: " + e.getMessage() + "</div>");
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
                    <button class="btn-add" onclick="openModal('addItemModal')">
                        <i class="fas fa-plus"></i> Add New Item
                    </button>
                </div>

                <div class="panel">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Part Name</th>
                                <th>ID</th>
                                <th>Manufacturer</th>
                                <th>Stock</th>
                                <th>Unit Cost</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
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
                                    <button class="btn-sm btn-restock" onclick="openRestockModal('<%= item.get("id") %>', '<%= item.get("name") %>', '<%= qty %>')">Restock</button>
                                    <button class="btn-sm btn-edit" onclick="openEditModal('<%= item.get("id") %>', '<%= item.get("name") %>', '<%= item.get("brand") %>', '<%= qty %>', '<%= item.get("cost") %>')">Edit</button>
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
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
					    <%
					        try {
					            Connection conReq = DriverManager.getConnection(dbURL, dbUser, dbPass);
					            // Updated query to show ALL requests so you can see history too
					            String sqlReq = "SELECT pr.*, p.PartName, u.Username FROM partrequest pr " +
					                         "JOIN part p ON pr.PartID = p.PartID " +
					                         "JOIN User u ON pr.RequestedBy = u.UserID " +
					                         "ORDER BY pr.RequestID DESC"; 
					            
					            ResultSet rsReq = conReq.createStatement().executeQuery(sqlReq);
					            while(rsReq.next()) {
					                String status = rsReq.getString("ApprovalStatus");
					                // Determine badge color based on status
					                String statusBadge = status.equals("Approved") ? "badge-success" : 
					                                    status.equals("Rejected") ? "badge-danger" : "badge-warning";
					    %>
					    <tr>
					        <td>#<%= rsReq.getInt("RequestID") %></td>
					        <td><%= rsReq.getString("Username") %></td>
					        <td><%= rsReq.getString("PartName") %></td>
					        <td><%= rsReq.getInt("QuantityRequested") %></td>
					        <td>#REP-<%= rsReq.getInt("RepairID") %></td>
					        <td>
					            <% if ("Pending".equalsIgnoreCase(status)) { %>
					                <a href="ApproveRequest.jsp?id=<%= rsReq.getInt("RequestID") %>&action=approve" 
					                   class="btn-sm" style="background:#27ae60; color:white; text-decoration:none; padding: 5px 10px; border-radius: 4px;">Approve</a>
					                <a href="ApproveRequest.jsp?id=<%= rsReq.getInt("RequestID") %>&action=reject" 
					                   class="btn-sm" style="background:#e74c3c; color:white; text-decoration:none; padding: 5px 10px; border-radius: 4px; margin-left: 5px;">Reject</a>
					            <% } else { %>
					                <span class="badge <%= statusBadge %>"><%= status %></span>
					            <% } %>
					        </td>
					    </tr>
					    <% } conReq.close(); } catch(Exception e) { out.println("Error: " + e.getMessage()); } %>
					</tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <div id="addItemModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Add New Inventory Item</h2>
                <button class="close-btn" onclick="closeModal('addItemModal')">&times;</button>
            </div>
            <form action="AddItem.jsp" method="POST">
                <div class="form-group"><label>Part Name</label><input type="text" name="partName" required></div>
                <div class="form-group"><label>Manufacturer</label><input type="text" name="brand" required></div>
                <div class="form-group" style="display: flex; gap: 15px;">
                    <div style="flex: 1;"><label>Initial Quantity</label><input type="number" name="qty" min="0" required></div>
                    <div style="flex: 1;"><label>Unit Cost (RM)</label><input type="number" name="cost" step="0.01" min="0" required></div>
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn-cancel" onclick="closeModal('addItemModal')">Cancel</button>
                    <button type="submit" class="btn-save">Add Item</button>
                </div>
            </form>
        </div>
    </div>

    <div id="restockModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Restock Item</h2>
                <button class="close-btn" onclick="closeModal('restockModal')">&times;</button>
            </div>
            <form action="UpdateStock.jsp" method="POST">
                <input type="hidden" name="partId" id="restockPartId">
                <div class="form-group"><label>Item Name</label><input type="text" id="restockItemName" readonly style="background:#f4f4f4;"></div>
                <div class="form-group"><label>Add Quantity</label><input type="number" name="addQuantity" min="1" required></div>
                <div class="modal-actions">
                    <button type="button" class="btn-cancel" onclick="closeModal('restockModal')">Cancel</button>
                    <button type="submit" class="btn-save">Confirm Restock</button>
                </div>
            </form>
        </div>
    </div>

    <div id="editItemModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Edit Inventory Item</h2>
                <button class="close-btn" onclick="closeModal('editItemModal')">&times;</button>
            </div>
            <form action="UpdateInventory.jsp" method="POST">
                <input type="hidden" name="partId" id="editItemSku">
                <div class="form-group"><label>Part Name</label><input type="text" name="partName" id="editItemName" required></div>
                <div class="form-group"><label>Manufacturer</label><input type="text" name="brand" id="editItemCategory" required></div>
                <div class="form-group" style="display: flex; gap: 15px;">
                    <div style="flex: 1;"><label>Stock</label><input type="number" name="qty" id="editItemStock" required></div>
                    <div style="flex: 1;"><label>Unit Cost (RM)</label><input type="number" step="0.01" name="cost" id="editItemPrice" required></div>
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn-cancel" onclick="closeModal('editItemModal')">Cancel</button>
                    <button type="submit" class="btn-save">Save Changes</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Tab Logic
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

        // Search Logic
        function filterInventory() {
            let input = document.getElementById('invSearch').value.toLowerCase();
            let rows = document.querySelectorAll('.inv-row');
            rows.forEach(row => { row.style.display = row.innerText.toLowerCase().includes(input) ? '' : 'none'; });
        }

        // Modal Logic
        function openModal(id) { document.getElementById(id).style.display = 'flex'; }
        function closeModal(id) { document.getElementById(id).style.display = 'none'; }

        function openRestockModal(id, name, qty) {
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