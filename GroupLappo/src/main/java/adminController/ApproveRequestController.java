package adminController;

import adminDAO.inventoryDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/ApproveRequest")
public class ApproveRequestController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        
        // 1. Get the dynamic ID from the session
        Integer currentAdminId = (Integer) session.getAttribute("userID");
        
        // 2. Security Check
        if (currentAdminId == null) {
            response.sendRedirect("LoginPage.jsp");
            return;
        }

        // 3. Capture parameters
        String idParam = request.getParameter("id");
        String action = request.getParameter("action");
        
        inventoryDAO dao = new inventoryDAO();
        boolean success = false;

        if (idParam != null && !idParam.isEmpty()) {
            try {
                int requestId = Integer.parseInt(idParam);

                if ("approve".equalsIgnoreCase(action)) {
                    // Logic: Deduct stock and record Admin ID
                    success = dao.approveRequest(requestId, currentAdminId);
                } else if ("reject".equalsIgnoreCase(action)) {
                    // Logic: Update status to Rejected (NOW ACTIVE)
                    success = dao.rejectRequest(requestId, currentAdminId);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // 4. Redirect back
        response.sendRedirect("admin_inventory.jsp?status=" + (success ? "processed" : "error"));
    }
}
