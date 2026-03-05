<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View | Secure Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <style>
        :root {
            --primary-gold: #c29b40;
            --gold-glow: rgba(194, 155, 64, 0.3);
            --bg-black: #0a0a0a;
            --card-dark: #121212;
            --glass-border: rgba(255, 255, 255, 0.05);
            --text-muted: #888888;
        }

        body {
            margin: 0;
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: var(--bg-black);
            background-image:
                radial-gradient(at 0% 0%, hsla(45,100%,5%,1) 0, transparent 50%),
                radial-gradient(at 100% 100%, hsla(0,0%,0%,1) 0, transparent 50%);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            color: white;
            overflow: hidden;
        }

        .login-card {
            display: flex;
            width: 900px;
            height: 550px;
            background: var(--card-dark);
            border-radius: 30px;
            border: 1px solid var(--glass-border);
            box-shadow: 0 40px 80px rgba(0,0,0,0.8);
            overflow: hidden;
            animation: slideUp 0.8s ease-out;
        }

        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }

        .brand-side {
            width: 40%;
            padding: 50px;
            background: linear-gradient(180deg, #181818 0%, #0a0a0a 100%);
            display: flex;
            flex-direction: column;
            justify-content: center;
            border-right: 1px solid var(--glass-border);
        }

        .brand-side i { font-size: 40px; color: var(--primary-gold); margin-bottom: 20px; }
        .brand-side h1 { font-size: 36px; font-weight: 800; margin: 0; letter-spacing: -1px; }
        .brand-side p { color: var(--text-muted); line-height: 1.6; font-size: 14px; margin-top: 15px; }

        .login-side {
            width: 60%;
            padding: 60px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .login-side h2 { font-size: 28px; font-weight: 700; margin-bottom: 8px; }
        .login-side p.sub { color: var(--text-muted); font-size: 14px; margin-bottom: 40px; }

        .form-group { margin-bottom: 25px; position: relative; }
        .form-group label {
            display: block; font-size: 11px; font-weight: 700; text-transform: uppercase;
            letter-spacing: 1.5px; color: var(--primary-gold); margin-bottom: 10px;
        }

        input {
            width: 100%; padding: 16px 20px; background: #1a1a1a; border: 1px solid var(--glass-border);
            border-radius: 15px; color: white; font-size: 15px; transition: 0.3s; box-sizing: border-box;
        }
        input:focus {
            border-color: var(--primary-gold); outline: none; background: #222;
            box-shadow: 0 0 20px var(--gold-glow);
        }

        .btn-submit {
            width: 100%; padding: 18px; background: var(--primary-gold); color: black;
            border: none; border-radius: 15px; font-size: 14px; font-weight: 800;
            cursor: pointer; transition: 0.4s; text-transform: uppercase; letter-spacing: 2px;
            margin-top: 10px;
        }
        .btn-submit:hover {
            transform: translateY(-3px); box-shadow: 0 15px 30px var(--gold-glow);
        }

        .error-box {
            background: rgba(239, 68, 68, 0.1); color: #f87171; padding: 12px;
            border-radius: 12px; font-size: 13px; margin-top: 20px; text-align: center;
            border: 1px solid rgba(239, 68, 68, 0.2);
        }
    </style>
</head>
<body>

    <div class="login-card">
        <div class="brand-side">
            <i class="fa-solid fa-hotel"></i>
            <h1>OCEAN VIEW</h1>
            <p>Smart Intelligence for Modern Hospitality Management.</p>
        </div>

        <div class="login-side">
            <h2>Welcome Back</h2>
            <p class="sub">Verify your identity to enter the hub.</p>

            <form action="LoginServlet" method="post">
                <div class="form-group">
                    <label>Employee ID / Username</label>
                    <input type="text" name="username" placeholder="e.g. malindu_01"
                           required minlength="4" maxlength="20"
                           pattern="[a-zA-Z0-9_]+"
                           title="Username must be 4-20 characters long and contain only letters, numbers, and underscores"
                           autocomplete="off">
                </div>

                <div class="form-group">
                    <label>Security Password</label>
                    <input type="password" name="password" placeholder="••••••••"
                           required minlength="4"
                           title="Password must be at least 4 characters long"
                           autocomplete="off">
                </div>

                <button type="submit" class="btn-submit">Sign In to Dashboard</button>
            </form>

            <% if(request.getParameter("error") != null) { %>
                <div class="error-box">
                    <i class="fa-solid fa-circle-exclamation"></i> Access Denied. Check your credentials or invalid input.
                </div>
            <% } %>
        </div>
    </div>

</body>
</html>