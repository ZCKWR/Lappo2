package userModel;

public class User {
	
	public int UserID;
	public String Username;
	public String UserEmail;
	public String UserPassword;
	public String UserAddress;
	public String UserPhoneNumber;
	public String UserType;
	
	public int getUserID() {
		return UserID;
	}
	public String getUsername() {
		return Username;
	}
	public String getUserEmail() {
		return UserEmail;
	}
	public String getUserPassword() {
		return UserPassword;
	}
	public String getUserAddress() {
		return UserAddress;
	}
	public String getUserPhoneNumber() {
		return UserPhoneNumber;
	}
	public String getUserType() {
		return UserType;
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
	public void setUserPassword(String UserPassword) {
		this.UserPassword = UserPassword;
	}
	public void setUserAddress(String UserAddress) {
		this.UserAddress = UserAddress;
	}
	public void setUserPhoneNumber(String UserPhoneNumber) {
		this.UserPhoneNumber = UserPhoneNumber;
	}
	public void setUserType(String UserType) {
		this.UserType = UserType;
	}
	
}

