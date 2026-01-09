<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // Retrieve form data from the Add Item Modal
    String partName = request.getParameter("partName");
    String manufacturer = request.getParameter("brand");
    String qtyStr = request.getParameter("qty");
    String costStr = request.getParameter("cost");

    if (partName != null && !partName.trim().isEmpty()) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lappo2", "root", "Zack1234!");

            // SQL query to insert a new part record
            String sql = "INSERT INTO part (PartName, Manufacturer, Quantity, UnitCost) VALUES (?, ?, ?, ?)";
            PreparedStatement pstmt = con.prepareStatement(sql);
            
            pstmt.setString(1, partName);
            pstmt.setString(2, manufacturer);
            pstmt.setInt(3, Integer.parseInt(qtyStr));
            pstmt.setDouble(4, Double.parseDouble(costStr));

            pstmt.executeUpdate();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    // Redirect back to the inventory list
    response.sendRedirect("admin_inventory.jsp");
%>