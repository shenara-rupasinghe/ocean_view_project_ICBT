<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String userRole = (String) session.getAttribute("role");
    Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
    List<Map<String, String>> recentGuests = (List<Map<String, String>>) request.getAttribute("recentGuests");

    if (stats == null) {
        stats = new HashMap<>();
        stats.put("occupied", 0); stats.put("available", 0);
        stats.put("arrivals", 0); stats.put("revenue", 0.0);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ocean View | Hotel Management Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        :root { --gold: #c29b40; --bg-dark: #050505; --card-bg: #111111; --border: rgba(194, 155, 64, 0.1); --text-dim: #888888; }
        body { margin: 0; font-family: 'Plus Jakarta Sans', sans-serif; background: var(--bg-dark); color: white; min-height: 100vh; }
        .dashboard-container { padding: 40px 60px; max-width: 1600px; margin: 0 auto; }
        .page-header { margin-bottom: 40px; display: flex; justify-content: space-between; align-items: flex-end; }
        .page-header h2 { font-size: 32px; font-weight: 800; margin: 0; letter-spacing: -1px; }
        .page-header p { color: var(--text-dim); margin: 5px 0 0 0; font-size: 14px; }
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 40px; }
        .stat-card { background: var(--card-bg); border: 1px solid var(--border); padding: 30px; border-radius: 24px; transition: 0.3s; }
        .stat-card:hover { border-color: var(--gold); transform: translateY(-5px); }
        .stat-card span { font-size: 11px; text-transform: uppercase; letter-spacing: 2px; color: var(--text-dim); font-weight: 700; }
        .stat-card h3 { font-size: 32px; margin: 15px 0 0 0; font-weight: 800; }
        .stat-card.revenue h3 { color: #10b981; }
        .content-layout { display: grid; grid-template-columns: 1.8fr 1.2fr; gap: 30px; }
        .panel { background: var(--card-bg); border: 1px solid var(--border); border-radius: 30px; padding: 35px; }
        .panel-title { font-size: 18px; font-weight: 700; margin-bottom: 25px; display: flex; align-items: center; gap: 10px; }
        .panel-title i { color: var(--gold); }
        .modern-table { width: 100%; border-collapse: collapse; }
        .modern-table th { text-align: left; color: var(--text-dim); font-size: 11px; text-transform: uppercase; padding-bottom: 20px; letter-spacing: 1px; }
        .modern-table td { padding: 20px 0; border-top: 1px solid rgba(255,255,255,0.05); font-size: 14px; }
        .res-id { color: var(--gold); font-weight: 800; }
        .status-badge { background: rgba(16, 185, 129, 0.1); color: #10b981; padding: 4px 12px; border-radius: 50px; font-size: 10px; font-weight: 800; }
    </style>
</head>
<body>

    <jsp:include page="navbar.jsp" /> <div class="dashboard-container">
        <header class="page-header">
            <div>
                <h2>Hotel Management Dashboard</h2> <p>Welcome to Ocean View Resort management system.</p>
            </div>
            <div style="text-align: right;">
                <span style="font-size: 12px; color: var(--text-dim);">SYSTEM TIME</span>
                <div style="font-weight: 800; color: var(--gold);" id="sync-time"></div>
            </div>
        </header>

        <div class="stats-grid">
            <div class="stat-card revenue">
                <span>Total Revenue</span> <h3>LKR <%= String.format("%,.0f", stats.get("revenue")) %></h3>
            </div>
            <div class="stat-card">
                <span>Today's Arrivals</span>
                <h3><%= stats.get("arrivals") %> Guests</h3>
            </div>
            <div class="stat-card">
                <span>Available Rooms</span> <h3><%= stats.get("available") %> Units</h3>
            </div>
            <div class="stat-card">
                <span>Occupied Rooms</span> <h3><%= stats.get("occupied") %> / 30</h3>
            </div>
        </div>

        <div class="content-layout">
            <div class="panel">
                <div class="panel-title"><i class="fa-solid fa-clock-rotate-left"></i> Recent Bookings</div> <table class="modern-table">
                    <thead>
                        <tr>
                            <th>Booking ID</th> <th>Guest Name</th> <th>Room Type</th> <th>Status</th> </tr>
                    </thead>
                    <tbody>
                        <% if (recentGuests != null && !recentGuests.isEmpty()) {
                            for (Map<String, String> guest : recentGuests) { %>
                            <tr>
                                <td class="res-id"><%= guest.get("res_id") %></td>
                                <td style="font-weight: 600;"><%= guest.get("guest_name") %></td>
                                <td><%= guest.get("room_type") %></td>
                                <td><span class="status-badge">Active</span></td> </tr>
                        <% } } else { %>
                            <tr><td colspan="4" style="text-align: center; color: var(--text-dim);">No recent bookings found.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <div class="panel" style="display: flex; flex-direction: column; align-items: center; justify-content: center;">
                <div class="panel-title" style="align-self: flex-start;"><i class="fa-solid fa-chart-pie"></i> Room Availability</div> <div style="width: 100%; height: 300px; position: relative;">
                    <canvas id="occupancyDoughnut"></canvas>
                </div>
                <p style="font-size: 12px; color: var(--text-dim); margin-top: 20px; text-align: center;">
                    Live updates from the hotel database.
                </p>
            </div>
        </div>
    </div>



    <script>
        document.getElementById('sync-time').innerText = new Date().toLocaleTimeString();

        const ctx = document.getElementById('occupancyDoughnut').getContext('2d');
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Occupied', 'Available'],
                datasets: [{
                    data: [<%= stats.get("occupied") %>, <%= stats.get("available") %>],
                    backgroundColor: ['#c29b40', 'rgba(194,155,64,0.05)'],
                    borderColor: 'rgba(194,155,64,0.2)',
                    borderWidth: 1,
                    hoverOffset: 10
                }]
            },
            options: {
                cutout: '80%',
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: { color: '#888', font: { family: 'Plus Jakarta Sans', size: 12 }, padding: 20 }
                    }
                },
                maintainAspectRatio: false
            }
        });
    </script>
</body>
</html>