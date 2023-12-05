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

@WebServlet("/DeleteCompanionPostServlet")
public class DeleteCompanionPostServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 클라이언트에서 전송한 Post_id 가져오기
        String postId = request.getParameter("post_id");

        // 로깅: 파라미터 값 확인
        System.out.println("Received Parameters: ");
        System.out.println("post_id: " + postId);

        // 여기에 데이터베이스에서 해당 Post_id에 해당하는 게시글 삭제 로직을 작성
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // JDBC 드라이버 로드
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // 데이터베이스 연결
            String serverIP = "localhost";
            String strSID = "orcl";
            String portNum = "1521";
            String user = "university";
            String pass = "comp322";
            String url = "jdbc:oracle:thin:@" + serverIP + ":" + portNum + ":" + strSID;

            conn = DriverManager.getConnection(url, user, pass);

            // 삭제 쿼리 작성
            String deleteQuery = "DELETE FROM TRAVEL_COMPANION_POST WHERE Post_id = ? ";
            pstmt = conn.prepareStatement(deleteQuery);
            pstmt.setInt(1, Integer.parseInt(postId));

            // 쿼리 실행
            int rowCount = pstmt.executeUpdate();

            if (rowCount > 0) {
                // 삭제가 성공한 경우
                response.getWriter().write("Success");
            } else {
                // 삭제가 실패한 경우
                response.getWriter().write("Failure");
            }

        } catch (ClassNotFoundException | SQLException e) {
            try {
				conn.rollback();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
            response.getWriter().write("Failure");
        } finally {
            // 자원 해제
            try {
                if (pstmt != null)
                    pstmt.close();
                if (conn != null)
                    conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
