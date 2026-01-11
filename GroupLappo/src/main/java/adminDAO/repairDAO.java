package adminDAO;

import java.sql.*;
import java.util.*;

public class repairDAO {
    private String dbURL = "jdbc:mysql://localhost:3306/lappo2";
    private String dbUser = "root";
    private String dbPass = "Zack1234!";
    private String driver = "com.mysql.jdbc.Driver";

    // 1. Fetch All Repairs for Active Repairs Page
    public List<Map<String, Object>> getAllRepairs() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT r.RepairID, u.Username AS CustomerName, u.UserID AS CustomerID, " +
                     "r.LaptopModel, r.CurrentStatus, r.DateIssued, tech.Username AS TechName, " +
                     "(i.LabourCost + i.PartCost) AS CalculatedPrice " +
                     "FROM Repair r " +
                     "LEFT JOIN User u ON r.CustomerID = u.UserID " + 
                     "LEFT JOIN User tech ON r.AssignedTech = tech.UserID " +
                     "LEFT JOIN Invoice i ON r.RepairID = i.RepairID " + 
                     "ORDER BY r.DateIssued DESC";
        try {
            Class.forName(driver);
            try (Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);
                 Statement st = con.createStatement();
                 ResultSet rs = st.executeQuery(sql)) {
                while (rs.next()) {
                    Map<String, Object> r = new HashMap<>();
                    r.put("id", rs.getInt("RepairID"));
                    r.put("customer", rs.getString("CustomerName"));
                    r.put("customerId", rs.getString("CustomerID"));
                    r.put("device", rs.getString("LaptopModel"));
                    r.put("techName", rs.getString("TechName")); 
                    r.put("status", rs.getString("CurrentStatus"));
                    r.put("date", rs.getTimestamp("DateIssued"));
                    r.put("price", rs.getObject("CalculatedPrice"));
                    list.add(r);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 2. Fetch Technicians for the Assignment Dropdown
    public List<Map<String, String>> getTechnicians() {
        List<Map<String, String>> technicians = new ArrayList<>();
        String sql = "SELECT UserID, Username FROM User WHERE UserType = 'Technician'";
        try {
            Class.forName(driver);
            try (Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);
                 Statement st = con.createStatement();
                 ResultSet rs = st.executeQuery(sql)) {
                while (rs.next()) {
                    Map<String, String> t = new HashMap<>();
                    t.put("id", String.valueOf(rs.getInt("UserID")));
                    t.put("name", rs.getString("Username"));
                    technicians.add(t);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return technicians;
    }

    // 3. Assign Tech AND move to 'In Progress' (Used by Active Repairs page)
    public boolean assignAndApprove(int repairId, int techId, int adminId) {
        String sql = "UPDATE Repair SET AssignedTech = ?, ApprovedBy = ?, " +
                     "CurrentStatus = 'In Progress' WHERE RepairID = ?";
        try {
            Class.forName(driver);
            try (Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, techId);
                ps.setInt(2, adminId);
                ps.setInt(3, repairId);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // 4. NEW: Approve Repair Request (Used by Dashboard Approve Button)
    public boolean approveRepairOrder(int repairId, int adminId) {
        String sql = "UPDATE Repair SET CurrentStatus = 'In Progress', ApprovedBy = ? WHERE RepairID = ?";
        try {
            Class.forName(driver);
            try (Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, adminId);
                ps.setInt(2, repairId);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // 5. NEW: Reject Repair Request (Used by Dashboard Reject Button)
    public boolean rejectRepairOrder(int repairId, int adminId) {
        String sql = "UPDATE Repair SET CurrentStatus = 'Rejected', ApprovedBy = ? WHERE RepairID = ?";
        try {
            Class.forName(driver);
            try (Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, adminId);
                ps.setInt(2, repairId);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
}
