package adminController;

import adminDAO.repairDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/ProcessRepairController") 
public class ProcessRepairController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        Integer adminId = (Integer) session.getAttribute("userID");

        if (adminId == null) {
            response.sendRedirect("LoginPage.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        String action = request.getParameter("action");

        if (idStr != null && action != null) {
            try {
                int repairId = Integer.parseInt(idStr);
                repairDAO dao = new repairDAO();
                boolean success = false;

                if ("approve".equals(action)) {
                    success = dao.approveRepairOrder(repairId, adminId);
                } else if ("reject".equals(action)) {
                    success = dao.rejectRepairOrder(repairId, adminId);
                }

                response.sendRedirect("admin_dashboard.jsp?status=" + (success ? action + "_ok" : "fail"));
            } catch (Exception e) {
                response.sendRedirect("admin_dashboard.jsp?status=error");
            }
        } else {
            response.sendRedirect("admin_dashboard.jsp");
        }
    }
}
