package techModel;

import java.sql.Date;

public class jobView {
	String Username;
	Date approveDate;
	String repairDesc;
	String currentStatus;
	String techRemarks;
	
	public jobView(String username, Date approveDate, String repairDesc, String currentStatus, String techRemarks) {
		super();
		Username = username;
		this.approveDate = approveDate;
		this.repairDesc = repairDesc;
		this.currentStatus = currentStatus;
		this.techRemarks = techRemarks;
	}


	public String getCurrentStatus() {
		return currentStatus;
	}


	public void setCurrentStatus(String currentStatus) {
		this.currentStatus = currentStatus;
	}


	public String getUsername() {
		return Username;
	}

	public void setUsername(String username) {
		Username = username;
	}

	public Date getApproveDate() {
		return approveDate;
	}

	public void setApproveDate(Date approveDate) {
		this.approveDate = approveDate;
	}

	public String getRepairDesc() {
		return repairDesc;
	}

	public void setRepairDesc(String repairDesc) {
		this.repairDesc = repairDesc;
	}

	public String getTechRemarks() {
		return techRemarks;
	}

	public void setTechRemarks(String techRemarks) {
		this.techRemarks = techRemarks;
	}
	
	
	
	
	
	
}
