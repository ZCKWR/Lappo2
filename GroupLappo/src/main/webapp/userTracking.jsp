<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
               <a href="userTracking.jsp" class="active">
                    <i class="fas fa-search-location"></i> <span>Track Repair</span>
                </a>
                <a href="userHistory.jsp">
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
            
            <div class="track-search-container">
                <h2>Track Your Repair Status</h2>
                <p style="color: var(--light-text-color);">Enter your Device to check status.</p>
                
                <div class="search-bar">
                    <input type="text" class="search-input" placeholder="Lenovo..." >
                    <button class="search-btn">Track</button>
                </div>
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
                                <th>Tracking ID</th>
                                <th>Date</th>
                                <th>Device</th>
                                <th>Issue</th>
                                <th>Technician</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>#REQ-2023-001</strong></td>
                                <td>Oct 24, 2023</td>
                                <td>MacBook Air M1</td>
                                <td>Screen Glitch</td>
                                <td>Zakwan</td>
                                <td><span class="badge badge-progress">In Progress</span></td>
                                <td>-</td>
                            </tr>
                            <tr>
                                <td><strong>#REQ-2023-002</strong></td>
                                <td>Oct 20, 2023</td>
                                <td>Dell XPS 13</td>
                                <td>Battery Replacement</td>
                                <td>Amad</td>
                               
                                <td>
                                <span class="badge badge-payment">Payment Pending</span>
                                </td>
                                <td>
                                <button class="btn-pay-status" onclick="showPaymentModal('#REQ-2023-002', '150.00')">
                                        <i class="fas fa-credit-card"></i> Pay Now
                                    </button>
                                </td>
                            </tr>
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
            
            <form onsubmit="event.preventDefault(); processPayment();">
                <div class="form-group">
                    <label>Payment Method</label>
                    <select id="paymentMethod" onchange="togglePaymentFields()">
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
                    <span style="color: var(--primary-color);" id="p_amount">RM 0.00</span>
                </div>
                
                <button type="submit" class="btn-confirm-pay">Confirm Payment</button>
            </form>
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
        function showPaymentModal(id, amount) {
            document.getElementById('p_id').textContent = id;
            document.getElementById('p_amount').textContent = 'RM ' + amount;
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
                closeModal('paymentModal');
                btn.textContent = originalText;
                btn.disabled = false;
                // In a real app, you would likely reload the page or update the table row here
                 location.reload(); 
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
    </script>

</body>
</html>