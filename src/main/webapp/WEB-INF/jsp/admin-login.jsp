<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - Hospital Administration</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            margin: 0;
            min-height: 100vh;
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #1e293b, #0f172a);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 30px 15px;
        }

        .login-container { width: 100%; max-width: 450px; }
        .login-card { background: white; border-radius: 20px; padding: 40px; box-shadow: 0 15px 40px rgba(0, 0, 0, 0.40); }
        .logo { width: 65px; height: 65px; margin: 0 auto 20px; border-radius: 50%; background: #dc2626; color: white; display: flex; align-items: center; justify-content: center; font-size: 30px; font-weight: bold; }
        .title { text-align: center; font-weight: 700; color: #1f2937; margin-bottom: 8px; }
        .subtitle { text-align: center; color: #6b7280; font-size: 14px; margin-bottom: 30px; }
        .form-label { font-weight: 600; color: #374151; font-size: 14px; }
        .form-control { height: 48px; border-radius: 10px; border: 1px solid #d1d5db; }
        .form-control:focus { border-color: #dc2626; box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.12); }
        .login-btn { width: 100%; height: 50px; border: none; border-radius: 10px; background: #dc2626; color: white; font-size: 16px; font-weight: 600; transition: 0.2s; margin-top: 10px; }
        .login-btn:hover { background: #b91c1c; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(220, 38, 38, 0.3); }
        .login-btn:disabled { background: #fca5a5; cursor: not-allowed; transform: none; }
        .footer-text { text-align: center; margin-top: 20px; color: rgba(255,255,255,0.5); font-size: 12px; }
        #message { display: none; margin-bottom: 20px; border-radius: 8px; }
    </style>
</head>
<body>

<div class="login-container">
    <div class="login-card">
        <div class="logo"><i class="fa-solid fa-shield-halved"></i></div>
        <h2 class="title">Admin Portal</h2>
        <p class="subtitle">Secure login for Hospital Administrators</p>

        <div id="message" class="alert" role="alert"></div>

        <form id="loginForm">
            <div class="mb-3">
                <label for="email" class="form-label">Admin Email</label>
                <input type="email" class="form-control" id="email" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" required>
            </div>
            <div class="mt-4">
                <button type="submit" class="login-btn" id="loginButton">Secure Login</button>
            </div>
        </form>

        <div style="text-align: center; margin-top: 25px; color: #6b7280; font-size: 14px;">
            Need an admin account? <a href="${pageContext.request.contextPath}/admin/register" style="color: #dc2626; font-weight: 600; text-decoration: none;">Register</a>
        </div>
    </div>
    <div class="footer-text">
        © 2026 Patient Case Management System • Admin Module
    </div>
</div>

<script>
    document.getElementById("loginForm").addEventListener("submit", async function(event) {
        event.preventDefault();
        
        const button = document.getElementById("loginButton");
        const email = document.getElementById("email").value.trim();
        const password = document.getElementById("password").value;

        button.disabled = true;
        button.innerText = "Authenticating...";

        try {
            const response = await fetch("${pageContext.request.contextPath}/api/auth/login", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ email: email, password: password })
            });

            if (response.ok) {
                // Now verify if the user is an admin
                const userRes = await fetch("${pageContext.request.contextPath}/api/users/email?email=" + encodeURIComponent(email));
                const userData = await userRes.json();
                
                if (userData.role === 'ADMIN') {
                    showMessage("Authentication successful. Loading portal...", "success");
                    setTimeout(() => {
                        window.location.href = "${pageContext.request.contextPath}/admin/dashboard";
                    }, 1000);
                } else {
                    showMessage("Access Denied. You do not have Administrator privileges.", "danger");
                }
            } else {
                showMessage("Invalid admin email or password.", "danger");
            }
        } catch (error) {
            showMessage("Unable to connect to the server.", "danger");
        } finally {
            button.disabled = false;
            button.innerText = "Secure Login";
        }
    });

    function showMessage(text, type) {
        const message = document.getElementById("message");
        message.className = "alert alert-" + type;
        message.innerText = text;
        message.style.display = "block";
    }
</script>
</body>
</html>
