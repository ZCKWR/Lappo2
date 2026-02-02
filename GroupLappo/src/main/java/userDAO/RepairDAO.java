package userDAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import userModel.Repair;
import util.DBConnection;


public class RepairDAO {

    public List<Repair> getOngoingRepairs(int studentID) {

        List<Repair> repairs = new ArrayList<>();

        String sql = "SELECT RepairID, DateIssued, LaptopModel, Issue, CurrentStatus FROM repair where CustomerID = ? AND CurrentStatus NOT IN ('Complete', 'Collected', 'Cancelled')";

        try {
            Connection conn = DBConnection.getConnection();
            System.out.println("DB Connection = " + conn);
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, studentID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Repair repair = new Repair();
                repair.setRepairID(rs.getInt("RepairID"));
                repair.setDateIssued(rs.getString("DateIssued"));
                repair.setLaptopModel(rs.getString("LaptopModel"));
                repair.setIssue(rs.getString("Issue"));
                repair.setCurrentStatus(rs.getString("CurrentStatus"));

                repairs.add(repair);
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return repairs;
    }
    
    public List<Repair> getPastRepairs(int studentID) {

        List<Repair> repairs = new ArrayList<>();

        String sql = "SELECT RepairID, DateIssued, LaptopModel, Issue, CurrentStatus FROM repair where CustomerID = ? AND CurrentStatus IN ('Complete', 'Collected', 'Cancelled')";

        try {
            Connection conn = DBConnection.getConnection();
            System.out.println("DB Connection = " + conn);
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, studentID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Repair repair = new Repair();
                repair.setRepairID(rs.getInt("RepairID"));
                repair.setDateIssued(rs.getString("DateIssued"));
                repair.setLaptopModel(rs.getString("LaptopModel"));
                repair.setIssue(rs.getString("Issue"));
                repair.setCurrentStatus(rs.getString("CurrentStatus"));

                repairs.add(repair);
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return repairs;
    }
    
    public void insertRepair(Repair repair) {

        try {
            Connection con = DBConnection.getConnection();

            String sql = "INSERT INTO REPAIR (LaptopModel, Issue, Description, DateIssued, CurrentStatus) " +
                         "VALUES (?, ?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, repair.LaptopModel);
            ps.setString(2, repair.Issue);
            ps.setString(3, repair.Description);
            ps.setString(4, repair.DateIssued);
            ps.setString(5, repair.CurrentStatus);

            ps.executeUpdate();
            con.close();

            System.out.println("DEBUG: Repair inserted successfully");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public List<Repair> getRepairStatus(int studentID) {

        List<Repair> repairs = new ArrayList<>();    

        String sql =
        	    "SELECT r.RepairID, r.DateIssued, r.LaptopModel, r.Issue, " +
        	    "u.Username AS TechnicianName, r.CurrentStatus " +		
        	    "FROM REPAIR r " +
        	    "LEFT JOIN USER u ON r.AssignedTech = u.UserID AND u.UserType = 'Technician'" +
        	    "WHERE r.CustomerID = ?";


        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, studentID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Repair repair = new Repair();
                repair.setRepairID(rs.getInt("RepairID"));
                repair.setDateIssued(rs.getString("DateIssued"));
                repair.setLaptopModel(rs.getString("LaptopModel"));
                repair.setIssue(rs.getString("Issue"));
                repair.setUsername(rs.getString("TechnicianName"));
                repair.setCurrentStatus(rs.getString("CurrentStatus"));

                repairs.add(repair);
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return repairs;
    }

    public List<Repair> getRepairStatusByDevice(String device, int studentID) {

        List<Repair> repairs = new ArrayList<>();

        String sql =
        		    "SELECT r.RepairID, r.DateIssued, r.LaptopModel, r.issue, r.CurrentStatus, " +
        	             "COALESCE(u.Username, '—') AS Username " +
        	             "FROM repair r " +  // Lowercase table name
        	             "LEFT JOIN `user` u ON r.AssignedTech = u.UserID " + // Backticks for reserved word
        	             "WHERE LOWER(r.LaptopModel) LIKE LOWER(?) AND CustomerID = ?";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + device + "%"); // partial match
            ps.setInt(2, studentID);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Repair r = new Repair();
                r.setRepairID(rs.getInt("RepairID"));
                r.setDateIssued(rs.getString("DateIssued"));
                r.setLaptopModel(rs.getString("LaptopModel"));
                r.setIssue(rs.getString("Issue"));
                r.setCurrentStatus(rs.getString("CurrentStatus"));
                r.setUsername(rs.getString("Username"));

                repairs.add(r);
            }
            
            
            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return repairs;
    }
    
    public double getPaymentAmountByRepairID(int repairID) {
        double amount = 0.0;

        String sql = "SELECT PaymentAmount FROM INVOICE WHERE RepairID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, repairID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                amount = rs.getDouble("PaymentAmount");
            }

            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return amount;
    }
    
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM REPAIR WHERE CurrentStatus = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int countAllRepairs(int studentID) {
        String sql = "SELECT COUNT(*) FROM REPAIR Where CustomerID = ?";
        try {
        	 Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ps.setInt(1, studentID);

             ResultSet rs = ps.executeQuery();

            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public double sumPendingPayments() {
        String sql =
            "SELECT COALESCE(SUM(i.PaymentAmount), 0) " +
            "FROM INVOICE i " +
            "JOIN REPAIR r ON i.RepairID = r.RepairID " +
            "WHERE r.CurrentStatus <> 'Completed'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }
   
         
    }





