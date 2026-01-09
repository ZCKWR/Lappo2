package adminController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import adminModel.UserBean;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/UserManagement")
public class UserController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<UserBean> userList = new ArrayList<>();
        try {
            // Database Connection (Replace with your DB details)
        	Connection con = DriverManager.getConnection(
        			"jdbc:mysql://localhost:3306/lappo2", "root", "Zack1234!");
            
            String sql = "SELECT * FROM users";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                UserBean u = new UserBean();
                u.setUserid(rs.getInt("userid"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));
                u.setJoinedDate(rs.getDate("joined_date"));
                userList.add(u);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("userList", userList);
        request.getRequestDispatcher("admin_users.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Logic for Add/Edit/Delete would go here (using a 'action' parameter)
    }
}