
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
import="java.util.List, techModel.jobAssigned" import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lappo Technician - Active Repairs</title>
    <!-- Load Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- Load Tailwind CSS for utility classes -->
    <script src="https://cdn.tailwindcss.com"></script>
    
    <link rel="stylesheet" href="CSS/AllTechnicianCSS.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    
    
</head>
<body>
    <div class="admin-wrapper">
        <% String technicianName = (String) session.getAttribute("username"); %>
        
        <!-- SIDEBAR -->
        <nav class="sidebar">
            <div class="sidebar-header">
               <i class="fas fa-laptop"></i> <p>Welcome, <span><%= technicianName %></span></p>
            </div>
            
            <div class="sidebar-nav">
                 <a href="jobController" >
                    <i class="fas fa-chart-pie"></i> <span>Dashboard</span>
                </a>
                <a href="jobServlet" class="active">
                    <i class="fas fa-wrench"></i> <span>Job</span>
                </a>
                <a href="requestPart">
                    <i class="fas fa-boxes"></i> <span>Request</span>
                </a>
                <a href="techUpdate">
                    <i class="fas fa-user-circle"></i> <span>Profile</span>
                </a>
            </div>

            <div class="sidebar-footer">
                <button class="btn-logout" onclick="window.location.href='index.html'">
                    <i class="fas fa-sign-out-alt"></i> <span>Logout</span>
                </button>
            </div>
        </nav>

        <!-- MAIN CONTENT -->
        <main class="main-content">
            
            <!-- Header -->
            <header class="top-header">
                <h1>Assigned Job</h1>
                 <div class="user-profile" onclick="window.location.href='technicianProfile.jsp'">
                    <i class="far fa-bell" style="font-size: 1.2em; color: var(--light-text-color); cursor: pointer; margin-right: 15px;" onclick="event.stopPropagation()"></i>
                    <div class="avatar-circle"><i class="fas fa-user"></i></div>
                </div>
            </header>

            <div id="app-container">
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                    <!-- Left Column: Job List -->
                    <div class="lg:col-span-1">
                        <div class="panel">
                            <h2 class="text-xl font-semibold text-indigo-600 mb-4 flex justify-between items-center">
                                Active Repair Jobs
                            </h2>
                            <div id="job-list" class="scrollable-list space-y-3">
                            
                            
                                <!-- Job items will be rendered here by JavaScript -->
                                <div class="text-center text-gray-400 p-4 border border-dashed rounded-lg">
                                    Loading jobs...
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Right Column: Detail & Update Panel -->
                    <div class="lg:col-span-2">
                        <div id="detail-panel" class="panel min-h-[300px]">
                            <h2 class="text-2xl font-bold text-gray-800 mb-6 border-b pb-3" id="detail-title">Select a Job to View Details</h2>

                            <form  action="jobServlet" method="post" id="update-form" onsubmit="return confirmUpdate(event);" >
                           
                            
                                <input type="hidden" id="job-doc-id" name="RepairID">
                                
                                <div class="space-y-4">
                                    <div>
                                        <p class="text-sm font-medium text-gray-500">Job ID:</p>
                                        <p class="text-lg font-semibold text-gray-900" id="detail-job-id"></p>
                                    </div>
                                    
                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                        <div>
                                            <p class="text-sm font-medium text-gray-500">Owner Name:</p>
                                            <p class="font-semibold text-gray-900" id="detail-customer-name"></p>
                                        </div>
                                        <div>
                                            <p class="text-sm font-medium text-gray-500">Owner Email:</p>
                                            <p class="font-semibold text-gray-900" id="detail-email"></p>
                                        </div>
                                        <div>
                                            <p class="text-sm font-medium text-gray-500">Laptop Model:</p>
                                            <p class="font-semibold text-gray-900" id="detail-model"></p>
                                        </div>
                                        <div>
                                            <p class="text-sm font-medium text-gray-500">Serial Number:</p>
                                            <p class="font-semibold text-gray-900" id="detail-serial"></p>
                                        </div>
                                    </div>
                                    
                                    <div class="border-t pt-4">
                                        <p class="text-sm font-medium text-gray-500">Date Issued:</p>
                                        <p class="font-semibold text-gray-900" id="detail-date-issued"></p>
                                    </div>

                                    <div class="border-t pt-4">
                                        <p class="text-sm font-medium text-gray-500">User's Note / Reported Problem:</p>
                                        <div id="detail-user-note" class="bg-gray-50 p-3 rounded-md text-gray-800 border border-gray-200"></div>
                                    </div>
                                </div>
                                
                                 <!--    //Details change -->

                                <div class="border-t pt-6"  id="currentStatus">
                                    <label for="currentStatus" class="block text-sm font-medium text-gray-700 mb-1">Update Repair Status</label>

                                     <select id="currentStatus" name="currentStatus" class="mt-1 block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-md shadow-sm">
                                        <option value="Pending Diagnosis">Pending Diagnosis</option>
                                        <option value="Diagnosing">In Progress</option>
                                        <option value="Awaiting">Awaiting Customer Approval</option>
                                        <option value="Awaiting Parts">Awaiting Parts</option>
                                        <option value="Repairing">Repairing</option>
                                        <option value="Ready">Ready for Collection</option>
                                        <option value="Complete">Complete / Collected</option>
                                    </select>
                                </div>
                                <div>
                                    <label for="remarks" class="block text-sm font-medium text-gray-700 mb-1">Technician Remarks (Problems found, repairs, testing)</label>
                                    <textarea id="remarks" name="remarks" rows="6" class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 mt-1 block w-full sm:text-sm border border-gray-300 rounded-md p-3" placeholder="Describe the issue, the fix, and any notes for the customer..."></textarea>
                                </div>
						 
                                <div class="flex justify-end">
                                    <input type="submit" name="Submit" value="Save Changes" class="w-full sm:w-auto bg-indigo-600 hover:bg-indigo-700 text-white font-medium py-2 px-6 rounded-lg shadow-md transition duration-150">
                            
                                </div>
                                <p id="save-message" class="text-sm text-center font-medium h-4"></p>
                            </form> 

                            <div id="no-job-selected" class="text-center p-12 text-gray-400">
                                ← Please select a job from the list to see its current status and update the technician remarks.
                            </div>
                        </div>
                    </div>
                </div>
            </div>         
        </main>
    </div>
    

    <script type="text/javascript">
    // Convert server-side repairJobs list to a JS object
    const jobDocs = {
        <% 
            List<jobAssigned> repairJobsList = (List<jobAssigned>) session.getAttribute("repairJobs");
            
            if (repairJobsList != null && !repairJobsList.isEmpty()) {
                for (int i = 0; i < repairJobsList.size(); i++) {
                	jobAssigned job = repairJobsList.get(i);
        %>
        "<%= job.getRepairID() %>": {
            jobId: "<%=  job.getRepairID() %>",
            customerName: "<%= job.getUserName() %>",
            customerEmail: "<%= job.getEmail() %>",
            laptopModel: "<%= job.getLaptopModel() %>",
            serialNumber: "<%= job.getSerialNumber() %>",
            userNote: "<%= job.getUserNote() %>", 
            currentStatus: "<%= job.getCurrentStatus() %>",
            remarks: "<%= job.getRemarks() %>", 
            dateIssued: <%= job.getDateIssued() != null ? job.getDateIssued().getTime() : "null" %>,
            timestamp: Date.now()
        }<%= (i < repairJobsList.size() - 1) ? "," : "" %>
        <%      }
            }
        %>
    };

        let selectedJob = null;
        window.onload = function () {
            document.getElementById("detail-panel").style.display = "none"; // hide by default
        };
        
        function getStatusColor(status) {
            switch (status) {
                case 'Complete / Collected': return 'bg-green-100 text-green-800';
                case 'Ready for Collection': return 'bg-teal-100 text-teal-800';
                case 'Repairing': return 'bg-yellow-100 text-yellow-800';
                case 'Awaiting Customer Approval':
                case 'Awaiting Parts': return 'bg-red-100 text-red-800';
                default: return 'bg-blue-100 text-blue-800';
            }
        }

        function renderJobList() {
            const jobListElement = document.getElementById('job-list');
            if(!jobListElement) return;

            jobListElement.innerHTML = '';
            const jobIds = Object.keys(jobDocs);

            if (jobIds.length === 0) {
                jobListElement.innerHTML = `
                    <div class="text-center text-gray-400 p-4 border border-dashed rounded-lg">
                        No repair jobs found in the database.
                    </div>`;
                return;
            }

            jobIds.forEach(jobId => {
                const data = jobDocs[jobId];
                const statusClass = getStatusColor(data.currentStatus);
                const jobItem = document.createElement('div');
                
                const isSelected = selectedJob && selectedJob.jobId === data.jobId;
                const baseClass = 'p-3 rounded-lg cursor-pointer transition duration-150 hover:bg-gray-100 ';
                const selectedClass = 'bg-indigo-100 border-2 border-indigo-500';
                const unselectedClass = 'bg-gray-50 border border-gray-200';
                
                jobItem.className = baseClass + (isSelected ? selectedClass : unselectedClass);
                
                jobItem.setAttribute('data-job-id', data.jobId);
                jobItem.onclick = () => selectJob(data.jobId);

                jobItem.innerHTML = `
                    <p class="font-semibold text-gray-800 text-sm">\${data.jobId}</p>
                    <p class="text-xs text-gray-500 truncate">\${data.customerName} - \${data.laptopModel}</p>
                    <span class="inline-block mt-1 text-xs font-medium px-2.5 py-0.5 rounded-full \${statusClass}">\${data.currentStatus}</span>
                `;
                jobListElement.appendChild(jobItem);
            });
        }
        
        function selectJob(jobId) {
            const data = jobDocs[jobId];
            if (!data) return;

            selectedJob = data;
            renderDetailPanel(data);
            renderJobList(); 
        }

        function renderDetailPanel(data) {
        	document.getElementById("detail-panel").style.display = "block";
        	
            document.getElementById('detail-title').textContent = 'Details for Job: ' + data.jobId;
            document.getElementById('no-job-selected').classList.add('hidden');
            document.getElementById('update-form').classList.remove('hidden');

            document.getElementById('job-doc-id').value = data.jobId;
            document.getElementById('detail-job-id').textContent = data.jobId || 'N/A';
            document.getElementById('detail-customer-name').textContent = data.customerName || 'N/A';
            document.getElementById('detail-email').textContent = data.customerEmail || 'N/A';
            document.getElementById('detail-model').textContent = data.laptopModel || 'N/A';
            document.getElementById('detail-serial').textContent = data.serialNumber || 'N/A';
            document.getElementById('detail-user-note').textContent = data.userNote || 'No note provided by user.';
            
            const date = data.dateIssued ? new Date(data.dateIssued) : null;
            document.getElementById('detail-date-issued').textContent = date ? date.toLocaleDateString() + ' at ' + date.toLocaleTimeString() : 'N/A';

            document.getElementById('currentStatus').value = data.currentStatus || 'N/A' ;
            document.getElementById('remarks').textContent= data.remarks || 'N/A';
        }

        // Use standard function definition for event handler to avoid any scope issues
        const updateForm = document.getElementById('update-form');
        if(updateForm) {
            updateForm.addEventListener('submit', function(e) {
                const docId = document.getElementById('job-doc-id').value;
                const status = document.getElementById('currentStatus').value;
                const remarks = document.getElementById('remarks').value;
                const saveMessage = document.getElementById('save-message');

                if (jobDocs[docId]) {
                    jobDocs[docId].currentStatus = status;
                    jobDocs[docId].remarks = remarks;
                    jobDocs[docId].timestamp = Date.now();
                    selectedJob = jobDocs[docId];
                    
                    renderJobList();
                    
                    
                    setTimeout(() => saveMessage.textContent = '', 3000);
                } else {
                    saveMessage.className = 'text-sm text-center font-medium h-4 text-red-600';
                    saveMessage.textContent = 'Error: Job not found.';
                }
            });
        }

        function initApp() {
            renderJobList();
        }
        
        function confirmUpdate(event) {
            event.preventDefault(); // stop form first

            Swal.fire({
                title: 'Confirm Update',
                text: 'Are you sure you want to update this repair record?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Yes, update it',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    event.target.submit(); // submit form
                }
            });
        }

        document.addEventListener('DOMContentLoaded', initApp);
    </script>
</body>
</html>