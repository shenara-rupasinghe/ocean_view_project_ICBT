package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/StaffServlet")
public class StaffServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"Admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("DashboardServlet?error=unauthorized");
            return;
        }

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            String id = request.getParameter("id");
            if (id != null) {
                boolean success = userDAO.deleteUser(id);
                if (success) {
                    response.sendRedirect("StaffServlet?status=deleted");
                } else {
                    response.sendRedirect("StaffServlet?status=delete_error");
                }
                return;
            }
        }


        List<Map<String, String>> staffList = userDAO.getAllUsers();
        request.setAttribute("staffList", staffList);
        request.getRequestDispatcher("manage-staff.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");


        if ("update".equals(action)) {
            String id = request.getParameter("editId");
            String fullName = request.getParameter("editFullName");
            String role = request.getParameter("editRole");

            boolean success = userDAO.updateStaff(id, fullName, role);
            if (success) {
                response.sendRedirect("StaffServlet?status=updated");
            } else {
                response.sendRedirect("StaffServlet?status=error");
            }
            return;
        }


        String name = request.getParameter("fullName");
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        String role = request.getParameter("role");

        if (name == null || name.isEmpty() || user == null || user.isEmpty() || pass == null || role == null) {
            response.sendRedirect("StaffServlet?status=missing");
            return;
        }

        boolean success = userDAO.registerUser(name, user, pass, role);

        if (success) {
            response.sendRedirect("StaffServlet?status=success");
        } else {
            response.sendRedirect("StaffServlet?status=error");
        }
    }
}