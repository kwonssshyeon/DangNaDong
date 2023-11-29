package com.test.lav9;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class handleStateServlet
 */
@WebServlet("/handleStateServlet")
public class handleStateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public handleStateServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	      String member_id = request.getParameter("member_id");
	      String state = request.getParameter("state");
	      
	      // 로깅: 파라미터 값 확인
	      System.out.println("Received Parameters: ");
	      System.out.println("member_id: " + member_id);
	      System.out.println("state: " + state);
	      
	      
	      Connection conn = null;

	      try {
	    	   conn = DatabaseCon.connectToDatabase();
	    	   conn.setAutoCommit(false);
	          

	          String query = "UPDATE APPLICATION_INFO SET Request_State=? WHERE Member_id=?";
	          try (PreparedStatement pstmt = conn.prepareStatement(query)) {
	              pstmt.setString(1, state);
	              pstmt.setString(2, member_id);

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



