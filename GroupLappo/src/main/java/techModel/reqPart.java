package techModel;

 import java.sql.Date;

public class reqPart {
	private int repairID;
	private String partName;
	private String manufacturer;
	private int quantityReq;
	private Date dateReq;
	private Date dateApproved;
	private String approvalStatus;
	
	public reqPart() {}
	
	
	public reqPart(int repairID, String partName, String manufacturer, int quantityReq, Date dateReq, Date dateApproved,
			String apporvalStatus) {
		super();
		this.repairID = repairID;
		this.partName = partName;
		this.manufacturer = manufacturer;
		this.quantityReq = quantityReq;
		this.dateReq = dateReq;
		this.dateApproved = dateApproved;
		this.approvalStatus = apporvalStatus;
	}

	


	public String getManufacturer() {
		return manufacturer;
	}




	public void setManufacturer(String manufacturer) {
		this.manufacturer = manufacturer;
	}




	public int getRepairID() {
		return repairID;
	}


	public void setRepairID(int repairID) {
		this.repairID = repairID;
	}


	public String getPartName() {
		return partName;
	}


	public void setPartName(String partName) {
		this.partName = partName;
	}


	public int getQuantityReq() {
		return quantityReq;
	}


	public void setQuantityReq(int quantityReq) {
		this.quantityReq = quantityReq;
	}


	public Date getDateReq() {
		return dateReq;
	}


	public void setDateReq(Date dateReq) {
		this.dateReq = dateReq;
	}


	public Date getDateApproved() {
		return dateApproved;
	}


	public void setDateApproved(Date dateApproved) {
		this.dateApproved = dateApproved;
	}


	public String getApprovalStatus() {
		return approvalStatus;
	}


	public void setApprovalStatus(String apporvalStatus) {
		this.approvalStatus = apporvalStatus;
	}
	
	
	

}
