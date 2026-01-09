<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
 import="java.util.List, techModel.techProfile" import="java.text.SimpleDateFormat"  import="java.sql.*, java.util.*"
import="javax.naming.*, javax.sql.*" %>

<jsp:useBean id="profile" class="techModel.techProfile" scope="request"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Technician Profile - Lappo</title>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="CSS/AllTechnicianCSS.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <%
    // Retrieve the bean stored in session
    techProfile bean = (techProfile) session.getAttribute("techProfile");

    // Safety check
    if (bean == null) {
        bean = new techProfile(); // avoid null errors
    }
%>
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    
   
</head>
<body>

    <div class="admin-wrapper">
       
        <nav class="sidebar">
            <div class="sidebar-header">
    	<i class="fas fa-laptop"></i> <p>Welcome, <span><%= bean.getTechName() %></span></p>
    	</div>
            <div class="sidebar-nav">
                <a href="jobController" >
                    <i class="fas fa-chart-pie"></i> <span>Dashboard</span>
                </a>
                <a href="jobServlet">
                    <i class="fas fa-wrench"></i> <span>Job</span>
                </a>
                <a href="requestPart">
                    <i class="fas fa-boxes"></i> <span>Request</span>
                </a>
                <a href="techUpdate" class="active">
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
                <h1>Technician Profile</h1>
            </div>
           
            <div class="profile-grid">
                <div class="card user-card">
                    <div class="large-avatar"><i class="fas fa-user-cog"></i></div>
                    <h2>Tech <%= bean.getTechName() %> </h2>
                    <p>Technician ID: TEC-<%= bean.getTechID() %></p>
                    <span class="role-badge">Senior Technician</span>
               
  
                </div>

                <div class="card details-card">

                    <form action="techUpdate" method="post" onsubmit="return confirmUpdate(event);">
                    	<input type="hidden" name="techId" value="<%= bean.getTechID() %>">
                    	
                        <div class="info-group">
                            <div class="form-group">
                                <label>Full Name</label>
                                <input type="text" class="form-control" name="username" value="<%= bean.getTechName() %>" />
                            </div>
                            <div class="form-group">
                                <label>Staff ID</label>
                                <input type="text" class="form-control"  name="techId" value="<%= bean.getTechID() %>" readonly style="background-color: #eee;">
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Email Address</label>
                            <input type="email" class="form-control" name="email" value="<%= bean.getTechEmail() %>">
                        </div>

                        <div class="form-group">
                            <label>Phone Number</label>
                            <input type="text" class="form-control" name="phone" value="<%= bean.getTechPhone() %>">
                        </div>

                        <div class="form-group">
                            <label>Address</label>
                            <input type="text" class="form-control" name="address" value="<%= bean.getTechAddress() %>">
                        </div>
                          <div class="details-header">
                        <input type="submit" name="Submit" value="Update Profile" class="btn-save">
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
    
    
    <script>
    
    function confirmUpdate(event) {
        event.preventDefault(); // stop form first

        Swal.fire({
            title: 'Confirm Update',
            text: 'Are you sure you want to update this repair record?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Yes, update it',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                event.target.submit(); // submit form
            }
        });
    }
     
    
    </script>

</body>
</html>