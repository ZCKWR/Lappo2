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
		
        RepairDAO dao = new RepairDAO();
        List<Repair> repairList = dao.getPastRepairs(studentID);

        request.setAttribute("repairList", repairList);
        request.getRequestDispatcher("UserDashboard.jsp")
               .forward(request, response);
    }
}
