<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    String id = request.getParameter("userId");

    if (id != null) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lappo2", "root", "Zack1234!");

            // Deleting from the parent table deletes child records automatically due to CASCADE
            String sql = "DELETE FROM User WHERE UserID = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(id));

            pstmt.executeUpdate();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    response.sendRedirect("admin_users.jsp");
%>