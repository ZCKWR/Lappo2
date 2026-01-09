package LogSign;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/SignUpServlet")
public class SignUpServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        // =======================
        // 1. Get form parameters
        // =======================
        String email = request.getParameter("email");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password"); // plain text

        // =======================
        // 2. Validation
        // =======================
        if (email == null || name == null || phone == null ||
            address == null || password == null ||
            email.isEmpty() || name.isEmpty() || password.isEmpty()) {

            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher("signUp.jsp").forward(request, response);
            return;
        }

        Connection con = null;
        PreparedStatement psCheck = null;
        PreparedStatement psInsert = null;
        ResultSet rs = null;

        try {
            // =======================
            // 3. Load MySQL Driver
            // =======================
            Class.forName("com.mysql.jdbc.Driver"); // MySQL 5.1.47

            // =======================
            // 4. Database Connection
            // =======================
            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/lappo2?useSSL=false&serverTimezone=UTC",
                "root",
                "Zack1234!"
            );

            // =======================
            // 5. Check email exists
            // =======================
            String checkSql = "SELECT UserID FROM user WHERE UserEmail = ?";
            psCheck = con.prepareStatement(checkSql);
            psCheck.setString(1, email);
            rs = psCheck.executeQuery();

            if (rs.next()) {
                request.setAttribute("errorMessage", "Email already registered.");
                request.getRequestDispatcher("signUp.jsp").forward(request, response);
                return;
            }

            // =======================
            // 6. Insert new user
            // =======================
            String insertSql =
                "INSERT INTO user " +
                "(Username, UserEmail, UserPassword, UserAddress, UserPhoneNumber, UserType) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

            psInsert = con.prepareStatement(insertSql);
            psInsert.setString(1, name);
            psInsert.setString(2, email);
            psInsert.setString(3, password); // ❌ NO hashing
            psInsert.setString(4, address);
            psInsert.setString(5, phone);
            psInsert.setString(6, "Student");

            psInsert.executeUpdate();

            // =======================
            // 7. Success → redirect
            // =======================
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Registration successful. Please login.");
            response.sendRedirect("LoginPage.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("signUp.jsp").forward(request, response);

        } finally {
            // =======================
            // 8. Close resources
            // =======================
            try {
                if (rs != null) rs.close();
                if (psCheck != null) psCheck.close();
                if (psInsert != null) psInsert.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("signUp.jsp");
    }
}
