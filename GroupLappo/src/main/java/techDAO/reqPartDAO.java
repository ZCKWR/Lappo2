package techDAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import techModel.partTrack;


public class reqPartDAO {



	    public List<partTrack> getAssignedRepairIDs(int technicianID) {

	        List<partTrack> list = new ArrayList<>();

	        String sql = "SELECT DISTINCT repairID FROM repair WHERE technicianID = ?";

	        try (Connection con = DriverManager.getConnection(
		    		"jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!");
	        		
	             PreparedStatement ps = con.prepareStatement(sql)) {

	            ps.setInt(1, technicianID);
	            ResultSet rs = ps.executeQuery();

	            while (rs.next()) {
	                partTrack rp = new partTrack();
	                rp.setRepairID(rs.getInt("repairID"));
	                list.add(rp);
	            }

	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	        return list;
	    }
	}

