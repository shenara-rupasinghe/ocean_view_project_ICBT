<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%
    Map<String, String> bill = (Map<String, String>) request.getAttribute("billData");
    Long nights = (Long) request.getAttribute("nightsCount");
    Double total = (Double) request.getAttribute("totalBill");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Invoice | Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Plus Jakarta Sans', sans-serif; background: #f1f5f9; padding: 50px; }
        .invoice-card {
            max-width: 800px; margin: auto; background: white; padding: 60px;
            border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        }
        .header { display: flex; justify-content: space-between; border-bottom: 2px solid #f1f5f9; padding-bottom: 30px; }
        .brand { font-size: 24px; font-weight: 800; color: #38bdf8; }
        .bill-to { margin-top: 40px; }
        .table { width: 100%; border-collapse: collapse; margin-top: 40px; }
        .table th { text-align: left; padding: 15px; background: #f8fafc; color: #64748b; font-size: 12px; text-transform: uppercase; }
        .table td { padding: 20px 15px; border-bottom: 1px solid #f1f5f9; }
        .total-box { margin-top: 40px; text-align: right; }
        .btn-print {
            background: #38bdf8; color: white; border: none; padding: 15px 30px;
            border-radius: 12px; font-weight: 700; cursor: pointer; float: right; margin-top: 20px;
        }
        @media print { .btn-print { display: none; } .invoice-card { box-shadow: none; border: none; } body { background: white; padding: 0; } }
    </style>
</head>
<body>

<% if(bill != null && total != null) { %>
    <div class="invoice-card">
        <div class="header">
            <div class="brand">OCEAN VIEW RESORT</div>
            <div>
                <p><b>Invoice ID:</b> #<%= bill.get("res_id") %></p>
                <p><b>Date:</b> <%= java.time.LocalDate.now() %></p>
            </div>
        </div>

        <div class="bill-to">
            <p style="color: #64748b; font-size: 12px; text-transform: uppercase; font-weight: 700;">Bill To:</p>
            <h2 style="margin: 5px 0;"><%= bill.get("guest_name") %></h2>
        </div>

        <table class="table">
            <thead>
                <tr>
                    <th>Description</th>
                    <th>Stay Details</th>
                    <th>Rate</th>
                    <th>Subtotal</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><b>Accommodation</b><br><small><%= bill.get("room_type") %></small></td>
                    <td><%= nights %> Night(s)</td>
                    <td>LKR <%= bill.get("price") %></td>
                    <td><b>LKR <%= String.format("%.2f", total) %></b></td>
                </tr>
            </tbody>
        </table>

        <div class="total-box">
            <p style="color: #64748b;">Grand Total</p>
            <h1 style="color: #38bdf8; margin: 0;">LKR <%= String.format("%.2f", total) %></h1>
        </div>

        <button class="btn-print" onclick="window.print()">Print Invoice</button>
        <button class="btn-print" style="background: #64748b; margin-right: 10px;" onclick="window.history.back()">Back</button>
    </div>
<% } else { %>
    <div style="text-align: center; margin-top: 100px;">
        <h2 style="color: #ef4444;">Invoice generation failed. No data received.</h2>
        <p style="color: #64748b;">Please click the button below to return to the reservation list.</p>
        <br>
        <a href="ReservationServlet?action=list" style="background: #38bdf8; color: white; padding: 10px 20px; text-decoration: none; border-radius: 8px;">Go Back</a>
    </div>
<% } %>

</body>
</html>