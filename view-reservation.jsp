<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View | Guest Search & Edit</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <style>
        :root {
            --primary: #38bdf8; --bg-dark: #020617; --glass: rgba(255, 255, 255, 0.03);
            --glass-border: rgba(255, 255, 255, 0.1); --text-dim: #94a3b8;
            --danger: #fb7185; --success: #10b981;
        }

        body {
            margin: 0; font-family: 'Plus Jakarta Sans', sans-serif; background: var(--bg-dark);
            background-image: radial-gradient(at 0% 0%, hsla(217,100%,15%,1) 0, transparent 50%),
                              radial-gradient(at 100% 100%, hsla(190,100%,10%,1) 0, transparent 50%);
            color: white; display: flex; min-height: 100vh;
        }

        .main-content { margin-left: 280px; padding: 60px; width: calc(100% - 280px); display: flex; flex-direction: column; align-items: center; }

        .search-container { width: 100%; max-width: 600px; margin-bottom: 40px; position: relative; }
        .search-box { display: flex; gap: 10px; background: var(--glass); padding: 10px; border-radius: 20px; border: 1px solid var(--glass-border); }
        .search-box input { flex: 1; background: transparent; border: none; color: white; padding: 15px; font-size: 16px; outline: none; }
        .btn-search { background: var(--primary); border: none; border-radius: 15px; padding: 0 25px; cursor: pointer; font-weight: 800; color: #000; }

        .detail-card {
            width: 100%; max-width: 750px; background: var(--glass); border: 1px solid var(--glass-border);
            border-radius: 35px; padding: 45px; backdrop-filter: blur(20px); box-shadow: 0 25px 50px rgba(0,0,0,0.5);
        }

        .detail-row { display: flex; justify-content: space-between; align-items: center; padding: 18px 0; border-bottom: 1px solid var(--glass-border); }
        .detail-row span { color: var(--text-dim); font-size: 13px; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; }

        .edit-input {
            background: rgba(255,255,255,0.05); border: 1px solid var(--glass-border);
            color: white; padding: 10px 15px; border-radius: 10px; font-family: inherit;
            width: 60%; font-size: 15px; transition: 0.3s;
        }
        .edit-input:focus { border-color: var(--primary); outline: none; background: rgba(56, 189, 248, 0.05); }

        .btn-update {
            background: var(--primary); color: #000; border: none; padding: 15px 35px;
            border-radius: 15px; font-weight: 800; cursor: pointer; margin-top: 30px;
            transition: 0.3s; width: 100%; font-size: 16px;
        }
        .btn-update:hover { transform: translateY(-3px); box-shadow: 0 10px 25px rgba(56, 189, 248, 0.4); }

        .status-msg { padding: 15px; border-radius: 10px; margin-bottom: 20px; font-weight: 600; font-size: 14px; }
        .success { background: rgba(16, 185, 129, 0.1); color: var(--success); border: 1px solid var(--success); }
        .error { background: rgba(251, 113, 133, 0.1); color: var(--danger); border: 1px solid var(--danger); }
    </style>
</head>
<body>

    <%@ include file="slidebar.jsp" %>

    <main class="main-content">
        <h1 style="font-weight: 800; font-size: 40px; margin: 0 0 10px 0;">Find & Modify</h1>
        <p style="color: var(--text-dim); margin-bottom: 40px;">Search by **Guest Name, ID, or Email** to update information.</p>

        <%-- Alerts --%>
        <% if("updated".equals(request.getParameter("status"))) { %>
            <div class="status-msg success"><i class="fa-solid fa-circle-check"></i> Reservation updated successfully!</div>
        <% } %>
        <% if(request.getParameter("error") != null) { %>
            <div class="status-msg error"><i class="fa-solid fa-circle-xmark"></i> Update failed. Please try again.</div>
        <% } %>

        <div class="search-container">
            <form action="ReservationServlet" method="get" class="search-box">
                <input type="hidden" name="action" value="search">


                <input type="text" name="searchTerm" id="searchInput" list="guestList"
                       placeholder="Start typing Name or ID..."
                       value="<%= request.getParameter("searchTerm") != null ? request.getParameter("searchTerm") : "" %>" required>

                <%-- Dynamic Datalist for Suggestions --%>
                <datalist id="guestList">
                    <%

                        List<Map<String, String>> suggestions = (List<Map<String, String>>) request.getAttribute("reservationList");
                        if(suggestions != null) {
                            for(Map<String, String> s : suggestions) {
                    %>
                        <option value="<%= s.get("res_id") %>"><%= s.get("guest_name") %></option>
                    <%      }
                        } %>
                </datalist>

                <button type="submit" class="btn-search"><i class="fa-solid fa-search"></i></button>
            </form>
        </div>

        <%-- Search Result and Update Form --%>
        <%
            Map<String, String> res = (Map<String, String>) request.getAttribute("searchResult");
            if(res != null && !res.isEmpty()) {
        %>
            <div class="detail-card">
                <form action="ReservationServlet" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="resId" value="<%= res.get("res_id") %>">

                    <h3 style="color: var(--primary); margin: 0 0 25px 0;"><i class="fa-solid fa-user-pen"></i> Update Guest Details</h3>

                    <div class="detail-row">
                        <span>Reservation ID</span>
                        <b style="color: var(--primary);"><%= res.get("res_id") %></b>
                    </div>

                    <div class="detail-row">
                        <span>Guest Full Name</span>
                        <input type="text" name="guestName" value="<%= res.get("guest_name") %>" class="edit-input" required>
                    </div>

                    <div class="detail-row" style="display: none;"> <%-- Hidden Field for NIC as it's often not updated --%>
                        <input type="hidden" name="nic" value="<%= res.get("nic_passport") %>">
                    </div>

                    <div class="detail-row">
                        <span>Email Address</span>
                        <input type="email" name="email" value="<%= res.get("email") %>" class="edit-input" required>
                    </div>

                    <div class="detail-row">
                        <span>Contact Number</span>
                        <input type="text" name="contact" value="<%= res.get("contact") %>" class="edit-input" required>
                    </div>

                    <div class="detail-row">
                        <span>Assigned Room</span>
                        <b>Room <%= res.get("room_no") %> (<%= res.get("room_type") %>)</b>
                    </div>

                    <div class="detail-row">
                        <span>Check-In Date</span>
                        <input type="date" name="checkIn" value="<%= res.get("check_in") %>" class="edit-input" required>
                    </div>

                    <div class="detail-row">
                        <span>Check-Out Date</span>
                        <input type="date" name="checkOut" value="<%= res.get("check_out") %>" class="edit-input" required>
                    </div>

                    <button type="submit" class="btn-update">Save & Update Reservation</button>
                </form>
            </div>
        <% } else if (request.getParameter("searchTerm") != null) { %>
            <div class="status-msg error" style="max-width: 600px; width: 100%; text-align: center;">
                No matching records found for "<%= request.getParameter("searchTerm") %>".
            </div>
        <% } %>
    </main>

</body>
</html>