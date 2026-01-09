<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // Retrieve form data from the Edit Modal
    String partId = request.getParameter("partId");
    String partName = request.getParameter("partName");
    String manufacturer = request.getParameter("brand");
    String qtyStr = request.getParameter("qty");
    String costStr = request.getParameter("cost");

    if (partId != null && partName != null) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lappo", "root", "12345");

            // SQL query to update the specific part
            String sql = "UPDATE part SET PartName = ?, Manufacturer = ?, Quantity = ?, UnitCost = ? WHERE PartID = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            
            pstmt.setString(1, partName);
            pstmt.setString(2, manufacturer);
            pstmt.setInt(3, Integer.parseInt(qtyStr));
            pstmt.setDouble(4, Double.parseDouble(costStr));
            pstmt.setInt(5, Integer.parseInt(partId));

            pstmt.executeUpdate();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    // Redirect back to the inventory list
    response.sendRedirect("admin_inventory.jsp");
%>