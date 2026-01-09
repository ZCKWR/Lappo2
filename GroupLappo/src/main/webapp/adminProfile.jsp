<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Profile - Lappo</title>
    <link rel="stylesheet" href="CSS/AllAdminCSS.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
   
</head>
<body>

    <div class="admin-wrapper">
        <nav class="sidebar">
            <div class="sidebar-header"> <i class="fas fa-laptop"></i> <span>Lappo Admin</span> </div>
            <div class="sidebar-nav">
               <a href="admin_dashboard.jsp" class="active">
                    <i class="fas fa-chart-pie"></i> <span>Dashboard</span>
                </a>
                <a href="admin_active_repair.jsp">
                    <i class="fas fa-wrench"></i> <span>Repairs</span>
                </a>
                <a href="admin_inventory.jsp">
                    <i class="fas fa-boxes"></i> <span>Inventory</span>
                </a>
                <a href="admin_users.jsp">
                    <i class="fas fa-users"></i> <span>Users</span>
                </a>
                <a href="adminProfile.jsp" class="active">
                    <i class="fas fa-user-circle"></i> <span>Profile</span>
                </a>
            </div>
            <div class="sidebar-footer">
                <button class="btn-logout" onclick="window.location.href='index.html'">
                    <i class="fas fa-sign-out-alt"></i> <span>Logout</span>
                </button>
            </div>
        </nav>

        <main class="main-content">
            <div class="profile-header">
                <h1>Admin Profile</h1>
            </div>

            <div class="profile-grid">
                <div class="card user-card">
                    <div class="large-avatar"><i class="fas fa-user-shield"></i></div>
                    <h2>Sarah Admin</h2>
                    <p>System Manager</p>
                    <span class="role-badge">Administrator</span>
                </div>

                <div class="card details-card">
                    <div class="details-header">
                        <h3>Account Details</h3>
                        <button class="btn-save">Update Profile</button>
                    </div>
                    
                    <form>
                        <div class="info-group">
                            <div class="form-group">
                                <label>Full Name</label>
                                <input type="text" class="form-control" value="Sarah Admin">
                            </div>
                            <div class="form-group">
                                <label>Admin ID</label>
                                <input type="text" class="form-control" value="ADM-001" readonly style="background-color: #eee;">
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Email Address</label>
                            <input type="email" class="form-control" value="sarah.admin@lappo.com">
                        </div>

                        <div class="form-group">
                            <label>Role Description</label>
                            <input type="text" class="form-control" value="Manage users, inventory, and repair assignments.">
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

</body>
</html>