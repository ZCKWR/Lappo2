package adminDAO;

import java.sql.*;
import java.util.*;

public class inventoryDAO {
    private String dbURL = "jdbc:mysql://localhost:3306/lappo2";
    private String dbUser = "root";
    private String dbPass = "Zack1234!";
    private String driver = "com.mysql.jdbc.Driver";

    // 1. Fetch all parts for the main inventory table
    public List<Map<String, Object>> getAllInventory() {
        List<Map<String, Object>> list = new ArrayList<>();
        String query = "SELECT * FROM part ORDER BY PartName ASC";
        try {
            Class.forName(driver);
            try (Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);
                 Statement st = con.createStatement();
                 ResultSet rs = st.executeQuery(query)) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("id", rs.getInt("PartID"));
                    item.put("name", rs.getString("PartName"));
                    item.put("brand", rs.getString("Manufacturer"));
                    item.put("qty", rs.getInt("Quantity"));
                    item.put("cost", rs.getDouble("UnitCost"));
                    list.add(item);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 2. Add New Item to 'part' table
    public boolean addItem(String name, String brand, int qty, double cost) {
        String sql = "INSERT INTO part (PartName, Manufacturer, Quantity, UnitCost) VALUES (?, ?, ?, ?)";
        try {
            Class.forName(driver);
            try (Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, name);
                ps.setString(2, brand);
                ps.setInt(3, qty);
                ps.setDouble(4, cost);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // 3. Restock Existing Part
    public boolean restockPart(int partId, int quantityToAdd) {
        String sql = "UPDATE part SET Quantity = Quantity + ? WHERE PartID = ?";
        try {
            Class.forName(driver);
            try (Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, quantityToAdd);
                ps.setInt(2, partId);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // 4. Update/Edit Part Details
    public boolean updateInventory(int partId, String name, String brand, int qty, double cost) {
        String sql = "UPDATE part SET PartName=?, Manufacturer=?, Quantity=?, UnitCost=? WHERE PartID=?";
        try {
            Class.forName(driver);
            try (Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, name);
                ps.setString(2, brand);
                ps.setInt(3, qty);
                ps.setDouble(4, cost);
                ps.setInt(5, partId);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // 5. TRANSACTIONAL LOGIC: Part Request Approval
    public boolean approveRequest(int requestId, int adminId) {
        Connection con = null;
        try {
            Class.forName(driver);
            con = DriverManager.getConnection(dbURL, dbUser, dbPass);
            con.setAutoCommit(false); // Enable transaction

            // Step A: Find PartID and Quantity for this request
            String infoSql = "SELECT PartID, QuantityRequested FROM partrequest WHERE RequestID = ?";
            PreparedStatement psInfo = con.prepareStatement(infoSql);
            psInfo.setInt(1, requestId);
            ResultSet rs = psInfo.executeQuery();

            if (rs.next()) {
                int partId = rs.getInt("PartID");
                int qtyReq = rs.getInt("QuantityRequested");

                // Step B: Deduct stock from 'part' table
                String deductSql = "UPDATE part SET Quantity = Quantity - ? WHERE PartID = ? AND Quantity >= ?";
                PreparedStatement psDeduct = con.prepareStatement(deductSql);
                psDeduct.setInt(1, qtyReq); 
                psDeduct.setInt(2, partId); 
                psDeduct.setInt(3, qtyReq);

                if (psDeduct.executeUpdate() > 0) {
                    // Step C: Update request status
                    String statusSql = "UPDATE partrequest SET ApprovalStatus='Approved', ApprovedBy=?, DateApproved=CURDATE() WHERE RequestID=?";
                    PreparedStatement psStatus = con.prepareStatement(statusSql);
                    psStatus.setInt(1, adminId); 
                    psStatus.setInt(2, requestId);
                    psStatus.executeUpdate();

                    con.commit(); 
                    return true;
                }
            }
        } catch (Exception e) {
            if (con != null) try { con.rollback(); } catch (SQLException ex) {}
            e.printStackTrace();
        } finally {
            if (con != null) try { con.close(); } catch (SQLException ex) {}
        }
        return false;
    }

    // 6. Reject Part Request
    // Added this method to handle rejections without affecting stock
    public boolean rejectRequest(int requestId, int adminId) {
        String sql = "UPDATE partrequest SET ApprovalStatus='Rejected', ApprovedBy=?, DateApproved=CURDATE() WHERE RequestID=?";
        try {
            Class.forName(driver);
            try (Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);
                 PreparedStatement ps = con.prepareStatement(sql)) {
                
                ps.setInt(1, adminId);
                ps.setInt(2, requestId);
                
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}