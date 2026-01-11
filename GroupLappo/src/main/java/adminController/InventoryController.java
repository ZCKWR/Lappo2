package adminController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet("/InventoryController")
public class InventoryController extends HttpServlet {
    private String dbURL = "jdbc:mysql://localhost:3306/lappo";
    private String dbUser = "root";
    private String dbPass = "12345";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        boolean success = false;
        
        Connection con = null;
        PreparedStatement ps = null;

        try {
            // Using the old MySQL driver
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(dbURL, dbUser, dbPass);
            
            if ("add".equals(action)) {
                String sql = "INSERT INTO part (PartName, Manufacturer, Quantity, UnitCost) VALUES (?, ?, ?, ?)";
                ps = con.prepareStatement(sql);
                ps.setString(1, request.getParameter("name"));
                ps.setString(2, request.getParameter("brand"));
                ps.setInt(3, Integer.parseInt(request.getParameter("qty")));
                ps.setDouble(4, Double.parseDouble(request.getParameter("cost")));
                success = ps.executeUpdate() > 0;

            } else if ("restock".equals(action)) {
                String sql = "UPDATE part SET Quantity = Quantity + ? WHERE PartID = ?";
                ps = con.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(request.getParameter("addQty")));
                ps.setInt(2, Integer.parseInt(request.getParameter("partId")));
                success = ps.executeUpdate() > 0;

            } else if ("edit".equals(action)) {
                String sql = "UPDATE part SET PartName = ?, Manufacturer = ?, Quantity = ?, UnitCost = ? WHERE PartID = ?";
                ps = con.prepareStatement(sql);
                ps.setString(1, request.getParameter("name"));
                ps.setString(2, request.getParameter("brand"));
                ps.setInt(3, Integer.parseInt(request.getParameter("qty")));
                ps.setDouble(4, Double.parseDouble(request.getParameter("cost")));
                ps.setInt(5, Integer.parseInt(request.getParameter("partId")));
                success = ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Manual closing of resources for old JDBC style
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
        }

        // Redirect back with status for feedback
        response.sendRedirect("admin_inventory.jsp?status=" + (success ? action + "_success" : "error"));
    }
}