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

@WebServlet("/repairStatus")
public class RepairStatusServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
		
		String device = request.getParameter("device");

        RepairDAO dao = new RepairDAO();
        List<Repair> repairList;
        
        if(device != null && !device.trim().isEmpty()) {
        	repairList = dao.getRepairStatusByDevice(device);
        } else {
        	repairList = dao.getRepairStatus();
        }
        
        System.out.println("SEARCH DEVICE = " + device);

        request.setAttribute("repairList", repairList);
        request.getRequestDispatcher("userTracking.jsp")
               .forward(request, response);
    }
}
