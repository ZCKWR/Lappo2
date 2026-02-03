package userController;

import java.io.IOException;
import java.util.List;

import userDAO.RepairDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import userModel.Repair;

@WebServlet("/pastRepairs")
public class PastRepairsServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
		

		HttpSession session = request.getSession();
		Integer studentID = (Integer) session.getAttribute("userID");
		
        RepairDAO repairDAO = new RepairDAO();
        
        int countPastRepair = repairDAO.countPastRepairs(studentID);
        
        System.out.println(countPastRepair);
        
        List<Repair> repairList = repairDAO.getPastRepairs(studentID);

        request.setAttribute("countPastRepair", countPastRepair);
        request.setAttribute("repairList", repairList);
        request.getRequestDispatcher("UserDashboard.jsp")
               .forward(request, response);
    }
}


// NO USE 