package techDAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import techModel.jobView;
import userModel.Repair;

public class dashboardDAO {
	public int countCompletedRepairs(int techID) {
		
	    int count = 0;

	    // Use try-with-resources to ensure connection closes automatically
	    try {
	    
	    	Class.forName("com.mysql.jdbc.Driver");
		    Connection con = DriverManager.getConnection(
		    "jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!"); 
	        
		    String sql = "SELECT COUNT(*) FROM repair WHERE CurrentStatus IN ('Complete', 'Paid') AND AssignedTech = ?";
		    
		    PreparedStatement ps = con.prepareStatement(sql);
	        // Set the technician ID from the parameter
	        ps.setInt(1, techID);

	        ResultSet rs = ps.executeQuery();
	        
	        if (rs.next()) {
	            // Retrieve the first column (the count)
	            count = rs.getInt(1);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    return count;
	}
	
	public List<jobView> viewPastRepairs(int techID) {
		
	    
	    List<jobView> pastJob = new ArrayList<>();

	    // Use try-with-resources to ensure connection closes automatically
	    try {
	    
	    	Class.forName("com.mysql.jdbc.Driver");
		    Connection con = DriverManager.getConnection(
		    "jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!"); 
	        
		    String sql = "SELECT u.Username, r.DateIssued, r.Issue, r.repairDesc, r.CurrentStatus, r.TechnicianRemarks " +
		             "FROM repair r " +
		             "JOIN user u ON r.CustomerID = u.UserID " +
		             "WHERE r.AssignedTech = ? " +
		             "AND r.CurrentStatus IN ('Complete', 'Paid') " + // Added 'r.' for safety
		             "ORDER BY r.DateIssued DESC";
		    
		    PreparedStatement ps = con.prepareStatement(sql);
	        // Set the technician ID from the parameter
	        ps.setInt(1, techID);

	        ResultSet rs = ps.executeQuery();
	        
	        while (rs.next()) {
	            jobView s = new jobView();
	                s.setUsername(rs.getString("Username")); 
	                s.setApproveDate(rs.getDate("DateIssued"));
	                s.setIssue(rs.getString("Issue"));
	                s.setRepairDesc(rs.getString("repairDesc"));
	                s.setCurrentStatus(rs.getString("CurrentStatus"));
	                s.setTechRemarks(rs.getString("TechnicianRemarks"));
	                pastJob.add(s);
	        }
	        
	           rs.close();
	            ps.close();
	            con.close();
	     
	        

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    return pastJob;
	}
	
	 public List<jobView> displayAllActiveJobs(int techid) {
		
		List<jobView> job = new ArrayList<>();

		
		try {
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection(
		"jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!");
		
			String sql = "SELECT u.Username, r.DateIssued, r.Issue, r.repairDesc, r.CurrentStatus, r.TechnicianRemarks " +
		             "FROM repair r " +
		             "JOIN user u ON r.CustomerID = u.UserID " +
		             "WHERE r.AssignedTech = ? AND CurrentStatus NOT IN ('Complete', 'Paid')";
		
		
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, techid);
        ResultSet rs = ps.executeQuery();
        
        
        while (rs.next()) {

            jobView s = new jobView(
                rs.getString("Username"), 
                rs.getDate("DateIssued"),
                rs.getString("Issue"),
                rs.getString("repairDesc"),
                rs.getString("CurrentStatus"),
                rs.getString("TechnicianRemarks")

            );
            job.add(s);
        }
		
		}catch (Exception e) {
    		e.printStackTrace();
    	}
		return job;
	}
}

	