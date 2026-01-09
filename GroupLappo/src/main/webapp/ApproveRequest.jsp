<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    String requestId = request.getParameter("id");
    String action = request.getParameter("action");
    
    // In a production app, you would get this from session: (int)session.getAttribute("userId")
    // For now, we use a placeholder ID (e.g., 1 for Admin)
    int currentAdminId = 1; 

    if (requestId != null && action != null) {
        Connection con = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lappo2", "root", "Zack1234!");
            
            // Start Transaction
            con.setAutoCommit(false);

            if ("approve".equalsIgnoreCase(action)) {
                // 1. Get request details (PartID and Qty)
                String infoSql = "SELECT PartID, QuantityRequested FROM partrequest WHERE RequestID = ?";
                PreparedStatement psInfo = con.prepareStatement(infoSql);
                psInfo.setInt(1, Integer.parseInt(requestId));
                ResultSet rs = psInfo.executeQuery();
                
                if(rs.next()) {
                    int partId = rs.getInt("PartID");
                    int qtyReq = rs.getInt("QuantityRequested");

                    // 2. Deduct from Inventory (Only if enough stock exists)
                    String deductSql = "UPDATE part SET Quantity = Quantity - ? WHERE PartID = ? AND Quantity >= ?";
                    PreparedStatement psDeduct = con.prepareStatement(deductSql);
                    psDeduct.setInt(1, qtyReq);
                    psDeduct.setInt(2, partId);
                    psDeduct.setInt(3, qtyReq);
                    
                    int rowsUpdated = psDeduct.executeUpdate();

                    if(rowsUpdated > 0) {
                        // 3. Update PartRequest Status
                        String updateReqSql = "UPDATE partrequest SET ApprovalStatus = 'Approved', ApprovedBy = ?, DateApproved = NOW() WHERE RequestID = ?";
                        PreparedStatement psReq = con.prepareStatement(updateReqSql);
                        psReq.setInt(1, currentAdminId);
                        psReq.setInt(2, Integer.parseInt(requestId));
                        psReq.executeUpdate();

                        // 4. Log the Transaction in parttransaction table
                        String transSql = "INSERT INTO parttransaction (PartID, QuantityChange, TransactionType, TransactionDate) VALUES (?, ?, 'Used for Repair', NOW())";
                        PreparedStatement psTrans = con.prepareStatement(transSql);
                        psTrans.setInt(1, partId);
                        psTrans.setInt(2, qtyReq);
                        psTrans.executeUpdate();

                        con.commit(); // Success
                    } else {
                        throw new Exception("Insufficient stock available to approve this request.");
                    }
                }
            } else if ("reject".equalsIgnoreCase(action)) {
                // Simple rejection logic
                String rejectSql = "UPDATE partrequest SET ApprovalStatus = 'Rejected', ApprovedBy = ?, DateApproved = NOW() WHERE RequestID = ?";
                PreparedStatement psRej = con.prepareStatement(rejectSql);
                psRej.setInt(1, currentAdminId);
                psRej.setInt(2, Integer.parseInt(requestId));
                psRej.executeUpdate();
                
                con.commit();
            }

        } catch (Exception e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException se) { se.printStackTrace(); }
            }
            // Optional: Store error message in session to display on the main page
            session.setAttribute("errorMessage", e.getMessage());
        } finally {
            if (con != null) {
                try { con.close(); } catch (SQLException se) { se.printStackTrace(); }
            }
        }
    }
    
    // Redirect back to the inventory page
    response.sendRedirect("admin_inventory.jsp");
%>