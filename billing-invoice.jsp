<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%
    // State Management & Data Retrieval
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Map<String, Object> d = (Map<String, Object>) request.getAttribute("billData");
    if (d == null || d.isEmpty()) {
        response.sendRedirect("ReservationServlet?action=list&error=no_data");
        return;
    }

    // Extracting Data Safely
    String resId = (String) d.get("res_id");
    String guest = (String) d.get("guest");
    String type = (String) d.get("type");
    String checkIn = (String) d.get("check_in");
    String checkOut = (String) d.get("check_out");
    int roomNo = (Integer) d.get("room_no");
    int nights = (Integer) d.get("nights");
    double grandTotal = (Double) d.get("grand_total");

    // Real-World Hotel Math (Reverse Calculation from Grand Total)
    // Assuming 10% Service Charge + 15% VAT = 25% Total Markup
    double subTotal = grandTotal / 1.25;
    double serviceCharge = subTotal * 0.10;
    double vat = subTotal * 0.15;
    double nightlyRate = subTotal / (nights > 0 ? nights : 1);

    // Current Timestamp for Invoice
    String invoiceDate = new SimpleDateFormat("yyyy-MM-dd hh:mm a").format(new Date());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Tax Invoice - <%= resId %></title>

    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;800&family=Libre+Barcode+39&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <style>
        :root { --gold: #c29b40; --bg: #050505; --card: #111; --border: rgba(194,155,64,0.2); }
        body { margin: 0; font-family: 'Plus Jakarta Sans', sans-serif; background: var(--bg); color: white; padding: 40px 20px; }

        /* Action Bar (Not Printed) */
        .action-bar { max-width: 800px; margin: 0 auto 20px auto; display: flex; justify-content: space-between; }
        .btn { padding: 12px 25px; border-radius: 8px; font-weight: 700; cursor: pointer; border: none; font-size: 13px; text-transform: uppercase; text-decoration: none; transition: 0.3s; }
        .btn-back { background: #333; color: white; border: 1px solid #555; }
        .btn-print { background: var(--gold); color: black; box-shadow: 0 5px 15px rgba(194,155,64,0.3); }
        .btn-print:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(194,155,64,0.5); }

        /* The Invoice Paper Form */
        .invoice-paper {
            max-width: 800px; margin: 0 auto; background: var(--card); border: 1px solid var(--border);
            border-radius: 16px; padding: 50px; box-shadow: 0 20px 40px rgba(0,0,0,0.5);
        }

        /* Header */
        .inv-header { display: flex; justify-content: space-between; align-items: flex-start; border-bottom: 2px solid var(--gold); padding-bottom: 20px; margin-bottom: 30px; }
        .hotel-info h1 { margin: 0; color: var(--gold); font-size: 28px; font-weight: 800; letter-spacing: 2px; }
        .hotel-info p { margin: 5px 0 0 0; color: #888; font-size: 12px; }
        .inv-title h2 { margin: 0; font-size: 32px; color: white; text-align: right; letter-spacing: 5px; font-weight: 300; }
        .inv-title p { margin: 5px 0 0 0; color: #888; text-align: right; font-size: 13px; font-weight: 600; }

        /* Meta Data Grid */
        .inv-meta { display: grid; grid-template-columns: 1fr 1fr; gap: 30px; margin-bottom: 40px; }
        .meta-box { background: rgba(255,255,255,0.03); padding: 20px; border-radius: 12px; border: 1px solid rgba(255,255,255,0.05); }
        .meta-box h4 { margin: 0 0 10px 0; color: var(--gold); font-size: 12px; text-transform: uppercase; letter-spacing: 1px; }
        .meta-item { display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 13px; color: #ccc; }
        .meta-item b { color: white; }

        /* Billing Table */
        .inv-table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
        .inv-table th { text-align: left; padding: 15px; background: rgba(194,155,64,0.1); color: var(--gold); font-size: 12px; text-transform: uppercase; letter-spacing: 1px; }
        .inv-table td { padding: 15px; border-bottom: 1px solid var(--border); font-size: 14px; }
        .text-right { text-align: right !important; }

        /* Totals Area */
        .inv-totals { display: flex; justify-content: flex-end; }
        .totals-box { width: 350px; }
        .total-row { display: flex; justify-content: space-between; padding: 10px 15px; font-size: 14px; color: #ccc; }
        .total-row b { color: white; }
        .grand-total { background: rgba(194,155,64,0.1); border: 1px solid var(--gold); border-radius: 8px; margin-top: 10px; padding: 15px; font-size: 20px; font-weight: 800; color: var(--gold); display: flex; justify-content: space-between; }

        /* Footer & Barcode */
        .inv-footer { margin-top: 50px; border-top: 1px dashed var(--border); padding-top: 20px; display: flex; justify-content: space-between; align-items: flex-end; }
        .barcode { font-family: 'Libre Barcode 39', cursive; font-size: 40px; color: white; }
        .signature { text-align: center; color: #888; font-size: 12px; }
        .signature-line { width: 150px; border-top: 1px solid #888; margin-bottom: 5px; }

        /* === PRINT STYLES === */
        @media print {
            body { background: white; padding: 0; color: black !important; }
            .no-print { display: none !important; }
            .invoice-paper { box-shadow: none; border: none; padding: 0; max-width: 100%; background: white !important; }
            .hotel-info h1, .inv-table th { color: black !important; background: #f4f4f4 !important; }
            .inv-title h2, .meta-item b, .inv-table td, .total-row b, .barcode { color: black !important; }
            .meta-box, .inv-table td, .inv-header { border-color: #ddd !important; background: transparent !important; }
            .grand-total { background: #f4f4f4 !important; border-color: black !important; color: black !important; }
            * { color: black !important; }
        }
    </style>
</head>
<body>

    <div class="action-bar no-print">
        <a href="ReservationServlet?action=list" class="btn btn-back"><i class="fa-solid fa-arrow-left"></i> Back to List</a>
        <button class="btn btn-print" onclick="window.print()"><i class="fa-solid fa-print"></i> Print Invoice</button>
    </div>

    <div class="invoice-paper">

        <div class="inv-header">
            <div class="hotel-info">
                <h1>OCEAN VIEW</h1>
                <p>123 Coastal Avenue, Galle, Sri Lanka<br>+94 91 234 5678 | billing@oceanview.lk</p>
            </div>
            <div class="inv-title">
                <h2>TAX INVOICE</h2>
                <p>Date: <%= invoiceDate %></p>
            </div>
        </div>

        <div class="inv-meta">
            <div class="meta-box">
                <h4>Guest Information</h4>
                <div class="meta-item"><span>Name:</span> <b><%= guest %></b></div>
                <div class="meta-item"><span>Reservation ID:</span> <b><%= resId %></b></div>
            </div>
            <div class="meta-box">
                <h4>Stay Details</h4>
                <div class="meta-item"><span>Room No:</span> <b><%= roomNo %> (<%= type %>)</b></div>
                <div class="meta-item"><span>Check-In:</span> <b><%= checkIn %></b></div>
                <div class="meta-item"><span>Check-Out:</span> <b><%= checkOut %></b></div>
                <div class="meta-item"><span>Total Duration:</span> <b><%= nights %> Night(s)</b></div>
            </div>
        </div>

        <table class="inv-table">
            <thead>
                <tr>
                    <th>Description</th>
                    <th class="text-right">Qty / Nights</th>
                    <th class="text-right">Unit Rate (LKR)</th>
                    <th class="text-right">Amount (LKR)</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Accommodation: <%= type %> Room<br><small style="color:#888;">Inclusive of selected amenities & services</small></td>
                    <td class="text-right"><%= nights %></td>
                    <td class="text-right"><%= String.format("%,.2f", nightlyRate) %></td>
                    <td class="text-right"><%= String.format("%,.2f", subTotal) %></td>
                </tr>
            </tbody>
        </table>

        <div class="inv-totals">
            <div class="totals-box">
                <div class="total-row"><span>Sub Total:</span> <b><%= String.format("%,.2f", subTotal) %></b></div>
                <div class="total-row"><span>Service Charge (10%):</span> <b><%= String.format("%,.2f", serviceCharge) %></b></div>
                <div class="total-row"><span>State VAT (15%):</span> <b><%= String.format("%,.2f", vat) %></b></div>
                <div class="grand-total">
                    <span>GRAND TOTAL:</span>
                    <span>LKR <%= String.format("%,.2f", grandTotal) %></span>
                </div>
            </div>
        </div>

        <div class="inv-footer">
            <div>
                <p style="font-size:12px; color:#888; margin-bottom:5px;">Scan for digital receipt validation:</p>
                <div class="barcode">*<%= resId %>*</div>
            </div>
            <div class="signature">
                <div class="signature-line"></div>
                Authorized Signature<br>
                <b>Ocean View Resort</b>
            </div>
        </div>

    </div>

</body>
</html>