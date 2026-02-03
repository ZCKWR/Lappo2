package userController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import userDAO.InvoiceDAO;
import userDAO.RepairDAO;

import java.io.IOException;

/**
 * Servlet implementation class SubmitPaymentServlet
 */
@WebServlet("/SubmitPayment")
public class SubmitPaymentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SubmitPaymentServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		
	    HttpSession session = request.getSession();
	    Integer studentID = (Integer) session.getAttribute("userID");
		int repairID = Integer.parseInt(request.getParameter("repairID"));
		
	    String paymentType = request.getParameter("paymentMethod"); // make sure your select has name="paymentMethod"

		InvoiceDAO dao = new InvoiceDAO();
	    
	    boolean invoiceSaved = dao.insertInvoice(studentID, repairID, paymentType);
	    
	    if (invoiceSaved) {
	        dao.markAsPaidIfComplete(repairID);
	        response.sendRedirect("repairStatus"); // or "pastInvoices"
	    }else {
	        response.sendRedirect("repairStatus?error=invoice_failed");
	    }


	}

}
