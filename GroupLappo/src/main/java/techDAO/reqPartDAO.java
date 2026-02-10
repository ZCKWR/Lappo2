package techDAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import techModel.jobAssigned;
import techModel.partTrack;
import techModel.reqPart;


public class reqPartDAO {
	
	public int countTotalPartRequests(int techID) {
	    int count = 0;

	    try {
	    	Class.forName("com.mysql.jdbc.Driver");
	    	Connection con = DriverManager.getConnection(
	    		    "jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!"); 
	            		 
	          String sql = "SELECT COUNT(*) FROM partrequest WHERE RequestedBy = ?";

	         PreparedStatement ps = con.prepareStatement(sql);
	        
	        ps.setInt(1, techID);

	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt(1); // Get the first column result
	        }
	        con.close();
	        
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
        
        con.close();
        
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
        
        con.close();
        
		}catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    return count;	 
	         		 
	        		 
	}
	
	public List<reqPart> viewPartRequest(int techID){
		
		List<reqPart> reqsPart = new ArrayList<>();
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
    		Connection con = DriverManager.getConnection(
    		"jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!");
    			
    		String sql = "SELECT " +
   	             "pr.RepairID, " +
   	             "p.PartName, " +
   	             "p.Manufacturer, " +
   	             "pr.QuantityRequested, " +
   	             "pr.DateRequest, " +
   	             "pr.DateApproved, " +
   	             "pr.ApprovalStatus " +
   	             "FROM partrequest pr " +
   	             "JOIN part p ON pr.PartID = p.PartID " +
   	             "JOIN repair r ON pr.RepairID = r.RepairID " +
   	             "WHERE pr.RequestedBy = ?";
    		
    		  PreparedStatement ps = con.prepareStatement(sql);
              ps.setInt(1, techID);
              ResultSet rs = ps.executeQuery();
              
              while (rs.next()) {
              	reqPart reqP = new reqPart(
                  rs.getInt("RepairID"),
                  rs.getString("PartName"),
                  rs.getString("manufacturer"),
                  rs.getInt("QuantityRequested"),
                  rs.getDate("DateRequest"),
                  rs.getDate("DateApproved"),
                  rs.getString("ApprovalStatus")
                );  
              	
                  reqsPart.add(reqP);    

              }
              con.close();
              
		}catch (Exception e) {
            e.printStackTrace();
        	
        }
		return reqsPart;
	}
	
	public List<partTrack> viewRepairList(int techID){
		
		List<partTrack> repairList = new ArrayList<>();
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
    		Connection con = DriverManager.getConnection(
    		"jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!");
    		
    		String repairSql = "SELECT RepairID, CurrentStatus, DateIssued, LaptopModel, repairDesc " +
                    "FROM repair " +
                    "WHERE AssignedTech = ? " +
                    "AND CurrentStatus NOT IN ('Complete', 'Paid', 'Cancelled') " +
                    "ORDER BY DateIssued DESC";

    		
            PreparedStatement stmt = con.prepareStatement(repairSql);
            stmt.setInt(1, techID);
           
                      
           ResultSet sp = stmt.executeQuery();
           while(sp.next()) {
           	partTrack pt = new partTrack();
           			pt.setRepairID(sp.getInt("RepairID"));
           			pt.setStatus(sp.getString("CurrentStatus"));
                    pt.setDate(sp.getString("DateIssued")); 
                    pt.setModel(sp.getString("LaptopModel"));
                    pt.setProblem(sp.getString("repairDesc"));
                    

           	repairList.add(pt);   
           
           }
           
           con.close();
    		
    		
		}catch (Exception e) {
            e.printStackTrace();
        	
        }
		return repairList;
	}
	
	
	}

