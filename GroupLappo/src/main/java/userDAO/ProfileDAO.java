package userDAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import userModel.Student;

public class ProfileDAO {
	
	public boolean updateProfile(Student bean) throws SQLException{
		
		boolean status = false;
	
	try {
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection(
		"jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!");
		
		String sql = "UPDATE user SET Username = ?, UserEmail = ?, UserPhoneNumber = ?, UserAddress = ? WHERE UserID = ?";
		
		PreparedStatement ps = con.prepareStatement(sql);
		
		int userID = bean.getUserID();
		String userName = bean.getUsername();
		String userEmail = bean.getUserEmail();
		String userPhone = bean.getUserPhoneNumber();
		String userAddress = bean.getUserAddress();
		
		ps.setString(1, userName);
		ps.setString(2, userEmail);
		ps.setString(3, userPhone);
		ps.setString(4, userAddress);
		ps.setInt(5, userID);
		
		
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
	
	public Student getProfileByUserId(int userId) {

	    Student bean = null;

	    try {
	        Class.forName("com.mysql.jdbc.Driver");
	        Connection con = DriverManager.getConnection(
	        "jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!");

	        String sql = "SELECT UserID, Username, UserEmail, UserPhoneNumber, UserAddress FROM user WHERE UserID = ?";
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setInt(1, userId);

	        ResultSet rs = ps.executeQuery();

	        if (rs.next()) {
	            bean = new Student();
	            bean.setUserID(rs.getInt("UserID"));
	            bean.setUsername(rs.getString("Username"));
	            bean.setUserEmail(rs.getString("UserEmail"));
	            bean.setUserPhoneNumber(rs.getString("UserPhoneNumber"));
	            bean.setUserAddress(rs.getString("UserAddress"));
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return bean;

}
}
