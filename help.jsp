<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Security: Session Validation Check
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
    <title>Ocean View | System Documentation</title>

    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <style>
        :root {
            --gold: #c29b40;
            --bg: #050505;
            --card: #111;
            --border: rgba(194,155,64,0.15);
            --text-dim: #888;
            --glass: rgba(255, 255, 255, 0.02);
            --danger: #ef4444;
            --success: #10b981;
            --warning: #f59e0b;
        }

        body {
            background: var(--bg); color: white; font-family: 'Plus Jakarta Sans', sans-serif;
            margin: 0; min-height: 100vh; overflow-x: hidden; line-height: 1.6;
        }

        /* Top Navbar Layout Fix (No Left Margin, No Flex on Body) */
        .main-content {
            padding: 40px; max-width: 1400px; margin: 0 auto; box-sizing: border-box;
        }

        /* Premium Hero Banner */
        .hero-banner {
            background: linear-gradient(135deg, rgba(17,17,17,0.8) 0%, rgba(5,5,5,1) 100%);
            padding: 50px; border-radius: 20px; border: 1px solid var(--border);
            border-left: 6px solid var(--gold); margin-bottom: 40px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.5); position: relative; overflow: hidden;
        }
        .hero-banner::after {
            content: '\f02d'; font-family: 'Font Awesome 6 Free'; font-weight: 900;
            position: absolute; right: 30px; top: 20px; font-size: 150px; color: rgba(194,155,64,0.03);
            pointer-events: none;
        }
        .hero-banner h1 { margin: 0; font-size: 38px; color: var(--gold); font-weight: 800; letter-spacing: 1px; }
        .hero-banner p { color: var(--text-dim); font-size: 16px; margin-top: 15px; max-width: 800px; font-weight: 400; }

        /* Document Sections */
        .doc-section {
            background: var(--card); padding: 40px; border-radius: 20px; margin-bottom: 35px;
            border: 1px solid var(--border); box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        .doc-section h2 {
            color: white; border-bottom: 1px solid var(--border); padding-bottom: 20px; margin-top: 0;
            display: flex; align-items: center; gap: 15px; font-size: 26px; font-weight: 800;
        }
        .doc-section h2 i { color: var(--gold); }
        .doc-section > p { color: var(--text-dim); font-size: 15px; margin-bottom: 30px; }

        /* Badges */
        .role-badge {
            font-size: 11px; padding: 6px 16px; border-radius: 50px; text-transform: uppercase;
            font-weight: 800; letter-spacing: 1.5px; margin-left: auto;
        }
        .admin-badge { background: rgba(239, 68, 68, 0.1); color: var(--danger); border: 1px solid rgba(239, 68, 68, 0.3); }
        .staff-badge { background: rgba(194,155,64,0.1); color: var(--gold); border: 1px solid rgba(194,155,64,0.3); }

        /* Instruction Grid & Cards */
        .instruction-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 25px;
        }
        .instruction-item {
            background: var(--glass); padding: 30px; border-radius: 16px;
            border: 1px solid rgba(255,255,255,0.03); border-top: 4px solid var(--gold);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .instruction-item:hover {
            transform: translateY(-5px); background: rgba(194,155,64,0.05); border-color: var(--border);
            box-shadow: 0 15px 30px rgba(0,0,0,0.4);
        }
        .instruction-item h4 { color: white; margin: 15px 0 10px 0; font-size: 18px; font-weight: 700; }
        .instruction-item p { color: var(--text-dim); font-size: 14px; margin: 0; line-height: 1.8; }

        .step-tag {
            display: inline-block; background: var(--gold); color: black; padding: 4px 12px;
            border-radius: 6px; font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 1px;
        }

        /* Technical Summary & Alerts */
        .summary-box {
            margin-top: 30px; padding: 30px; background: rgba(255,255,255,0.02);
            border-radius: 16px; border-left: 4px solid #fff; color: #ccc; font-size: 15px;
        }
        .summary-box b { color: var(--gold); }
        .summary-box ul { margin: 15px 0 0 0; padding-left: 20px; }
        .summary-box li { margin-bottom: 8px; color: var(--text-dim); }

        .important-note {
            background: rgba(239, 68, 68, 0.05); color: #fff; padding: 25px 30px;
            border-radius: 16px; border: 1px dashed rgba(239, 68, 68, 0.4); margin-top: 40px;
            display: flex; align-items: flex-start; gap: 20px;
        }
        .important-note i { color: var(--danger); font-size: 28px; margin-top: 5px; }
        .important-note strong { color: var(--danger); display: block; margin-bottom: 5px; font-size: 16px; text-transform: uppercase; letter-spacing: 1px; }

        /* Responsive Design */
        @media (max-width: 768px) {
            .main-content { padding: 20px; }
            .hero-banner { padding: 30px; }
            .hero-banner h1 { font-size: 28px; }
            .doc-section { padding: 25px; }
            .doc-section h2 { flex-direction: column; align-items: flex-start; gap: 10px; font-size: 22px; }
            .role-badge { margin-left: 0; }
            .important-note { flex-direction: column; gap: 15px; }
        }
    </style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <div class="main-content">
        <div class="hero-banner">
            <h1><i class="fa-solid fa-book-bookmark" style="margin-right: 15px;"></i>System Help & Documentation</h1>
            <p>Comprehensive operational manual for the Ocean View Resort Management System. This guide provides step-by-step instructions for all user roles defined in the system requirements.</p>
        </div>

        <div class="doc-section">
            <h2><i class="fa-solid fa-user-gear"></i> Administrative Operations <span class="role-badge admin-badge">Admin Access</span></h2>
            <p>Administrators have full authority over the system backend, user management, and financial oversight.</p>

            <div class="instruction-grid">
                <div class="instruction-item">
                    <span class="step-tag">Phase 01</span>
                    <h4>User Management</h4>
                    <p>Register new staff members, assign roles (Admin/Staff), and manage secure login credentials within the 'Staff Control' panel.</p>
                </div>
                <div class="instruction-item">
                    <span class="step-tag">Phase 02</span>
                    <h4>Financial Oversight</h4>
                    <p>Monitor real-time revenue stats. The system aggregates 'Grand Total' values from all completed reservations to provide dynamic income insights.</p>
                </div>
                <div class="instruction-item">
                    <span class="step-tag">Phase 03</span>
                    <h4>Database Integrity</h4>
                    <p>The system utilizes a <b>Singleton Design Pattern</b> for database connections, ensuring high performance and data consistency across all endpoints.</p>
                </div>
            </div>
        </div>

        <div class="doc-section">
            <h2><i class="fa-solid fa-bell-concierge"></i> Staff Operations <span class="role-badge staff-badge">Staff Access</span></h2>
            <p>Staff members are responsible for the daily workflow, guest management, and the complete billing cycle.</p>

            <div class="instruction-grid">
                <div class="instruction-item">
                    <span class="step-tag">Task A</span>
                    <h4>Guest Registration</h4>
                    <p>Navigate to 'New Booking'. Collect Guest Name, NIC, Contact, and Stay Dates. Ensure a unique Reservation ID is systematically assigned.</p>
                </div>
                <div class="instruction-item">
                    <span class="step-tag">Task B</span>
                    <h4>Room Allocation</h4>
                    <p>Select available rooms from the Visual Property Map. The system automatically updates room status to 'Occupied' upon successful booking processing.</p>
                </div>
                <div class="instruction-item">
                    <span class="step-tag">Task C</span>
                    <h4>Billing & Checkout</h4>
                    <p>Locate the guest in the 'Reservations' table. Click 'Print Invoice'. The system automatically calculates taxes and prints a professional receipt.</p>
                </div>
            </div>
        </div>

        <div class="doc-section">
            <h2><i class="fa-solid fa-microchip"></i> System Technical Overview</h2>



            <div class="summary-box">
                <p>This enterprise reservation system is built using the <b>Java EE (Jakarta EE)</b> framework. It strictly adheres to the <b>Model-View-Controller (MVC)</b> architecture to seamlessly separate data handling (DAO), business logic (Servlets), and presentation (JSPs).</p>
                <p style="margin-top: 15px; color: white; font-weight: 600;">Key Enterprise & Security Features:</p>
                <ul>
                    <li><b>Role-Based Access Control (RBAC):</b> Strict route protection distinguishing Admin vs. Staff endpoints.</li>
                    <li><b>Session Management:</b> Secure HTTP Sessions handling state across the application.</li>
                    <li><b>ACID Transactions:</b> Rollback mechanisms in SQL to prevent partial bookings.</li>
                    <li><b>Dynamic UI Rendering:</b> Real-time visual map and dashboard metrics updating via backend data.</li>
                </ul>
            </div>
        </div>

        <div class="important-note">
            <i class="fa-solid fa-shield-halved"></i>
            <div>
                <strong>Strict Security Compliance</strong>
                <span style="color: #fca5a5; font-size: 14px; line-height: 1.6;">Always ensure you use the <b>System Power / Logout</b> button located on the top navigation bar before closing your browser. This safely invalidates the active session and prevents unauthorized data breaches of guest records.</span>
            </div>
        </div>

    </div>

</body>
</html>