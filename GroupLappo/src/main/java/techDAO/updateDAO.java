package techDAO;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import techModel.techProfile;


public class updateDAO {
	
	public boolean updateProfile(techProfile bean) throws SQLException{
		
		boolean status = false;
	
	try {
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection(
		"jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!");
		
		String sql = "UPDATE user SET Username = ?, UserEmail = ?, UserPhoneNumber = ?, UserAddress = ? WHERE UserID = ?";
		
		PreparedStatement ps = con.prepareStatement(sql);
		
		int techID = bean.getTechID();
		String techName = bean.getTechName();
		String techEmail = bean.getTechEmail();
		String techPhone = bean.getTechPhone();
		String techAddress = bean.getTechAddress();
		
		ps.setString(1, techName);
		ps.setString(2, techEmail);
		ps.setString(3, techPhone);
		ps.setString(4, techAddress);
		ps.setInt(5, techID);
		
		
	    int res = ps.executeUpdate();
	    
	    if(res == 1)
	    	status = true;
		
	}catch (ClassNotFoundException e) {
        e.printStackTrace(); // Catch driver errors
    } catch (SQLException e) {
        e.printStackTrace(); // Catch SQL errors
    }
		return status;
	}
	
	public techProfile getProfileByUserId(int userId) {

	    techProfile bean = null;

	    try {
	        Class.forName("com.mysql.jdbc.Driver");
	        Connection con = DriverManager.getConnection(
	        "jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!");

	        String sql = "SELECT UserID, Username, UserEmail, UserPhoneNumber, UserAddress FROM user WHERE UserID = ?";
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setInt(1, userId);

	        ResultSet rs = ps.executeQuery();

	        if (rs.next()) {
	            bean = new techProfile();
	            bean.setTechID(rs.getInt("UserID"));
	            bean.setTechName(rs.getString("Username"));
	            bean.setTechEmail(rs.getString("UserEmail"));
	            bean.setTechPhone(rs.getString("UserPhoneNumber"));
	            bean.setTechAddress(rs.getString("UserAddress"));
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return bean;

}}
