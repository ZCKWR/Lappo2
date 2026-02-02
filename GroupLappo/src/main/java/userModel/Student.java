package userModel;

public class Student {
	
	public int UserID;
	public String Username;
	public String UserEmail;
	public String UserAddress;
	public String UserPhoneNumber;
	
	public Student() {}
	
	public Student(int userID, String username, String userEmail, String userAddress, String userPhoneNumber) {
		super();
		UserID = userID;
		Username = username;
		UserEmail = userEmail;
		UserAddress = userAddress;
		UserPhoneNumber = userPhoneNumber;
	}
	
	public int getUserID() {
		return UserID;
	}
	public String getUsername() {
		return Username;
	}
	public String getUserEmail() {
		return UserEmail;
	}
	
	public String getUserAddress() {
		return UserAddress;
	}
	public String getUserPhoneNumber() {
		return UserPhoneNumber;
	}
	
	public void setUserID(int UserID) {
		this.UserID = UserID;
	}
	public void setUsername(String Username) {
		this.Username = Username;
	}
	public void setUserEmail(String UserEmail) {
		this.UserEmail = UserEmail;
	}

	public void setUserAddress(String UserAddress) {
		this.UserAddress = UserAddress;
	}
	public void setUserPhoneNumber(String UserPhoneNumber) {
		this.UserPhoneNumber = UserPhoneNumber;
	}
	
}

