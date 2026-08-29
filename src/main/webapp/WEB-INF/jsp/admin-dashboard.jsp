<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Hospital Administration</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root { --primary-red: #dc2626; --bg-color: #f1f5f9; --sidebar-bg: #111827; --text-muted: #6b7280; }
        body { font-family: 'Inter', sans-serif; background-color: var(--bg-color); margin: 0; overflow-x: hidden; }
        .wrapper { display: flex; width: 100%; }
        
        #sidebar { min-width: 250px; max-width: 250px; background: var(--sidebar-bg); color: #fff; min-height: 100vh; padding-top: 20px; display: flex; flex-direction: column; }
        .sidebar-header { padding: 20px; border-bottom: 1px solid rgba(255,255,255,0.1); font-weight: 700; font-size: 1.1rem; display: flex; align-items: center; gap: 10px; }
        .sidebar-header .icon { background: var(--primary-red); width: 32px; height: 32px; border-radius: 8px; display: flex; align-items: center; justify-content: center; }
        ul.components { padding: 20px 0; margin-bottom: 0; }
        ul.components li { padding: 5px 20px; }
        ul.components li a { color: rgba(255,255,255,0.7); text-decoration: none; display: flex; align-items: center; gap: 12px; padding: 10px 15px; border-radius: 8px; transition: all 0.3s; }
        ul.components li a:hover, ul.components li.active a { color: #fff; background: rgba(255,255,255,0.1); }
        ul.components li.active a { background: var(--primary-red); }

        #content { width: 100%; padding: 30px; }
        .top-navbar { background: #fff; padding: 15px 30px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.03); display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        
        .nav-tabs .nav-link { color: var(--text-muted); font-weight: 500; border: none; padding: 12px 25px; border-radius: 8px; margin-right: 5px; }
        .nav-tabs .nav-link.active { background-color: var(--primary-red); color: white; }
        .nav-tabs { border-bottom: none; margin-bottom: 25px; }
        
        .content-card { background: #fff; border-radius: 16px; padding: 25px; box-shadow: 0 4px 20px rgba(0,0,0,0.02); }
        
        .badge-status { padding: 6px 12px; border-radius: 50px; font-weight: 500; font-size: 0.85rem; }
        .status-admitted { background: #fef9c3; color: #854d0e; }
        .status-discharged { background: #dcfce7; color: #166534; }
        
        .btn-primary { background-color: var(--primary-red); border-color: var(--primary-red); }
        .btn-primary:hover { background-color: #b91c1c; border-color: #b91c1c; }
    </style>
</head>
<body>

<div class="wrapper">
    <!-- Admin Sidebar -->
    <nav id="sidebar">
        <div class="sidebar-header">
            <div class="icon"><i class="fa-solid fa-shield-halved"></i></div>
            Admin Portal
        </div>
        <ul class="list-unstyled components">
            <li class="active"><a href="#"><i class="fa-solid fa-bed-pulse"></i> Admissions & Billing</a></li>
        </ul>
        <ul class="list-unstyled components" style="margin-top: auto; border-top: 1px solid rgba(255,255,255,0.1);">
            <li><a href="${pageContext.request.contextPath}/admin/login" style="color: #ef4444;"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></li>
        </ul>
    </nav>

    <!-- Page Content -->
    <div id="content">
        <div class="top-navbar">
            <h4 class="m-0 fw-bold" style="color: #111827;">Hospital Administration</h4>
            <div class="fw-bold" style="color: var(--primary-red);">Administrator</div>
        </div>

        <div class="content-card">
            <ul class="nav nav-tabs" id="adminTabs" role="tablist">
              <li class="nav-item">
                <button class="nav-link active" id="admit-tab" data-bs-toggle="tab" data-bs-target="#admit" type="button" role="tab">Admit Patient</button>
              </li>
              <li class="nav-item">
                <button class="nav-link" id="billing-tab" data-bs-toggle="tab" data-bs-target="#billing" type="button" role="tab">Billing & Release</button>
              </li>
            </ul>
            
            <div class="tab-content">
              <!-- Admit Patient Tab -->
              <div class="tab-pane fade show active" id="admit" role="tabpanel">
                  <div class="row">
                      <div class="col-md-5 border-end pe-4">
                          <h5 class="fw-bold mb-4">New Admission</h5>
                          <div id="admitAlert"></div>
                          <form id="admitForm">
                              <div class="mb-3">
                                  <label class="form-label">Select Patient</label>
                                  <select class="form-select" id="admitPatientId" required>
                                      <!-- Loaded via JS -->
                                  </select>
                              </div>
                              <div class="mb-3">
                                  <label class="form-label">Admission Type</label>
                                  <select class="form-select" id="admissionType" required>
                                      <option value="Emergency">Emergency</option>
                                      <option value="Scheduled">Scheduled</option>
                                      <option value="Elective">Elective</option>
                                  </select>
                              </div>
                              <div class="mb-3">
                                  <label class="form-label">Room / Bed Number</label>
                                  <input type="text" class="form-control" id="roomNumber" required placeholder="e.g. ICU-01, Ward A Bed 4">
                              </div>
                              <div class="mb-3">
                                  <label class="form-label">Reason for Admission / Diagnosis</label>
                                  <textarea class="form-control" id="reason" rows="2" placeholder="Primary reason for admission"></textarea>
                              </div>
                              <div class="mb-3">
                                  <label class="form-label">Condition upon Admission</label>
                                  <input type="text" class="form-control" id="condition" placeholder="e.g. Stable, Critical">
                              </div>
                              <div class="mb-3">
                                  <label class="form-label">Attending Doctor</label>
                                  <select class="form-select" id="doctorId">
                                      <!-- Loaded via JS -->
                                  </select>
                              </div>
                              <div class="mb-3">
                                  <label class="form-label">Dietary Requirements (Optional)</label>
                                  <input type="text" class="form-control" id="dietary" placeholder="e.g. Vegetarian, Low Sodium">
                              </div>
                              <button type="submit" class="btn btn-primary w-100">Admit Patient</button>
                          </form>
                      </div>
                      <div class="col-md-7 ps-4">
                          <h5 class="fw-bold mb-4">Currently Admitted Patients</h5>
                          <div class="table-responsive">
                              <table class="table table-hover" id="admittedTable">
                                  <thead>
                                      <tr>
                                          <th>Adm. ID</th>
                                          <th>Patient Name</th>
                                          <th>Room</th>
                                          <th>Adm. Date</th>
                                      </tr>
                                  </thead>
                                  <tbody>
                                      <!-- Loaded via JS -->
                                  </tbody>
                              </table>
                          </div>
                      </div>
                  </div>
              </div>
              
              <!-- Billing & Release Tab -->
              <div class="tab-pane fade" id="billing" role="tabpanel">
                  <div class="row">
                      <div class="col-md-5 border-end pe-4">
                          <h5 class="fw-bold mb-4">Generate Bill & Discharge</h5>
                          <div id="billAlert"></div>
                          <form id="billForm">
                              <div class="mb-3">
                                  <label class="form-label">Select Admitted Patient</label>
                                  <select class="form-select" id="billAdmissionId" required>
                                      <!-- Loaded via JS -->
                                  </select>
                              </div>
                              <div class="mb-3">
                                  <label class="form-label">Total Bill Amount ($)</label>
                                  <input type="number" class="form-control" id="billAmount" required min="0" step="0.01">
                              </div>
                              <button type="submit" class="btn btn-primary w-100">Generate Bill & Discharge</button>
                          </form>
                      </div>
                      <div class="col-md-7 ps-4">
                          <h5 class="fw-bold mb-4">Billing History</h5>
                          <div class="table-responsive">
                              <table class="table table-hover" id="billingTable">
                                  <thead>
                                      <tr>
                                          <th>Bill ID</th>
                                          <th>Patient</th>
                                          <th>Amount</th>
                                          <th>Status</th>
                                          <th>Action</th>
                                      </tr>
                                  </thead>
                                  <tbody>
                                      <!-- Loaded via JS -->
                                  </tbody>
                              </table>
                          </div>
                      </div>
                  </div>
              </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        loadData();
        
        // Handle Admit Form
        document.getElementById('admitForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            const btn = this.querySelector('button');
            btn.disabled = true;
            
            const patientId = document.getElementById('admitPatientId').value;
            const room = document.getElementById('roomNumber').value;
            const type = document.getElementById('admissionType').value;
            const reason = document.getElementById('reason').value;
            const condition = document.getElementById('condition').value;
            const dietary = document.getElementById('dietary').value;
            const doctorId = document.getElementById('doctorId').value;
            
            try {
                let url = `${pageContext.request.contextPath}/api/admissions/admit?patientId=` + patientId + 
                          '&roomNumber=' + encodeURIComponent(room) + 
                          '&admissionType=' + encodeURIComponent(type) + 
                          '&reason=' + encodeURIComponent(reason) + 
                          '&condition=' + encodeURIComponent(condition) + 
                          '&dietary=' + encodeURIComponent(dietary);
                if (doctorId) url += '&doctorId=' + doctorId;
                
                const res = await fetch(url, { method: 'POST' });
                if(res.ok) {
                    document.getElementById('admitAlert').innerHTML = '<div class="alert alert-success py-2">Patient successfully admitted!</div>';
                    this.reset();
                    loadData();
                    setTimeout(() => document.getElementById('admitAlert').innerHTML = '', 3000);
                } else {
                    throw new Error("Failed to admit");
                }
            } catch(e) {
                document.getElementById('admitAlert').innerHTML = '<div class="alert alert-danger py-2">Error admitting patient.</div>';
            }
            btn.disabled = false;
        });

        // Handle Bill & Discharge Form
        document.getElementById('billForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            const btn = this.querySelector('button');
            btn.disabled = true;
            
            const selectedOpt = document.getElementById('billAdmissionId').selectedOptions[0];
            const admissionId = selectedOpt.value;
            const patientId = selectedOpt.getAttribute('data-patient');
            const amount = document.getElementById('billAmount').value;
            
            try {
                // Generate Bill
                await fetch(`${pageContext.request.contextPath}/api/billing/create?patientId=` + patientId + `&admissionId=` + admissionId + `&amount=` + amount, { method: 'POST' });
                // Discharge Patient
                await fetch(`${pageContext.request.contextPath}/api/admissions/` + admissionId + `/discharge`, { method: 'POST' });
                
                document.getElementById('billAlert').innerHTML = '<div class="alert alert-success py-2">Bill generated and patient discharged!</div>';
                this.reset();
                loadData();
                setTimeout(() => document.getElementById('billAlert').innerHTML = '', 3000);
            } catch(e) {
                document.getElementById('billAlert').innerHTML = '<div class="alert alert-danger py-2">Error processing billing.</div>';
            }
            btn.disabled = false;
        });
    });

    async function loadData() {
        // 1. Load All Patients for Dropdown
        const pRes = await fetch('${pageContext.request.contextPath}/api/patients');
        const patients = await pRes.json();
        
        let pOptions = '<option value="">Select a patient...</option>';
        patients.forEach(p => {
            pOptions += `<option value="`+p.id+`">`+(p.user ? p.user.name : 'Unknown')+` (ID: #PT-`+p.id+`)</option>`;
        });
        document.getElementById('admitPatientId').innerHTML = pOptions;
        
        // 2. Load Doctors for Dropdown
        const docRes = await fetch('${pageContext.request.contextPath}/api/doctors');
        if(docRes.ok) {
            const doctors = await docRes.json();
            let dOptions = '<option value="">Select Attending Doctor (Optional)...</option>';
            doctors.forEach(d => {
                const name = d.user ? d.user.name : 'Unknown';
                const spec = d.specialization ? ' - ' + d.specialization : '';
                dOptions += `<option value="`+d.id+`">Dr. `+name+spec+`</option>`;
            });
            document.getElementById('doctorId').innerHTML = dOptions;
        }

        // 3. Load Active Admissions
        const aRes = await fetch('${pageContext.request.contextPath}/api/admissions/active');
        const admissions = await aRes.json();
        
        let aRows = '';
        let billOptions = '<option value="">Select admitted patient...</option>';
        
        admissions.forEach(a => {
            const date = new Date(a.admissionDate).toLocaleDateString();
            const pName = a.patient && a.patient.user ? a.patient.user.name : 'Unknown';
            aRows += `<tr><td>#ADM-`+a.id+`</td><td class="fw-bold">`+pName+`</td><td>`+a.roomNumber+`</td><td>`+date+`</td></tr>`;
            billOptions += `<option value="`+a.id+`" data-patient="`+a.patient.id+`">`+pName+` (Room: `+a.roomNumber+`)</option>`;
        });
        document.querySelector('#admittedTable tbody').innerHTML = aRows || '<tr><td colspan="4" class="text-center text-muted">No active admissions.</td></tr>';
        document.getElementById('billAdmissionId').innerHTML = billOptions;

        // 4. Load Billing History
        const bRes = await fetch('${pageContext.request.contextPath}/api/billing');
        const bills = await bRes.json();
        
        let bRows = '';
        bills.forEach(b => {
            const pName = b.patient && b.patient.user ? b.patient.user.name : 'Unknown';
            const statusBadge = b.status === 'PAID' ? '<span class="badge-status status-discharged">PAID</span>' : '<span class="badge-status status-admitted">UNPAID</span>';
            const actionBtn = b.status === 'UNPAID' ? `<button class="btn btn-sm btn-outline-success" onclick="payBill(`+b.id+`)">Mark Paid</button>` : `<button class="btn btn-sm btn-light" disabled>Paid</button>`;
            
            bRows += `<tr>
                <td>#INV-`+b.id+`</td>
                <td class="fw-bold">`+pName+`</td>
                <td>$`+b.amount.toFixed(2)+`</td>
                <td>`+statusBadge+`</td>
                <td>`+actionBtn+`</td>
            </tr>`;
        });
        document.querySelector('#billingTable tbody').innerHTML = bRows || '<tr><td colspan="5" class="text-center text-muted">No billing history.</td></tr>';
    }

    async function payBill(billId) {
        if(confirm('Are you sure you want to mark this bill as PAID?')) {
            await fetch(`${pageContext.request.contextPath}/api/billing/` + billId + `/pay`, { method: 'POST' });
            loadData();
        }
    }
</script>
</body>
</html>
