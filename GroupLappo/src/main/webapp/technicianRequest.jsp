<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
import="java.util.List, techModel.reqPart" import="java.text.SimpleDateFormat"  import="java.sql.*, java.util.*"
import="javax.naming.*, javax.sql.*"
import="techModel.partTrack"%>
<!DOCTYPE html> 
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lappo Technician - Inventory</title>
    <link rel="stylesheet" href="CSS/AllTechnicianCSS.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <jsp:useBean id="repairDao" class="techModel.partTrack" scope="page" />
    
    <%
    // Fetch part list from the database to populate dropdown
    Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lappo2", "root", "Zack1234!");
    Statement stmt = con.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT partID, partName, manufacturer FROM part");
    
    Integer count = (Integer) session.getAttribute("assignedJobsCount");
    int totalReq = (count != null) ? count : 0;
    %>
    
    
    
   
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
                 <a href="jobController" >
                    <i class="fas fa-chart-pie"></i> <span>Dashboard</span>
                </a>
                <a href="jobServlet">
                    <i class="fas fa-wrench"></i> <span>Job</span>
                </a>
                <a href="requestPart" class="active">
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
                    <h1>Part Request</h1>
                </div>
               <div class="user-profile" onclick="window.location.href='technicianProfile.jsp'">
                    <i class="far fa-bell" style="font-size: 1.2em; color: var(--light-text-color); cursor: pointer; margin-right: 15px;" onclick="event.stopPropagation()"></i>
                    <div class="avatar-circle"><i class="fas fa-user"></i></div>
                </div>
            </header>

            <!-- Inventory Stats -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-info">
                        <h3>Part Requested</h3>
                        <p class="number"><%= request.getAttribute("partReqCount") %></p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-info">
                        <h3>Pending</h3>
                        <p class="number" style="color: var(--warning-color);"><%= request.getAttribute("partPenCount") %></p>
                    </div>                   
                </div>
                <div class="stat-card">
                    <div class="stat-info">
                        <h3>Approved</h3>
                        <p class="number" style="color: green"><%= request.getAttribute("partApproveCount") %></p>
                    </div>                   
                </div>
            </div>

            <!-- Inventory Toolbar -->
            <div class="inventory-toolbar">
                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <input type="text" id="searchInput" placeholder="Search by Part Name, ID, or Category...">
                </div>
                <button class="btn-add" id="openModalBtn">
                    <i class="fas fa-plus"></i> Request New Part
                </button>
            </div>

            <!-- Inventory Table -->
            <div class="panel">
                <table class="data-table" id="inventoryTable">
                    <thead>
                        <tr>
                            <th>Repair ID</th>
                            <th>Part Name</th>
                            <th>Manufacturer</th>
                            <th>Quantity Requested</th>
                            <th>Date Request</th>
                            <th>Date Approved</th>
                            <th>Approval Status</th>
                        </tr>
                    </thead>
                    <tbody id="partsTableBody">
              <%
            // 1. Manually retrieve the list from the request
           List<reqPart> reqList = (List<reqPart>) session.getAttribute("reqsPart");
            
            // 2. Check if the list exists and loop through it
           if (reqList != null && !reqList.isEmpty()) {
                for (int i = 0; i < reqList.size(); i++) {
                	reqPart s = reqList.get(i);
        	%>
                 <tr>
                            <td><strong><%= s.getRepairID() %></strong></td>
                            <td><%= s.getPartName() %></td>
                            <td><%= s.getManufacturer() %></td>
                            <td><%= s.getQuantityReq() %></td>
                            <td><%= s.getDateReq() %></td>
                            <td><%= s.getDateApproved() %></td>
                            <td>
                                <p><span class="badge badge-warning"> <%= s.getApprovalStatus() %></span> </p>
                            </td>
                        </tr>
                
            <%= (i < reqList.size() - 1) ? "," : "" %>
            <%    }  }
        
    %>

                    </tbody>
                </table>
            </div>

        </main>
    </div>
    
    <!-- Request Part Modal -->
    <div id="addItemModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Request New Part</h2>
                <button class="close-btn" id="closeModalX">&times;</button>
            </div>
            <form id="addItemForm" name="partRequest" action="requestPart" method="post">
                <div class="form-group">
                
					 <label>Repair Identification Number</label>
						 <select name="repairID" id="rID" required>
						 <option value="">-- Select Repair Job --</option>
	  <%
     		   List<partTrack> repairList =
            (List<partTrack>) session.getAttribute("repairList");

      	  if (repairList != null && !repairList.isEmpty()) {
            for (partTrack pt : repairList) {
    		%>
                <option value="<%= pt.getRepairID() %>">
                    <%= pt.getRepairID() %> -
  					<%= pt.getStatus() %> -
  					<%= pt.getDate() %> -
  					<%= pt.getModel() %> -
 					<%= pt.getProblem() %> 
                </option>
   	 			<%
            	}
        		}
    			%>
    		</select>
					 
                    <label>Part Name</label>
                    <select name ="partID" id="pID" required>
                    <% while(rs.next()){ %>
						<option value="<%= rs.getInt("partID") %>">
						<%= rs.getString("partName") %> - <%= rs.getString("manufacturer") %>
					</option>
					 <% } %>
                    </select>

                </div>
                 <div class="form-group">
                    <label>Quantity</label>
                    <input type="number" name="quantityReq" id="qReq" min="1" required>
                    
                      <!-- You can replace with session username -->
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn-cancel" id="cancelBtn">Cancel</button>
                    <input type="submit" name="Submit" class="btn-save" value="Submit Request">
                </div>
            </form>
        </div>
    </div>

    <!-- JAVASCRIPT FOR MODAL & ADD ITEM -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // DOM Elements
            const modal = document.getElementById('addItemModal');
            const openBtn = document.getElementById('openModalBtn');
            const closeBtnX = document.getElementById('closeModalX');
            const cancelBtn = document.getElementById('cancelBtn');
            const form = document.getElementById('addItemForm');
            const tableBody = document.querySelector('#inventoryTable tbody');

            // Open Modal
            if(openBtn) {
                openBtn.addEventListener('click', function() {
                    modal.style.display = 'flex';
                });
            }


            // Close Modal functions
            function closeModal() {
                modal.style.display = 'none';
            }

            if(closeBtnX) closeBtnX.addEventListener('click', closeModal);
            if(cancelBtn) cancelBtn.addEventListener('click', closeModal);

            // Close if clicking outside content
            window.addEventListener('click', function(e) {
                if (e.target === modal) {
                    closeModal();
                }
            });
            
       

            // Handle Form Submission
            if(form) {
                form.addEventListener('submit', function(e) {


                    // 1. Get Values
                    const  repairId = document.getElementById('rID').value;
                    const partID = document.getElementById('pID').value;
                    const  manufacturer = document.getElementById('manu').value;
                    const quantity = document.getElementById('qReq').value;

                    // 3. Create New Row
                    var newRow = document.createElement('tr');
                    
                    // Using string concatenation to avoid JSP EL conflicts
                    var rowHtml = '<td><strong>' + name + '</strong></td>' +
                                  '<td style="color: var(--light-text-color);">' + sku + '</td>' +
                                  '<td>' + category + '</td>' +
                                  '<td>' + stockStatus + '</td>' +
                                  '<td>RM' + price + '</td>' +
                                  '<td>' + statusBadge + '</td>';
                    
                    newRow.innerHTML = rowHtml;

                    // 4. Add Animation class
                    newRow.style.animation = "fadeIn 0.5s";

                    // 5. Append to Table (at top)
                    tableBody.prepend(newRow);

                    // 7. Cleanup
                    form.reset();
                    closeModal();
                });
            }
        });
        
        //For searching 
         const searchInput = document.getElementById("searchInput");
  		const tbody = document.getElementById("partsTableBody");

 		 function filterTable() {
    	const keyword = searchInput.value.toLowerCase().trim();
    	const rows = tbody.querySelectorAll("tr");

    	 let visibleCount = 0;

    	rows.forEach(row => {
	      const text = row.innerText.toLowerCase();
	      const match = text.includes(keyword);
     	 row.style.display = match ? "" : "none";
      	if (match) visibleCount++;
    	});

    	// Optional: show "no results" row
    	const existingNoRow = document.getElementById("noResultsRow");
    	if (existingNoRow) existingNoRow.remove();

    	if (visibleCount === 0 && rows.length > 0) {
     	 const noRow = document.createElement("tr");
     	 noRow.id = "noResultsRow";
     	 noRow.innerHTML = `<td class="no-results" colspan="7">No matching records found.</td>`;
     	 tbody.appendChild(noRow);
   	 }
  	}

  	if (searchInput && tbody) {
    	searchInput.addEventListener("input", filterTable);
  }	
        
    </script>

</body>
</html>