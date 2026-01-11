package adminDAO;

import java.sql.*;
import java.util.*;

public class userDAO {
    private String dbURL = "jdbc:mysql://localhost:3306/lappo2";
    private String dbUser = "root";
    private String dbPass = "Zack1234!";
    private String driver = "com.mysql.jdbc.Driver";

    // 1. Fetch all users for admin_users.jsp
    public List<Map<String, String>> getAllUsers() {
        List<Map<String, String>> list = new ArrayList<>();
        String query = "SELECT UserID, Username, UserEmail, UserType FROM User ORDER BY UserID ASC";
        
        try {
            Class.forName(driver);
            try (Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);
                 Statement st = con.createStatement();
                 ResultSet rs = st.executeQuery(query)) {
                
                while (rs.next()) {
                    Map<String, String> user = new HashMap<>();
                    user.put("id", rs.getString("UserID"));
                    user.put("name", rs.getString("Username"));
                    user.put("email", rs.getString("UserEmail"));
                    user.put("type", rs.getString("UserType"));
                    list.add(user);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 2. Register new user (Multi-table insert with Transaction)
    public boolean registerUser(String name, String email, String pass, String address, String phone, String role) {
        Connection con = null;
        try {
            Class.forName(driver);
            con = DriverManager.getConnection(dbURL, dbUser, dbPass);
            con.setAutoCommit(false); 

            String sqlUser = "INSERT INTO User (Username, UserEmail, UserPassword, UserAddress, UserPhoneNumber, UserType) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement psUser = con.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS);
            psUser.setString(1, name);
            psUser.setString(2, email);
            psUser.setString(3, pass);
            psUser.setString(4, address);
            psUser.setString(5, phone);
            psUser.setString(6, role);
            psUser.executeUpdate();

            ResultSet rs = psUser.getGeneratedKeys();
            if (rs.next()) {
                int newId = rs.getInt(1);
                String sqlChild = "";
                if ("Student".equalsIgnoreCase(role)) sqlChild = "INSERT INTO Student (UserID, CampusName) VALUES (?, 'Not Set')";
                else if ("Technician".equalsIgnoreCase(role)) sqlChild = "INSERT INTO Technician (UserID, HourlyRate) VALUES (?, 0.00)";
                else if ("Admin".equalsIgnoreCase(role)) sqlChild = "INSERT INTO Admin (UserID, DateHired) VALUES (?, CURDATE())";

                if (!sqlChild.isEmpty()) {
                    PreparedStatement psChild = con.prepareStatement(sqlChild);
                    psChild.setInt(1, newId);
                    psChild.executeUpdate();
                }
            }
            con.commit();
            return true;
        } catch (Exception e) {
            if (con != null) try { con.rollback(); } catch (SQLException ex) {}
            e.printStackTrace();
            return false;
        } finally {
            if (con != null) try { con.close(); } catch (SQLException e) {}
        }
    }

    // 3. Delete User by ID
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM User WHERE UserID = ?";
        try {
            Class.forName(driver);
            try (Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, userId);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // 4. Update User Profile (Used by Admin User Management)
    public boolean updateUser(int userId, String name, String email, String role) {
        String sql = "UPDATE User SET Username = ?, UserEmail = ?, UserType = ? WHERE UserID = ?";
        try {
            Class.forName(driver);
            try (Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, role);
                ps.setInt(4, userId);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // 5. Fetch Full Profile Details (Used by adminProfile.jsp)
    public Map<String, String> getUserProfile(int userId) {
        Map<String, String> user = new HashMap<>();
        String sql = "SELECT Username, UserEmail, UserType, UserAddress, UserPhoneNumber FROM User WHERE UserID = ?";
        try {
            Class.forName(driver);
            try (Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        user.put("name", rs.getString("Username"));
                        user.put("email", rs.getString("UserEmail"));
                        user.put("role", rs.getString("UserType"));
                        user.put("address", rs.getString("UserAddress"));
                        user.put("phone", rs.getString("UserPhoneNumber"));
                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return user;
    }

    // 6. Complete Profile Update (Used by UpdateProfile Servlet)
    public boolean updateFullProfile(int userId, String name, String email, String address, String phone) {
        String sql = "UPDATE User SET Username = ?, UserEmail = ?, UserAddress = ?, UserPhoneNumber = ? WHERE UserID = ?";
        try {
            Class.forName(driver);
            try (Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, address);
                ps.setString(4, phone);
                ps.setInt(5, userId);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
}
