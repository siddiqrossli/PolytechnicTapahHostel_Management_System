package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBTest{

    public static void main(String[] args) {
        // Database connection details
        //String url = "jdbc:mysql://localhost:3306/hostel_management?zeroDateTimeBehavior=convertToNull";
        String url = "jdbc:mysql://localhost:3306/hostel_management?zeroDateTimeBehavior=convertToNull";
        String user = "farish";  // Replace with your MySQL username
        String password = "kakilangit";  // Replace with your MySQL password if necessary

        // Establish the connection
        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            if (conn != null) {
                System.out.println("Database connection successful!");
            } else {
                System.out.println("Database connection failed.");
            }
        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
