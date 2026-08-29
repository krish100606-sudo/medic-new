<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings - Patient Case Management</title>
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
        
        .nav-tabs .nav-link { color: var(--text-muted); font-weight: 500; border: none; padding: 10px 20px; border-radius: 8px; margin-right: 5px; }
        .nav-tabs .nav-link.active { background-color: var(--primary-blue); color: white; }
        .nav-tabs { border-bottom: none; margin-bottom: 25px; }
    </style>
</head>
<body>
<div class="wrapper">
    <jsp:include page="sidebar.jsp" />
    <div id="content">
        <div class="top-navbar">
            <h4 class="m-0 fw-bold" style="color: #1e293b;">Settings</h4>
            <div class="user-profile">
                <div class="text-end me-2"><div class="fw-bold" style="font-size: 0.9rem; color: #1e293b;">Welcome Back</div><div class="text-muted" style="font-size: 0.8rem;">Doctor / Admin</div></div>
                <div class="user-avatar"><i class="fa-solid fa-user"></i></div>
            </div>
        </div>
        <div class="content-card">
            <ul class="nav nav-tabs" id="myTab" role="tablist">
              <li class="nav-item" role="presentation">
                <button class="nav-link active" id="profile-tab" data-bs-toggle="tab" data-bs-target="#profile" type="button" role="tab" aria-controls="profile" aria-selected="true">Profile</button>
              </li>
              <li class="nav-item" role="presentation">
                <button class="nav-link" id="security-tab" data-bs-toggle="tab" data-bs-target="#security" type="button" role="tab" aria-controls="security" aria-selected="false">Security</button>
              </li>
              <li class="nav-item" role="presentation">
                <button class="nav-link" id="notifications-tab" data-bs-toggle="tab" data-bs-target="#notifications" type="button" role="tab" aria-controls="notifications" aria-selected="false">Notifications</button>
              </li>
            </ul>
            <div class="tab-content" id="myTabContent">
              <div class="tab-pane fade show active" id="profile" role="tabpanel" aria-labelledby="profile-tab">
                  <h5 class="fw-bold mb-4">Profile Settings</h5>
                  <form>
                      <div class="row g-3 mb-3">
                          <div class="col-md-6">
                              <label class="form-label text-muted">First Name</label>
                              <input type="text" class="form-control" value="Doctor">
                          </div>
                          <div class="col-md-6">
                              <label class="form-label text-muted">Last Name</label>
                              <input type="text" class="form-control" value="Admin">
                          </div>
                      </div>
                      <div class="mb-3">
                          <label class="form-label text-muted">Email Address</label>
                          <input type="email" class="form-control" value="doctor@example.com">
                      </div>
                      <button type="submit" class="btn btn-primary px-4">Save Changes</button>
                  </form>
              </div>
              <div class="tab-pane fade" id="security" role="tabpanel" aria-labelledby="security-tab">
                  <h5 class="fw-bold mb-4">Security Settings</h5>
                  <form>
                      <div class="mb-3">
                          <label class="form-label text-muted">Current Password</label>
                          <input type="password" class="form-control">
                      </div>
                      <div class="mb-3">
                          <label class="form-label text-muted">New Password</label>
                          <input type="password" class="form-control">
                      </div>
                      <div class="mb-3">
                          <label class="form-label text-muted">Confirm New Password</label>
                          <input type="password" class="form-control">
                      </div>
                      <button type="submit" class="btn btn-primary px-4">Update Password</button>
                  </form>
              </div>
              <div class="tab-pane fade" id="notifications" role="tabpanel" aria-labelledby="notifications-tab">
                  <h5 class="fw-bold mb-4">Notification Preferences</h5>
                  <div class="form-check form-switch mb-3">
                      <input class="form-check-input" type="checkbox" id="emailNotif" checked>
                      <label class="form-check-label" for="emailNotif">Email Notifications</label>
                  </div>
                  <div class="form-check form-switch mb-3">
                      <input class="form-check-input" type="checkbox" id="smsNotif">
                      <label class="form-check-label" for="smsNotif">SMS Notifications</label>
                  </div>
                  <button type="button" class="btn btn-primary px-4">Save Preferences</button>
              </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
