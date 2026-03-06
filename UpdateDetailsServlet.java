package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/UpdateDetailsServlet")
public class UpdateDetailsServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();


        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String username = (String) session.getAttribute("username");
        UserDAO dao = new UserDAO();
        boolean success = dao.updateUserDetails(fullName, email, phone, username);

        if (success) {

            session.setAttribute("user", fullName);
            response.sendRedirect("settings.jsp?status=success");
        } else {
            response.sendRedirect("settings.jsp?status=error");
        }
    }
}