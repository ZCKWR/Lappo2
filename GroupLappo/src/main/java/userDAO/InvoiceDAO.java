package userDAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;


import userModel.Invoice;
import util.DBConnection;

public class InvoiceDAO {

    public List<Invoice> getPastInvoices() {

        List<Invoice> invoices = new ArrayList<>();

        String sql = 
        	    "SELECT i.InvoiceID, " +
        	    "i.PaymentDate, " +
        	    "r.LaptopModel, " +
        	    "r.Issue, " +
        	    "i.PaymentAmount " +
        	    "FROM invoice i " +
        	    "JOIN repair r ON i.RepairID = r.RepairID " +
        	    "ORDER BY i.PaymentDate DESC";


        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
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
}
