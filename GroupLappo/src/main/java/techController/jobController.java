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
import userModel.Repair;
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
		
		List<jobView> pastComplete = dao.viewPastRepairs(technicianId);
		
        List<jobView> activeRepairs = dao.displayAllActiveJobs(technicianId);
        
        int assignedJobsCount = activeRepairs.size();
        
        session.setAttribute("assignedJobsCount", assignedJobsCount);
        
        session.setAttribute("ActiveJob", activeRepairs);
			
		session.setAttribute("pastRepairs", pastComplete);
		
		request.setAttribute("completedCount", totalCompleted);


		request.getRequestDispatcher("technicianDashboard.jsp").forward(request, response);
	}
	

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}
	

}
