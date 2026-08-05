<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Staff Login</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            background-color: #fce8e6;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            overflow: auto;
            padding: 0px;
        }

        .login-container {
            background-color: #ffffff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 3px 8px rgba(0, 0, 0, 0.08);
            width: 100%;
            max-width: 370px;
            text-align: center;
        }

        h1 {
            color: #8b0000;
            font-size: 26px;
            margin-bottom: 8px;
        }

        h2 {
            color: #8b0000;
            font-size: 20px;
            margin: 15px 0 10px;
        }

        .welcome-text {
            font-size: 14px;
            color: #333;
            margin-bottom: 12px;
        }

        .roles-section {
            margin: 12px 0 20px;
            border-top: 1px solid #f5c9c9;
            border-bottom: 1px solid #f5c9c9;
            padding: 12px 0;
            display: flex;
            justify-content: center;
            gap: 15px;
        }

        .role-button {
            background-color: #fdf2f1;
            border: 1px solid #8b0000;
            color: #8b0000;
            padding: 10px 15px;
            border-radius: 6px;
            font-size: 13px;
            text-decoration: none;
            font-weight: bold;
            display: inline-flex;
            flex-direction: column;
            align-items: center;
            transition: all 0.3s ease;
            width: 100px;
            box-sizing: border-box;
        }

        .role-button:hover {
            background-color: #8b0000;
            color: white;
        }

        .role-button img {
            width: 25px;
            height: 25px;
            margin-bottom: 4px;
            object-fit: contain;
        }

        .role-button.active {
            background-color: #8b0000;
            color: white;
        }

        .role-button.active img {
            filter: brightness(0) invert(1);
        }

        form {
            text-align: left;
        }

        .form-group {
            margin-bottom: 12px;
        }

        label {
            display: block;
            margin-bottom: 4px;
            font-weight: bold;
            color: #333;
            font-size: 14px;
        }

        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
        }

        .button-group {
            text-align: center;
            margin-top: 16px;
        }

        input[type="submit"] {
            background-color: #8b0000;
            color: white;
            border: none;
            padding: 8px 20px;
            font-size: 14px;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #a51414;
        }

        .error-message {
            background-color: #ffd6d6;
            color: #b30000;
            border: 1px solid #ffcccc;
            padding: 8px;
            border-radius: 5px;
            margin-bottom: 12px;
            text-align: center;
            font-size: 14px;
        }

        .create-account-link {
            margin-top: 16px;
            font-size: 13px;
        }

        .create-account-link a {
            color: #8b0000;
            text-decoration: none;
        }

        .create-account-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="login-container">
    <h1>Polytechnic Hostel</h1>
    <p class="welcome-text">Welcome back</p>
    <p class="welcome-text">Please enter your details to sign in as staff.</p>

    <div class="roles-section">
        <a href="login.jsp" class="role-button">
            <img src="img/student.png" alt="Student Icon">
            Student
        </a>
        <a href="staffLogin.jsp" class="role-button active">
            <img src="img/staff.png" alt="Staff Icon">
            Staff
        </a>
    </div>

    <h2>Staff Login</h2>

    <c:if test="${not empty requestScope.error}">
        <div class="error-message">
            ${requestScope.error}
        </div>
    </c:if>

    <form action="staffLogin" method="post">
        <div class="form-group">
            <label for="staffId">Staff ID:</label>
            <input type="text" id="staffId" name="staffId" required>
        </div>
        <div class="form-group">
            <label for="staffPassword">Password:</label>
            <input type="password" id="staffPassword" name="staffPassword" required>
        </div>
        <div class="button-group">
            <input type="submit" value="Login">
        </div>
    </form>
</div>

</body>
</html>