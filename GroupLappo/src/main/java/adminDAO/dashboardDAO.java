package adminDAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class dashboardDAO {
public int countTotalUser() {
		
	    int count = 0;

	    // Use try-with-resources to ensure connection closes automatically
	    try {
	    
	    	Class.forName("com.mysql.jdbc.Driver");
		    Connection con = DriverManager.getConnection(
		    "jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!"); 
	        
		    String sql = "SELECT COUNT(*) FROM user";
		    
		    PreparedStatement ps = con.prepareStatement(sql);
	        // Set the technician ID from the parameter

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

public int countTotalActiveJobs() {
	
	int count = 0;
	
	try {
		Class.forName("com.mysql.jdbc.Driver");
	    Connection con = DriverManager.getConnection(
	    "jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!"); 
	    
	    String sql = "SELECT COUNT(*) FROM repair WHERE CurrentStatus NOT IN ('Complete', 'Paid', 'Cancelled')";
	    
	    PreparedStatement ps = con.prepareStatement(sql);
        // Set the technician ID from the parameter

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

public int countTotalCompleteJob() {
	
	int count = 0;
	
	try {
		Class.forName("com.mysql.jdbc.Driver");
	    Connection con = DriverManager.getConnection(
	    "jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!"); 
	    
	    String sql = "SELECT COUNT(*) FROM repair WHERE CurrentStatus IN ('Complete', 'Paid')";
	    
	    PreparedStatement ps = con.prepareStatement(sql);
        // Set the technician ID from the parameter

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

public int countTotalPendingJob() {
	
	int count = 0;
	
	try {
		Class.forName("com.mysql.jdbc.Driver");
	    Connection con = DriverManager.getConnection(
	    "jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!"); 
	    
	    String sql = "SELECT COUNT(*) FROM repair " +
	             "WHERE AssignedTech IS NULL " +
	             "AND CurrentStatus <> 'Cancelled'";	    
	    PreparedStatement ps = con.prepareStatement(sql);
        // Set the technician ID from the parameter

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
