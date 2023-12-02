package com;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/applicate")
public class apply extends HttpServlet{
	public static final String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
	   public static final String USER_UNIVERSITY = "university";
	   public static final String USER_PASSWD = "comp322";
	   public static final List<String> TABLES_NAME = Arrays.asList("APPLICATION_INFO", "CPN_CONTAIN", "CPN_IMAGE",
		 "ITR_CONTAIN", "ITR_IMAGE", "LIKE_POST", "LOCATION", "MEMBER", "ONE_TO_ONE_CHAT", "REAL_TIME_CHAT", "REPLY", "SCRAP",
		 "TRAVEL_COMPANION_POST", "TRAVEL_INTRODUCTION_POST", "CHAT_ROOM");
	   public static String memberId = null;
	   public static String location = null;
	
	   public int post_id;
	   public int reply_id;
	   String creationTime;
	   
	   public void doPost(HttpServletRequest request, HttpServletResponse response)
	            throws ServletException, IOException {
		   
		   creationTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
		   String member_id = request.getParameter("member_id");
		   int post_id = Integer.parseInt(request.getParameter("post_id"));
	        // Your Java function logic goes here
		   String result = applyTravel(member_id,post_id);

	        // Send a response (if needed)
	        response.getWriter().write(result);
	    }
	
	   public String applyTravel(String member_id,int post_id) {
		  Connection conn = null; // Connection object
		  Statement stmt = null;    // Statement object
		  
		  String result;
		
		  if(member_id==null || member_id.isEmpty())
			  return "Try to use after login";
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
	  
		  
		  String insertReply = "INSERT INTO application_info (post_id, Member_id, request_state, application_time) VALUES (?, ?, ?, TO_TIMESTAMP(?, 'YYYY-MM-DD HH24:MI:SS'))";
		  
		  try{
			PreparedStatement pstmt = conn.prepareStatement(insertReply);
			pstmt.setInt(1, post_id);
			pstmt.setString(2, member_id);
			pstmt.setString(3, "대기");
			pstmt.setString(4, creationTime);
			
			pstmt.executeUpdate();
			System.out.print(pstmt);
			result="Successfully applicated.";
			pstmt.close();
			} catch (SQLException e) {
				result = "You've already applied.";
				System.out.println(e.getMessage());
			}
		  try {
			conn.commit();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
				e.printStackTrace();
			}
		      
		      
		return result;
		}

}
