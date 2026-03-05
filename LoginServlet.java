package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String usernameInput = request.getParameter("username");
        String passwordInput = request.getParameter("password");

        if (usernameInput == null || usernameInput.trim().isEmpty() ||
                passwordInput == null || passwordInput.trim().isEmpty()) {
            response.sendRedirect("login.jsp?error=empty_fields");
            return;
        }

        usernameInput = usernameInput.trim();
        passwordInput = passwordInput.trim();

        if (usernameInput.length() < 4 || usernameInput.length() > 20 || passwordInput.length() < 4) {
            response.sendRedirect("login.jsp?error=invalid_length");
            return;
        }

        if (!usernameInput.matches("^[a-zA-Z0-9_]+$")) {
            response.sendRedirect("login.jsp?error=invalid_characters");
            return;
        }

        UserDAO dao = new UserDAO();
        Map<String, String> userData = dao.authenticateUser(usernameInput, passwordInput);

        if (userData != null) {
            HttpSession session = request.getSession();
            String role = userData.get("role");

            session.setAttribute("username", usernameInput);
            session.setAttribute("fullName", userData.get("fullName"));
            session.setAttribute("role", role);

            if ("Admin".equalsIgnoreCase(role)) {
                response.sendRedirect("DashboardServlet");
            } else {
                response.sendRedirect("StaffDashboardServlet");
            }
        } else {
            response.sendRedirect("login.jsp?error=true");
        }
    }
}