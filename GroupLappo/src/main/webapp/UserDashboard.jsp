<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - Lappo</title>
    <link rel="stylesheet" href="CSS/UserDashboard.css">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
   
        
       
</head>
<body>

    <div class="wrapper">
        
        <!-- SIDEBAR (Light Theme) -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <i class="fas fa-laptop"></i> <span>Lappo Student</span>
            </div>
            
            <div class="sidebar-nav">
                <a href="#" class="active">
                    <i class="fas fa-th-large"></i> <span>Dashboard</span>
                </a>
               <a href="userTracking.jsp">
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

        <!-- MAIN CONTENT -->
        <main class="main-content">
            
            <!-- Header -->
            <header class="top-header">
                <div>
                    <h1>Welcome, Student</h1>
                    <p>Here's what's happening with your devices today.</p>
                </div>
                <div class="user-profile" onclick="window.location.href='userProfile.jsp'">
                    <i class="far fa-bell" style="font-size: 1.2em; color: var(--light-text-color); cursor: pointer;" onclick="event.stopPropagation()"></i>
                    <span>Zakwan Imran</span>
                    <div class="avatar-circle"><i class="fas fa-user"></i></div>
                </div>
            </header>

            <!-- Dashboard Statistics -->
            <div class="stats-grid">
                <!-- Active Repairs -->
                <div class="stat-card">
                    <div class="stat-info">
                        <h3>Active Repairs</h3>
                        <p class="number">1</p>
                    </div>
                    <div class="stat-icon icon-blue">
                        <i class="fas fa-tools"></i>
                    </div>
                </div>

                <!-- Total Repairs -->
                <div class="stat-card">
                    <div class="stat-info">
                        <h3>Total History</h3>
                        <p class="number">3</p>
                    </div>
                    <div class="stat-icon icon-teal">
                        <i class="fas fa-clipboard-check"></i>
                    </div>
                </div>

                <!-- Pending Payment -->
                <div class="stat-card">
                    <div class="stat-info">
                        <h3>Amount Due</h3>
                        <p class="number">RM 0.00</p>
                    </div>
                    <div class="stat-icon icon-orange">
                        <i class="fas fa-wallet"></i>
                    </div>
                </div>
            </div>

            <!-- Quick Action Bar -->
            <div class="action-bar">
                <button type="button" class="btn-action" onclick="openBookingModal()">
                    <i class="fas fa-plus"></i> Book New Repair
                </button>
            </div>

            <!-- Table: Current Repairs -->
            <div class="panel">
                <div class="panel-header">
                    <h2>Ongoing Repairs</h2>
                    <span class="badge badge-progress">1 Active</span>
                </div>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Tracking ID</th>
                            <th>Date Submitted</th>
                            <th>Device</th>
                            <th>Issue</th>
                            <th>Status</th>
                           
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><strong>#REQ-2023-001</strong></td>
                            <td>Oct 24, 2023</td>
                            <td>MacBook Air M1</td>
                            <td>Screen Display Glitch</td>
                            <td><span class="badge badge-progress">In Progress</span></td>
                           
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Table: Repair History -->
            <div class="panel">
                <div class="panel-header">
                    <h2>Past Repairs</h2>
                </div>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Device</th>
                            <th>Issue</th>
                            <th>Date Completed</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Dell XPS 13</td>
                            <td>Battery Replacement</td>
                            <td>Sep 15, 2023</td>
                            <td><span class="badge badge-completed">Completed</span></td>
                        </tr>
                        <tr>
                            <td>iPhone 11</td>
                            <td>Water Damage</td>
                            <td>Aug 02, 2023</td>
                            <td><span class="badge badge-completed">Completed</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>

        </main>
    </div>
    
    <!-- Booking Modal Popup -->
    <div id="bookingModal" class="modal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeBookingModal()">&times;</span>
            <h2 style="margin-top: 0; color: var(--text-color); margin-bottom: 20px;">Schedule Repair</h2>
            <form action="BookRepairServlet" method="post">
                <div class="form-group">
                    <label>Device Model</label>
                    <input type="text" name="device" placeholder="e.g. MacBook Pro 2021" required>
                </div>
                <div class="form-group">
                    <label>Issue Type</label>
                    <select name="issueType">
                        <option>Screen Damage</option>
                        <option>Battery Issue</option>
                        <option>Water Damage</option>
                        <option>Software/OS</option>
                        <option>Other</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" rows="3" placeholder="Please describe the issue..." required></textarea>
                </div>
                <div class="form-group">
                    <label>Preferred Date</label>
                    <input type="date" name="date" required>
                </div>
                <button type="submit" class="btn-submit">Confirm Booking</button>
            </form>
        </div>
    </div>

    <!-- Script to handle modal -->
    <script>
        // Simple and robust modal logic
        function openBookingModal() {
            var modal = document.getElementById("bookingModal");
            if (modal) {
                modal.style.display = "flex";
            }
        }
        
        function closeBookingModal() {
            var modal = document.getElementById("bookingModal");
            if (modal) {
                modal.style.display = "none";
            }
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            var modal = document.getElementById("bookingModal");
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }
    </script>

</body>
</html>