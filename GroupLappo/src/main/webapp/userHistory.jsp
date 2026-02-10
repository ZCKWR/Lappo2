<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="userModel.Invoice" %>
<%@ page import="userModel.Repair" %>
<%@ page import="userDAO.RepairDAO" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Repair History - Lappo</title>
    <link rel="stylesheet" href="CSS/userHistory.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    
    <%  List<Invoice> viewInvoice = (List<Invoice>) request.getAttribute("viewInvoices");%>
</head>
<body>
<% String studentName = (String) session.getAttribute("username"); %>

    <div class="wrapper">
        <!-- Sidebar -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <i class="fas fa-laptop"></i> <span> <%= studentName %></span>
            </div>
            <div class="sidebar-nav">
                <a href="ongoingRepairs" >
                    <i class="fas fa-th-large"></i> <span>Dashboard</span>
                </a>
               <a href="repairStatus">
                    <i class="fas fa-search-location"></i> <span>Track Repair</span>
                </a>
                <a href="pastInvoices" class="active">
                    <i class="fas fa-history"></i> <span>History</span>
                </a>
                <a href="Profile">
                    <i class="fas fa-user-circle"></i> <span>Profile</span>
                </a>
            </div>
            <div class="sidebar-footer">
                <button class="btn-logout" onclick="window.location.href='LoginPage.jsp'">
                    <i class="fas fa-sign-out-alt"></i> <span>Logout</span>
                </button>
            </div>
        </nav>

        <!-- Main Content -->
        <main class="main-content">
            
            <header class="top-header">
                <div>
                    <h1>Repair History</h1>
                    <p style="color: var(--light-text-color); margin-top: 5px;">View your past service records.</p>
                </div>
                <div class="user-profile" onclick="window.location.href='Profile'">
                    <i class="far fa-bell" style="font-size: 1.2em; color: var(--light-text-color); cursor: pointer;" onclick="event.stopPropagation()"></i>
                    <span><%= studentName %></span>
                    <div class="avatar-circle"><i class="fas fa-user"></i></div>
                </div>
            </header>

            <div class="panel">
                <div class="panel-header">
                    <h2>Past Repairs</h2>
                </div>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Job ID</th>
                            <th>Date Completed</th>
                            <th>Device</th>
                            <th>Issue</th>
                            <th>Total Cost</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    	<%
    						List<Invoice> invoiceList = (List<Invoice>) request.getAttribute("invoiceList");

    						if (invoiceList != null) {
        					for (Invoice inv : invoiceList) {
						%>
                        <tr>
                            <td><%= inv.getInvoiceID() %></td>
    						<td><%= inv.getPaymentDate() %></td>
    						<td><%= inv.getLaptopModel() %></td>
    						<td><%= inv.getIssue() %></td>
    						<td>RM <%= String.format("%.2f", inv.getPaymentAmount()) %></td>
                            <td>
        					<button onclick="showReceipt(<%= inv.getInvoiceID() %> )">
            					View Invoice
        					</button>
    						</td>
                        </tr>
                        <%
        						}
    						}
						%>
                    </tbody>
                </table>
            </div>

        </main>
    </div>

    <!-- Receipt Modal -->
    <div id="receiptModal" class="modal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeReceiptModal()">&times;</span>
            <div class="receipt-header">
                <i class="fas fa-check-circle" style="color: var(--primary-color); font-size: 3em; margin-bottom: 10px;"></i>
                <h2>Payment Receipt</h2>
                <p>Thank you for using Lappo!</p>
            </div>
         
            <div class="receipt-details">
                <div class="receipt-row">
                    <span style="color: var(--light-text-color);">Transaction ID</span>
                    <span id="r_id" style="font-weight: 600;"></span>
                </div>
                <div class="receipt-row">
                    <span style="color: var(--light-text-color);">Date</span>
                    <span id="r_date"></span>
                </div>
                <div class="receipt-row">
                    <span style="color: var(--light-text-color);">Labour Cost</span>
                    <span id="r_labour"></span>
                </div>
                 <div class="receipt-row">
                    <span style="color: var(--light-text-color);">Part Cost</span>
                    <span id="r_partcost"></span>
                </div>
                <div class="receipt-row">
                    <span style="color: var(--light-text-color);">Payment Type</span>
                    <span id="r_type"> </span>
                </div>
                
                <div class="receipt-total">
                    <span>Total Paid</span>
                    <span style="color: var(--primary-color);" id="r_total"></span>
                </div>
            </div>
            
            <button class="btn-print" onclick="window.print()">Print Receipt</button>
        </div>
    </div>

    <script>
        function showReceipt(repairID) {
        
        	const invoice = invoiceData[repairID];
            if (!invoice) {
                alert("Invoice not found");
                return;
            }
            document.getElementById('r_id').textContent = repairID;
            document.getElementById('r_type').textContent = invoice.paytype;
            document.getElementById('r_labour').textContent = 'RM' + invoice.labour;
            document.getElementById('r_partcost').textContent = 'RM ' + invoice.partcost;            
            document.getElementById('r_total').textContent = 'RM ' + invoice.amount;
            document.getElementById('r_date').textContent = invoice.date;
            
            
            document.getElementById('receiptModal').style.display = 'flex';
        }

        function closeReceiptModal() {
            document.getElementById('receiptModal').style.display = 'none';
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            var modal = document.getElementById('receiptModal');
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }
        
        
        const invoiceData = {
                <% for (Invoice pastInv : viewInvoice) {
                %>
                <%= pastInv.getInvoiceID() %>: {
                    paytype: "<%= pastInv.getPaymentType() %>",
                    labour: "<%= pastInv.getLabourCost() %>",
                    amount: "<%= pastInv.getPaymentAmount() %>",
                    partcost: "<%= pastInv.getPartCost() %>",
                    date: "<%= pastInv.getPaymentDate() %>"
                },
                <% } %>
            };
    </script>

</body>
</html>