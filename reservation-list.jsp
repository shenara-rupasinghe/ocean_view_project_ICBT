<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // 🔒 Security: Check if user is logged in
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View | Guest Registry</title>

    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <style>
        :root {
            --gold: #c29b40; --bg: #050505; --card: #111;
            --border: rgba(194,155,64,0.15); --text-dim: #888;
            --glass: rgba(255, 255, 255, 0.02);
        }

        body {
            background: var(--bg); color: white; font-family: 'Plus Jakarta Sans', sans-serif;
            margin: 0; min-height: 100vh;
        }

        .main-content {
            padding: 40px; width: 95%; margin: 0 auto; box-sizing: border-box;
        }

        .header-section {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 30px; padding-bottom: 20px; border-bottom: 1px solid var(--border);
        }

        .header-section h2 { font-size: 32px; font-weight: 800; color: var(--gold); margin: 0; }

        /* Modern Search Bar */
        .search-container { position: relative; width: 400px; }
        .search-input {
            width: 100%; background: var(--card); border: 1px solid var(--border);
            border-radius: 50px; padding: 12px 20px 12px 50px; color: white; outline: none; transition: 0.3s;
        }
        .search-input:focus { border-color: var(--gold); box-shadow: 0 0 15px rgba(194,155,64,0.1); }
        .search-icon { position: absolute; left: 20px; top: 15px; color: var(--gold); }

        /* Table Styling */
        .table-wrapper {
            background: var(--card); border: 1px solid var(--border);
            border-radius: 20px; padding: 10px; overflow-x: auto;
        }

        table { width: 100%; border-collapse: separate; border-spacing: 0 5px; }
        th {
            padding: 20px 15px; text-align: left; color: var(--gold); font-size: 11px;
            text-transform: uppercase; letter-spacing: 1px; font-weight: 800; border-bottom: 1px solid var(--border);
        }
        td { padding: 15px; background: var(--glass); font-size: 13px; vertical-align: middle; }

        tr td:first-child { border-radius: 12px 0 0 12px; }
        tr td:last-child { border-radius: 0 12px 12px 0; text-align: right; }

        tr:hover td { background: rgba(194,155,64,0.05); }

        .res-id { color: var(--gold); font-family: monospace; font-size: 14px; font-weight: 800; }
        .guest-name { font-weight: 700; color: #fff; display: block; }
        .sub-text { font-size: 11px; color: var(--text-dim); }

        .room-badge {
            background: rgba(194,155,64,0.1); color: var(--gold); padding: 5px 12px;
            border-radius: 6px; font-weight: 800; border: 1px solid rgba(194,155,64,0.3);
        }

        .btn-invoice {
            background: var(--gold); color: black; padding: 10px 15px;
            text-decoration: none; border-radius: 8px; font-weight: 800; font-size: 11px;
            text-transform: uppercase; transition: 0.3s; display: inline-flex; align-items: center; gap: 5px;
        }
        .btn-invoice:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(194,155,64,0.3); }

        .empty-state { padding: 60px; text-align: center; color: var(--text-dim); }
    </style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <div class="main-content">
        <div class="header-section">
            <div>
                <h2>Guest Registry</h2>
                <p style="color: var(--text-dim); margin-top: 5px;">Comprehensive list of all resort reservations.</p>
            </div>
            <div class="search-container">
                <i class="fa-solid fa-magnifying-glass search-icon"></i>
                <input type="text" id="liveSearch" class="search-input" placeholder="Search by Guest Name, ID or NIC...">
            </div>
        </div>

        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Guest Name</th>
                        <th>NIC / Passport</th>
                        <th>Contact</th>
                        <th>Room</th>
                        <th>Stay Period</th>
                        <th>Amount</th>
                        <th style="text-align: right;">Action</th>
                    </tr>
                </thead>
                <tbody id="resTableBody">
                    <%
                        // Fetching list from Servlet
                        List<Map<String, String>> list = (List<Map<String, String>>) request.getAttribute("reservationList");
                        if(list != null && !list.isEmpty()) {
                            for(Map<String, String> res : list) {
                    %>
                    <tr>
                        <td><span class="res-id"><%= res.get("res_id") %></span></td>
                        <td><span class="guest-name"><%= res.get("guest_name") %></span></td>
                        <td><%= res.get("nic") %></td>
                        <td><%= res.get("contact") %></td>
                        <td><span class="room-badge">R-<%= res.get("room_no") %></span></td>
                        <td>
                            <div style="font-weight: 600;"><%= res.get("check_in") %></div>
                            <div class="sub-text">to <%= res.get("check_out") %></div>
                        </td>
                        <td><b style="color: white;">LKR <%= String.format("%,.2f", Double.parseDouble(res.get("grand_total"))) %></b></td>
                        <td style="text-align: right;">
                            <a href="ReservationServlet?action=checkout&resId=<%= res.get("res_id") %>" class="btn-invoice">
                                <i class="fa-solid fa-file-invoice-dollar"></i> Invoice
                            </a>
                        </td>
                    </tr>
                    <%      }
                        } else { %>
                    <tr><td colspan="8" class="empty-state">No records found. Access via ReservationServlet?action=list</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
    document.getElementById('liveSearch').addEventListener('input', function() {
        const term = this.value;
        const tbody = document.getElementById('resTableBody');

        fetch('ReservationServlet?action=ajaxSearch&term=' + encodeURIComponent(term))
            .then(response => response.json())
            .then(data => {
                tbody.innerHTML = '';
                if(data.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="8" class="empty-state">No matches found.</td></tr>';
                    return;
                }
                data.forEach(res => {
                    tbody.innerHTML += `
                        <tr>
                            <td><span class="res-id">${res.res_id}</span></td>
                            <td><span class="guest-name">${res.guest_name}</span></td>
                            <td>${res.nic}</td>
                            <td>${res.contact}</td>
                            <td><span class="room-badge">R-${res.room_no}</span></td>
                            <td>
                                <div style="font-weight: 600;">${res.check_in}</div>
                                <div class="sub-text">to ${res.check_out}</div>
                            </td>
                            <td><b style="color: white;">LKR ${parseFloat(res.grand_total).toLocaleString(undefined, {minimumFractionDigits: 2})}</b></td>
                            <td style="text-align: right;">
                                <a href="ReservationServlet?action=checkout&resId=${res.res_id}" class="btn-invoice">
                                    <i class="fa-solid fa-file-invoice-dollar"></i> Invoice
                                </a>
                            </td>
                        </tr>
                    `;
                });
            });
    });
    </script>
</body>
</html>