<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports - Patient Case Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary-blue: #0A66C2; --bg-color: #f1f5f9; --sidebar-bg: #1e293b; --text-muted: #64748b; }
        body { font-family: 'Inter', sans-serif; background-color: var(--bg-color); margin: 0; overflow-x: hidden; }
        .wrapper { display: flex; width: 100%; }
        #sidebar { min-width: 250px; max-width: 250px; background: var(--sidebar-bg); color: #fff; transition: all 0.3s; min-height: 100vh; padding-top: 20px; display: flex; flex-direction: column; }
        .sidebar-header { padding: 20px; border-bottom: 1px solid rgba(255,255,255,0.1); font-weight: 700; font-size: 1.2rem; display: flex; align-items: center; gap: 10px; }
        .sidebar-header .icon { background: var(--primary-blue); width: 32px; height: 32px; border-radius: 8px; display: flex; align-items: center; justify-content: center; }
        ul.components { padding: 20px 0; margin-bottom: 0; }
        ul.components li { padding: 5px 20px; }
        ul.components li a { color: rgba(255,255,255,0.7); text-decoration: none; display: flex; align-items: center; gap: 12px; padding: 10px 15px; border-radius: 8px; transition: all 0.3s; }
        ul.components li a:hover, ul.components li.active a { color: #fff; background: rgba(255,255,255,0.1); }
        ul.components li.active a { background: var(--primary-blue); }
        #content { width: 100%; padding: 30px; }
        .top-navbar { background: #fff; padding: 15px 30px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.03); display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .user-profile { display: flex; align-items: center; gap: 10px; }
        .user-avatar { width: 40px; height: 40px; background: #e2e8f0; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: var(--primary-blue); font-weight: 700; }
        .content-card { background: #fff; border-radius: 16px; padding: 25px; box-shadow: 0 4px 20px rgba(0,0,0,0.02); }
    </style>
</head>
<body>
<div class="wrapper">
    <jsp:include page="sidebar.jsp" />
    <div id="content">
        <div class="top-navbar">
            <h4 class="m-0 fw-bold" style="color: #1e293b;">Medical Reports</h4>
            <div class="user-profile">
                <div class="text-end me-2"><div class="fw-bold" style="font-size: 0.9rem; color: #1e293b;">Welcome Back</div><div class="text-muted" style="font-size: 0.8rem;">Doctor / Admin</div></div>
                <div class="user-avatar"><i class="fa-solid fa-user"></i></div>
            </div>
        </div>
        <div class="content-card">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5 class="m-0 fw-bold">Lab Results & Documents</h5>
                <button class="btn btn-primary"><i class="fa-solid fa-upload me-2"></i>Upload Report</button>
            </div>
            <p class="text-muted">Access, upload, and review patient medical reports and lab results.</p>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
