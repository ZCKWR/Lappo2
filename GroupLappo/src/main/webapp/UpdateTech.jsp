<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    String repairId = request.getParameter("repairId");
    String techUserId = request.getParameter("techUserId");

    if (repairId != null && techUserId != null) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lappo", "root", "12345");

            // Update assigned tech and set status to In Progress
            String sql = "UPDATE Repair SET AssignedTech = ?, CurrentStatus = 'In Progress' WHERE RepairID = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(techUserId));
            pstmt.setInt(2, Integer.parseInt(repairId));

            pstmt.executeUpdate();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    response.sendRedirect("admin_active_repair.jsp");
%>