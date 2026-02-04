package adminController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import adminDAO.inventoryDAO;

/**
 * Servlet implementation class InventoryDelete
 */
@WebServlet("/InventoryDelete")
public class InventoryDelete extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public InventoryDelete() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub

        int partID = Integer.parseInt(request.getParameter("partID"));
        
        System.out.println(partID);
        inventoryDAO dao = new inventoryDAO();

        if (!dao.isPartUsed(partID)) {
            dao.deletePart(partID);
        }
		
        
        request.getRequestDispatcher("admin_inventory.jsp").forward(request, response);
		
	}

}
