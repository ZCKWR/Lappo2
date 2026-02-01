package userController;

import java.io.IOException;
import java.util.List;

import userDAO.InvoiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import userModel.Invoice;

@WebServlet("/pastInvoices")
public class PastInvoicesServlet extends HttpServlet {

	static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        InvoiceDAO dao = new InvoiceDAO();
        List<Invoice> invoiceList = dao.getPastInvoices();

        request.setAttribute("invoiceList", invoiceList);
        request.getRequestDispatcher("userHistory.jsp")
               .forward(request, response);
    }
}

