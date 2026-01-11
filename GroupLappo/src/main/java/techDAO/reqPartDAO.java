package techDAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import techModel.partTrack;


public class reqPartDAO {
	
	public int countTotalPartRequests(int techID) {
	    int count = 0;

	    try (Connection con = DriverManager.getConnection(
	            "jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", 
	            "root", "Zack1234!");
	         PreparedStatement ps = con.prepareStatement(
	        		 
	            "SELECT COUNT(*) FROM partrequest WHERE RequestedBy = ?")) {

	        Class.forName("com.mysql.jdbc.Driver");
	        
	        ps.setInt(1, techID);

	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt(1); // Get the first column result
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    return count;
	}
	
	public int countTotalPartPending(int techID) {
		int count = 0;
		
		try {
		
		Class.forName("com.mysql.jdbc.Driver");
	    Connection con = DriverManager.getConnection(
	    "jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!"); 
	    
	    String sql = "SELECT COUNT(*) FROM partrequest WHERE ApprovalStatus = 'Pending' AND RequestedBy = ?; ";
	    
	    PreparedStatement ps = con.prepareStatement(sql);
	    
	 // Set the technician ID from the parameter
        ps.setInt(1, techID);

        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            // Retrieve the first column (the count)
            count = rs.getInt(1);
        }
        
		}catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    return count;	 
	         		 
	        		 
	}
	
	public int countTotalPartApproved(int techID) {
		int count = 0;
		
		try {
		
		Class.forName("com.mysql.jdbc.Driver");
	    Connection con = DriverManager.getConnection(
	    "jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!"); 
	    
	    String sql = "SELECT COUNT(*) FROM partrequest WHERE ApprovalStatus = 'Approved' AND RequestedBy = ?; ";
	    
	    PreparedStatement ps = con.prepareStatement(sql);
	    
	 // Set the technician ID from the parameter
        ps.setInt(1, techID);

        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            // Retrieve the first column (the count)
            count = rs.getInt(1);
        }
        
		}catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    return count;	 
	         		 
	        		 
	}
	}

