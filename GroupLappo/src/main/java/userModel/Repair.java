package userModel;

public class Repair {
	
	public int studentID;
    public int RepairID;
    public String DateIssued;
	public String LaptopModel;
    public String TechnicianRemarks;
    public String CurrentStatus;
    public String Issue;
    public String Description;
    public String Username;
    public double PaymentAmount;
    
    
    
    public void setStudentID(int studentID) {
		this.studentID = studentID;
	}
    public int getStudentID() {
		return studentID;
	}
    public int getRepairID() {
        return RepairID;
    }

    public void setRepairID(int RepairID) {
        this.RepairID = RepairID;
    }

    public String getDateIssued() {
        return DateIssued;
    }

    public void setDateIssued(String DateIssued) {
        this.DateIssued = DateIssued;
    }

    public String getLaptopModel() {
        return LaptopModel;
    }

    public void setLaptopModel(String LaptopModel) {
        this.LaptopModel = LaptopModel;
    }

    public String getTechnicianRemarks() {
        return TechnicianRemarks;
    }

    public void setTechnicianRemarks(String TechnicianRemarks) {
        this.TechnicianRemarks = TechnicianRemarks;
    }

    public String getCurrentStatus() {
        return CurrentStatus;
    }

    public void setCurrentStatus(String CurrentStatus) {
        this.CurrentStatus = CurrentStatus;
    }
    
    public String getIssue() {
    	return Issue;    
    }
    
    public void setIssue(String Issue) {
    	this.Issue = Issue;
    }
    
    public String getDescription() {
    	return Description;
    }
    
    public void setDescription(String Description) {
    	this.Description = Description;
    }
    
    public String getUsername() {
    	return Username;
    }
    
    public void setUsername(String Username) {
    	this.Username = Username;
    }
    
    public double getPaymentAmount() {
    	return PaymentAmount;
    }
    
    public void setPaymentAmount(double PaymentAmount) {
    	this.PaymentAmount = PaymentAmount;
    }
}

