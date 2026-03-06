package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/StaffDashboardServlet")
public class StaffDashboardServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(StaffDashboardServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // 🔒 Security Check
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            ReservationDAO dao = new ReservationDAO();
            Map<String, Object> stats = dao.getDashboardStats();
            List<Map<String, String>> recentGuests = dao.getRecentReservations(5);

            request.setAttribute("stats", stats);
            request.setAttribute("recentGuests", recentGuests);
            request.setAttribute("userRole", session.getAttribute("role")); // Pass role to JSP

            // Forwarding to the same dashboard.jsp but with staff privileges
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading staff dashboard", e);
            response.sendRedirect("login.jsp?error=dashboard_failed");
        }
    }
}