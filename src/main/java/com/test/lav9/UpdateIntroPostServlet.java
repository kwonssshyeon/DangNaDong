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
 * Servlet implementation class UpdateIntroPostServlet
 */
@WebServlet("/UpdateIntroPostServlet")
public class UpdateIntroPostServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateIntroPostServlet() {
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
		String title = request.getParameter("title");
        String travelDate = request.getParameter("travelDate");
        String travelPeriod = request.getParameter("travelPeriod");

        String expectedCost = request.getParameter("expectedCost");
        String contentText = request.getParameter("contentText");
        String memberId = request.getParameter("memberId");
        String postId = request.getParameter("postId");
        // 파일 이름 받아오기
        String imageName = request.getParameter("imageName");
        System.out.println("imageName: " + imageName);
        
        // 데이터베이스 연결
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            String url = "jdbc:oracle:thin:@localhost:1521:orcl";
            String user = "university";
            String pass = "comp322";
            conn = DriverManager.getConnection(url, user, pass);

            // Update 쿼리 작성
            String updateQuery = "UPDATE TRAVEL_INTRODUCTION_POST SET Title=?, Travel_date=?, Travel_period=?,Cost=?,"
                    + " Content_text=? WHERE Post_id=?";

            pstmt = conn.prepareStatement(updateQuery);
            pstmt.setString(1, title);
            pstmt.setString(2, travelDate);
            pstmt.setString(3, travelPeriod);
            pstmt.setString(4, expectedCost);
            pstmt.setString(5, contentText);
            pstmt.setString(6, postId);

            // Update 수행
            int rowsUpdated = pstmt.executeUpdate();

            // 성공적으로 Update된 행이 있다면
            if (rowsUpdated > 0) {
                response.getWriter().write("Update Successful");
            } else {
                response.getWriter().write("Update Failed");
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            // 리소스 해제
            try {
                if (pstmt != null) {
                    pstmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}