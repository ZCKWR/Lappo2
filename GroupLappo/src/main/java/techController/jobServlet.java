package techController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import techModel.jobAssigned;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet implementation class jobServlet
 */
@WebServlet("/jobServlet")
public class jobServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public jobServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		HttpSession session = request.getSession();
		Integer technicianId = (Integer) session.getAttribute("userID");
		
		
		List<jobAssigned> repairJobs = new ArrayList<>();
		

	        try {
	        	Class.forName("com.mysql.jdbc.Driver");
	    		Connection con = DriverManager.getConnection(
	    		"jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!");
	            // Your SQL query
	    		String sql = "SELECT " +
	    	             "r.RepairID AS JobID, " +
	    	             "u_owner.Username AS OwnerName, " +
	    	             "u_owner.UserEmail AS OwnerEmail, " +
	    	             "r.LaptopModel, r.SerialNumber, r.DateIssued, " +
	    	             "r.repairDesc, r.CurrentStatus, r.TechnicianRemarks " +
	    	             "FROM repair r " +
	    	             "JOIN user u_owner ON r.CustomerID = u_owner.UserID " +
	    	             "WHERE r.AssignedTech = ? " +
	    	             "AND r.CurrentStatus != 'Complete'";
	                    

	           PreparedStatement ps = con.prepareStatement(sql);
	           ps.setInt(1, technicianId);
	           ResultSet rs = ps.executeQuery();

	            // Display results in HTML table
	           if(technicianId != null) {
	            while (rs.next()) {
	            	jobAssigned job = new jobAssigned(
	                rs.getInt("JobID"),
	                rs.getString("OwnerName"),
	                rs.getString("OwnerEmail"),
	                rs.getString("LaptopModel"),
	                rs.getString("SerialNumber"),
	                rs.getDate("DateIssued"),
	                rs.getString("repairDesc"),
	                rs.getString("CurrentStatus"),
	                rs.getString("TechnicianRemarks")
	                
	              );  
	                repairJobs.add(job);    

	            }
	            session.setAttribute("repairJobs", repairJobs);
	          
	            request.setAttribute("repairJobs", repairJobs);

	            
	            con.close();
	            } 
	        }catch (Exception e) {
	            	throw new ServletException(e);
	            	
	            }
	        request.getRequestDispatcher("technicianJob.jsp").forward(request, response);
	        
	        
	    }
	      
	    
	


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stubs
		
		/**
		 
		 
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		
	    System.out.println("HALLO");

	    System.out.println("repairId = " + request.getParameter("RepairID"));
	    System.out.println("status = " + request.getParameter("currentStatus"));
	    System.out.println("remarks = " + request.getParameter("remarks"));
		**/
		
		String r = request.getParameter("RepairID");
		String n = request.getParameter("currentStatus");
		String p = request.getParameter("remarks");


		
		try {
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection(
		"jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!");
		
		String sql = "UPDATE repair SET CurrentStatus = ?, TechnicianRemarks = ? WHERE RepairID = ?";


			
		
		PreparedStatement ps = con.prepareStatement(sql);
		
		ps.setString(1, n);
		ps.setString(2, p);
		ps.setInt(3, Integer.parseInt(r));
		

		    ps.executeUpdate();
		   
	        con.close();
		   /**
		   System.out.println("Test");s
	       if (rows > 0)
	    	   System.out.println("Success");
	       else 
	    	   System.out.println("failed");
	       **/

			response.sendRedirect("jobServlet");
			
			return;
			
		} catch (Exception e2) {
			throw new ServletException(e2);
		}
		//out.close();
		}

	
	}


