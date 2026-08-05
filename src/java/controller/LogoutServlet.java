package controller; // Or whatever your servlet package is

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/logout") // Map this servlet to /logout URL
public class LogoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Get existing session, don't create new

        if (session != null) {
            session.invalidate(); // Invalidate the session
        }

        // Redirect to the login page after invalidating the session
        response.sendRedirect("login.jsp");
    }

    // Usually, logout is handled by GET requests, but you can add doPost if needed.
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Just call doGet for simplicity
    }
}