package com;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.io.IOException;
import java.sql.*;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/submitReply")
public class reply extends HttpServlet{
	   public static final String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
	   public static final String USER_UNIVERSITY = "university";
	   public static final String USER_PASSWD = "comp322";
	   public static final List<String> TABLES_NAME = Arrays.asList("APPLICATION_INFO", "CPN_CONTAIN", "CPN_IMAGE",
	         "ITR_CONTAIN", "ITR_IMAGE", "LIKE_POST", "LOCATION", "MEMBER", "ONE_TO_ONE_CHAT", "REAL_TIME_CHAT", "REPLY", "SCRAP",
	         "TRAVEL_COMPANION_POST", "TRAVEL_INTRODUCTION_POST", "CHAT_ROOM");
	   public static String memberId = null;
	   public static String location = null;

	   public int post_id;
	   public int reply_id = 0;
	   String creationTime;
	   
	   public void doPost(HttpServletRequest request, HttpServletResponse response)
	            throws ServletException, IOException {
		   
		   creationTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
		   String member_id = request.getParameter("member_id");
		   int post_id = Integer.parseInt(request.getParameter("post_id"));
		   String content = request.getParameter("content");
	        // Your Java function logic goes here
		   System.out.print(member_id+post_id+content);
		   
		   String result = insertReply(content,member_id,post_id);

	        // Send a response (if needed)
	       response.getWriter().write(result);
	   }

	   public String insertReply(String content,String member_id,int post_id) {
	      Connection conn = null; // Connection object
	      Statement stmt = null;    // Statement object
	      Scanner scanner = new Scanner(System.in);
	      
	      String result="";

	      if(content==null || content.isEmpty())return "You can summit comment after writing";
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
			
			result="successfully submmited";
			pstmt.close();
			} catch (SQLException e) {
				System.out.print(e.getMessage());
				result="failed to submmit";
			}
	    try {
			conn.commit();
		}catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    
	    return result;
	     
	      

	}
	   

}
