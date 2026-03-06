package com.oceanview.controller;

import com.oceanview.dao.DashboardDAO;
import com.oceanview.dao.ReservationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // 🔒 Security Check
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        request.setAttribute("userRole", role);

        DashboardDAO dashDao = new DashboardDAO();
        ReservationDAO resDao = new ReservationDAO();

        Map<String, Object> stats = dashDao.getComprehensiveStats();
        List<Map<String, String>> recentGuests = resDao.getRecentReservations(5);

        request.setAttribute("stats", stats);
        request.setAttribute("recentGuests", recentGuests);

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}