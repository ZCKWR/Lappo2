

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
import java.util.ArrayList;
import java.util.List;


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
		reqPartDAO dao = new reqPartDAO();
					
		List<partTrack> repairList = new ArrayList<>();
	
		List<reqPart> reqsPart = new ArrayList<>();
	
		int totalRequests = dao.countTotalPartRequests(technicianIds);
		int totalPending = dao.countTotalPartPending(technicianIds);
		int totalApproved = dao.countTotalPartApproved(technicianIds);
		
		reqsPart = dao.viewPartRequest(technicianId);
		
		
		repairList = dao.viewRepairList(technicianId);
		
		request.setAttribute("partReqCount", totalRequests);
		request.setAttribute("partPenCount", totalPending);
		request.setAttribute("partApproveCount", totalApproved);
		
        session.setAttribute("reqsPart", reqsPart);

        session.setAttribute("repairList", repairList);
           
        request.getRequestDispatcher("technicianRequest.jsp").forward(request, response);
        
     
    }
      
		
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		
		HttpSession session = request.getSession();
		Integer technicianId = (Integer) session.getAttribute("userID");
		
		
		String repairID = request.getParameter("repairID");
		String partID = request.getParameter("partID");
		String quantity =request.getParameter("quantityReq");
		
		
		try {
		Class.forName("com.mysql.jdbc.Driver");
		 Connection con = DriverManager.getConnection(
		"jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!");

			
		 String sql = "INSERT INTO partrequest "
		           + "(QuantityRequested, ApprovalStatus, RepairID, PartID, RequestedBy) "
		           + "VALUES (?, ?, ?, ?, ?)";
		

		PreparedStatement ps = con.prepareStatement(sql);
		
        ps.setInt(1, Integer.parseInt(quantity));      
        ps.setString(2, "Pending");         
        ps.setInt(3, Integer.parseInt(repairID));        
        ps.setInt(4, Integer.parseInt(partID));       
        ps.setInt(5,  technicianId);
        
        
        int row = ps.executeUpdate();
        
        if (row > 0) {
            response.sendRedirect("requestPart");
        } else {
            response.sendRedirect("technicianRequest.jsp?error=true");
        }
        	
		}catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
		
	}
}
	
		

		    
	    
	    
	    
	
