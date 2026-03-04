package com.oceanview.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {

    // Static instance for the Singleton pattern
    private static DBConnection instance;
    private static Connection connection;

    // Correct Database Configuration for Shenara's Project
    // DB Name changed from 'ocean_view' to 'ocean_view_shenara'
    private static final String URL = "jdbc:mysql://localhost:3306/ocean_view_shenara?useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASS = "";

    /**
     * Private Constructor: Encapsulation
     * Prevents other classes from creating new instances of DBConnection.
     */
    private DBConnection() throws SQLException {
        try {
            // Loading the MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(URL, USER, PASS);
            System.out.println(">>> Database Connected Successfully to: ocean_view_shenara");
        } catch (ClassNotFoundException e) {
            Logger.getLogger(DBConnection.class.getName()).log(Level.SEVERE, "MySQL Driver Not Found", e);
            throw new SQLException(e);
        }
    }

    public static synchronized DBConnection getInstance() throws SQLException {
        // Double-check locking for thread safety
        if (instance == null) {
            instance = new DBConnection();
        } else if (connection == null || connection.isClosed()) {
            instance = new DBConnection();
        }
        return instance;
    }

    public Connection getConnection() {
        return connection;
    }
}