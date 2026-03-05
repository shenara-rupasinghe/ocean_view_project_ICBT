<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Role-Based Access Control: Fetching user identity from session
    String role = (String) session.getAttribute("role");
    String fullName = (String) session.getAttribute("fullName");
%>
<style>
    :root {
        --gold: #c29b40; /* Premium Gold theme color */
        --dark-bg: #050505;
        --nav-glass: rgba(15, 15, 15, 0.95);
        --border-gold: rgba(194, 155, 64, 0.2);
    }

    /* Navbar 1: System Utility & Status Bar */
    .utility-bar {
        background: #000;
        padding: 10px 60px;
        display: flex;
        justify-content: space-between; /* Keeps status left and nothing on right */
        align-items: center;
        border-bottom: 1px solid var(--border-gold);
        font-size: 11px;
        color: #888;
        font-weight: 600;
        letter-spacing: 1px;
    }

    .system-status { display: flex; gap: 20px; align-items: center; }
    .status-dot { width: 8px; height: 8px; background: #10b981; border-radius: 50%; display: inline-block; margin-right: 5px; box-shadow: 0 0 10px #10b981; }

    /* Navbar 2: Primary Hotel Navigation */
    .main-nav {
        background: var(--nav-glass);
        backdrop-filter: blur(15px);
        padding: 15px 60px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        position: sticky;
        top: 0;
        z-index: 9999;
        border-bottom: 1px solid var(--border-gold);
    }

    .brand { font-size: 22px; font-weight: 800; color: white; text-decoration: none; letter-spacing: -1px; }
    .brand span { color: var(--gold); }

    .nav-links { display: flex; gap: 25px; align-items: center; }
    .nav-links a {
        color: #aaa; text-decoration: none; font-size: 13px; font-weight: 700;
        transition: 0.3s; text-transform: uppercase; letter-spacing: 0.5px;
    }
    .nav-links a:hover { color: var(--gold); }
    .nav-links a.active { color: var(--gold); border-bottom: 2px solid var(--gold); padding-bottom: 5px; }

    /* Profile Section Branding */
    .user-profile { display: flex; align-items: center; gap: 12px; padding-left: 20px; border-left: 1px solid var(--border-gold); }
    .role-badge {
        background: var(--gold); color: black; padding: 3px 10px;
        border-radius: 50px; font-size: 10px; font-weight: 900;
    }

    /* Responsive adjustments */
    @media (max-width: 1024px) {
        .utility-bar, .main-nav { padding: 10px 20px; }
        .nav-links { gap: 15px; }
        .nav-links a { font-size: 11px; }
    }
</style>

<div class="utility-bar">
    <div class="system-status">
        <span><i class="fa-solid fa-server"></i> Node: GALLE_SRV_01</span>
        <span><span class="status-dot"></span> System Production Mode</span>
        <span><i class="fa-solid fa-clock"></i> <span id="server-time"></span></span>
    </div>
    <div style="font-size: 10px; color: var(--gold);">PREMIUM MANAGEMENT SUITE</div>
</div>

<nav class="main-nav">
    <a href="DashboardServlet" class="brand">OCEAN<span>VIEW</span></a>

    <div class="nav-links">
        <a href="DashboardServlet"><i class="fa-solid fa-gauge"></i> Dashboard</a>
        <a href="ReservationServlet?action=new"><i class="fa-solid fa-calendar-plus"></i> New Booking</a>
        <a href="ReservationServlet?action=list"><i class="fa-solid fa-list-check"></i> Reservations</a>
        <a href="RoomServlet"><i class="fa-solid fa-bed"></i> Rooms</a>

        <% if("Admin".equalsIgnoreCase(role)) { %>
            <a href="ReportServlet"><i class="fa-solid fa-chart-line"></i> Money Reports</a>
            <a href="StaffServlet"><i class="fa-solid fa-users-gear"></i> Staff Control</a>
        <% } %>

        <a href="help.jsp"><i class="fa-solid fa-circle-info"></i> Help</a>

        <div class="user-profile">
            <div style="text-align: right;">
                <div style="font-size: 12px; font-weight: 700; color: white;"><%= fullName != null ? fullName : "User" %></div>
                <span class="role-badge"><%= role != null ? role : "Guest" %></span>
            </div>
            <a href="LogoutServlet" style="color: #f87171; font-size: 18px; padding-left: 10px;" title="Sign Out">
                <i class="fa-solid fa-power-off"></i>
            </a>
        </div>
    </div>
</nav>

<script>
    // Real-time server-side simulated clock
    function updateClock() {
        const now = new Date();
        const clockEl = document.getElementById('server-time');
        if(clockEl) clockEl.innerText = now.toLocaleTimeString();
    }
    setInterval(updateClock, 1000);
    updateClock();

    // Active Navigation Highlighting logic
    const currentUrl = window.location.href;
    document.querySelectorAll('.nav-links a').forEach(link => {
        const linkHref = link.getAttribute('href');
        if(currentUrl.includes(linkHref) || (currentUrl.includes("add-reservation") && linkHref.includes("action=new"))) {
            link.classList.add('active');
        }
    });
</script>