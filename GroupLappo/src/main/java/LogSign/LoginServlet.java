package LogSign;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import techModel.techProfile;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role"); // student / technician
        
        

        if (email == null || password == null ||
            email.isEmpty() || password.isEmpty()) {

            request.setAttribute("errorMessage", "Please fill in all fields.");
            request.getRequestDispatcher("LoginPage.jsp").forward(request, response);
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");

            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/lappo2?useSSL=false&serverTimezone=UTC",
                "root",
                "Zack1234!"
            );
            

            // 🔑 CHECK EMAIL + PASSWORD ONLY
            String sql =
                "SELECT UserID, Username, UserType FROM user " +
                "WHERE UserEmail=? AND UserPassword=?";

            ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);

            rs = ps.executeQuery();

            if (rs.next()) {
                String userType = rs.getString("UserType");

                HttpSession session = request.getSession();
                session.setAttribute("userID", rs.getInt("UserID"));
                session.setAttribute("username", rs.getString("Username"));
                session.setAttribute("role", userType);
                
                

                // 🔥 ADMIN OVERRIDE (AUTO)
                if ("Admin".equalsIgnoreCase(userType)) {
                    response.sendRedirect("admin_dashboard.jsp");
                    return;
                }

                // 👤 STUDENT / TECHNICIAN ikut radio
                if ("student".equals(role) && "Student".equalsIgnoreCase(userType)) {
                    response.sendRedirect("UserDashboard.jsp");
                    return;
                } 
                else if ("technician".equals(role) && "Technician".equalsIgnoreCase(userType)) {
                    response.sendRedirect("jobController");
                    return;
                } 
                else {
                    request.setAttribute("errorMessage",
                        "Role mismatch. Please select the correct role.");
                    request.getRequestDispatcher("LoginPage.jsp").forward(request, response);
                }

            } else {
                request.setAttribute("errorMessage",
                    "Invalid email or password.");
                request.getRequestDispatcher("LoginPage.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Server error.");
            request.getRequestDispatcher("LoginPage.jsp").forward(request, response);

        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException ignored) {}
        }
    }
}
