<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Patient Case Management</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- FontAwesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --primary-blue: #0A66C2;
            --bg-color: #f1f5f9;
            --sidebar-bg: #1e293b;
            --text-muted: #64748b;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-color);
            margin: 0;
            overflow-x: hidden;
        }

        /* Layout */
        .wrapper {
            display: flex;
            width: 100%;
        }

        /* Sidebar */
        #sidebar {
            min-width: 250px;
            max-width: 250px;
            background: var(--sidebar-bg);
            color: #fff;
            transition: all 0.3s;
            min-height: 100vh;
            padding-top: 20px;
        }

        .sidebar-header {
            padding: 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            font-weight: 700;
            font-size: 1.2rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .sidebar-header .icon {
            background: var(--primary-blue);
            width: 32px;
            height: 32px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        ul.components {
            padding: 20px 0;
        }

        ul.components li {
            padding: 10px 20px;
        }

        ul.components li a {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 15px;
            border-radius: 8px;
            transition: all 0.3s;
        }

        ul.components li a:hover, ul.components li.active a {
            color: #fff;
            background: rgba(255,255,255,0.1);
        }

        ul.components li.active a {
            background: var(--primary-blue);
        }

        /* Main Content */
        #content {
            width: 100%;
            padding: 30px;
        }

        .top-navbar {
            background: #fff;
            padding: 15px 30px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            background: #e2e8f0;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary-blue);
            font-weight: 700;
        }

        /* Dashboard Cards */
        .stat-card {
            background: #fff;
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.02);
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: transform 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-info h3 {
            font-size: 2rem;
            font-weight: 700;
            margin: 0;
            color: #1e293b;
        }

        .stat-info p {
            margin: 0;
            color: var(--text-muted);
            font-weight: 500;
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }

        .icon-blue { background: rgba(10, 102, 194, 0.1); color: var(--primary-blue); }
        .icon-green { background: rgba(16, 185, 129, 0.1); color: #10b981; }
        .icon-purple { background: rgba(139, 92, 246, 0.1); color: #8b5cf6; }

        /* Recent Activity Table */
        .recent-section {
            background: #fff;
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.02);
            margin-top: 30px;
        }

        .recent-section h4 {
            font-weight: 700;
            margin-bottom: 20px;
            color: #1e293b;
        }

        .table th {
            color: var(--text-muted);
            font-weight: 600;
            border-bottom-width: 1px;
        }

        .badge-status {
            padding: 6px 12px;
            border-radius: 50px;
            font-weight: 500;
            font-size: 0.85rem;
        }

        .status-active { background: #dcfce7; color: #166534; }
        .status-pending { background: #fef9c3; color: #854d0e; }

    </style>
</head>
<body>

<div class="wrapper">
    <!-- Sidebar -->
    <jsp:include page="sidebar.jsp" />

    <!-- Page Content -->
    <div id="content">
        <div class="top-navbar">
            <h4 class="m-0 fw-bold" style="color: #1e293b;">Overview</h4>
            
            <div class="user-profile">
                <div class="text-end me-2">
                    <div class="fw-bold" style="font-size: 0.9rem; color: #1e293b;">Welcome Back</div>
                    <div class="text-muted" style="font-size: 0.8rem;">Doctor / Admin</div>
                </div>
                <div class="user-avatar">
                    <i class="fa-solid fa-user"></i>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-info">
                        <p>Total Patients</p>
                        <h3>1,284</h3>
                    </div>
                    <div class="stat-icon icon-blue">
                        <i class="fa-solid fa-users"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-info">
                        <p>Active Cases</p>
                        <h3>342</h3>
                    </div>
                    <div class="stat-icon icon-green">
                        <i class="fa-solid fa-file-waveform"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-info">
                        <p>Appointments Today</p>
                        <h3>28</h3>
                    </div>
                    <div class="stat-icon icon-purple">
                        <i class="fa-solid fa-calendar-day"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Cases -->
        <div class="recent-section">
            <h4>Recent Patient Cases</h4>
            <div class="table-responsive">
                <table class="table table-borderless align-middle">
                    <thead>
                        <tr>
                            <th>Patient Name</th>
                            <th>Case ID</th>
                            <th>Date</th>
                            <th>Diagnosis</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr style="border-bottom: 1px solid #f1f5f9;">
                            <td class="fw-bold">Sarah Jenkins</td>
                            <td class="text-muted">#CS-2941</td>
                            <td>Oct 24, 2026</td>
                            <td>Hypertension</td>
                            <td><span class="badge-status status-active">Active</span></td>
                            <td><button class="btn btn-sm btn-light">View</button></td>
                        </tr>
                        <tr style="border-bottom: 1px solid #f1f5f9;">
                            <td class="fw-bold">Michael Chen</td>
                            <td class="text-muted">#CS-2940</td>
                            <td>Oct 24, 2026</td>
                            <td>Routine Checkup</td>
                            <td><span class="badge-status status-active">Active</span></td>
                            <td><button class="btn btn-sm btn-light">View</button></td>
                        </tr>
                        <tr>
                            <td class="fw-bold">Emily Rodriguez</td>
                            <td class="text-muted">#CS-2939</td>
                            <td>Oct 23, 2026</td>
                            <td>Migraine Analysis</td>
                            <td><span class="badge-status status-pending">Pending Review</span></td>
                            <td><button class="btn btn-sm btn-light">View</button></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
