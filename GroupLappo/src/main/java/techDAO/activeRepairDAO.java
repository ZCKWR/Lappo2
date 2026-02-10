package techDAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import techModel.jobAssigned;

public class activeRepairDAO {
	public List<jobAssigned> viewPastRepairs(int techID){
		
		List<jobAssigned> repairJobs = new ArrayList<>();
		

        try {
        	Class.forName("com.mysql.jdbc.Driver");
    		Connection con = DriverManager.getConnection(
    		"jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!");
            // Your SQL query
    		String sql = "SELECT " +
    	             "r.RepairID AS JobID, " +
    	             "u_owner.Username AS OwnerName, " +
    	             "u_owner.UserEmail AS OwnerEmail, " +
    	             "r.LaptopModel, r.SerialNumber, r.DateIssued, " +
    	             "r.repairDesc, r.CurrentStatus, r.Issue, r.TechnicianRemarks " +
    	             "FROM repair r " +
    	             "JOIN user u_owner ON r.CustomerID = u_owner.UserID " +
    	             "WHERE r.AssignedTech = ? " +
    	             "AND r.CurrentStatus NOT IN ('Complete', 'Paid') " +
    	             "ORDER BY r.DateIssued ASC";
                    

           PreparedStatement ps = con.prepareStatement(sql);
           ps.setInt(1, techID);
           ResultSet rs = ps.executeQuery();


            while (rs.next()) {
            	jobAssigned job = new jobAssigned(
                rs.getInt("JobID"),
                rs.getString("OwnerName"),
                rs.getString("OwnerEmail"),
                rs.getString("LaptopModel"),
                rs.getString("SerialNumber"),
                rs.getDate("DateIssued"),
                rs.getString("Issue"),
                rs.getString("repairDesc"),
                rs.getString("CurrentStatus"),
                rs.getString("TechnicianRemarks")
                
              );  
                repairJobs.add(job);    
		
	}
        }catch (Exception e) {
        	 e.printStackTrace();        	
        }
        return repairJobs;
	}
	
	
}
