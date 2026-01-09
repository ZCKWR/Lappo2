package techModel;

import java.sql.Date;

public class jobAssigned {
	private int RepairID; 
	private String UserName;
	private String LaptopModel; 
	private String Email; 
	private String SerialNumber; 
	private Date DateIssued;
	private String UserNote;
	private String CurrentStatus;
	private String Remarks;
	
	public jobAssigned() {};
	



	public String getUserNote() {
		return UserNote;
	}




	public void setUserNote(String userNote) {
		UserNote = userNote;
	}




	public String getCurrentStatus() {
		return CurrentStatus;
	}




	public void setCurrentStatus(String currentStatus) {
		CurrentStatus = currentStatus;
	}




	public String getRemarks() {
		return Remarks;
	}




	public void setRemarks(String remarks) {
		Remarks = remarks;
	}




	public jobAssigned(int repairID, String userName, String laptopModel, String email, String serialNumber,
			Date dateIssued, String userNote, String currentStatus, String remarks) {
		super();
		RepairID = repairID;
		UserName = userName;
		LaptopModel = laptopModel;
		Email = email;
		SerialNumber = serialNumber;
		DateIssued = dateIssued;
		UserNote = userNote;
		CurrentStatus = currentStatus;
		Remarks = remarks;
	}




	public int getRepairID() {
		return RepairID;
	}



	public void setRepairID(int repairID) {
		RepairID = repairID;
	}



	public String getUserName() {
		return UserName;
	}



	public void setUserName(String userName) {
		UserName = userName;
	}



	public String getLaptopModel() {
		return LaptopModel;
	}



	public void setLaptopModel(String laptopModel) {
		LaptopModel = laptopModel;
	}



	public String getEmail() {
		return Email;
	}



	public void setEmail(String email) {
		Email = email;
	}



	public String getSerialNumber() {
		return SerialNumber;
	}



	public void setSerialNumber(String serialNumber) {
		SerialNumber = serialNumber;
	}



	public Date getDateIssued() {
		return DateIssued;
	}



	public void setDateIssued(Date dateIssued) {
		DateIssued = dateIssued;
	}
	
	
	
	
	
}
