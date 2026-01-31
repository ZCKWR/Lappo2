package adminModel;

public class lowStock {
	
	private int repairID; 
	private String partName;
	private int quantity;
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
	public int getQuantity() {
		return quantity;
	}
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	public lowStock(int repairID, String partName, int quantity) {
		super();
		this.repairID = repairID;
		this.partName = partName;
		this.quantity = quantity;
	}
}
