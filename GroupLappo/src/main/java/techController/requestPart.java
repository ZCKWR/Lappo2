package techController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import techDAO.reqPartDAO;
import techModel.partTrack;
import techModel.reqPart;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.io.PrintWriter;


/**
 * Servlet implementation class requestPart
 */
@WebServlet("/requestPart")
public class requestPart extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public requestPart() {
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
		
		int technicianIds = (int) session.getAttribute("userID");
		
		reqPartDAO dao2 = new reqPartDAO();
		
		reqPartDAO dao = new reqPartDAO();
		
		reqPartDAO dao3 = new reqPartDAO();
		
		List<reqPart> reqsPart = new ArrayList<>();
		
		
		int totalRequests = dao.countTotalPartRequests(technicianIds);
		int totalPending = dao2.countTotalPartPending(technicianIds);
		int totalApproved = dao3.countTotalPartApproved(technicianIds);
		
		request.setAttribute("partReqCount", totalRequests);
		request.setAttribute("partPenCount", totalPending);
		request.setAttribute("partApproveCount", totalApproved);
		


        try {
        	Class.forName("com.mysql.jdbc.Driver");
    		Connection con = DriverManager.getConnection(
    		"jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!");
            // Your SQL query
    		
			
    		String sql = "SELECT " +
    	             "pr.RepairID, " +
    	             "p.PartName, " +
    	             "p.Manufacturer, " +
    	             "pr.QuantityRequested, " +
    	             "pr.DateRequest, " +
    	             "pr.DateApproved, " +
    	             "pr.ApprovalStatus " +
    	             "FROM partrequest pr " +
    	             "JOIN part p ON pr.PartID = p.PartID " +
    	             "JOIN repair r ON pr.RepairID = r.RepairID " +
    	             "WHERE pr.RequestedBy = ?";
    		
            String repairSql = "SELECT DISTINCT repairID FROM repair WHERE assignedTech = ?";
            PreparedStatement stmt = con.prepareStatement(repairSql);
            stmt.setInt(1, technicianIds);

	        
           PreparedStatement ps = con.prepareStatement(sql);
           ps.setInt(1, technicianId);
           ResultSet rs = ps.executeQuery();
           
           

            // Display results in HTML table
          
           
            while (rs.next()) {
            	reqPart reqP = new reqPart(
                rs.getInt("RepairID"),
                rs.getString("PartName"),
                rs.getString("manufacturer"),
                rs.getInt("QuantityRequested"),
                rs.getDate("DateRequest"),
                rs.getDate("DateApproved"),
                rs.getString("ApprovalStatus")
              );  
            	
                reqsPart.add(reqP);    

            }
            
            int totalReqPart = reqsPart.size();
            

            session.setAttribute("totalReqPart", totalReqPart);
 
            session.setAttribute("reqsPart", reqsPart);
          
            request.setAttribute("reqsPart", reqsPart);

            
            con.close();
            } catch (Exception e) {
            	throw new ServletException(e);
            	
            }
        request.getRequestDispatcher("technicianRequest.jsp").forward(request, response);
        
        
    }
      
		
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		System.out.println("===== FORM PARAMETERS =====");

		request.getParameterMap().forEach((key, value) -> {
		    System.out.println(key + " = " + Arrays.toString(value));
		});

		System.out.println("===========================");
		
		HttpSession session = request.getSession();
		Integer technicianId = (Integer) session.getAttribute("userID");
		
		

		
		
		
		/**
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		
	    System.out.println("HALLO");

	    System.out.println("repairId = " + request.getParameter("RepairID"));
	    System.out.println("status = " + request.getParameter("currentStatus"));
	    System.out.println("remarks = " + request.getParameter("remarks"));
		**/
		
		String repairID = request.getParameter("repairID");
		String partID = request.getParameter("partID");
		String quantity =request.getParameter("quantityReq");
		
		
        
		
		response.setContentType("text/html");
		
	    System.out.println("HALLO");

	    System.out.println("repairId = " + request.getParameter("repairID"));
	    System.out.println("partID = " + request.getParameter("partID"));
	    System.out.println("ApprovalStatus = " + request.getParameter("quantityReq"));
	    System.out.println("repairID = " + request.getParameter("repairID"));
	    System.out.println("ApprovalStatus = " + "Pending");


	       Connection con = null;
		
		try {
		Class.forName("com.mysql.jdbc.Driver");
		 con = DriverManager.getConnection(
		"jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!");

			
		 String sql = "INSERT INTO partrequest "
		           + "(QuantityRequested, ApprovalStatus, RepairID, PartID, RequestedBy) "
		           + "VALUES (?, ?, ?, ?, ?)";
		

		try( PreparedStatement ps = con.prepareStatement(sql)){
		
		
        ps.setInt(1, Integer.parseInt(quantity));
        
        ps.setString(2, "Pending"); // Default approval status
        
        ps.setInt(3, Integer.parseInt(repairID));
        
        ps.setInt(4, Integer.parseInt(partID));
        
        ps.setInt(5,  technicianId);
        
        
        int row = ps.executeUpdate();
        
        if (row > 0) {
            response.sendRedirect("technicianRequest.jsp?success=true");
        } else {
            response.sendRedirect("technicianRequest.jsp?error=true");
        }
        
        response.sendRedirect("requestPart");
		
		return;

		} 
		}catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
		
	}
	}
		

		    
	    
	    
	    
	
