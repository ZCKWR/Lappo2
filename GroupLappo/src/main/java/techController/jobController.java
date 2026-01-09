package techController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import techDAO.dashboardDAO;

import java.io.IOException;
import techModel.jobView;
import jakarta.servlet.RequestDispatcher;
import java.io.PrintWriter;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet implementation class jobController
 */
@WebServlet("/jobController")
public class jobController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public jobController() {
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
		
		dashboardDAO dao = new dashboardDAO();
		
		int totalCompleted = dao.countCompletedRepairs(technicianId);
		
		request.setAttribute("completedCount", totalCompleted);
		
		
		List<jobView> job = new ArrayList<>();
		
		
		try {
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection(
		"jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!");
		
		if(technicianId != null) {
			String sql = "SELECT u.Username, r.DateIssued, r.repairDesc, r.CurrentStatus, r.TechnicianRemarks " +
                    "FROM repair r " +
                    "JOIN user u ON r.CustomerID = u.UserID " +
                    "WHERE r.AssignedTech = ?";
		
		
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, technicianId);
        ResultSet rs = ps.executeQuery();
        
        System.out.println("Current Tech ID: " + technicianId);
        
        while (rs.next()) {
            // Match the constructor in your JavaBean
            jobView s = new jobView(
                rs.getString("Username"), 
                rs.getDate("DateIssued"),
                rs.getString("repairDesc"),
                rs.getString("CurrentStatus"),
                rs.getString("TechnicianRemarks")

            );
            job.add(s);
        }
        int assignedJobsCount = job.size();

        session.setAttribute("job", job);
        session.setAttribute("assignedJobsCount", assignedJobsCount);
		
		con.close();
	} 
		}catch (Exception e) {
		e.printStackTrace();
	}
		request.getRequestDispatcher("technicianDashboard.jsp").forward(request, response);
	}
	

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}
	
	//TEst Change 323

}
