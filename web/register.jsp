<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Student Registration</title>
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

        .register-container {
            background-color: #ffffff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 3px 8px rgba(0, 0, 0, 0.08);
            width: 100%;
            max-width: 500px;
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
            margin: 15px 0 20px;
        }

        .welcome-text {
            font-size: 14px;
            color: #333;
            margin-bottom: 20px;
        }

        form {
            text-align: left;
        }

        .form-group {
            margin-bottom: 15px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
            font-size: 14px;
        }

        input[type="text"],
        input[type="password"],
        input[type="number"],
        select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            box-sizing: border-box;
        }

        .button-group {
            text-align: center;
            margin-top: 25px;
        }

        button[type="submit"] {
            background-color: #8b0000;
            color: white;
            border: none;
            padding: 10px 25px;
            font-size: 15px;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button[type="submit"]:hover {
            background-color: #a51414;
        }

        .error-message {
            background-color: #ffd6d6;
            color: #b30000;
            border: 1px solid #ffcccc;
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 20px;
            text-align: center;
            font-size: 14px;
        }

        .success-message {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 20px;
            text-align: center;
            font-size: 14px;
        }

        .login-link {
            margin-top: 20px;
            font-size: 14px;
            text-align: center;
        }

        .login-link a {
            color: #8b0000;
            text-decoration: none;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        /* Two-column layout for form groups */
        .form-row {
            display: flex;
            gap: 15px;
        }

        .form-col {
            flex: 1;
        }
    </style>
</head>
<body>

<div class="register-container">
    <h1>Polytechnic Hostel</h1>
    <h2>Student Registration</h2>
    <p class="welcome-text">Create your student account to apply for hostel accommodation</p>

    <c:if test="${not empty requestScope.error}">
        <div class="error-message">${requestScope.error}</div>
    </c:if>
    
    <c:if test="${not empty requestScope.message}">
        <div class="success-message">${requestScope.message}</div>
    </c:if>

    <form action="RegisterServlet" method="post">
        <div class="form-row">
            <div class="form-col">
                <div class="form-group">
                    <label for="studentId">Student ID</label>
                    <input type="text" name="studentId" id="studentId" required />
                </div>
            </div>
            <div class="form-col">
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" name="password" id="password" required />
                </div>
            </div>
        </div>

        <div class="form-group">
            <label for="name">Full Name</label>
            <input type="text" name="name" id="name" required />
        </div>

        <div class="form-row">
            <div class="form-col">
                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="text" name="phone" id="phone" required />
                </div>
            </div>
            <div class="form-col">
                <div class="form-group">
                    <label for="gender">Gender</label>
                    <select name="gender" id="gender" required>
                        <option value="">Select Gender</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                    </select>
                </div>
            </div>
        </div>

        <div class="form-group">
            <label for="emergencyContact">Emergency Contact</label>
            <input type="text" name="emergencyContact" id="emergencyContact" required />
        </div>

        <div class="form-row">
            <div class="form-col">
                <div class="form-group">
                    <label for="semester">Semester</label>
                    <input type="number" name="semester" id="semester" required min="1" />
                </div>
            </div>
            <div class="form-col">
                <div class="form-group">
                    <label for="cgpa">CGPA</label>
                    <input type="text" name="cgpa" id="cgpa" required pattern="[0-4](\.\d{1,2})?" title="Please enter a valid CGPA (e.g., 3.50)" />
                </div>
            </div>
        </div>

        <div class="form-group">
            <label for="houseIncome">Household Income (RM)</label>
            <input type="text" name="houseIncome" id="houseIncome" required pattern="[0-9]+" title="Please enter a numeric value" />
        </div>

        <div class="button-group">
            <button type="submit">Register</button>
        </div>
    </form>

    <p class="login-link">Already have an account? <a href="login.jsp">Login here</a></p>
</div>

</body>
</html>