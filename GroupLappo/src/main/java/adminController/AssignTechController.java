package adminController;

import adminDAO.repairDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/AssignTech")
public class AssignTechController extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 1. Get current Admin ID from session
        HttpSession session = request.getSession();
        Integer adminId = (Integer) session.getAttribute("userID");

        // 2. Security Check: Ensure admin is logged in
        if (adminId == null) {
            response.sendRedirect("LoginPage.jsp");
            return;
        }

        // 3. Retrieve IDs from the modal form
        String rIdStr = request.getParameter("repairId");
        String tIdStr = request.getParameter("techUserId");

        // 4. Validation and Execution
        if (rIdStr != null && !rIdStr.isEmpty() && tIdStr != null && !tIdStr.isEmpty()) {
            try {
                int repairId = Integer.parseInt(rIdStr);
                int techId = Integer.parseInt(tIdStr);

                repairDAO dao = new repairDAO();
                
                // Calls the method that updates AssignedTech, ApprovedBy, and sets Status to 'In Progress'
                boolean success = dao.assignAndApprove(repairId, techId, adminId);
                
                if (success) {
                    response.sendRedirect("admin_active_repair.jsp?status=success");
                } else {
                    response.sendRedirect("admin_active_repair.jsp?status=db_error");
                }
                
            } catch (NumberFormatException e) {
                response.sendRedirect("admin_active_repair.jsp?status=invalid_input");
            }
        } else {
            response.sendRedirect("admin_active_repair.jsp?status=missing_fields");
        }
    }
}
