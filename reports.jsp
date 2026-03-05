<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // State Management: Security Check
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Only Admin can access financial reports (Role-based access)
    if (!"Admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("DashboardServlet");
        return;
    }

    // Retrieve Data from Servlet
    Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
    Map<String, Double> revData = (Map<String, Double>) request.getAttribute("revenueMap");

    // Null-safe data extraction
    double revenue = (stats != null && stats.get("revenue") != null) ? ((Number) stats.get("revenue")).doubleValue() : 0.0;
    int occupied = (stats != null && stats.get("occupied") != null) ? ((Number) stats.get("occupied")).intValue() : 0;
    int arrivals = (stats != null && stats.get("arrivals") != null) ? ((Number) stats.get("arrivals")).intValue() : 0;

    // Total rooms logic (Assume 50 total as per assignment)
    int available = 50 - occupied;
    double occupancyRate = (occupied / 50.0) * 100;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ocean View | Executive Analytics</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
            --text-muted: #888;
        }

        body {
            margin: 0; font-family: 'Plus Jakarta Sans', sans-serif; background: var(--bg); color: white; min-height: 100vh; overflow-x: hidden;
        }

        /* Layout Structure */
        .main-content {
            padding: 40px; margin-left: 280px; width: calc(100% - 360px);
        }

        /* Header Section */
        .report-header {
            display: flex; justify-content: space-between; align-items: flex-end;
            margin-bottom: 30px; padding-bottom: 20px; border-bottom: 1px solid var(--border);
        }

        .btn-print {
            background: rgba(194,155,64,0.1); border: 1px solid var(--gold); color: var(--gold);
            padding: 12px 24px; border-radius: 12px; font-weight: 700; cursor: pointer; transition: 0.3s;
            display: flex; align-items: center; gap: 8px; letter-spacing: 1px; text-transform: uppercase; font-size: 12px;
        }
        .btn-print:hover { background: var(--gold); color: #000; box-shadow: 0 10px 20px rgba(194,155,64,0.2); }

        /* Key Metrics Grid */
        .kpi-grid {
            display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 30px;
        }
        .kpi-card {
            background: var(--card); padding: 25px; border-radius: 20px; border: 1px solid var(--border);
            position: relative; overflow: hidden;
        }
        .kpi-card::before {
            content: ''; position: absolute; top: 0; left: 0; width: 4px; height: 100%; background: var(--gold);
        }
        .kpi-title { font-size: 11px; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: 1.5px; margin-bottom: 10px; display: block; }
        .kpi-value { font-size: 32px; font-weight: 800; margin: 0; color: white; }
        .kpi-trend { font-size: 12px; font-weight: 600; color: var(--success); display: flex; align-items: center; gap: 5px; margin-top: 10px; }

        /* Main Analytics Section */
        .analytics-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 25px; }

        .chart-container {
            background: var(--card); padding: 30px; border-radius: 20px; border: 1px solid var(--border);
        }

        /* Professional Calculator UI */
        .calc-container {
            background: var(--card); padding: 25px; border-radius: 20px; border: 1px solid var(--gold);
            height: fit-content; box-shadow: 0 10px 30px rgba(0,0,0,0.5);
        }
        .calc-screen {
            width: 100%; background: rgba(0,0,0,0.5); border: 1px solid var(--border);
            padding: 20px; color: var(--gold); text-align: right; font-size: 28px; font-weight: 800;
            border-radius: 12px; margin-bottom: 20px; box-sizing: border-box; font-family: monospace; outline: none;
        }
        .calc-btns { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; }
        .calc-btns button {
            padding: 15px; border: 1px solid rgba(255,255,255,0.05); border-radius: 10px;
            background: rgba(255,255,255,0.02); color: white; cursor: pointer; transition: 0.2s;
            font-size: 16px; font-weight: 600; font-family: 'Plus Jakarta Sans';
        }
        .calc-btns button:hover { background: rgba(194,155,64,0.1); border-color: var(--gold); color: var(--gold); }
        .calc-btns .op-btn { color: var(--gold); background: rgba(194,155,64,0.05); }
        .calc-btns .eq-btn { background: var(--gold); color: #000; font-weight: 800; border: none; }
        .calc-btns .eq-btn:hover { background: #d4af37; color: #000; transform: scale(1.05); }

        /* Print Media Styles */
        @media print {
            .sidebar, .btn-print, .calc-container, nav { display: none !important; }
            .main-content { margin-left: 0; width: 100%; padding: 0; }
            body { background: white; color: black; }
            .kpi-card, .chart-container { border: 1px solid #ccc; background: white; color: black; break-inside: avoid; }
            .kpi-value, .report-header h2 { color: black !important; }
            canvas { filter: invert(1); } /* Basic print fix for dark charts */
        }
    </style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <div class="main-content">
        <div class="report-header">
            <div>
                <h2 style="margin:0; font-weight:800; color:var(--gold); font-size: 34px;">Executive Analytics</h2>
                <p style="color: var(--text-muted); margin: 8px 0 0 0; font-size: 14px; letter-spacing: 0.5px;">Real-time financial performance and forecasting</p>
            </div>
            <button class="btn-print" onclick="window.print()">
                <i class="fa-solid fa-print"></i> Generate Report
            </button>
        </div>

        <div class="kpi-grid">
            <div class="kpi-card">
                <span class="kpi-title">Gross Revenue (YTD)</span>
                <h2 class="kpi-value">LKR <%= String.format("%,.0f", revenue) %></h2>
                <div class="kpi-trend"><i class="fa-solid fa-arrow-trend-up"></i> +12.4% vs Last Quarter</div>
            </div>
            <div class="kpi-card">
                <span class="kpi-title">Occupancy Rate</span>
                <h2 class="kpi-value"><%= String.format("%.1f", occupancyRate) %>%</h2>
                <div class="kpi-trend"><i class="fa-solid fa-arrow-trend-up"></i> <%= occupied %> / 50 Rooms Booked</div>
            </div>
            <div class="kpi-card">
                <span class="kpi-title">Today's Check-ins</span>
                <h2 class="kpi-value"><%= arrivals %> Guests</h2>
                <div class="kpi-trend" style="color: var(--text-muted);"><i class="fa-solid fa-clock"></i> Updated just now</div>
            </div>
        </div>

        <div class="analytics-grid">

            <div class="chart-container">
                <h3 style="margin: 0 0 20px 0; font-size: 16px; color: white;"><i class="fa-solid fa-chart-area" style="color: var(--gold); margin-right: 8px;"></i> Monthly Revenue Trajectory</h3>
                <canvas id="revenueChart" height="120"></canvas>
            </div>

            <div class="calc-container">
                <h3 style="margin: 0 0 20px 0; font-size: 14px; color: var(--gold); text-transform: uppercase; letter-spacing: 1px;"><i class="fa-solid fa-calculator"></i> Quick Compute</h3>
                <input type="text" id="calcScreen" class="calc-screen" readonly value="0">
                <div class="calc-btns">
                    <button class="op-btn" onclick="clearScreen()">AC</button>
                    <button class="op-btn" onclick="backspace()"><i class="fa-solid fa-delete-left"></i></button>
                    <button class="op-btn" onclick="press('/')">÷</button>
                    <button class="op-btn" onclick="press('*')">×</button>

                    <button onclick="press('7')">7</button>
                    <button onclick="press('8')">8</button>
                    <button onclick="press('9')">9</button>
                    <button class="op-btn" onclick="press('-')">−</button>

                    <button onclick="press('4')">4</button>
                    <button onclick="press('5')">5</button>
                    <button onclick="press('6')">6</button>
                    <button class="op-btn" onclick="press('+')">+</button>

                    <button onclick="press('1')">1</button>
                    <button onclick="press('2')">2</button>
                    <button onclick="press('3')">3</button>
                    <button class="eq-btn" onclick="calculate()" style="grid-row: span 2;">=</button>

                    <button onclick="press('0')" style="grid-column: span 2;">0</button>
                    <button onclick="press('.')">.</button>
                </div>
            </div>

        </div>
    </div>

    <script>
        // 1. Chart.js Initialization for Premium Area Chart
        const ctx = document.getElementById('revenueChart').getContext('2d');

        // Prepare Data from Java backend
        <%
            List<String> monthsList = new ArrayList<>();
            List<Double> valuesList = new ArrayList<>();
            if (revData != null && !revData.isEmpty()) {
                monthsList.addAll(revData.keySet());
                valuesList.addAll(revData.values());
            } else {
                // Fallback dummy data if DB is empty
                monthsList.addAll(Arrays.asList("Oct", "Nov", "Dec", "Jan", "Feb", "Mar"));
                valuesList.addAll(Arrays.asList(450000.0, 520000.0, 890000.0, 610000.0, 750000.0, 920000.0));
            }
        %>

        // Create Gradient for Chart
        let gradient = ctx.createLinearGradient(0, 0, 0, 400);
        gradient.addColorStop(0, 'rgba(194,155,64,0.5)'); // Gold transparent
        gradient.addColorStop(1, 'rgba(194,155,64,0.0)');

        new Chart(ctx, {
            type: 'line',
            data: {
                labels: <%= monthsList.toString().replace("[", "['").replace("]", "']").replace(", ", "','") %>,
                datasets: [{
                    label: 'Gross Revenue (LKR)',
                    data: <%= valuesList.toString() %>,
                    borderColor: '#c29b40', /* Gold border */
                    backgroundColor: gradient,
                    fill: true,
                    tension: 0.4, /* Smooth curves */
                    borderWidth: 3,
                    pointBackgroundColor: '#050505',
                    pointBorderColor: '#c29b40',
                    pointBorderWidth: 2,
                    pointRadius: 4,
                    pointHoverRadius: 6
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { display: false }, /* Hide default legend for cleaner look */
                    tooltip: {
                        backgroundColor: '#111',
                        titleColor: '#c29b40',
                        bodyColor: '#fff',
                        borderColor: 'rgba(194,155,64,0.3)',
                        borderWidth: 1,
                        padding: 10,
                        callbacks: {
                            label: function(context) {
                                let label = context.dataset.label || '';
                                if (label) { label += ': '; }
                                if (context.parsed.y !== null) {
                                    label += new Intl.NumberFormat('en-LK', { style: 'currency', currency: 'LKR' }).format(context.parsed.y);
                                }
                                return label;
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: { color: 'rgba(255,255,255,0.05)', drawBorder: false },
                        ticks: { color: '#888', callback: function(value) { return value / 1000 + 'k'; } }
                    },
                    x: {
                        grid: { display: false },
                        ticks: { color: '#888' }
                    }
                }
            }
        });

        // 2. Custom Calculator Logic
        const screen = document.getElementById('calcScreen');
        let isEvaluated = false;

        function press(val) {
            if(isEvaluated && !isNaN(val)) { screen.value = val; isEvaluated = false; return; }
            if(isEvaluated && isNaN(val)) { isEvaluated = false; }
            if(screen.value === '0' || screen.value === 'Error') screen.value = val;
            else screen.value += val;
        }

        function clearScreen() { screen.value = '0'; isEvaluated = false; }

        function backspace() {
            if(screen.value === 'Error') { screen.value = '0'; return; }
            screen.value = screen.value.slice(0, -1);
            if(screen.value === '') screen.value = '0';
        }

        function calculate() {
            try {
                // Replace visual symbols with valid operators before eval
                let expression = screen.value.replace(/×/g, '*').replace(/÷/g, '/').replace(/−/g, '-');
                let result = eval(expression);
                // Format if decimal
                screen.value = Number.isInteger(result) ? result : result.toFixed(2);
                isEvaluated = true;
            } catch(e) {
                screen.value = 'Error';
                isEvaluated = true;
            }
        }
    </script>
</body>
</html>