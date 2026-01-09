<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // Get all parameters from the Add Modal
    String name = request.getParameter("userName");
    String email = request.getParameter("userEmail");
    String pass = request.getParameter("userPassword");
    String address = request.getParameter("userAddress");
    String phone = request.getParameter("userPhone");
    String role = request.getParameter("userRole"); 

    if (name != null && email != null) {
        Connection con = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lappo2", "root", "Zack1234!");
            
            // Start Transaction: Both inserts must succeed or both fail
            con.setAutoCommit(false); 

            // 1. Insert into Parent Table
            String sqlUser = "INSERT INTO User (Username, UserEmail, UserPassword, UserAddress, UserPhoneNumber, UserType) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement psUser = con.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS);
            psUser.setString(1, name);
            psUser.setString(2, email);
            psUser.setString(3, pass);
            psUser.setString(4, address);
            psUser.setString(5, phone);
            psUser.setString(6, role);
            psUser.executeUpdate();

            // Get the auto-generated UserID
            ResultSet rs = psUser.getGeneratedKeys();
            if (rs.next()) {
                int newId = rs.getInt(1);

                // 2. Insert into Child Table based on Role
                String sqlChild = "";
                if ("Student".equalsIgnoreCase(role)) {
                    sqlChild = "INSERT INTO Student (UserID, CampusName) VALUES (?, 'Not Set')";
                } else if ("Technician".equalsIgnoreCase(role)) {
                    sqlChild = "INSERT INTO Technician (UserID, HourlyRate) VALUES (?, 0.00)";
                } else if ("Admin".equalsIgnoreCase(role)) {
                    sqlChild = "INSERT INTO Admin (UserID, DateHired) VALUES (?, CURDATE())";
                }

                if (!sqlChild.isEmpty()) {
                    PreparedStatement psChild = con.prepareStatement(sqlChild);
                    psChild.setInt(1, newId);
                    psChild.executeUpdate();
                }
            }

            con.commit(); // Success: Save changes to DB
        } catch (Exception e) {
            if (con != null) try { con.rollback(); } catch (SQLException ex) {} // Failure: Undo changes
            e.printStackTrace();
            out.println("Error: " + e.getMessage());
            return;
        } finally {
            if (con != null) con.close();
        }
    }
    response.sendRedirect("admin_users.jsp");
%>