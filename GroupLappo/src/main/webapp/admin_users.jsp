<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>

<%
    // Database Configuration
    String dbURL = "jdbc:mysql://localhost:3306/lappo2";
    String dbUser = "root";
    String dbPass = "Zack1234!";

    List<Map<String, String>> userList = new ArrayList<>();
    int studentCount = 0, techCount = 0, adminCount = 0;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);
        
        // Fetch all users to populate the table and counters
        String query = "SELECT UserID, Username, UserEmail, UserType FROM User ORDER BY UserID ASC";
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(query);

        while(rs.next()){
            Map<String, String> user = new HashMap<>();
            String type = rs.getString("UserType");
            
            user.put("id", rs.getString("UserID"));
            user.put("name", rs.getString("Username"));
            user.put("email", rs.getString("UserEmail"));
            user.put("type", type);

            if("Student".equalsIgnoreCase(type)) studentCount++;
            else if("Technician".equalsIgnoreCase(type)) techCount++;
            else if("Admin".equalsIgnoreCase(type)) adminCount++;

            userList.add(user);
        }
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lappo Admin - User Management</title>
    <link rel="stylesheet" href="CSS/AllAdminCSS.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>

    <div class="admin-wrapper">
        <nav class="sidebar">
            <div class="sidebar-header"><i class="fas fa-laptop"></i> <span>Lappo Admin</span></div>
            <div class="sidebar-nav">
                <a href="admin_dashboard.jsp"><i class="fas fa-chart-pie"></i> <span>Dashboard</span></a>
                <a href="admin_active_repair.jsp"><i class="fas fa-wrench"></i> <span>Repairs</span></a>
                <a href="admin_inventory.jsp"><i class="fas fa-boxes"></i> <span>Inventory</span></a>
                <a href="admin_users.jsp" class="active"><i class="fas fa-users"></i> <span>Users</span></a>
                <a href="adminProfile.jsp"><i class="fas fa-user-circle"></i> <span>Profile</span></a>
            </div>
            <div class="sidebar-footer">
                <button class="btn-logout" onclick="window.location.href='index.html'"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></button>
            </div>
        </nav>

        <main class="main-content">
            <header class="top-header">
                <div><h1>User Management</h1></div>
                <div class="user-profile" onclick="window.location.href='adminProfile.jsp'">
                    <div class="avatar-circle"><i class="fas fa-user"></i></div>
                </div>
            </header>

            <div class="filter-tabs">
                <div class="filter-tab active" onclick="filterRole('all', this)">All Users (<%= userList.size() %>)</div>
                <div class="filter-tab" onclick="filterRole('Student', this)">Students (<%= studentCount %>)</div>
                <div class="filter-tab" onclick="filterRole('Technician', this)">Technicians (<%= techCount %>)</div>
                <div class="filter-tab" onclick="filterRole('Admin', this)">Admins (<%= adminCount %>)</div>
            </div>

            <div class="toolbar">
                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <input type="text" id="userSearch" placeholder="Search by Name, Email, or ID..." onkeyup="searchUsers()">
                </div>
                <button class="btn-add" onclick="openAddModal()"><i class="fas fa-plus"></i> Add User</button>
            </div>

            <div class="panel">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Role</th>
                            <th>Email Address</th>
                            <th style="text-align: center;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(Map<String, String> user : userList) { 
                            String roleClass = "badge-student";
                            String iconClass = "fa-user";
                            if("Admin".equalsIgnoreCase(user.get("type"))) { roleClass = "badge-admin"; iconClass="fa-user-shield"; }
                            else if("Technician".equalsIgnoreCase(user.get("type"))) { roleClass = "badge-tech"; iconClass="fa-tools"; }
                        %>
                        <tr class="user-row" data-role="<%= user.get("type") %>">
                            <td>
                                <div class="user-cell">
                                    <div class="user-avatar-small"><i class="fas <%= iconClass %>"></i></div>
                                    <div>
                                        <strong><%= user.get("name") %></strong><br>
                                        <span style="font-size: 0.85em; color: var(--light-text-color);">ID: <%= user.get("id") %></span>
                                    </div>
                                </div>
                            </td>
                            <td><span class="badge <%= roleClass %>"><%= user.get("type") %></span></td>
                            <td><%= user.get("email") %></td>
                            <td style="text-align: center;">
                                <button class="btn-sm btn-edit" onclick="openEditModal('<%= user.get("id") %>', '<%= user.get("name") %>', '<%= user.get("email") %>', '<%= user.get("type") %>')">
                                    <i class="fas fa-pen"></i>
                                </button>
                                <% if(!"Admin".equalsIgnoreCase(user.get("type"))) { %>
                                    <button class="btn-sm btn-delete" onclick="confirmDelete('<%= user.get("id") %>')">
                                        <i class="fas fa-ban"></i>
                                    </button>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

    <div id="addUserModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Add New User</h2>
                <button class="close-btn" onclick="closeModal('addUserModal')">&times;</button>
            </div>
            <form action="AddUser.jsp" method="POST">
                <div class="form-group"><label>Full Name</label><input type="text" name="userName" required></div>
                <div class="form-group"><label>Email Address</label><input type="email" name="userEmail" required></div>
                <div class="form-group"><label>Password</label><input type="password" name="userPassword" required></div>
                <div class="form-group"><label>Address</label><input type="text" name="userAddress"></div>
                <div class="form-group"><label>Phone Number</label><input type="text" name="userPhone"></div>
                <div class="form-group">
                    <label>User Role</label>
                    <select name="userRole">
                        <option value="Student">Student</option>
                        <option value="Technician">Technician</option>
                        <option value="Admin">Admin</option>
                    </select>
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn-cancel" onclick="closeModal('addUserModal')">Cancel</button>
                    <button type="submit" class="btn-save">Save User</button>
                </div>
            </form>
        </div>
    </div>

    <div id="editUserModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Edit User</h2>
                <button class="close-btn" onclick="closeModal('editUserModal')">&times;</button>
            </div>
            <form action="UpdateUser.jsp" method="POST">
                <input type="hidden" name="userId" id="editUserId">
                <div class="form-group"><label>Full Name</label><input type="text" name="userName" id="editName" required></div>
                <div class="form-group"><label>Email Address</label><input type="email" name="userEmail" id="editEmail" required></div>
                <div class="form-group">
                    <label>User Role</label>
                    <select name="userRole" id="editRole">
                        <option value="Student">Student</option>
                        <option value="Technician">Technician</option>
                        <option value="Admin">Admin</option>
                    </select>
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn-cancel" onclick="closeModal('editUserModal')">Cancel</button>
                    <button type="submit" class="btn-save">Update User</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function searchUsers() {
            let input = document.getElementById('userSearch').value.toLowerCase();
            document.querySelectorAll('.user-row').forEach(row => {
                row.style.display = row.innerText.toLowerCase().includes(input) ? '' : 'none';
            });
        }

        function filterRole(role, element) {
            document.querySelectorAll('.filter-tab').forEach(tab => tab.classList.remove('active'));
            element.classList.add('active');
            document.querySelectorAll('.user-row').forEach(row => {
                row.style.display = (role === 'all' || row.getAttribute('data-role') === role) ? '' : 'none';
            });
        }

        function openAddModal() { document.getElementById('addUserModal').style.display = 'flex'; }
        
        function openEditModal(id, name, email, role) {
            document.getElementById('editUserId').value = id;
            document.getElementById('editName').value = name;
            document.getElementById('editEmail').value = email;
            document.getElementById('editRole').value = role;
            document.getElementById('editUserModal').style.display = 'flex';
        }

        function closeModal(modalId) { document.getElementById(modalId).style.display = 'none'; }

        function confirmDelete(id) {
            if(confirm("Are you sure you want to delete User ID: " + id + "?")) {
                window.location.href = "DeleteUser.jsp?userId=" + id;
            }
        }
    </script>
</body>
</html>