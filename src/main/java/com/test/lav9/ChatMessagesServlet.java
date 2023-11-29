package com.test.lav9;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class GetChatMessagesServlet
 */
@WebServlet("/ChatMessagesServlet")
public class ChatMessagesServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ChatMessagesServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		  
		  String chat_room_id=request.getParameter("chat_room_id");
		  String member_id = request.getParameter("member_id");
	      String message = request.getParameter("message");
	       
	      // 로깅: 파라미터 값 확인
	      System.out.println("Received Parameters: ");
	      System.out.println("chat_room_id:"+ chat_room_id);
	      System.out.println("member_id: " + member_id); // 메세지 보내는 사람
	      System.out.println("message: " + message);
	      
	      
	      Connection conn = null;

	      try {
	    	   conn = DatabaseCon.connectToDatabase();
	    	   conn.setAutoCommit(false);
	          
	    	  String query = "INSERT INTO ONE_TO_ONE_CHAT (chat_id,chat_room_id,Member_id,Message) VALUES (?,?,?,?) ";
	          try (PreparedStatement pstmt = conn.prepareStatement(query)) {
	        	  pstmt.setInt(1, 1129);//chat_id 테스트 용도
	        	  pstmt.setString(2,chat_room_id);
	              pstmt.setString(3, member_id);
	              pstmt.setString(4, message);

	              int rowsAffected = pstmt.executeUpdate();
	              System.out.println(rowsAffected + " row(s) updated"); // 디버깅을 위한 출력

	              conn.commit();
	          }
	         
	      } catch (SQLException e) {
	          e.printStackTrace();
	      } catch (ClassNotFoundException e) {
			// 드라이버 연결 실패
			e.printStackTrace();
		} finally {
	          // 리소스 정리
	          try {
	              if (conn != null) {
	                  conn.close();
	              }
	          } catch (SQLException e) {
	              e.printStackTrace();
	          }
	      }}}
