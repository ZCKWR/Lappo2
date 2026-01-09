<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    String partId = request.getParameter("partId");
    String addQty = request.getParameter("addQuantity");

    if (partId != null && addQty != null && !addQty.isEmpty()) {
        Connection con = null;
        PreparedStatement pstmt = null;
        try {
            // Using the updated driver class name
            Class.forName("com.mysql.jdbc.Driver"); 
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lappo", "root", "12345");

            // Standard SQL update for the 'part' table
            String sql = "UPDATE part SET Quantity = Quantity + ? WHERE PartID = ?";
            pstmt = con.prepareStatement(sql);
            
            pstmt.setInt(1, Integer.parseInt(addQty));
            pstmt.setInt(2, Integer.parseInt(partId));

            int rowsAffected = pstmt.executeUpdate();
            
            // Optional: You can print this to the console for debugging
            System.out.println("Restock successful. Rows updated: " + rowsAffected);

        } catch (Exception e) {
            e.printStackTrace();
            // This will show the error on the screen if it fails
            out.println("Error updating stock: " + e.getMessage());
            return; 
        } finally {
            if (pstmt != null) pstmt.close();
            if (con != null) con.close();
        }
    }
    
    // Redirect back to refresh the table
    response.sendRedirect("admin_inventory.jsp");
%>