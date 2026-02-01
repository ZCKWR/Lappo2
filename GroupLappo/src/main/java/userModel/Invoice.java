package userModel;

public class Invoice {
	public String InvoiceID;
	public double PaymentAmount;
	public String PaymentType;
	public String PaymentDate;
	public double LabourCost;
	public double PartCost;
	public String StudentID;
	public String RepairID;
	public String LaptopModel;
	public String Issue;
	public String UserID;
	
	public String getInvoiceID() {
		return InvoiceID;
	}
	public double getPaymentAmount() {
		return PaymentAmount;
	}
	public String getPaymentType() {
		return PaymentType;
	}
	public String getPaymentDate() {
		return PaymentDate;
	}
	public double getLabourCost() {
		return LabourCost;
	}
	public double getPartCost() {
		return PartCost;
	}
	public String getStudentID() {
		return StudentID;
	}
	public String getRepairID() {
		return RepairID;
	}
	public String getLaptopModel() {
		return LaptopModel;
	}
	public String getIssue() {
		return Issue;
	}
	public String getUserID() {
		return UserID;
	}
	
	public void setInvoiceID(String InvoiceID) {
		this.InvoiceID = InvoiceID;
	}
	public void setPaymentAmount(double PaymentAmount) {
		this.PaymentAmount = PaymentAmount;
	}
	public void setPaymentType(String PaymentType) {
		this.PaymentType = PaymentType;
	}
	public void setPaymentDate(String PaymentDate) {
		this.PaymentDate = PaymentDate;
	}
	public void setLabourCost(double LabourCost) {
		this.LabourCost = LabourCost;
	}
	public void setPartCost(double PartCost) {
		this.PartCost = PartCost;
	}
	public void setStudentID(String StudentID) {
		this.StudentID = StudentID;
	}
	public void setRepairID(String RepairID) {
		this.RepairID = RepairID;
	}
	public void setLaptopModel(String LaptopModel) {
		this.LaptopModel = LaptopModel;
	}
	public void setIssue(String Issue) {
		this.Issue = Issue;
	}
	public void setUserID(String UserID) {
		this.UserID = UserID;
	}
}

