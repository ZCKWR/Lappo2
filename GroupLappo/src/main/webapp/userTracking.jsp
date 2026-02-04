<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="userModel.Repair" %>
<%@ page import="userDAO.RepairDAO" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Track Repair - Lappo</title>
   <link rel="stylesheet" href="CSS/userTracking.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
   
</head>
<body>
<% String studentName = (String) session.getAttribute("username"); %>

    <div class="wrapper">
        <!-- Sidebar -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <i class="fas fa-laptop"></i> <span>Welcome <%= studentName %></span>
            </div>
            <div class="sidebar-nav">
                <a href="ongoingRepairs" >
                    <i class="fas fa-th-large"></i> <span>Dashboard</span>
                </a>
               <a href="repairStatus" class="active">
                    <i class="fas fa-search-location"></i> <span>Track Repair</span>
                </a>
                <a href="pastInvoices">
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
            	<div class="track-search-container">
                	<h2>Track Your Repair Status</h2>
                	<p style="color: var(--light-text-color);">Enter your Device to check status.</p>
                	
            		<form action="repairStatus" method="get">
                		<div class="search-bar">
                    		<input type="text" class="search-input" name="device" placeholder="Lenovo..." >
                    		<button type="submit" class="search-btn">Track</button>
                		</div>
                	</form>
                	
            	</div>
			
            <!-- Result Section -->
            <div class="tracking-result">
                
                <div class="panel">
                    <div class="panel-header">
                        <h2>Repair Status</h2>
                    </div>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Device</th>
                                <th>Issue</th>
                                <th>Technician</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                           <%
    							List<Repair> statusRepairList = (List<Repair>) request.getAttribute("repairList");

    							if (statusRepairList != null) {
        							for (Repair r : statusRepairList) {
							%>
                            <tr>
    							<td><%= r.getDateIssued() %></td>
    							<td><%= r.getLaptopModel() %></td>
    							<td><%= r.getIssue() %></td>
    							<td><%= r.getUsername() %></td>
    							<td style="<%
    								String status = r.getCurrentStatus();
    								if ("Complete".equalsIgnoreCase(status)) {
        								out.print("color: green; font-weight: bold;");
    								} else if ("Payment Pending".equalsIgnoreCase(status)) {
        								out.print("color: orange; font-weight: bold;");
    								} else if ("Paid".equalsIgnoreCase(status)) {
        								out.print("color: orange; font-weight: bold;");
    								} else {
        								out.print("color: black;");
    								}
    							
								%>">
    								<%= status %>
								</td>


                                <td >
								<%
    								//String status = r.getCurrentStatus();

    								if ("Complete".equalsIgnoreCase(status)) {
								%>
        								<button onclick="openPayment(<%= r.getRepairID() %>, <%= new userDAO.RepairDAO().getPaymentAmountByRepairID(r.getRepairID())  %>)">
            								Pay Now
        								</button>
								<%
    								} else if ("Paid".equalsIgnoreCase(status)) {
								%>
        								<button onclick="openInvoice(<%= r.getRepairID() %>)">
            								View Invoice
        								</button>
								<%
    								} else {
								%>
        								<button disabled>—</button>
								<%
    								}
								%>
								</td>
                            </tr>
                            <%
        							}
    							}
                            %>
                        </tbody>
                    </table>
                </div>

            </div>

        </main>
    </div>

    
    
    
    <!-- Payment Modal -->
    <div id="paymentModal" class="modal">
        <div class="modal-content" style="text-align: left;">
            <span class="close-btn" onclick="closeModal('paymentModal')">&times;</span>
            <div class="receipt-header" style="text-align: center;">
                <i class="fas fa-credit-card" style="color: var(--primary-color); font-size: 2.5em; margin-bottom: 10px;"></i>
                <h2>Secure Payment</h2>
                <p>Completing payment for <span id="p_id" style="font-weight: bold;">#REQ-000</span></p>
            </div>
            
            <form  id="paymentForm" method="post" action="SubmitPayment" onsubmit="event.preventDefault(); processPayment();">
            
                <input type="hidden" name="repairID" id="repairIDInput">
    			<input type="hidden" name="amount" id="amountInput">
                <div class="form-group">
                    <label>Payment Method</label>
                    <select id="paymentMethod" name="paymentMethod" onchange="togglePaymentFields()">
                        <option value="card">Credit/Debit Card</option>
                        <option value="online">Online Banking (FPX)</option>
                    </select>
                </div>

                <div id="cardFields">
                    <div class="form-group">
                        <label>Cardholder Name</label>
                        <input type="text" placeholder="John Doe">
                    </div>
                    <div class="form-group">
                        <label>Card Number</label>
                        <input type="text" placeholder="0000 0000 0000 0000">
                    </div>
                    <div class="form-row">
                        <div class="form-group" style="flex: 1;">
                            <label>Expiry Date</label>
                            <input type="text" placeholder="MM/YY">
                        </div>
                        <div class="form-group" style="flex: 1;">
                            <label>CVV</label>
                            <input type="text" placeholder="123">
                        </div>
                    </div>
                </div>

                <div id="onlineFields" style="display: none;">
                    <div class="form-group">
                        <label>Select Bank</label>
                        <select>
                            <option>Maybank2u</option>
                            <option>CIMB Clicks</option>
                            <option>Public Bank</option>
                            <option>RHB Now</option>
                            <option>Hong Leong Connect</option>
                            <option>AmBank</option>
                            <option>Bank Islam</option>
                        </select>
                    </div>
                     <p style="font-size: 0.9em; color: var(--light-text-color); margin-bottom: 15px;">
                        You will be redirected to your bank's secure login page to complete the transaction.
                    </p>
                </div>
                
                <div class="receipt-total" style="margin-bottom: 20px;">
                    <span>Amount to Pay</span>
                    <span style="color: var(--primary-color);" id="p_amount">RM </span>
                </div>
                
                <button type="submit" class="btn-confirm-pay">Confirm Payment</button>
            </form>
        </div>
    </div>
    
    <!-- Invoice Modal -->
