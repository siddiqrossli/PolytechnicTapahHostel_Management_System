<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("staffId") == null) {
        response.sendRedirect("staffLogin.jsp");
        return;
    }
%>
<html>
<head><title>Staff Dashboard</title></head>
<body>
    <h2>Welcome, <%= session.getAttribute("staffName") %></h2>
    <ul>
        <li>Hello world</li>
    </ul>
</body>
</html>
