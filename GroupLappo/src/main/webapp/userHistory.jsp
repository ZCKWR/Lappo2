<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Repair History - Lappo</title>
    <link rel="stylesheet" href="CSS/userHistory.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    
</head>
<body>

    <div class="wrapper">
        <!-- Sidebar -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <i class="fas fa-laptop"></i> <span>Lappo Student</span>
            </div>
            <div class="sidebar-nav">
                <a href="UserDashboard.jsp" >
                    <i class="fas fa-th-large"></i> <span>Dashboard</span>
                </a>
               <a href="userTracking.jsp">
                    <i class="fas fa-search-location"></i> <span>Track Repair</span>
                </a>
                <a href="userHistory.jsp" class="active">
                    <i class="fas fa-history"></i> <span>History</span>
                </a>
                <a href="userProfile.jsp">
                    <i class="fas fa-user-circle"></i> <span>Profile</span>
                </a>
            </div>
            <div class="sidebar-footer">
                <button class="btn-logout" onclick="window.location.href='index.html'">
                    <i class="fas fa-sign-out-alt"></i> <span>Log Out</span>
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
                <div class="user-profile" onclick="window.location.href='userProfile.jsp'">
                    <i class="far fa-bell" style="font-size: 1.2em; color: var(--light-text-color); cursor: pointer;" onclick="event.stopPropagation()"></i>
                    <span>Zakwan</span>
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
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><strong>#REQ-2023-002</strong></td>
                            <td>Oct 20, 2023</td>
                            <td>Dell XPS 13</td>
                            <td>Battery Replacement</td>
                            <td>RM 150.00</td>
                            <td><span class="badge badge-completed">Completed</span></td>
                            <td><button class="btn-sm" onclick="showReceipt('#REQ-2023-002', 'Dell XPS 13', 'Battery Replacement', '150.00', 'Oct 20, 2023')">View Receipt</button></td>
                        </tr>
                        <tr>
                            <td><strong>#REQ-2023-003</strong></td>
                            <td>Sep 15, 2023</td>
                            <td>iPhone 11</td>
                            <td>Water Damage Repair</td>
                            <td>RM 250.00</td>
                            <td><span class="badge badge-completed">Completed</span></td>
                            <td><button class="btn-sm" onclick="showReceipt('#REQ-2023-003', 'iPhone 11', 'Water Damage Repair', '250.00', 'Sep 15, 2023')">View Receipt</button></td>
                        </tr>
                        <tr>
                            <td><strong>#REQ-2023-004</strong></td>
                            <td>Aug 05, 2023</td>
                            <td>HP Pavilion</td>
                            <td>Keyboard Replacement</td>
                            <td>RM 0.00</td>
                            <td><span class="badge badge-cancelled">Cancelled</span></td>
                            <td><button class="btn-sm">Details</button></td>
                        </tr>
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
                    <span id="r_id" style="font-weight: 600;">#REQ-000</span>
                </div>
                <div class="receipt-row">
                    <span style="color: var(--light-text-color);">Date</span>
                    <span id="r_date">Jan 01, 2024</span>
                </div>
                <div class="receipt-row">
                    <span style="color: var(--light-text-color);">Device</span>
                    <span id="r_device">Laptop Model</span>
                </div>
                 <div class="receipt-row">
                    <span style="color: var(--light-text-color);">Service</span>
                    <span id="r_service">Repair Type</span>
                </div>
                <div class="receipt-row">
                    <span style="color: var(--light-text-color);">Payment Method</span>
                    <span id="r_payment">Online (FPX)</span>
                </div>
                
                <div class="receipt-total">
                    <span>Total Paid</span>
                    <span style="color: var(--primary-color);" id="r_total">RM 0.00</span>
                </div>
            </div>
            
            <button class="btn-print" onclick="window.print()">Print Receipt</button>
        </div>
    </div>

    <script>
        function showReceipt(id, device, service, cost, date) {
            document.getElementById('r_id').textContent = id;
            document.getElementById('r_device').textContent = device;
            document.getElementById('r_service').textContent = service;
            document.getElementById('r_total').textContent = 'RM ' + cost;
            document.getElementById('r_date').textContent = date;
            
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
    </script>

</body>
</html>