<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // Security Check
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Retrieve room data
    List<Map<String, String>> rooms = (List<Map<String, String>>) request.getAttribute("rooms");

    // Quick Stats
    int availableCount = 0;
    int occupiedCount = 0;
    if (rooms != null) {
        for (Map<String, String> r : rooms) {
            if ("Occupied".equals(r.get("status"))) occupiedCount++;
            else availableCount++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ocean View | Property Map</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        :root {
            --gold: #c29b40;
            --bg: #050505;
            --card: #111;
            --border: rgba(194,155,64,0.15);
            --danger: #ef4444;
            --success: #10b981;
        }

        body {
            margin: 0;
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: var(--bg);
            color: white;
            min-height: 100vh;
        }


        .map-container {
            padding: 40px;
            max-width: 1500px;
            margin: 0 auto;
        }

        /* Premium Header */
        .map-header {
            display: flex; justify-content: space-between; align-items: flex-end;
            margin-bottom: 30px; padding-bottom: 20px;
            border-bottom: 1px solid var(--border);
        }

        .summary-badges { display: flex; gap: 15px; }
        .badge {
            padding: 10px 22px; border-radius: 50px; font-size: 13px; font-weight: 700;
            border: 1px solid; display: flex; align-items: center; gap: 8px; letter-spacing: 0.5px;
        }
        .badge.all { border-color: var(--border); color: #fff; background: rgba(255,255,255,0.05); }
        .badge.avail { border-color: rgba(16, 185, 129, 0.4); color: var(--success); background: rgba(16, 185, 129, 0.1); }
        .badge.occ { border-color: rgba(239, 68, 68, 0.4); color: var(--danger); background: rgba(239, 68, 68, 0.1); }

        /* Full Width Grid System */
        .room-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
            gap: 20px;
        }

        /* Individual Room Card */
        .room-card {
            background: var(--card); border: 1px solid var(--border); border-radius: 16px;
            padding: 22px 15px; text-align: center; transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative; overflow: hidden; display: flex; flex-direction: column;
            align-items: center; justify-content: center; text-decoration: none;
        }

        .room-icon { font-size: 30px; margin-bottom: 12px; transition: 0.3s; }
        .room-no { font-size: 24px; font-weight: 800; margin: 0; color: white; letter-spacing: 1px; }
        .room-type { font-size: 11px; font-weight: 700; color: #888; text-transform: uppercase; letter-spacing: 1px; margin-top: 8px; }

        /* Hover & Status Effects */
        .status-available { border-color: rgba(194,155,64,0.3); }
        .status-available .room-icon { color: var(--gold); }
        .status-available:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(194,155,64,0.15);
            border-color: var(--gold);
            background: rgba(194,155,64,0.03);
        }
        .status-available:hover .room-icon { transform: scale(1.15); }

        /* Occupied State */
        .status-occupied { border-color: rgba(239, 68, 68, 0.15); background: rgba(239, 68, 68, 0.03); opacity: 0.5; cursor: not-allowed; }
        .status-occupied .room-icon { color: var(--danger); }
        .status-occupied .room-no { color: #555; }
        .status-occupied .room-type { color: #444; }
    </style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <div class="map-container">
        <div class="map-header">
            <div>
                <h2 style="font-size: 34px; margin: 0; font-weight: 800; color: var(--gold);">Visual Property Map</h2>
                <p style="color: #888; margin: 8px 0 0 0; font-size: 14px; letter-spacing: 0.5px;">Real-time overview of all 50 assets</p>
            </div>
            <div class="summary-badges">
                <div class="badge all"><i class="fa-solid fa-hotel"></i> Total: <%= rooms != null ? rooms.size() : 0 %></div>
                <div class="badge avail"><i class="fa-solid fa-door-open"></i> Available: <%= availableCount %></div>
                <div class="badge occ"><i class="fa-solid fa-lock"></i> Occupied: <%= occupiedCount %></div>
            </div>
        </div>

        <div class="room-grid">
            <%
                if (rooms != null && !rooms.isEmpty()) {
                    for (Map<String, String> r : rooms) {
                        boolean isAvailable = "Available".equals(r.get("status"));
                        String statusClass = isAvailable ? "status-available" : "status-occupied";
                        String link = isAvailable ? "ReservationServlet?action=new&roomNo=" + r.get("id") : "javascript:void(0);";
            %>
                <a href="<%= link %>" class="room-card <%= statusClass %>" title="<%= isAvailable ? "Click to Book Room " + r.get("id") : "Room " + r.get("id") + " is Occupied" %>">
                    <i class="fa-solid fa-bed room-icon"></i>
                    <h3 class="room-no"><%= r.get("id") %></h3>
                    <div class="room-type"><%= r.get("type") %></div>
                </a>
            <%
                    }
                } else {
            %>
                <div style="grid-column: 1 / -1; text-align: center; color: #888; padding: 100px 0;">
                    <i class="fa-solid fa-database" style="font-size: 50px; margin-bottom: 20px; color: var(--gold); opacity: 0.5;"></i>
                    <h3 style="color: white; margin-bottom: 10px;">No Inventory Data Found</h3>
                    <p style="font-size: 14px;">Please run the database setup scripts to populate rooms.</p>
                </div>
            <% } %>
        </div>
    </div>

</body>
</html>