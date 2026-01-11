package adminController;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import adminDAO.userDAO;

@WebServlet("/UpdateProfile")
public class UpdateProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userID");

        // 1. Security Check
        if (userId == null) {
            response.sendRedirect("LoginPage.jsp");
            return;
        }

        // 2. Capture Form Data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // 3. Update Database
        userDAO dao = new userDAO();
        boolean success = dao.updateFullProfile(userId, name, email, address, phone);

        if (success) {
            // 4. Update Session Attributes
            // This ensures the sidebar/header updates names immediately
            session.setAttribute("username", name);
            
            // 5. Redirect back with success message
            response.sendRedirect("adminProfile.jsp?status=success");
        } else {
            response.sendRedirect("adminProfile.jsp?status=error");
        }
    }
}
