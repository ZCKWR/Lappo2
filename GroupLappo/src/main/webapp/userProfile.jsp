<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="userModel.Student" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Lappo</title>
     <link rel="stylesheet" href="CSS/userProfile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
 
 <%
 Student bean = (Student) session.getAttribute("userProfile");
 // Safety check
 if (bean == null) {
     bean = new Student(); // avoid null errors
 }
 
 %>
 
 <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
   
</head>
<body>
<% String studentName = (String) session.getAttribute("username"); %>

    <div class="wrapper">
        <!-- Sidebar Navigation -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <i class="fas fa-laptop"></i> <span>Welcome <%= studentName %></span>
            </div>
            <div class="sidebar-nav">
               <a href="ongoingRepairs" >
                    <i class="fas fa-th-large"></i> <span>Dashboard</span>
                </a>
               <a href="repairStatus" >
                    <i class="fas fa-search-location"></i> <span>Track Repair</span>
                </a>
                <a href="pastInvoices">
                    <i class="fas fa-history"></i> <span>History</span>
                </a>
                <a href="Profile" class="active">
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
            <div class="profile-header">
                <h1>My Profile</h1>
            </div>

            <div class="profile-grid">
                <!-- User Summary Card -->
                <div class="card user-card">
                    <div class="large-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <h2><%= bean.getUsername() %></h2>
                    <p>USER ID: <%=bean.getUserID() %></p>
                    
                    <span class="role-badge">Student</span>
                </div>

                <!-- User Details Form -->
                <div class="card details-card">
                    <div class="details-header">
                        <h3>Personal Information</h3> 
                    </div>
                    
                    <form action="Profile" method="post" onsubmit="return confirmUpdate(event);">
                    	<input type="hidden" name="userID" value="<%= bean.getUserID() %>">
                        <div class="info-group">
                            <div class="form-group">
                                <label>Full Name</label>
                                <input type="text" name="username"class="form-control" value="<%= bean.getUsername() %>">
                            </div>
                           <div class="form-group">
                                <label>Email Address</label>
                                <input type="email" name="useremail" class="form-control" value="<%= bean.getUserEmail() %>">
                            </div>
                        </div>

                        <div class="info-group">
                            
                            <div class="form-group">
                                <label>Phone Number</label>
                                <input type="text" name="userphone" class="form-control" value="<%= bean.getUserPhoneNumber() %>">
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Address</label>
                            <input type="text" name="useraddress" class="form-control" value="<%= bean.getUserAddress() %>">
                        </div>
                        
                        <div class="details-header">
                        <input type="submit" name="Submit" value="Update Profile" class="btn-save">
                        </div>
						
						<!--  
                        <div class="info-group">
                            <div class="form-group">
                                <label>Campus</label>
                                <input type="text" class="form-control" value="Uitm Tapah">
                            </div>
                           
                        </div>
                        -->
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
            text: 'Are you sure you want to update this your profile?',
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