package userDAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;


import userModel.Invoice;
import util.DBConnection;

public class InvoiceDAO {

    public List<Invoice> getPastInvoices(int studentID) {

        List<Invoice> invoices = new ArrayList<>();

        String sql = 
        		"SELECT i.InvoiceID, " +
        	             "i.PaymentDate, " +
        	             "r.LaptopModel, " +
        	             "r.Issue, " +        
        	             "i.PaymentAmount " +
        	             "FROM invoice i " +
        	             "JOIN repair r ON i.RepairID = r.RepairID " +
        	             "WHERE r.CustomerID = ? " +  
        	             "ORDER BY i.PaymentDate DESC";


        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, studentID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
            	Invoice invoice = new Invoice();
                invoice.setInvoiceID(rs.getString("InvoiceID"));
                invoice.setPaymentDate(rs.getString("PaymentDate"));
                invoice.setLaptopModel(rs.getString("LaptopModel"));
                invoice.setIssue(rs.getString("Issue"));
                invoice.setPaymentAmount(rs.getDouble("PaymentAmount"));

                invoices.add(invoice);
            }
            System.out.println("Total invoices fetched: " + invoices.size());

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return invoices;
    }
    
    public boolean insertInvoice(int studentID, int repairID, String paymentType) {

        RepairDAO repairDAO = new RepairDAO();
        double part = repairDAO.getPartCostByRepairID(repairID);    
        double amount = repairDAO.getPaymentAmountByRepairID(repairID);
    

        String sql = "INSERT INTO invoice (PaymentAmount, PaymentType, PaymentDate, LabourCost, PartCost, StudentID, RepairID) " +
                     "VALUES (?, ?, NOW(), 50.00, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDouble(1, amount);
            ps.setString(2, paymentType);
            ps.setDouble(3, part);
            ps.setInt(4, studentID);
            ps.setInt(5, repairID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
     
    public boolean markAsPaidIfComplete(int repairID) {
        String sql = "UPDATE repair SET CurrentStatus='Paid' WHERE repairID=? AND CurrentStatus='Complete'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, repairID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


}
