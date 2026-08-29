<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patients - Patient Case Management</title>
    
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
        .wrapper { display: flex; width: 100%; }

        /* Sidebar styles are in sidebar.jsp, but need basic layout here */
        #sidebar {
            min-width: 250px; max-width: 250px;
            background: var(--sidebar-bg); color: #fff;
            transition: all 0.3s; min-height: 100vh; padding-top: 20px; display: flex; flex-direction: column;
        }
        .sidebar-header { padding: 20px; border-bottom: 1px solid rgba(255,255,255,0.1); font-weight: 700; font-size: 1.2rem; display: flex; align-items: center; gap: 10px; }
        .sidebar-header .icon { background: var(--primary-blue); width: 32px; height: 32px; border-radius: 8px; display: flex; align-items: center; justify-content: center; }
        ul.components { padding: 20px 0; margin-bottom: 0; }
        ul.components li { padding: 5px 20px; }
        ul.components li a { color: rgba(255,255,255,0.7); text-decoration: none; display: flex; align-items: center; gap: 12px; padding: 10px 15px; border-radius: 8px; transition: all 0.3s; }
        ul.components li a:hover, ul.components li.active a { color: #fff; background: rgba(255,255,255,0.1); }
        ul.components li.active a { background: var(--primary-blue); }

        /* Main Content */
        #content { width: 100%; padding: 30px; }
        .top-navbar { background: #fff; padding: 15px 30px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.03); display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .user-profile { display: flex; align-items: center; gap: 10px; }
        .user-avatar { width: 40px; height: 40px; background: #e2e8f0; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: var(--primary-blue); font-weight: 700; }

        .content-card { background: #fff; border-radius: 16px; padding: 25px; box-shadow: 0 4px 20px rgba(0,0,0,0.02); }
    </style>
</head>
<body>

<div class="wrapper">
    <!-- Sidebar -->
    <jsp:include page="sidebar.jsp" />

    <!-- Page Content -->
    <div id="content">
        <div class="top-navbar">
            <h4 class="m-0 fw-bold" style="color: #1e293b;">Patients Directory</h4>
            <div class="user-profile">
                <div class="text-end me-2">
                    <div class="fw-bold" style="font-size: 0.9rem; color: #1e293b;">Welcome Back</div>
                    <div class="text-muted" style="font-size: 0.8rem;">Doctor / Admin</div>
                </div>
                <div class="user-avatar"><i class="fa-solid fa-user"></i></div>
            </div>
        </div>

        <div class="content-card">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5 class="m-0 fw-bold">All Patients</h5>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addPatientModal"><i class="fa-solid fa-plus me-2"></i>Add Patient</button>
            </div>
            
            <p class="text-muted">Search and manage your patient records here.</p>
            
            <div class="table-responsive mt-3">
                <table class="table table-hover" id="patientsTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Gender</th>
                            <th>Phone</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Populated by JS -->
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Add Patient Modal -->
<div class="modal fade" id="addPatientModal" tabindex="-1" aria-labelledby="addPatientModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title fw-bold" id="addPatientModalLabel">Add New Patient</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form id="addPatientForm">
            <div id="alertPlaceholder"></div>
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Full Name</label>
                    <input type="text" class="form-control" id="patientName" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Email (Used for Login)</label>
                    <input type="email" class="form-control" id="patientEmail" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Temporary Password</label>
                    <input type="password" class="form-control" id="patientPassword" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Phone Number</label>
                    <input type="text" class="form-control" id="patientPhone">
                </div>
                <div class="col-md-6">
                    <label class="form-label">Gender</label>
                    <select class="form-select" id="patientGender">
                        <option value="">Select Gender...</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Date of Birth</label>
                    <input type="date" class="form-control" id="patientDob">
                </div>
                <div class="col-12">
                    <label class="form-label">Address</label>
                    <textarea class="form-control" id="patientAddress" rows="2"></textarea>
                </div>
            </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-primary" id="savePatientBtn">Save Patient</button>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        loadPatients();

        document.getElementById('savePatientBtn').addEventListener('click', async function() {
            const btn = this;
            const form = document.getElementById('addPatientForm');
            if(!form.checkValidity()) {
                form.reportValidity();
                return;
            }

            btn.disabled = true;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>Saving...';
            
            const name = document.getElementById('patientName').value;
            const email = document.getElementById('patientEmail').value;
            const password = document.getElementById('patientPassword').value;
            
            const phone = document.getElementById('patientPhone').value;
            const gender = document.getElementById('patientGender').value;
            const dob = document.getElementById('patientDob').value;
            const address = document.getElementById('patientAddress').value;

            try {
                // Step 1: Register User
                const userParams = new URLSearchParams();
                userParams.append('name', name);
                userParams.append('email', email);
                userParams.append('password', password);
                userParams.append('role', 'PATIENT');
                
                const userRes = await fetch('${pageContext.request.contextPath}/api/users/register', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: userParams.toString()
                });
                
                if(!userRes.ok) throw new Error('Failed to create user account. Email might already exist.');
                const userData = await userRes.json();
                
                // Step 2: Create Patient Profile
                const profileRes = await fetch(`${pageContext.request.contextPath}/api/patients/user/` + userData.id, {
                    method: 'POST'
                });
                if(!profileRes.ok) throw new Error('Failed to create patient profile.');
                const profileData = await profileRes.json();
                
                // Step 3: Update Patient Details
                const updateRes = await fetch(`${pageContext.request.contextPath}/api/patients/` + profileData.id, {
                    method: 'PUT',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        phone: phone,
                        gender: gender,
                        dateOfBirth: dob ? dob : null,
                        address: address
                    })
                });
                
                if(!updateRes.ok) throw new Error('Failed to update patient details.');
                
                // Success
                document.getElementById('alertPlaceholder').innerHTML = '<div class="alert alert-success">Patient added successfully!</div>';
                setTimeout(() => {
                    var modal = bootstrap.Modal.getInstance(document.getElementById('addPatientModal'));
                    modal.hide();
                    form.reset();
                    document.getElementById('alertPlaceholder').innerHTML = '';
                    loadPatients();
                }, 1000);
                
            } catch (error) {
                document.getElementById('alertPlaceholder').innerHTML = '<div class="alert alert-danger">' + error.message + '</div>';
            } finally {
                btn.disabled = false;
                btn.innerHTML = 'Save Patient';
            }
        });
    });

    async function loadPatients() {
        try {
            const res = await fetch('${pageContext.request.contextPath}/api/patients');
            if(!res.ok) return;
            const patients = await res.json();
            const tbody = document.querySelector('#patientsTable tbody');
            tbody.innerHTML = '';
            
            if(patients.length === 0) {
                tbody.innerHTML = '<tr><td colspan="5" class="text-center text-muted py-4">No patients found.</td></tr>';
                return;
            }

            patients.forEach(p => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td>#PT-00` + p.id + `</td>
                    <td class="fw-bold">` + (p.user ? p.user.name : 'Unknown') + `</td>
                    <td>` + (p.gender || '-') + `</td>
                    <td>` + (p.phone || '-') + `</td>
                    <td><button class="btn btn-sm btn-outline-primary">Profile</button></td>
                `;
                tbody.appendChild(tr);
            });
        } catch(e) {
            console.error('Failed to load patients', e);
        }
    }
</script>
</body>
</html>
