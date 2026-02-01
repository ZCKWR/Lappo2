package userController;

import java.io.IOException;
import java.util.List;

import userDAO.RepairDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import userModel.Repair;

@WebServlet("/pastRepairs")
public class PastRepairsServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        RepairDAO dao = new RepairDAO();
        List<Repair> repairList = dao.getPastRepairs();

        request.setAttribute("repairList", repairList);
        request.getRequestDispatcher("UserDashboard.jsp")
               .forward(request, response);
    }
}
