<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // Database Connection Settings
    String dbURL = "jdbc:mysql://localhost:3306/lappo";
    String dbUser = "root";
    String dbPass = "12345";

    String id = request.getParameter("id");
    String action = request.getParameter("action");

    if (id != null && action != null) {
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(dbURL, dbUser, dbPass);

            if (action.equals("approve")) {
                // Change status to In Progress
                String sql = "UPDATE Repair SET CurrentStatus = 'In Progress' WHERE Repairid = ?";
                pstmt = con.prepareStatement(sql);
                pstmt.setString(1, id);
                pstmt.executeUpdate();
            } 
            else if (action.equals("reject")) {
                // Delete the record from the database
                String sql = "DELETE FROM Repair WHERE RepairID = ?";
                pstmt = con.prepareStatement(sql);
                pstmt.setString(1, id);
                pstmt.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (pstmt != null) pstmt.close();
            if (con != null) con.close();
        }
    }

    // Redirect back to dashboard to see changes
    response.sendRedirect("admin_dashboard.jsp");
%>