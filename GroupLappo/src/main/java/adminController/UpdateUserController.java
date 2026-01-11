package adminController;

import adminDAO.userDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/UpdateUser")
public class UpdateUserController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("userId"));
        String name = request.getParameter("userName");
        String email = request.getParameter("userEmail");
        String role = request.getParameter("userRole");

        userDAO dao = new userDAO();
        if (dao.updateUser(id, name, email, role)) {
            response.sendRedirect("admin_users.jsp?status=updated");
        } else {
            response.sendRedirect("admin_users.jsp?status=error");
        }
    }
}
