package techModel;

import java.sql.Date;

public class jobView {
	String Username;
	Date approveDate;
	String Issue;
	String repairDesc;
	String currentStatus;
	String techRemarks;
	
	public jobView() {}
	
	public jobView(String username, Date approveDate, String issue, String repairDesc, String currentStatus,
			String techRemarks) {
		super();
		Username = username;
		this.approveDate = approveDate;
		Issue = issue;
		this.repairDesc = repairDesc;
		this.currentStatus = currentStatus;
		this.techRemarks = techRemarks;
	}

	public String getIssue() {
		return Issue;
	}

	public void setIssue(String issue) {
		Issue = issue;
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
