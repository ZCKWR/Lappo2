package adminController;

import adminDAO.userDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/DeleteUser")
public class DeleteUserController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String userId = request.getParameter("userId");
        
        userDAO dao = new userDAO();
        if (dao.deleteUser(Integer.parseInt(userId))) {
            response.sendRedirect("admin_users.jsp?status=deleted");
        } else {
            response.sendRedirect("admin_users.jsp?status=error");
        }
    }
}
