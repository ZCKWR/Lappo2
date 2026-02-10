package techController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import techDAO.activeRepairDAO;
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
@WebServlet("/activeJob")
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
		
		activeRepairDAO dao = new activeRepairDAO();
	
		List<jobAssigned> repairJobs = new ArrayList<>();
		
		repairJobs = dao.viewPastRepairs(technicianId);
		
        session.setAttribute("repairJobs", repairJobs);

	    request.getRequestDispatcher("technicianJob.jsp").forward(request, response);
	        
	        
	    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stubs
		
		
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


			response.sendRedirect("activeJob");
			
			return;
			
		} catch (Exception e2) {
			throw new ServletException(e2);
		}
		
		}

	
	}


