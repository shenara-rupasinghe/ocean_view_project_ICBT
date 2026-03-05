<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ocean View | User Details</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #22d3ee;
            --bg: #0f172a;
            --card: #1e293b;
            --text-main: #f1f5f9;
            --text-dim: #94a3b8;
            --accent: #38bdf8;
        }

        body {
            background: var(--bg);
            color: var(--text-main);
            font-family: 'Segoe UI', system-ui, sans-serif;
            margin: 0;
            display: flex;
        }

        .main-content {
            margin-left: 280px;
            padding: 50px;
            width: 100%;
            display: flex;
            justify-content: center;
            align-items: flex-start;
        }

        .details-container {
            background: var(--card);
            width: 100%;
            max-width: 800px;
            padding: 40px;
            border-radius: 24px;
            border: 1px solid rgba(255, 255, 255, 0.05);
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
        }

        .profile-header {
            display: flex;
            align-items: center;
            gap: 25px;
            margin-bottom: 40px;
            padding-bottom: 25px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .avatar {
            width: 120px;
            height: 120px;
            background: linear-gradient(135deg, var(--primary), #06b6d4);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 50px;
            color: #0f172a;
            font-weight: bold;
            box-shadow: 0 10px 20px rgba(34, 211, 238, 0.2);
        }

        .header-info h2 { margin: 0; font-size: 28px; color: var(--primary); }
        .header-info p { margin: 5px 0 0; color: var(--text-dim); }

        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .info-item {
            background: rgba(15, 23, 42, 0.5);
            padding: 20px;
            border-radius: 16px;
            border: 1px solid rgba(255, 255, 255, 0.03);
        }

        .info-label {
            display: block;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--accent);
            margin-bottom: 8px;
            font-weight: bold;
        }

        .info-value {
            font-size: 16px;
            color: var(--text-main);
        }

        .system-badge {
            margin-top: 30px;
            padding: 15px;
            background: rgba(34, 211, 238, 0.05);
            border-radius: 12px;
            display: flex;
            align-items: center;
            gap: 15px;
            color: var(--text-dim);
            font-size: 14px;
        }
    </style>
</head>
<body>

    <jsp:include page="slidebar.jsp" />

    <div class="main-content">
        <div class="details-container">
            <div class="profile-header">
                <div class="avatar">
                    <%-- නමේ මුල් අකුර පෙන්වීමට --%>
                    <%= (session.getAttribute("user") != null) ? session.getAttribute("user").toString().substring(0,1).toUpperCase() : "U" %>
                </div>
                <div class="header-info">
                    <h2>Account Overview</h2>
                    <p>Welcome back, <%= session.getAttribute("user") %>! Here are your profile details.</p>
                </div>
            </div>

            <div class="info-grid">
                <div class="info-item">
                    <span class="info-label">Full Name</span>
                    <span class="info-value"><%= session.getAttribute("user") %></span>
                </div>
                <div class="info-item">
                    <span class="info-label">User Role</span>
                    <span class="info-value"><%= session.getAttribute("role") %></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Username</span>
                    <span class="info-value">@<%= session.getAttribute("username") %></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Account Status</span>
                    <span class="info-value" style="color: #10b981;"><i class="fa-solid fa-circle-check"></i> Active Member</span>
                </div>
                <div class="info-item" style="grid-column: span 2;">
                    <span class="info-label">Access Level</span>
                    <span class="info-value">
                        <% if ("Admin".equals(session.getAttribute("role"))) { %>
                            Full System Administration Access
                        <% } else { %>
                            Standard Guest & Reservation Management Access
                        <% } %>
                    </span>
                </div>
            </div>

            <div class="system-badge">
                <i class="fa-solid fa-shield-halved" style="font-size: 24px; color: var(--primary);"></i>
                <span>This profile is managed by <b>Ocean View Resort</b> IT policies. Personal details are securely stored in the system database.</span>
            </div>
        </div>
    </div>

</body>
</html>