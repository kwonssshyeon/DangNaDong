package com;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.sql.*;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;

public class reply {
	public static final String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
	   public static final String USER_UNIVERSITY = "university";
	   public static final String USER_PASSWD = "comp322";
	   public static final List<String> TABLES_NAME = Arrays.asList("APPLICATION_INFO", "CPN_CONTAIN", "CPN_IMAGE",
	         "ITR_CONTAIN", "ITR_IMAGE", "LIKE_POST", "LOCATION", "MEMBER", "ONE_TO_ONE_CHAT", "REAL_TIME_CHAT", "REPLY", "SCRAP",
	         "TRAVEL_COMPANION_POST", "TRAVEL_INTRODUCTION_POST", "CHAT_ROOM");
	   public static String memberId = null;
	   public static String location = null;

	   public static int post_id = 1001;
	   private int reply_id = 5000;
	   String creationTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

	   public void insertReply(String content,String member_id,int post_id) {
	      Connection conn = null; // Connection object
	      Statement stmt = null;    // Statement object
	      Scanner scanner = new Scanner(System.in);

	      if(content==null || content.isEmpty())return;
	      try {
	         // Load a JDBC driver for Oracle DBMS
	         Class.forName("oracle.jdbc.driver.OracleDriver");
	         // Get a Connection object 
	         System.out.println("Success!");
	      } catch (ClassNotFoundException e) {
	         System.err.println("error = " + e.getMessage());
	         System.exit(1);
	      }

	      // Make a connection
	      try {
	         conn = DriverManager.getConnection(URL, USER_UNIVERSITY, USER_PASSWD);
	         conn.setAutoCommit(false);
	         System.out.println("Connected.");
	      } catch (SQLException ex) {
	         ex.printStackTrace();
	         System.err.println("Cannot get a connection: " + ex.getLocalizedMessage());
	         System.err.println("Cannot get a connection: " + ex.getMessage());
	         System.exit(1);
	      }
	      
	      
	      
	    String max_query="SELECT MAX(reply_id) FROM reply";
	    try {
	    	Statement stmt1 = conn.createStatement();
		  	ResultSet max_rs = stmt1.executeQuery(max_query);
		  	if(max_rs.next())
		  		reply_id = max_rs.getInt(1);
		  	reply_id = reply_id+1;
		  	max_rs.close();
		  	stmt1.close();
	    }
	    catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	      String insertReply = "INSERT INTO REPLY (reply_id, Member_id, Post_id, Content, Creation_time) VALUES (?, ?, ?, ?, TO_TIMESTAMP(?, 'YYYY-MM-DD HH24:MI:SS'))";
	      
	      try{
			PreparedStatement pstmt = conn.prepareStatement(insertReply);
			pstmt.setInt(1, reply_id);
			pstmt.setString(2, member_id);
			pstmt.setInt(3, post_id);
			pstmt.setString(4, content);
			pstmt.setString(5, creationTime);
			
			pstmt.executeUpdate();
			System.out.print(pstmt);
			pstmt.close();
			} catch (SQLException e) {
				System.out.print(e.getMessage());
			}
	      try {
			conn.commit();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	      
	      

	}
	   

}
