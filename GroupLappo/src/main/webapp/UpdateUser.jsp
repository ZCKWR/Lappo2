<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    String id = request.getParameter("userId");
    String name = request.getParameter("userName");
    String email = request.getParameter("userEmail");
    String newRole = request.getParameter("userRole"); 

    if (id != null) {
        Connection con = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lappo", "root", "12345");
            con.setAutoCommit(false);

            // 1. Identify current role
            String currentRole = "";
            PreparedStatement psCheck = con.prepareStatement("SELECT UserType FROM User WHERE UserID = ?");
            psCheck.setInt(1, Integer.parseInt(id));
            ResultSet rs = psCheck.executeQuery();
            if(rs.next()) {
                currentRole = rs.getString("UserType");
            }

            // 2. Update the parent User table
            PreparedStatement psUpdate = con.prepareStatement("UPDATE User SET Username=?, UserEmail=?, UserType=? WHERE UserID=?");
            psUpdate.setString(1, name);
            psUpdate.setString(2, email);
            psUpdate.setString(3, newRole);
            psUpdate.setInt(4, Integer.parseInt(id));
            psUpdate.executeUpdate();

            // 3. Role Migration Logic (Only if role actually changed)
            if (!newRole.equalsIgnoreCase(currentRole)) {
                // Delete from ALL old child tables to ensure no duplicate roles
                String[] tables = {"Student", "Technician", "Admin"};
                for (String table : tables) {
                    PreparedStatement psDel = con.prepareStatement("DELETE FROM " + table + " WHERE UserID=?");
                    psDel.setInt(1, Integer.parseInt(id));
                    psDel.executeUpdate();
                }

                // Insert into the new requested role table
                String sqlChild = "";
                if ("Student".equalsIgnoreCase(newRole)) 
                    sqlChild = "INSERT INTO Student (UserID, CampusName) VALUES (?, 'Not Set')";
                else if ("Technician".equalsIgnoreCase(newRole)) 
                    sqlChild = "INSERT INTO Technician (UserID, HourlyRate) VALUES (?, 0.00)";
                else if ("Admin".equalsIgnoreCase(newRole)) 
                    sqlChild = "INSERT INTO Admin (UserID, DateHired) VALUES (?, CURDATE())";

                if(!sqlChild.equals("")) {
                    PreparedStatement psInsert = con.prepareStatement(sqlChild);
                    psInsert.setInt(1, Integer.parseInt(id));
                    psInsert.executeUpdate();
                }
            }

            con.commit();
        } catch (Exception e) {
            if (con != null) con.rollback();
            out.println("<div style='color:red; font-family:sans-serif; padding:20px; border:2px solid red;'>");
            out.println("<h2>Update Denied</h2>");
            out.println("<p>Error: " + e.getMessage() + "</p>");
            out.println("<p>Ensure you ran the SQL migration to redirect Foreign Keys to the User table.</p>");
            out.println("<a href='admin_users.jsp'>Go Back</a>");
            out.println("</div>");
            return;
        } finally {
            if (con != null) con.close();
        }
    }
    response.sendRedirect("admin_users.jsp");
%>