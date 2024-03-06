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

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/oneToOneChat")
public class oneChat extends HttpServlet{
	public static final String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
    public static final String USER_UNIVERSITY = "university";
    public static final String USER_PASSWD = "comp322";

    public String member_id = null;
    public int post_id;
    public String message=null;
    public String creationTime;
    
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
	   
	   member_id = request.getParameter("member_id");
	   post_id = Integer.parseInt(request.getParameter("post_id"));
	   message = request.getParameter("message");
	   creationTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
	   String result = oneChat(member_id,post_id);

       response.getWriter().write(result);
   }
    
    public String oneChat(String member_id,int post_id) {
	      Connection conn = null; // Connection object
	      Statement stmt = null;    // Statement object
	      PreparedStatement pstmt;
	      ResultSet rs;
	      
	      String result="";

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
	      
	      //1. post id 랑 member id로 채팅방 있는지 확인
	      String checkSql = "select chat_room_id,max(chat_id) from one_to_one_chat natural join chat_room"+
	      " where member_id='"+member_id+"' and post_id="+post_id+"group by chat_room_id";
	      int rowCount=0;
	      int chat_room_id=0;
	      int chat_id=0;
	      try {
			  pstmt = conn.prepareStatement(checkSql);
			  rs = pstmt.executeQuery();
			  while (rs.next()) {
				  chat_room_id = rs.getInt(1);
				  chat_id = rs.getInt(2);
				  chat_id+=1;
				  rowCount+=1;
		        }
			  
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	      System.out.println("존재하는지"+rowCount+"-채팅방번호(없으면0)"+chat_room_id+"-채팅번호(없으면0)"+chat_id);
	      
	      //2. 있으면 이어서 작성 / 없으면 새로운 채팅방 만들기(+ 다음 채팅방 번호 찾는 쿼리필요)
	      
	      if(rowCount==0) {
	    	  String roomSql = "select max(chat_room_id) from chat_room";
	    	  try {
				  pstmt = conn.prepareStatement(roomSql);
				  rs = pstmt.executeQuery();
				  while (rs.next()) {
					  chat_room_id = rs.getInt(1);
					  chat_room_id+=1;
				  }
				  
				} catch (SQLException e) {
					System.out.print(e.getMessage());
				}
	    	  System.out.println("새로만든 채팅방-"+chat_room_id+"채팅번호-"+chat_id);
	    	  String createRoomSql = "INSERT INTO chat_room (chat_room_id, Post_id, applier_id) VALUES (?, ?, ?)";
	    	  try{
					pstmt = conn.prepareStatement(createRoomSql);
					pstmt.setInt(1,chat_room_id);
					pstmt.setInt(2, post_id);
					pstmt.setString(3, member_id);
					pstmt.executeUpdate();
					result="new chatroow was created.";
					pstmt.close();
			} catch (SQLException e) {
				System.out.print(e.getMessage());
				result="failed to submmit. you've already submitted.";
			}
	    	  
	      }
	      
	      System.out.println("최종채팅방"+chat_room_id+"채팅"+chat_id+"메세지"+message);
	      //3-1. 이어서 작성하는 경우 가장마지막 chat id 찾고 추가
	      //3-2. 새로만드는 경우 chat_id=1로 추가
	      String insertChatSql = "insert into one_to_one_chat(chat_id,chat_room_id,member_id,message, creation_time)"+
	      " values (?, ?, ?, ?, TO_TIMESTAMP(?, 'YYYY-MM-DD HH24:MI:SS'))";
	      try {
			pstmt = conn.prepareStatement(insertChatSql);
			pstmt.setInt(1,chat_id);
			pstmt.setInt(2,chat_room_id);
			
			pstmt.setString(3, member_id);
			pstmt.setString(4, message);
			pstmt.setString(5, creationTime);
			pstmt.executeUpdate();
			
			result="successfully submmited";
			pstmt.close();
			System.out.println(chat_id+"-"+chat_room_id+"-"+member_id);
			
		} catch (SQLException e) {
			e.printStackTrace();
		}

	      try {
	    	  conn.commit();
	      }catch (SQLException e) {
	    	  e.printStackTrace();
	      }
	    
	      return chat_room_id+"/"+result;
	     
	      

	}

}
