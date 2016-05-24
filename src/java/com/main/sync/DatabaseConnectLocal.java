package com.main.sync;

import com.mysql.jdbc.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class DatabaseConnectLocal {

    Connection conn = null;
    PreparedStatement ps = null;

    public DatabaseConnectLocal() {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = (Connection) DriverManager.getConnection("jdbc:mysql://localhost:3306/karworx", "root", "krisnela");
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public Connection getConnection() {
        return conn;
    }

}
