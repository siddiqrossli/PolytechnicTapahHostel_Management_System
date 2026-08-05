<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Apply for College</title>
    <style>
        body { font-family: Arial; padding: 20px; background: #f5f5f5; }
        .info-box { background: white; padding: 20px; border-radius: 10px; width: 50%; margin: auto; box-shadow: 0 0 10px #ccc; }
        .btn { padding: 10px 20px; background-color: #007bff; color: white; border: none; cursor: pointer; }
        .btn:hover { background-color: #0056b3; }
    </style>
</head>
<body>
<div class="info-box">
    <h2>Student Information</h2>
    <p><strong>Name:</strong> ${name}</p>
    <p><strong>ID:</strong> ${studentId}</p>
    <p><strong>Phone Number:</strong> ${phone}</p>
    <p><strong>Merit:</strong> ${merit}</p>
    <hr>
    <h3>Your merit is below 5.5. Please submit an appeal.</h3>
    <form action="SubmitAppealServlet" method="post">
        <label for="appealReason">Appeal Reason:</label><br>
        <textarea name="appealReason" rows="4" cols="50" required></textarea><br><br>
        <button type="submit" class="btn">Submit Appeal</button>
    </form>
</div>
</body>
</html>
