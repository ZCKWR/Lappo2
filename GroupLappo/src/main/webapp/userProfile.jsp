<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Lappo</title>
     <link rel="stylesheet" href="CSS/userProfile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
   
</head>
<body>

    <div class="wrapper">
        <!-- Sidebar Navigation -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <i class="fas fa-laptop"></i> <span>Lappo Student</span>
            </div>
            <div class="sidebar-nav">
               <a href="UserDashboard.jsp" >
                    <i class="fas fa-th-large"></i> <span>Dashboard</span>
                </a>
               <a href="userTracking.jsp" >
                    <i class="fas fa-search-location"></i> <span>Track Repair</span>
                </a>
                <a href="userHistory.jsp">
                    <i class="fas fa-history"></i> <span>History</span>
                </a>
                <a href="userProfile.jsp" class="active">
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
            <div class="profile-header">
                <h1>My Profile</h1>
            </div>

            <div class="profile-grid">
                <!-- User Summary Card -->
                <div class="card user-card">
                    <div class="large-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <h2>Zakwan</h2>
                    <p>ID : 2025123</p>
                    
                    <span class="role-badge">Student</span>
                </div>

                <!-- User Details Form -->
                <div class="card details-card">
                    <div class="details-header">
                        <h3>Personal Information</h3>
                        <button class="btn-save">Save Changes</button>
                    </div>
                    
                    <form>
                        <div class="info-group">
                            <div class="form-group">
                                <label>Full Name</label>
                                <input type="text" class="form-control" value="Zawkan Imran">
                            </div>
                           <div class="form-group">
                                <label>Email Address</label>
                                <input type="email" class="form-control" value="Zakwan@hehe.com">
                            </div>
                        </div>

                        <div class="info-group">
                            
                            <div class="form-group">
                                <label>Phone Number</label>
                                <input type="text" class="form-control" value="+60 12-345 6789">
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Address</label>
                            <input type="text" class="form-control" value="Unires">
                        </div>

                        <div class="info-group">
                            <div class="form-group">
                                <label>Campus</label>
                                <input type="text" class="form-control" value="Uitm Tapah">
                            </div>
                           
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

</body>
</html>