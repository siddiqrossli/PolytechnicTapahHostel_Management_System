<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Update Profile</title>
  <link rel="stylesheet" href="style.css">
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
      <h2>Change E-mail</h2>
      <form action="ChangeEmailServlet" method="POST">
        <div class="form-group">
          <input type="email" name="newMail" placeholder="New E-Mail" required>
        </div>
        <div class="form-group">
          <input type="email" name="confirmMail" placeholder="Confirm E-Mail" required>
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