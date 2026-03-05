<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    if (session.getAttribute("username") == null || !"Admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("DashboardServlet");
        return;
    }
    String currentUsername = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View | Staff Control</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        :root {
            --gold: #c29b40; --bg: #050505; --card: #111;
            --border: rgba(194,155,64,0.15); --text-dim: #888;
            --glass: rgba(255, 255, 255, 0.02);
            --danger: #ef4444; --success: #10b981; --info: #38bdf8;
        }

        body { background: var(--bg); color: white; font-family: 'Plus Jakarta Sans', sans-serif; margin: 0; min-height: 100vh; overflow-x: hidden; }
        .main-content { padding: 40px; max-width: 1500px; margin: 0 auto; box-sizing: border-box; }

        .header-section { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 30px; padding-bottom: 20px; border-bottom: 1px solid var(--border); }
        .header-section h2 { font-size: 34px; font-weight: 800; margin: 0; color: var(--gold); }
        .header-section p { color: var(--text-dim); margin-top: 8px; font-size: 14px; }

        .alert { padding: 15px 20px; border-radius: 12px; margin-bottom: 30px; font-weight: 600; font-size: 13px; display: flex; align-items: center; gap: 10px; }
        .alert-success { background: rgba(16, 185, 129, 0.1); border: 1px solid rgba(16, 185, 129, 0.3); color: var(--success); }
        .alert-error { background: rgba(239, 68, 68, 0.1); border: 1px solid rgba(239, 68, 68, 0.3); color: var(--danger); }

        .form-split-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 30px; margin-bottom: 50px; }
        .form-card { background: var(--card); border: 1px solid var(--border); border-radius: 20px; padding: 30px; box-shadow: 0 20px 40px rgba(0, 0, 0, 0.5); }
        .form-card.admin-card { border-top: 4px solid var(--gold); }
        .form-card.staff-card { border-top: 4px solid #fff; }
        .form-card h3 { margin: 0 0 20px 0; font-size: 20px; font-weight: 800; }
        .admin-card h3 { color: var(--gold); }

        input, select { width: 100%; background: rgba(0,0,0,0.5); border: 1px solid var(--border); color: white; padding: 15px; border-radius: 12px; outline: none; margin-bottom: 15px; box-sizing: border-box; font-family: inherit; font-size: 14px; }
        input:focus, select:focus { border-color: var(--gold); background: rgba(194,155,64,0.05); }
        option { background: var(--bg); color: white; }

        .btn-submit { width: 100%; padding: 15px; border: none; border-radius: 12px; font-weight: 800; font-size: 14px; cursor: pointer; transition: 0.3s; text-transform: uppercase; letter-spacing: 1px; }
        .btn-admin { background: var(--gold); color: black; }
        .btn-admin:hover { background: #d4af37; transform: translateY(-2px); }
        .btn-staff { background: white; color: black; }
        .btn-staff:hover { background: #ccc; transform: translateY(-2px); }

        .table-wrapper { background: var(--card); border: 1px solid var(--border); border-radius: 20px; padding: 15px; overflow-x: auto; }
        table { width: 100%; border-collapse: separate; border-spacing: 0 8px; min-width: 800px; }
        th { padding: 18px 20px; text-align: left; color: var(--gold); font-size: 12px; text-transform: uppercase; letter-spacing: 1px; font-weight: 800; border-bottom: 1px solid var(--border); }
        td { padding: 18px 20px; background: var(--glass); font-size: 14px; color: white; vertical-align: middle; }
        tr td:first-child { border-radius: 12px 0 0 12px; border-left: 2px solid transparent; color: var(--text-dim); }
        tr td:last-child { border-radius: 0 12px 12px 0; }
        tr:hover td { background: rgba(194,155,64,0.05); }

        .role-badge { padding: 6px 14px; border-radius: 8px; font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 1px; display: inline-block;}
        .role-admin { background: rgba(194,155,64,0.1); color: var(--gold); border: 1px solid rgba(194,155,64,0.3); }
        .role-staff { background: rgba(255,255,255,0.05); color: #fff; border: 1px solid rgba(255,255,255,0.1); }

        .action-flex { display: flex; gap: 10px; justify-content: flex-end; }
        .btn-action { width: 35px; height: 35px; border-radius: 8px; border: none; display: flex; justify-content: center; align-items: center; cursor: pointer; transition: 0.3s; color: white; font-size: 14px; }
        .btn-view { background: rgba(56, 189, 248, 0.1); color: var(--info); border: 1px solid rgba(56, 189, 248, 0.3); }
        .btn-view:hover { background: var(--info); color: black; box-shadow: 0 5px 15px rgba(56, 189, 248, 0.3); }
        .btn-edit { background: rgba(16, 185, 129, 0.1); color: var(--success); border: 1px solid rgba(16, 185, 129, 0.3); }
        .btn-edit:hover { background: var(--success); color: black; box-shadow: 0 5px 15px rgba(16, 185, 129, 0.3); }
        .btn-delete { background: rgba(239, 68, 68, 0.1); color: var(--danger); border: 1px solid rgba(239, 68, 68, 0.3); }
        .btn-delete:hover { background: var(--danger); color: white; box-shadow: 0 5px 15px rgba(239, 68, 68, 0.3); }
        .btn-delete:disabled { opacity: 0.3; cursor: not-allowed; }


        .modal-overlay {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.8);
            backdrop-filter: blur(5px); display: none; justify-content: center; align-items: center; z-index: 1000;
        }
        .modal-box {
            background: var(--card); width: 400px; padding: 30px; border-radius: 20px;
            border: 1px solid var(--border); box-shadow: 0 25px 50px rgba(0,0,0,0.5);
            animation: popIn 0.3s ease-out; position: relative;
        }
        @keyframes popIn { from { transform: scale(0.9); opacity: 0; } to { transform: scale(1); opacity: 1; } }
        .close-btn { position: absolute; top: 20px; right: 20px; color: var(--text-dim); cursor: pointer; font-size: 20px; transition: 0.2s; }
        .close-btn:hover { color: white; }
        .profile-icon { font-size: 60px; color: var(--gold); text-align: center; margin-bottom: 20px; display: block; }

        @media (max-width: 1024px) { .form-split-grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <div class="main-content">
        <div class="header-section">
            <div>
                <h2>Access Control & Registry</h2>
                <p>Manage system access levels and human resources.</p>
            </div>
        </div>

        <% String status = request.getParameter("status");
           if("success".equals(status)) { %>
            <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> System user successfully registered.</div>
        <% } else if("updated".equals(status)) { %>
            <div class="alert alert-success"><i class="fa-solid fa-pen-to-square"></i> User profile updated successfully.</div>
        <% } else if("deleted".equals(status)) { %>
            <div class="alert alert-success"><i class="fa-solid fa-trash-can"></i> User account permanently removed.</div>
        <% } else if("error".equals(status) || "delete_error".equals(status)) { %>
            <div class="alert alert-error"><i class="fa-solid fa-triangle-exclamation"></i> Action failed. Please try again.</div>
        <% } %>

        <div class="form-split-grid">
            <div class="form-card admin-card">
                <h3><i class="fa-solid fa-user-shield"></i> Authorize Executive</h3>
                <form action="StaffServlet" method="POST">
                    <input type="hidden" name="action" value="register"> <input type="hidden" name="role" value="Admin">
                    <input type="text" name="fullName" placeholder="Full Executive Name" required>
                    <input type="text" name="username" placeholder="Unique Login ID" required>
                    <input type="password" name="password" placeholder="Secure Password" required>
                    <button type="submit" class="btn-submit btn-admin">Grant Admin Access</button>
                </form>
            </div>
            <div class="form-card staff-card">
                <h3><i class="fa-solid fa-user-tie"></i> Register Front-Desk</h3>
                <form action="StaffServlet" method="POST">
                    <input type="hidden" name="action" value="register"> <input type="hidden" name="role" value="Staff">
                    <input type="text" name="fullName" placeholder="Full Staff Name" required>
                    <input type="text" name="username" placeholder="Unique Login ID" required>
                    <input type="password" name="password" placeholder="Temporary Password" required>
                    <button type="submit" class="btn-submit btn-staff">Create Staff Account</button>
                </form>
            </div>
        </div>

        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Emp ID</th>
                        <th>Registered Name</th>
                        <th>Login Username</th>
                        <th>Authorization Level</th>
                        <th style="text-align: right;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Map<String, String>> list = (List<Map<String, String>>) request.getAttribute("staffList");
                        if(list != null && !list.isEmpty()) {
                            for(Map<String, String> user : list) {
                                boolean isAdmin = "Admin".equals(user.get("role"));
                                boolean isSelf = currentUsername.equals(user.get("username"));
                                String badgeClass = isAdmin ? "role-admin" : "role-staff";
                    %>
                    <tr>
                        <td>#EMP-<%= user.get("id") %></td>
                        <td><b style="color: white; font-size: 15px;"><%= user.get("fullName") %></b>
                            <% if(isSelf) { %> <span style="font-size:10px; color:var(--gold); margin-left:5px;">(YOU)</span> <% } %>
                        </td>
                        <td style="font-family: monospace; font-size: 15px;"><%= user.get("username") %></td>
                        <td><span class="role-badge <%= badgeClass %>"><%= user.get("role") %></span></td>
                        <td>
                            <div class="action-flex">
                                <button class="btn-action btn-view" title="View Profile"
                                        onclick="openViewModal('<%= user.get("id") %>', '<%= user.get("fullName") %>', '<%= user.get("username") %>', '<%= user.get("role") %>')">
                                    <i class="fa-solid fa-eye"></i>
                                </button>

                                <button class="btn-action btn-edit" title="Edit User"
                                        onclick="openEditModal('<%= user.get("id") %>', '<%= user.get("fullName") %>', '<%= user.get("role") %>')">
                                    <i class="fa-solid fa-pen-to-square"></i>
                                </button>

                                <button class="btn-action btn-delete" title="<%= isSelf ? "Cannot delete active session" : "Delete User" %>"
                                        onclick="confirmDelete('<%= user.get("id") %>', '<%= user.get("fullName") %>')" <%= isSelf ? "disabled" : "" %>>
                                    <i class="fa-solid fa-trash-can"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                    <%      }
                        } else { %>
                    <tr><td colspan="5" style="text-align:center; padding: 40px; color: var(--text-dim);">No registry records found.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <div class="modal-overlay" id="viewModal">
        <div class="modal-box">
            <i class="fa-solid fa-xmark close-btn" onclick="closeModal('viewModal')"></i>
            <i class="fa-solid fa-circle-user profile-icon"></i>
            <h3 style="text-align: center; margin: 0; font-size: 24px;" id="viewName">Name</h3>
            <p style="text-align: center; color: var(--gold); margin: 5px 0 20px 0; font-weight: 700; font-size: 12px; letter-spacing: 1px;" id="viewRole">ROLE</p>

            <div style="background: rgba(255,255,255,0.03); padding: 20px; border-radius: 12px; border: 1px solid rgba(255,255,255,0.05);">
                <div style="display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 14px;">
                    <span style="color: var(--text-dim);">Employee ID:</span><b id="viewId" style="color: white;">#EMP-</b>
                </div>
                <div style="display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 14px;">
                    <span style="color: var(--text-dim);">Username:</span><b id="viewUsername" style="color: white; font-family: monospace;">username</b>
                </div>
                <div style="display: flex; justify-content: space-between; font-size: 14px;">
                    <span style="color: var(--text-dim);">Status:</span><b style="color: var(--success);">ACTIVE</b>
                </div>
            </div>
        </div>
    </div>

    <div class="modal-overlay" id="editModal">
        <div class="modal-box">
            <i class="fa-solid fa-xmark close-btn" onclick="closeModal('editModal')"></i>
            <h3 style="margin: 0 0 20px 0; font-size: 20px; border-bottom: 1px solid var(--border); padding-bottom: 15px;"><i class="fa-solid fa-user-pen" style="color: var(--gold); margin-right: 10px;"></i> Edit User Profile</h3>

            <form action="StaffServlet" method="POST">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="editId" id="editId">

                <label style="font-size: 11px; color: var(--gold); text-transform: uppercase; font-weight: 700; margin-bottom: 8px; display: block;">Full Name</label>
                <input type="text" name="editFullName" id="editFullName" required>

                <label style="font-size: 11px; color: var(--gold); text-transform: uppercase; font-weight: 700; margin-bottom: 8px; display: block;">Authorization Level</label>
                <select name="editRole" id="editRole" required>
                    <option value="Admin">Admin</option>
                    <option value="Staff">Staff</option>
                </select>

                <button type="submit" class="btn-submit btn-admin" style="margin-top: 10px;">Save Changes</button>
            </form>
        </div>
    </div>

    <script>
        // Delete Alert
        function confirmDelete(userId, userName) {
            Swal.fire({
                title: 'Revoke Access?',
                text: "You are about to permanently delete " + userName + ".",
                icon: 'warning', showCancelButton: true, confirmButtonColor: '#ef4444', cancelButtonColor: '#333', confirmButtonText: 'Yes, Terminate', background: '#111', color: '#fff'
            }).then((result) => {
                if (result.isConfirmed) { window.location.href = "StaffServlet?action=delete&id=" + userId; }
            })
        }

        // Modal Logic
        function openViewModal(id, name, user, role) {
            document.getElementById('viewId').innerText = "#EMP-" + id;
            document.getElementById('viewName').innerText = name;
            document.getElementById('viewUsername').innerText = user;
            document.getElementById('viewRole').innerText = role.toUpperCase();
            document.getElementById('viewModal').style.display = 'flex';
        }

        function openEditModal(id, name, role) {
            document.getElementById('editId').value = id;
            document.getElementById('editFullName').value = name;
            document.getElementById('editRole').value = role;
            document.getElementById('editModal').style.display = 'flex';
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }
    </script>
</body>
</html>