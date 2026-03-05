<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Map<String, String>> allRooms = (List<Map<String, String>>) request.getAttribute("allRooms");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ocean View | New Guest Enrollment</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        :root { --gold: #c29b40; --bg: #050505; --card: #111; --border: rgba(194,155,64,0.15); }
        body { margin: 0; font-family: 'Plus Jakarta Sans', sans-serif; background: var(--bg); color: white; }
        .booking-container { padding: 40px 60px; display: grid; grid-template-columns: 1.8fr 1.2fr; gap: 40px; }
        .glass-card { background: var(--card); border: 1px solid var(--border); border-radius: 30px; padding: 35px; }
        label { display: block; font-size: 11px; font-weight: 700; text-transform: uppercase; color: var(--gold); margin-bottom: 8px; letter-spacing: 1px; }
        input, select, textarea { width: 100%; padding: 14px; background: rgba(255,255,255,0.03); border: 1px solid var(--border); border-radius: 12px; color: white; margin-bottom: 20px; box-sizing: border-box; }
        input:focus { border-color: var(--gold); outline: none; background: rgba(255,255,255,0.08); }
        .svc-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .svc-item { background: rgba(255,255,255,0.02); padding: 12px; border-radius: 12px; border: 1px solid var(--border); font-size: 13px; display: flex; align-items: center; gap: 10px; cursor: pointer; transition: 0.3s; }
        .svc-item:hover { background: rgba(194,155,64,0.05); border-color: var(--gold); }
        .btn-confirm { width: 100%; padding: 20px; background: var(--gold); color: black; border: none; border-radius: 15px; font-weight: 800; text-transform: uppercase; cursor: pointer; transition: 0.4s; }
        .btn-confirm:hover { transform: translateY(-3px); box-shadow: 0 15px 30px rgba(194,155,64,0.3); }
        option[disabled] { color: #f87171; background: #222; }
    </style>
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <form id="bookingForm" action="ReservationServlet" method="post">
        <input type="hidden" name="action" value="add">
        <input type="hidden" name="grandTotal" id="grandTotalInput">

        <main class="booking-container">
            <div class="form-side">
                <h2 style="font-size: 32px; margin-bottom: 10px;">New Guest Enrollment</h2>
                <div class="glass-card">
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div><label>Guest Full Name</label><input type="text" name="guestName" required></div>
                        <div><label>Contact Number</label><input type="text" name="contact" required></div>
                    </div>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div><label>NIC / Passport</label><input type="text" name="nic" required></div>
                        <div><label>Permanent Address</label><input type="text" name="address" required></div>
                    </div>
                    <div style="display: grid; grid-template-columns: 1.5fr 1fr; gap: 20px;">
                        <div><label>Room Allocation</label>
                            <select name="roomNo" id="roomSelect" required onchange="updateTotal()">
                                <option value="" data-price="0">-- Select Available Room --</option>
                                <% if(allRooms != null) { for(Map<String, String> r : allRooms) { %>
                                    <option value="<%= r.get("id") %>" data-price="<%= r.get("price") %>" data-type="<%= r.get("type") %>" <%= "Occupied".equals(r.get("status")) ? "disabled" : "" %>>
                                        Room <%= r.get("id") %> - <%= r.get("type") %> (LKR <%= r.get("price") %>)
                                    </option>
                                <% } } %>
                            </select>
                        </div>
                        <div><label>Selected Room Type</label><input type="text" id="roomTypeDisplay" name="roomType" readonly></div>
                    </div>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div><label>Check-In Date</label><input type="date" id="checkIn" name="checkIn" required onchange="updateTotal()"></div>
                        <div><label>Check-Out Date</label><input type="date" id="checkOut" name="checkOut" required onchange="updateTotal()"></div>
                    </div>
                    <label>Premium Add-ons</label>
                    <div class="svc-grid">
                        <label class="svc-item"><input type="checkbox" class="svc" data-p="1500" onchange="updateTotal()"> Breakfast Buffet</label>
                        <label class="svc-item"><input type="checkbox" class="svc" data-p="5000" onchange="updateTotal()"> Full Spa Access</label>
                    </div>
                </div>
            </div>

            <div class="summary-side">
                <div class="glass-card" style="border-color: var(--gold); position: sticky; top: 120px;">
                    <h3 style="color: var(--gold);"><i class="fa-solid fa-receipt"></i> Stay Summary</h3>
                    <div style="display: flex; justify-content: space-between; margin: 20px 0;">
                        <span>Total Stay Duration</span><b id="dispNights">0 Nights</b>
                    </div>

                    <label>Settlement Method</label>
                    <select name="paymentMethod" id="payMethod" required>
                        <option value="Cash">Cash Settlement</option>
                        <option value="Card">Credit/Debit Card</option>
                    </select>

                    <div style="font-size: 42px; font-weight: 800; color: var(--gold); margin: 20px 0;" id="dispTotal">LKR 0</div>
                    <button type="button" class="btn-confirm" onclick="handleSubmission()">Commit Reservation</button>
                </div>
            </div>
        </main>
    </form>

    <script>
        function updateTotal() {
            const roomOpt = document.getElementById('roomSelect').selectedOptions[0];
            const roomPrice = parseInt(roomOpt.getAttribute('data-price') || 0);
            document.getElementById('roomTypeDisplay').value = roomOpt.getAttribute('data-type') || 'N/A';
            let svcTotal = 0;
            document.querySelectorAll('.svc:checked').forEach(cb => svcTotal += parseInt(cb.getAttribute('data-p')));
            const cin = new Date(document.getElementById('checkIn').value);
            const cout = new Date(document.getElementById('checkOut').value);
            let nights = (cin && cout && cout > cin) ? Math.ceil((cout - cin) / (1000 * 60 * 60 * 24)) : 1;
            document.getElementById('dispNights').innerText = nights + " Night(s)";
            let finalBill = (roomPrice + svcTotal) * nights;
            document.getElementById('dispTotal').innerText = "LKR " + finalBill.toLocaleString();
            document.getElementById('grandTotalInput').value = finalBill;
        }

        function handleSubmission() {
            const form = document.getElementById('bookingForm');
            if(!form.checkValidity()) { form.reportValidity(); return; }
            Swal.fire({ title: 'Confirm Enrollment?', icon: 'warning', showCancelButton: true, confirmButtonColor: '#c29b40', confirmButtonText: 'Authorize' }).then((result) => {
                if (result.isConfirmed) form.submit();
            });
        }
    </script>
</body>
</html>