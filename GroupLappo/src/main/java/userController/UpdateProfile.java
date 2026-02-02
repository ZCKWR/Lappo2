package userController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import techDAO.updateDAO;
import techModel.techProfile;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import userModel.Student;
import userDAO.ProfileDAO;

/**
 * Servlet implementation class UpdateProfile
 */
@WebServlet("/Profile")
public class UpdateProfile extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateProfile() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		HttpSession session = request.getSession();
		Integer studentID = (Integer) session.getAttribute("userID");

        ProfileDAO profileDAO = new ProfileDAO();
        
        Student bean = profileDAO.getProfileByUserId(studentID);

        session.setAttribute("userProfile", bean);
        
        
        List<Student> profile = new ArrayList<>();
        
    	try {
    		Class.forName("com.mysql.jdbc.Driver");
    		Connection con = DriverManager.getConnection(
    		"jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!");
    		
    		if(studentID != null) {
    			
    			
    			String sql = "SELECT u.UserID, u.Username, u.UserEmail, u.UserAddress, u.UserPhoneNumber " +
    		             "FROM user u " +
    		             "JOIN User t ON u.UserID = t.UserID " + // Added space here
    		             "WHERE u.UserID = ?";
    		
    		
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, studentID);
            ResultSet rs = ps.executeQuery();
            
            System.out.println("Current Student ID: " + studentID);
            
            
            while (rs.next()) {
                // Match the constructor in your JavaBean
                Student profiles = new Student(
                    rs.getInt("UserID"), 
                    rs.getString("Username"),
                    rs.getString("UserEmail"),
                    rs.getString("UserAddress"),
                    rs.getString("UserPhoneNumber")

                );
                profile.add(profiles);
            }

            session.setAttribute("profile1", profile);
    		
    		con.close();
    	} 
    		}catch (Exception e) {
    		e.printStackTrace();
    	}
        
        
        request.getRequestDispatcher("userProfile.jsp").forward(request, response);
	
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		HttpSession session = request.getSession();
		Integer studentID = (Integer) session.getAttribute("userID");
		
		
		try {
			
			if(studentID != null) {
			
			int userID = Integer.parseInt(request.getParameter("userID"));
			String userName = request.getParameter("username");
			String userEmail = request.getParameter("useremail");
			String userPhone = request.getParameter("userphone");
			String userAddress = request.getParameter("useraddress");
			
			Student bean = new Student();
			bean.setUserID(userID);
            bean.setUsername(userName);
            bean.setUserEmail(userEmail);
            bean.setUserPhoneNumber(userPhone);
            bean.setUserAddress(userAddress);
            
            ProfileDAO dao = new ProfileDAO();
            
            boolean isUpdated = dao.updateProfile(bean);
            
            if(isUpdated) {    
        	
            	session.setAttribute("userID", userID);
            	session.setAttribute("username", userName);
            	session.setAttribute("useremail",  userEmail);
            	session.setAttribute("userphone", userPhone);
            	session.setAttribute("useraddress", userAddress);
            	
            	session.setAttribute("profile1", bean);
            	
            	session.setAttribute("message", "Profile updated successfully!");
            } else {
                request.getSession().setAttribute("error", "Update failed. Please try again.");
            }
  
			}else {
				System.out.println("Error");
			}

			}catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("error", "An error occurred: " + e.getMessage());
            }	
		// 5. Redirect back to the profile page
		response.sendRedirect("Profile"); 
		
		}
	}
		
	

