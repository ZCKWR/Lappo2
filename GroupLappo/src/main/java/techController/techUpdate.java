package techController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import techDAO.updateDAO;
import techModel.jobView;
import techModel.techProfile;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
/**
 * Servlet implementation class techUpdate
 */
@WebServlet("/techUpdate")
public class techUpdate extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public techUpdate() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		HttpSession session = request.getSession();
		Integer technicianId = (Integer) session.getAttribute("userID");
		
		updateDAO dao = new updateDAO();
	    techProfile bean = dao.getProfileByUserId(technicianId);
	    
	    session.setAttribute("techProfile", bean);

		
		
		List<techProfile> profile = new ArrayList<>();
		
		
		try {
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection(
		"jdbc:mysql://localhost:3306/lappo2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "Zack1234!");
		
		if(technicianId != null) {
			
			
			String sql = "SELECT u.UserID, u.Username, u.UserEmail, u.UserAddress, u.UserPhoneNumber " +
		             "FROM user u " +
		             "JOIN technician t ON u.UserID = t.UserID " + // Added space here
		             "WHERE u.UserID = ?";
		
		
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, technicianId);
        ResultSet rs = ps.executeQuery();
        
        System.out.println("Current Tech ID: " + technicianId);
        
        
        while (rs.next()) {
            // Match the constructor in your JavaBean
            techProfile profiles = new techProfile(
                rs.getInt("UserID"), 
                rs.getString("Username"),
                rs.getString("UserEmail"),
                rs.getString("UserAddress"),
                rs.getString("UserPhoneNumber")

            );
            profile.add(profiles);
        }

        session.setAttribute("profile", profile);
		
		con.close();
	} 
		}catch (Exception e) {
		e.printStackTrace();
	}
		request.getRequestDispatcher("technicianProfile.jsp").forward(request, response);
	}
	

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		HttpSession session = request.getSession();
		Integer technicianId = (Integer) session.getAttribute("userID");
		
		
		try {
			
			if(technicianId != null) {
			
			int techID = Integer.parseInt(request.getParameter("techId"));
			String techName = request.getParameter("username");
			String techEmail = request.getParameter("email");
			String techPhone = request.getParameter("phone");
			String techAddress = request.getParameter("address");
			
			techProfile bean = new techProfile();
			bean.setTechID(techID);
            bean.setTechName(techName);
            bean.setTechEmail(techEmail);
            bean.setTechPhone(techPhone);
            bean.setTechAddress(techAddress);
            
            updateDAO dao = new updateDAO();
            
            boolean isUpdated = dao.updateProfile(bean);
            
            if(isUpdated) {    
            	
            	session.setAttribute("techId", techID);
            	session.setAttribute("username", techName);
            	session.setAttribute("email",  techEmail);
            	session.setAttribute("phone", techPhone);
            	session.setAttribute("address", techAddress);
            	
            	session.setAttribute("techProfile", bean);
            	
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
		 request.getRequestDispatcher("technicianProfile.jsp").forward(request, response);
	        
		}
			
		
	}

