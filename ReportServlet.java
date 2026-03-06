package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO; // එරර් එක ආවේ මේක නැති නිසයි
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/ReportServlet")
public class ReportServlet extends HttpServlet {


    private static final Logger LOGGER = Logger.getLogger(ReportServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            ReservationDAO dao = new ReservationDAO();


            Map<String, Object> stats = dao.getDashboardStats();
            Map<String, Double> revenueMap = dao.getMonthlyRevenue();


            request.setAttribute("stats", stats);
            request.setAttribute("revenueMap", revenueMap);


            request.getRequestDispatcher("reports.jsp").forward(request, response);

        } catch (Exception e) {

            LOGGER.log(Level.SEVERE, "Error generating financial reports", e);
            response.sendRedirect("DashboardServlet?error=report_generation_failed");
        }
    }
}