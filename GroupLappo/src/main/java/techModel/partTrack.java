package techModel;

public class partTrack {
	 private int repairID;

	 
	 public partTrack() {}
	 
	 
	 public int getRepairID() {
		 return repairID; 
	 }
	 public partTrack(int repairID) {
		super();
		this.repairID = repairID;
	}
	 public void setRepairID(int repairID) {
		 this.repairID = repairID;
	 }
	 
	 public String toString() {
		    return "RepairID=" + repairID;
		}
	 
 
}
