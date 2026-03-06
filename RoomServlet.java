package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;
//updated
@WebServlet("/RoomServlet")
public class RoomServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {

            ReservationDAO dao = new ReservationDAO();
            List<Map<String, String>> roomList = dao.getAllRooms();


            request.setAttribute("rooms", roomList);
            request.getRequestDispatcher("room-map.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=loading_map");
        }
    }
}