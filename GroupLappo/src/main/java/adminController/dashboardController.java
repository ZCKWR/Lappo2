package adminController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import adminDAO.dashboardDAO;
import adminModel.lowStock;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet implementation class dashboardController
 */
@WebServlet("/dashboardController")
public class dashboardController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public dashboardController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		HttpSession session = request.getSession();
		
		
		dashboardDAO totalUser = new dashboardDAO();
		dashboardDAO totalActiveJob = new dashboardDAO();
		dashboardDAO totalCompleteJob = new dashboardDAO();
		dashboardDAO totalPendingJob = new dashboardDAO();
		
		
		int countTotalUser = totalUser.countTotalUser();
		int countTotalActiveJob = totalActiveJob.countTotalActiveJobs();
		int countTotalCompleteJob = totalCompleteJob.countTotalCompleteJob();
		int countTotalPendingJob = totalPendingJob.countTotalPendingJob();
		
		request.setAttribute("totalUser", countTotalUser);
		request.setAttribute("countTotalActiveJob", countTotalActiveJob);
		request.setAttribute("countTotalCompleteJob", countTotalCompleteJob);
		request.setAttribute("countTotalPendingJob", countTotalPendingJob);
				
		
		List<lowStock> low = new ArrayList<>();
		
		try {
		    
	    	Class.forName("com.mysql.jdbc.Driver");
		    Connection con = DriverManager.getConnection(
		    "jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!"); 
	        
		    String sql = "SELECT partID, partName, Quantity FROM part WHERE Quantity < 10";
		    
		    PreparedStatement ps = con.prepareStatement(sql);

	        ResultSet rs = ps.executeQuery();
	        
	        while (rs.next()) {
	            lowStock ls = new lowStock(
	            rs.getInt("partID"),
	            rs.getString("partName"),
	            rs.getInt("Quantity")
	           );
	            low.add(ls);
	        }
		}catch(Exception e) {
	        e.printStackTrace();
	    }
        session.setAttribute("lowStock", low);
        
        request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
        
        for (lowStock ls : low) {
            System.out.println(ls.getRepairID());
        }

		

		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
