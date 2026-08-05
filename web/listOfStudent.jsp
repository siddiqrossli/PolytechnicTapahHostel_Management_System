<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Admin Dashboard - Students</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
  <style>
   .welcome-box {
      background: #c85454;
      border-radius: 20px;
      color: white;
      padding: 25px;
      min-height: 75vh;
      display: flex;
      flex-direction: column;
      box-shadow: 0 0 15px rgba(0,0,0,0.2);
    }
    
    .table-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 15px;
      flex-wrap: wrap;
      gap: 15px;
    }
    
    .title-container {
      display: flex;
      align-items: center;
      gap: 15px;
    }
    
    .search-container {
      display: flex;
      gap: 10px;
      align-items: center;
    }
    
    .search-input {
      padding: 8px 15px;
      border-radius: 20px;
      border: none;
      background-color: #7a3a3a;
      color: white;
      width: 200px;
    }
    
    .search-button {
      background-color: #894142;
      color: white;
      border: none;
      padding: 8px 15px;
      border-radius: 20px;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    
    .filter-buttons {
      display: flex;
      gap: 8px;
      margin-bottom: 15px;
    }
    
    .filter-btn {
      background-color: #894142;
      color: white;
      border: none;
      padding: 6px 12px;
      border-radius: 15px;
      cursor: pointer;
      font-size: 0.9em;
    }
    
    .filter-btn.active {
      background-color: #4CAF50;
    }
    
    .action-buttons {
      display: flex;
      gap: 10px;
    }
    
    .action-btn {
      background-color: #2196F3;
      color: white;
      border: none;
      padding: 8px 15px;
      border-radius: 20px;
      cursor: pointer;
      font-weight: bold;
      font-size: 0.9em;
    }
    
    .export-btn {
      background-color: #FF9800;
    }
    
    .table-scroll-container {
      overflow-y: auto;
      max-height: 55vh;
      margin-top: 15px;
      border-radius: 10px;
      flex-grow: 1;
    }
    
    table {
      width: 100%;
      border-collapse: collapse;
      background-color: rgba(137, 65, 66, 0.95);
      color: white;
    }
    
    th, td {
      padding: 12px 15px;
      text-align: left;
      border-bottom: 1px solid #7a3a3a;
    }
    
    th {
      background-color: #7a3a3a;
      position: sticky;
      top: 0;
      font-weight: bold;
    }
    
    tr:hover {
      background-color: rgba(122, 58, 58, 0.5);
    }
    
    .status-approved {
      color: #4CAF50;
      font-weight: bold;
    }
    
    .status-not-approved {
      color: #f44336;
      font-weight: bold;
    }
    
    .status-pending {
      color: #FFC107;
      font-weight: bold;
    }
    
    .merit-high {
      color: #4CAF50;
    }
    
    .merit-medium {
      color: #FFC107;
    }
    
    .merit-low {
      color: #f44336;
    }
    
    .action-cell {
      display: flex;
      gap: 8px;
    }
    
    .icon-btn {
      background: none;
      border: none;
      color: white;
      cursor: pointer;
      padding: 5px;
      border-radius: 50%;
      width: 30px;
      height: 30px;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    
    .icon-btn:hover {
      background-color: rgba(255,255,255,0.1);
    }
    
    .edit-btn {
      color: #2196F3;
    }
    
    .delete-btn {
      color: #f44336;
    }
    
    .view-btn {
      color: #4CAF50;
    }
  </style>
</head>
<body>
  <header>
    <div class="logo">
      <img src="${pageContext.request.contextPath}/img/logo.png" alt="Logo" />
    </div>
    <button class="logout-btn" onclick="window.location.href='${pageContext.request.contextPath}/LogoutServlet'">Log Out</button>
  </header>
  <div class="dashboard-container">
    <div class="sidebar">
      <div>
        <div class="student-card">
          <img src="${pageContext.request.contextPath}/img/student.png" alt="Profile" class="profile-pic" />
          <h3>${sessionScope.user.name}</h3>
          <p>${sessionScope.user.id}</p>
          <p>${sessionScope.user.role}</p>
        </div>
        <button class="change-links button" onclick="window.location.href='maintenance.jsp'">VIEW MAINTENANCE</button>
        <button class="change-links button" onclick="window.location.href='staff.jsp'">VIEW STAFF</button>
        <button class="change-links button active" onclick="window.location.href='student.jsp'">VIEW STUDENT</button>
        <button class="change-links button" onclick="window.location.href='room.jsp'">VIEW ROOM</button>
        <button class="change-links button" onclick="window.location.href='bills.jsp'">VIEW BILLS</button>
      </div>
    </div>

    <div class="main-dashboard">
      <div class="welcome-box">
        <div class="table-header">
          <div class="title-container">
            <h2 class="table-title">Student List</h2>
            <button class="action-btn" onclick="window.location.href='addStudent.jsp'">Add Student</button>
          </div>
          
          <form class="search-container" action="StudentServlet" method="GET">
            <input type="text" name="searchQuery" placeholder="Search students..." class="search-input">
            <button type="submit" class="search-button">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="11" cy="11" r="8"></circle>
                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
              </svg>
            </button>
          </form>
        </div>
        
        <div class="filter-buttons">
          <button class="filter-btn ${empty param.filter || param.filter eq 'all' ? 'active' : ''}" 
                  onclick="window.location.href='student.jsp?filter=all'">All Students</button>
          <button class="filter-btn ${param.filter eq 'approved' ? 'active' : ''}" 
                  onclick="window.location.href='student.jsp?filter=approved'">Approved</button>
          <button class="filter-btn ${param.filter eq 'pending' ? 'active' : ''}" 
                  onclick="window.location.href='student.jsp?filter=pending'">Pending</button>
          <button class="filter-btn ${param.filter eq 'not-approved' ? 'active' : ''}" 
                  onclick="window.location.href='student.jsp?filter=not-approved'">Not Approved</button>
          <button class="filter-btn ${param.filter eq 'with-room' ? 'active' : ''}" 
                  onclick="window.location.href='student.jsp?filter=with-room'">With Room</button>
          <button class="filter-btn ${param.filter eq 'without-room' ? 'active' : ''}" 
                  onclick="window.location.href='student.jsp?filter=without-room'">Without Room</button>
        </div>
        
        <div class="table-scroll-container">
          <table>
            <thead>
              <tr>
                <th>Student ID</th>
                <th>Name</th>
                <th>Block</th>
                <th>Room</th>
                <th>Merit</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="student" items="${studentList}">
                <tr>
                  <td>${student.studentId}</td>
                  <td>${student.name}</td>
                  <td>${not empty student.block ? student.block : '-'}</td>
                  <td>${not empty student.room ? student.room : '-'}</td>
                  <td class="
                    ${student.merit >= 15 ? 'merit-high' : 
                      (student.merit >= 8 ? 'merit-medium' : 'merit-low')}">
                    ${student.merit}
                  </td>
                  <td class="
                    ${student.status eq 'APPROVED' ? 'status-approved' : 
                      (student.status eq 'PENDING' ? 'status-pending' : 'status-not-approved')}">
                    ${student.status}
                  </td>
                  <td class="action-cell">
                    <button class="icon-btn view-btn" title="View" 
                            onclick="window.location.href='StudentServlet?action=view&id=${student.studentId}'">
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                        <circle cx="12" cy="12" r="3"></circle>
                      </svg>
                    </button>
                    <button class="icon-btn edit-btn" title="Edit" 
                            onclick="window.location.href='StudentServlet?action=edit&id=${student.studentId}'">
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                      </svg>
                    </button>
                    <c:if test="${student.status ne 'APPROVED'}">
                      <button class="icon-btn delete-btn" title="Delete" 
                              onclick="if(confirm('Are you sure you want to delete this student?')) { 
                                window.location.href='StudentServlet?action=delete&id=${student.studentId}' 
                              }">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                          <path d="M3 6h18"></path>
                          <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                        </svg>
                      </button>
                    </c:if>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <div class="notice-panel">
      <h2>Notice</h2>
      <ul class="notice-list">
        <c:forEach var="notice" items="${notices}">
          <li>${notice}</li>
        </c:forEach>
      </ul>
    </div>
  </div>
  <footer>
    <hr />
    &copy; 2023 Titan Company
  </footer>
</body>
</html>