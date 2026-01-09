package techDAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class dashboardDAO {
	public int countCompletedRepairs(int techID) {
		
	    int count = 0;

	    // Use try-with-resources to ensure connection closes automatically
	    try {
	    
	    	Class.forName("com.mysql.jdbc.Driver");
		    Connection con = DriverManager.getConnection(
		    "jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!"); 
	        
		    String sql = "SELECT COUNT(*) FROM repair WHERE CurrentStatus = 'Complete' AND AssignedTech = ?";
		    
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

}
	