<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Staff Registration</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .container {
            width: 500px;
            margin: 50px auto;
            border: 1px solid #ccc;
            padding: 20px;
            box-shadow: 2px 2px 5px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }
        label {
            display: inline-block;
            width: 180px; /* Adjust as needed */
            margin-right: 10px;
            text-align: right;
            font-weight: bold;
        }
        input[type="text"],
        input[type="password"],
        input[type="email"], /* Added for staff email */
        input[type="number"],
        select {
            flex: 1; /* Allow input to take remaining space */
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .submit-button {
            display: block;
            width: 150px;
            margin: 20px auto 0;
            padding: 10px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        .submit-button:hover {
            background-color: #0056b3;
        }
        .error-message {
            color: red;
            text-align: center;
            margin-bottom: 15px;
        }
        .success-message {
            color: green;
            text-align: center;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Staff Registration</h2>

    <%-- Show error or success message if set --%>
    <c:if test="${not empty error}">
        <div class="error-message">${error}</div>
    </c:if>
    <c:if test="${not empty message}">
        <div class="success-message">${message}</div>
    </c:if>

    <%-- Form action now points to the StaffRegisterServlet --%>
    <form action="staffRegister" method="post">
        <div class="form-group">
            <label for="staffID">Staff ID:</label>
            <input type="text" name="staffID" id="staffID" required />
        </div>
        <div class="form-group">
            <label for="staffPassword">Password:</label>
            <input type="password" name="staffPassword" id="staffPassword" required />
        </div>
        <div class="form-group">
            <label for="staffName">Full Name:</label>
            <input type="text" name="staffName" id="staffName" required />
        </div>
        <div class="form-group">
            <label for="staffNumber">Phone Number:</label>
            <input type="text" name="staffNumber" id="staffNumber" required />
        </div>
        <div class="form-group">
            <label for="staffEmail">Email:</label>
            <input type="email" name="staffEmail" id="staffEmail" required />
        </div>
        <div class="form-group">
            <label for="staffPosition">Position:</label>
            <input type="text" name="staffPosition" id="staffPosition" required />
        </div>

        <div class="form-group">
            <button type="submit" class="submit-button">Register Staff</button>
        </div>
    </form>
</div>

</body>
</html>