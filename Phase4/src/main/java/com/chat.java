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

@WebServlet("/addChat")
public class chat extends HttpServlet {
	
	public static final String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
	public static final String USER_UNIVERSITY = "university";
	public static final String USER_PASSWD = "comp322";
	
	private int chat_id = 302;

	public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
		
	   String creationTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
	   String member_id = request.getParameter("member_id");
	   String location = request.getParameter("location");
	   String content = request.getParameter("content");
	   System.out.println(location);
        // Your Java function logic goes here
	   
	   String result = insertRealTimeChat(content,member_id,location, creationTime);

        // Send a response (if needed)
       response.getWriter().write(result);
   }
	
	public String insertRealTimeChat(String content, String member_id, String location, String creationTime) {
		String response = "";
		
		Connection conn = null; // Connection object
	    Statement stmt = null;    // Statement object
	    
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
	         
            //수동으로 트랜잭션 관리
	         conn.setAutoCommit(false);
	         System.out.println("Connected.");
	         
	         
	         
	        //real_time_chat 에 lock 설정
		      String lockQuery = "SELECT * FROM real_time_chat WHERE location_id = ? FOR UPDATE";
		      PreparedStatement pstmt = conn.prepareStatement(lockQuery);
		      pstmt.setString(1, location);
		      ResultSet rs = pstmt.executeQuery();
		      
		      //chat_id 가져오기
		      String max_query="SELECT MAX(chat_id) FROM real_time_chat";
			    try {
			    	Statement stmt1 = conn.createStatement();
				  	ResultSet max_rs = stmt1.executeQuery(max_query);
				  	if(max_rs.next())
				  		chat_id = max_rs.getInt(1);
				  	chat_id = chat_id+1;
				  	max_rs.close();
				  	stmt1.close();
			    }
			    catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		      
			 
			  String insertReply = "insert into real_time_chat values (?, ?, ?, ?, TO_TIMESTAMP(?, 'YYYY-MM-DD HH24:MI:SS'), ?)";
		      
			  try{
					PreparedStatement pstmt1 = conn.prepareStatement(insertReply);
					pstmt1.setInt(1, chat_id);
					pstmt1.setString(2, location);
					pstmt1.setString(3, member_id);
					pstmt1.setString(4, content);
					pstmt1.setString(5, creationTime);
					pstmt1.setString(6,"한국");
					
					pstmt1.executeUpdate();
					response="successfully send";
					
					pstmt.close();
									
				}catch (SQLException e) {
					System.out.print(e.getMessage());
					response="failed to send";
					
					//예외 발생 시 rollback
					try {
		                if (conn != null) {
		                	conn.rollback();
		                }
		            } catch (SQLException rollbackException) {
		                rollbackException.printStackTrace();
		            }
		            e.printStackTrace();
		            
				}
			  
			  //lock 해제
			  conn.commit();			  
			  
	      } catch (SQLException ex) {
	         ex.printStackTrace();
	         System.err.println("Cannot get a connection: " + ex.getLocalizedMessage());
	         System.err.println("Cannot get a connection: " + ex.getMessage());
	         System.exit(1);
	      }
	      
		   
		    
		  return response;
		    
	}
}

