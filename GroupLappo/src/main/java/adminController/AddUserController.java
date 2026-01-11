package adminController;

import adminDAO.userDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/AddUser")
public class AddUserController extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Get Parameters from your JSP Form
        String name = request.getParameter("userName");
        String email = request.getParameter("userEmail");
        String pass = request.getParameter("userPassword");
        String address = request.getParameter("userAddress");
        String phone = request.getParameter("userPhone");
        String role = request.getParameter("userRole"); // This maps to UserType in your DB

        // 2. Process via DAO
        userDAO dao = new userDAO();
        // Ensure this method in userDAO uses the correct column names shown in your screenshot
        boolean success = dao.registerUser(name, email, pass, address, phone, role);

        // 3. Redirect with Status
        if (success) {
            response.sendRedirect("admin_users.jsp?status=success");
        } else {
            response.sendRedirect("admin_users.jsp?status=error");
        }
    }
}
