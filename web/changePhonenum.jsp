<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Update Profile - Change Phone Number</title>
  <link rel="stylesheet" href="style.css">
  <style>
    /* Add any additional styles you need here */
    .update-profile-container {
      max-width: 600px;
      margin: 0 auto;
      padding: 20px;
    }
    .form-box {
      background-color: #f9f9f9;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }
    .form-group {
      margin-bottom: 15px;
    }
    .form-group input {
      width: 100%;
      padding: 10px;
      border: 1px solid #ddd;
      border-radius: 4px;
      box-sizing: border-box;
    }
    .form-buttons {
      display: flex;
      gap: 10px;
      margin-top: 20px;
    }
    .save-btn, .cancel-btn {
      padding: 10px 20px;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }
    .save-btn {
      background-color: #4CAF50;
      color: white;
    }
    .cancel-btn {
      background-color: #f44336;
      color: white;
    }
    .button-group {
      display: flex;
      flex-direction: column;
      gap: 10px;
      margin-top: 20px;
    }
    .cprof-button {
      display: block;
      padding: 10px;
      text-align: center;
      background-color: #894142;
      color: white;
      text-decoration: none;
      border-radius: 4px;
    }
  </style>
</head>
<body>
  <header>
    <div class="logo">
      <img src="img/logo.png.png" alt="Polytechnic Logo">
    </div>
    <nav>
      <button class="logout-btn">Log Out</button>
    </nav>
  </header>

  <main class="update-profile-container">
    <div class="form-box">
      <h1>Polytechnic Hostel</h1>
      <h2>Change Phone Number</h2>
      <form action="ChangePhoneServlet" method="POST">
        <div class="form-group">
          <input type="tel" name="newPhoneNum" placeholder="New Phone Number" pattern="[0-9]{10,15}" required>
        </div>
        <div class="form-group">
          <input type="tel" name="confirmPhoneNum" placeholder="Confirm Phone Number" pattern="[0-9]{10,15}" required>
        </div>
        <div class="form-group">
          <input type="password" name="password" placeholder="Password" required>
        </div>
    
        <div class="form-buttons">
          <button type="submit" class="save-btn">Save</button>
          <button type="reset" class="cancel-btn">Cancel</button>
        </div>
      </form>

      <div class="button-group">
        <a href="change_password.jsp" class="cprof-button">Change Password</a>
        <a href="change_phonenum.jsp" class="cprof-button">Change Phone Number</a>
        <a href="change_mail.jsp" class="cprof-button">Change E-Mail</a>
      </div>
    </div>
  </main>
</body>
</html>