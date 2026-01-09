package techModel;

public class techProfile {
	private int techID;
	private String techName;
	private String techEmail;
	private String techAddress;
	private String techPhone;
	
	public techProfile() {}
	
	public int getTechID() {
		return techID;
	}
	public void setTechID(int techID) {
		this.techID = techID;
	}
	public String getTechName() {
		return techName;
	}
	public void setTechName(String techName) {
		this.techName = techName;
	}
	public String getTechEmail() {
		return techEmail;
	}
	public void setTechEmail(String techEmail) {
		this.techEmail = techEmail;
	}
	public String getTechAddress() {
		return techAddress;
	}
	public void setTechAddress(String techAddress) {
		this.techAddress = techAddress;
	}
	public String getTechPhone() {
		return techPhone;
	}
	public void setTechPhone(String techPhone) {
		this.techPhone = techPhone;
	}
	
	public techProfile(int techID, String techName, String techEmail, String techAddress, String techPhone) {
		super();
		this.techID = techID;
		this.techName = techName;
		this.techEmail = techEmail;
		this.techAddress = techAddress;
		this.techPhone = techPhone;
	}
	
	
	
	
	
	
}
