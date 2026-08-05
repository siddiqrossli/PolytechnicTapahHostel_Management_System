package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    //private static final String url = "jdbc:mysql://localhost:3306/hostel_management?zeroDateTimeBehavior=convertToNull";
    private static final String url = "jdbc:mysql://localhost:3306/hostel_management?zeroDateTimeBehavior=convertToNull";
    private static final String USER = "root";
    private static final String PASSWORD = "";
    public static Connection getConnection() throws SQLException {
        try {
            //Class.forName("com.mysql.jdbc.Driver"); 
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL Driver loaded successfully.");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Derby Driver not found", e);
        }

        try {
            Connection conn = DriverManager.getConnection(url, USER, PASSWORD);
            System.out.println("Connection to database established.");
            return conn;
        } catch (SQLException e) {
            System.err.println("Error establishing connection: " + e.getMessage());
            throw e;
        }
    }
}