<div id="invoiceModal" class="modal">
    <div class="modal-content" style="text-align: left;">
        <span class="close-btn" onclick="closeModal('invoiceModal')">&times;</span>
        
        <div class="receipt-header" style="text-align: center;">
            <i class="fas fa-file-invoice-dollar" 
               style="color: var(--primary-color); font-size: 2.5em; margin-bottom: 10px;"></i>
            <h2>Invoice</h2>
            <p>Invoice for <span id="i_id" style="font-weight: bold;">#REQ-000</span></p>
        </div>

        <!-- Invoice Info (same spacing style as payment modal) -->
        <div class="form-group">
            <label>Device</label>
            <input type="text" id="i_device" readonly>
        </div>

        <div class="form-group">
            <label>Issue</label>
            <input type="text" id="i_issue" readonly>
        </div>

        <div class="form-group">
            <label>Payment Date</label>
            <input type="text" id="i_date" readonly>
        </div>

        <div class="receipt-total" style="margin-bottom: 20px;">
            <span>Total Paid</span>
            <span style="color: var(--primary-color);" id="i_amount">RM</span>
        </div>

        <button class="btn-confirm-pay" onclick="closeModal('invoiceModal')">
            Close
        </button>
    </div>
</div>

    <script>
        // Modal Logic
        function openBookingModal() {
            document.getElementById("bookingModal").style.display = "flex";
        }
        
        function closeBookingModal() {
            document.getElementById("bookingModal").style.display = "none";
        }
        
        // Payment Logic
        function openPayment(repairID, amount) {
        	// Set the repair ID
            document.getElementById('p_id').textContent = "#REQ-" + repairID;
        	
        	//Set the amount
            document.getElementById('p_amount').textContent = "RM " + amount.toFixed(2);
        	
        	//for update the status 
            document.getElementById('repairIDInput').value = repairID;
            document.getElementById('amountInput').value = amount.toFixed(2);
        	
        	// Show the modal
            document.getElementById('paymentModal').style.display = 'flex';
        }

        function togglePaymentFields() {
            var method = document.getElementById("paymentMethod").value;
            var cardFields = document.getElementById("cardFields");
            var onlineFields = document.getElementById("onlineFields");

            if (method === "card") {
                cardFields.style.display = "block";
                onlineFields.style.display = "none";
            } else {
                cardFields.style.display = "none";
                onlineFields.style.display = "block";
            }
        }

        function processPayment() {
            // Simulate processing
            const btn = document.querySelector('.btn-confirm-pay');
            const originalText = btn.textContent;
            btn.textContent = "Processing...";
            btn.disabled = true;
            
            setTimeout(() => {
                alert("Payment Successful!");
                
                document.getElementById("paymentForm").submit();
               // closeModal('paymentModal');
               // btn.textContent = originalText;
                // btn.disabled = false;
                // In a real app, you would likely reload the page or update the table row here
                // location.reload(); 
            }, 1500);
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }
        
        // Close modal if clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById("bookingModal");
            const paymentModal = document.getElementById("paymentModal");
            if (event.target == modal) {
                modal.style.display = "none";
            }
            if (event.target == paymentModal) {
                paymentModal.style.display = "none";
            }
        }
        
        function openInvoice(repairID) {
            // These values are injected from JSP
            const invoice = invoiceData[repairID];
            if (!invoice) {
                alert("Invoice not found");
                return;
            }

            document.getElementById('i_id').textContent = "#REQ-" + repairID;
            document.getElementById('i_device').value = invoice.device;
            document.getElementById('i_issue').value = invoice.issue;
            document.getElementById('i_date').value = invoice.date;
            document.getElementById('i_amount').textContent = 
                "RM " + parseFloat(invoice.amount).toFixed(2);

            document.getElementById('invoiceModal').style.display = 'flex';
        }
        
        const invoiceData = {
                <% for (Repair r : statusRepairList) {
                    if ("Paid".equalsIgnoreCase(r.getCurrentStatus())) {
                %>
                <%= r.getRepairID() %>: {
                    device: "<%= r.getLaptopModel() %>",
                    issue: "<%= r.getIssue() %>",
                    amount: "<%= new userDAO.RepairDAO()
                                .getPaymentAmountByRepairID(r.getRepairID()) %>",
                    date: "<%= r.getDateIssued() %>"
                },
                <% }} %>
            };
        
    </script>

</body>
</html>