package techModel;

public class partTrack {
	 private int repairID;
	 private String status;
	 private String date;
	 private String model;
	 private String problem;

	 
	 public String getStatus() {
		return status;
	}


	 public partTrack(int repairID, String status, String date, String model, String problem) {
		super();
		this.repairID = repairID;
		this.status = status;
		this.date = date;
		this.model = model;
		this.problem = problem;
	}


	 public void setStatus(String status) {
		 this.status = status;
	 }


	 public String getDate() {
		 return date;
	 }


	 public void setDate(String date) {
		 this.date = date;
	 }


	 public String getModel() {
		 return model;
	 }


	 public void setModel(String model) {
		 this.model = model;
	 }


	 public String getProblem() {
		 return problem;
	 }


	 public void setProblem(String problem) {
		 this.problem = problem;
	 }


	 public partTrack() {}
	 
	 
	 public int getRepairID() {
		 return repairID; 
	 }
	 
	 public void setRepairID(int repairID) {
		 this.repairID = repairID;
	 }
	 
	 public String toString() {
		    return "RepairID=" + repairID;
		}
	 
 
}
