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

@WebServlet("/ongoingRepairs")
public class OngoingRepairsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	
    	HttpSession session = request.getSession();
		Integer studentID = (Integer) session.getAttribute("userID");

        RepairDAO repairDAO = new RepairDAO();
        
        int activeRepairs = repairDAO.countByStatus("In Progress");
        int totalRepairs = repairDAO.countAllRepairs(studentID);
        double amountDue = repairDAO.sumPendingPayments();

        request.setAttribute("activeRepairs", activeRepairs);
        request.setAttribute("totalRepairs", totalRepairs);
        request.setAttribute("amountDue", amountDue);

        List<Repair> repairs = repairDAO.getOngoingRepairs(studentID);
        List<Repair> pastRepair = repairDAO.getPastRepairs(studentID);
        
     // DEBUG: print size to console
        System.out.println("Repairs list size: " + repairs.size());
        
        request.setAttribute("pastRepair", pastRepair);
        request.setAttribute("repairList", repairs);
        request.getRequestDispatcher("UserDashboard.jsp")
               .forward(request, response);
    }
}

