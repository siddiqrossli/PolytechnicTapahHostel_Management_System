<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Admin Dashboard - Add Room</title>
  <link rel="stylesheet" href="style.css" />
  <style>
    .form-container {
      background-color: rgba(137, 65, 66, 0.95);
      padding: 20px;
      border-radius: 10px;
      color: white;
      margin-bottom: 20px;
    }
    .form-group {
      margin-bottom: 15px;
    }
    .form-group label {
      display: block;
      margin-bottom: 5px;
      font-weight: bold;
    }
    .form-group input, .form-group select {
      width: 100%;
      padding: 10px;
      border-radius: 5px;
      border: none;
      background-color: #7a3a3a;
      color: white;
    }
    .form-buttons {
      display: flex;
      gap: 10px;
      margin-top: 20px;
    }
    .add-btn {
      background-color: #4CAF50;
      color: white;
      border: none;
      padding: 10px 20px;
      border-radius: 5px;
      cursor: pointer;
    }
    .cancel-btn {
      background-color: #f44336;
      color: white;
      border: none;
      padding: 10px 20px;
      border-radius: 5px;
      cursor: pointer;
    }
  </style>
</head>
<body>
  <header>
    <div class="logo">
      <img src="img/logo.png" alt="Logo" />
    </div>
    <button class="logout-btn">Log Out</button>
  </header>
  <div class="dashboard-container">
    <div class="sidebar">
      <div>
        <div class="student-card">
          <img src="img/student.png" alt="Profile" class="profile-pic" />
          <h3>AMEER FARHAN</h3>
          <p>206787</p>
          <p>Admin</p>
        </div>
        <button class="change-links button">VIEW MAINTENANCE</button>
        <button class="change-links button">VIEW STAFF</button>
        <button class="change-links button">VIEW STUDENT</button>
        <button class="change-links button active">VIEW ROOM</button>
        <button class="change-links button">VIEW BILLS</button>
      </div>
    </div>

    <div class="main-dashboard">
      <div class="welcome-box">
        <h1>Polytechnic Hostel</h1>
        
        <div class="form-container">
          <form action="AddRoomServlet" method="post">
            <div class="form-group">
              <label for="block-id">Block ID</label>
              <input type="text" id="block-id" name="blockId" placeholder="Enter Block ID">
            </div>
            <div class="form-group">
              <label for="room-id">Room ID</label>
              <input type="text" id="room-id" name="roomId" placeholder="Enter Room ID">
            </div>
            <div class="form-group">
              <label for="room-type">Room Type</label>
              <select id="room-type" name="roomType">
                <option value="">Select Room Type</option>
                <option value="single">Single</option>
                <option value="double">Double</option>
                <option value="quad">Quad</option>
              </select>
            </div>
            <div class="form-group">
              <label for="capacity">Room Capacity</label>
              <input type="number" id="capacity" name="capacity" placeholder="Enter Capacity">
            </div>
            <div class="form-buttons">
              <button type="submit" class="add-btn">Add</button>
              <button type="button" class="cancel-btn">Cancel</button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <div class="notice-panel">
      <h2>Notice</h2>
      <ul class="notice-list">
        <li>🎉 Events & Celebrations</li>
        <li>Cultural Day / Fest Notices</li>
        <li>Sports Day / E-Sports Tournament</li>
        <li>Freshers' Orientation Schedule</li>
        <li>Graduation Ceremony Details</li>
        <li>Student Club Recruitment / Open Day</li>
        <li>Photography / Art / Debate Competitions</li>
        <li>Personal Growth & Support</li>
        <li>Mental Health Awareness Events</li>
        <li>Motivational Quotes / "Student of the Week" Spotlight</li>
        <li>Counseling Sessions Schedule</li>
        <li>Time Management or Study Skills Workshops</li>
        <li>Language Exchange or Toastmasters Meetups</li>
      </ul>
    </div>
  </div>
  <footer>
    <hr />
    &copy; 2023 Titan Company
  </footer>
</body>
</html>