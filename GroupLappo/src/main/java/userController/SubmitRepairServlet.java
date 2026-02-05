package userController;

import java.io.IOException;

import userDAO.RepairDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import userModel.Repair;

@WebServlet("/submitRepair")
public class SubmitRepairServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	    	
		HttpSession session = request.getSession();
		Integer studentID = (Integer) session.getAttribute("userID");

        // 1. Get form data	
        String LaptopModel = request.getParameter("laptopModel");
        String Issue = request.getParameter("issue");
        String Description = request.getParameter("description");
        String DateIssued = request.getParameter("dateIssued");
        String SerialNumber = request.getParameter("serialNumber");

        // 2. Create Repair object
        Repair repair = new Repair();
        repair.studentID = studentID;
        repair.LaptopModel = LaptopModel;
        repair.Issue = Issue;
        repair.Description = Description;
        repair.DateIssued = DateIssued;
        repair.serialNumber = SerialNumber;
        repair.CurrentStatus = "Pending"; 

        // 3. Save to database
        RepairDAO dao = new RepairDAO();
        dao.insertRepair(repair);


        // 4. Redirect (VERY IMPORTANT)
        response.sendRedirect("ongoingRepairs");
    }
}
