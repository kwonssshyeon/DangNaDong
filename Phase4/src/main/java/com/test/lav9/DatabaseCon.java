package com.test.lav9;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseCon {

    public static Connection connectToDatabase() throws SQLException, ClassNotFoundException {
        String serverIP = "localhost";
        String strSID = "orcl";
        String portNum = "1521";
        String user = "university";
        String pass = "comp322";
        String url = "jdbc:oracle:thin:@" + serverIP + ":" + portNum + ":" + strSID;

        Class.forName("oracle.jdbc.driver.OracleDriver");
        System.out.println("Connecting to the database...");
        Connection conn = DriverManager.getConnection(url, user, pass);
        conn.setAutoCommit(false);

        return conn;
    }

}
