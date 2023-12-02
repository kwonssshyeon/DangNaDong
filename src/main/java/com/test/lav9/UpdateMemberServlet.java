package com.test.lav9;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class UpdateMemberServlet
 */
@WebServlet("/UpdateMemberServlet")
public class UpdateMemberServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateMemberServlet() {
        super();
        // TODO Auto-generated constructor stub
    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      String member_id = request.getParameter("member_id");
      String nickname = request.getParameter("nickname");
      String introduction = request.getParameter("introduction");
      String email = request.getParameter("email");
      String birthdateStr = request.getParameter("birthdate");
      String profile_image = request.getParameter("profile_image"); // 변경된 부분

      
      // 로깅: 파라미터 값 확인
      System.out.println("Received Parameters: ");
      System.out.println("member_id: " + member_id);
      System.out.println("nickname: " + nickname);
      System.out.println("introduction: " + introduction);
      System.out.println("email: " + email);
      System.out.println("birthdate: " + birthdateStr);
      System.out.println("profile_image: " + profile_image);
      
      
      // 문자열 형식의 날짜를 Date 객체로 변환
      SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
      Date birthdate = null;
      try {
        birthdate = dateFormat.parse(birthdateStr);
      } catch (ParseException e) {
        e.printStackTrace();
        // 날짜 형식이 잘못된 경우 응답으로 에러 메시지 등을 전송
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid date format");
        return;
      }
      
      Connection conn = null; 

      try {
    	   conn = DatabaseCon.connectToDatabase();
    	   conn.setAutoCommit(false);

          String query = "UPDATE MEMBER SET Nickname=?, Self_introdution=?, E_mail=?, Birth=?,Profile_image=? WHERE Member_id=?";
          try (PreparedStatement pstmt = conn.prepareStatement(query)) {
              pstmt.setString(1, nickname);
              pstmt.setString(2, introduction);
              pstmt.setString(3, email);
              pstmt.setDate(4, new java.sql.Date(birthdate.getTime())); // Date 객체를 SQL Date로 변환
              pstmt.setString(5, profile_image);
              pstmt.setString(6, member_id);

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
