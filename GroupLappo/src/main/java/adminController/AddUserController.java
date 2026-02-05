package adminController;

import adminDAO.userDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/AddUser")
public class AddUserController extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    	
    	try {
    		
    		Class.forName("com.mysql.jdbc.Driver");
    		
    		Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/lappo2?useSSL=false&serverTimezone=UTC",
                    "root",
                    "Zack1234!"
                );
    		
    		// 1. Get Parameters from your JSP Form
            String name = request.getParameter("userName");
            String email = request.getParameter("userEmail");
            String pass = request.getParameter("userPassword");
            String address = request.getParameter("userAddress");
            String phone = request.getParameter("userPhone");
            String role = request.getParameter("userRole"); // This maps to UserType in your DB
    	
    	String checkSql = "SELECT UserID FROM user WHERE UserEmail = ?";
        PreparedStatement psCheck = con.prepareStatement(checkSql);
        psCheck.setString(1, email);
        ResultSet rs = psCheck.executeQuery();

        if (rs.next()) {
            request.setAttribute("errorMessage", "Email already registered.");
            request.getRequestDispatcher("admin_users.jsp").forward(request, response);
            return;
        }
        
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
    }catch(Exception e) {
    	e.printStackTrace();
    }
    }
}
