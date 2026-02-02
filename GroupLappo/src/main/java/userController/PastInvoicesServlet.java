package userController;

import java.io.IOException;
import java.util.List;

import userDAO.InvoiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import userModel.Invoice;

@WebServlet("/pastInvoices")
public class PastInvoicesServlet extends HttpServlet {

	static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

		HttpSession session = request.getSession();
		Integer studentID = (Integer) session.getAttribute("userID");
		
        InvoiceDAO dao = new InvoiceDAO();
        List<Invoice> invoiceList = dao.getPastInvoices(studentID);

        request.setAttribute("invoiceList", invoiceList);
        request.getRequestDispatcher("userHistory.jsp")
               .forward(request, response);
    }
}

