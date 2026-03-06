package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

@WebServlet("/ReservationServlet")
public class ReservationServlet extends HttpServlet {

    private final ReservationDAO dao = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 🔒 Security: Session Validation
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        // 🔍 1. AJAX Live Search Logic (JSON Response)
        if ("ajaxSearch".equals(action)) {
            String term = request.getParameter("term");
            List<Map<String, String>> results = dao.searchReservationsList(term);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < results.size(); i++) {
                Map<String, String> r = results.get(i);
                json.append("{")
                        .append("\"res_id\":\"").append(r.get("res_id")).append("\",")
                        .append("\"guest_name\":\"").append(r.get("guest_name")).append("\",")
                        .append("\"nic\":\"").append(r.get("nic")).append("\",")
                        .append("\"contact\":\"").append(r.get("contact")).append("\",")
                        .append("\"room_no\":\"").append(r.get("room_no")).append("\",")
                        .append("\"room_type\":\"").append(r.get("room_type")).append("\",")
                        .append("\"check_in\":\"").append(r.get("check_in")).append("\",")
                        .append("\"check_out\":\"").append(r.get("check_out")).append("\",")
                        .append("\"grand_total\":\"").append(r.get("grand_total")).append("\"")
                        .append("}");
                if (i < results.size() - 1) json.append(",");
            }
            json.append("]");
            out.print(json.toString());
            out.flush();
            return;
        }

        // 📋 2. View All Guests List
        if ("list".equals(action)) {
            List<Map<String, String>> list = dao.getAllReservations();
            request.setAttribute("reservationList", list);
            request.getRequestDispatcher("reservation-list.jsp").forward(request, response);
        }

        // 🆕 3. New Reservation Page (Loads available rooms)
        else if ("new".equals(action)) {
            try {
                List<Map<String, String>> rooms = dao.getAllRooms();
                request.setAttribute("allRooms", rooms);
                request.getRequestDispatcher("add-reservation.jsp").forward(request, response);
            } catch (Exception e) {
                response.sendRedirect("DashboardServlet?error=loading_failed");
            }
        }

        // 🗺️ 4. Room Map Integration
        else if ("map".equals(action)) {
            try {
                List<Map<String, String>> rooms = dao.getAllRooms();
                request.setAttribute("rooms", rooms);
                request.getRequestDispatcher("room-map.jsp").forward(request, response);
            } catch (Exception e) {
                response.sendRedirect("DashboardServlet?error=map_failed");
            }
        }

        // 💰 5. Invoice Generation (Billing)
        else if ("checkout".equals(action)) {
            String resId = request.getParameter("resId");
            Map<String, Object> billData = dao.getBillingDetails(resId);
            request.setAttribute("billData", billData);
            request.getRequestDispatcher("billing-invoice.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        // 📥 Add New Reservation Logic
        if ("add".equals(action)) {
            try {

                String resId = "BK-" + (System.currentTimeMillis() % 100000);
                String name = request.getParameter("guestName");
                String nic = request.getParameter("nic");
                String contact = request.getParameter("contact");
                String address = request.getParameter("address");

                // 2. Room No සහ Grand Total Parse කිරීම (Error handling එක්ක)
                String roomNoStr = request.getParameter("roomNo");
                int roomNo = (roomNoStr != null && !roomNoStr.isEmpty()) ? Integer.parseInt(roomNoStr) : 0;

                String roomType = request.getParameter("roomType");
                String checkIn = request.getParameter("checkIn");
                String checkOut = request.getParameter("checkOut");

                String grandTotalStr = request.getParameter("grandTotal");
                double grandTotal = (grandTotalStr != null && !grandTotalStr.isEmpty()) ? Double.parseDouble(grandTotalStr) : 0.0;

                String paymentMethod = request.getParameter("paymentMethod");


                boolean success = dao.addReservation(resId, name, nic, contact, address, roomNo, roomType, checkIn, checkOut, grandTotal, paymentMethod);

                if (success) {

                    response.sendRedirect("ReservationServlet?action=list&status=added");
                } else {

                    response.sendRedirect("ReservationServlet?action=new&error=db_error");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("ReservationServlet?action=new&error=invalid_data");
            }
        }
    }
}