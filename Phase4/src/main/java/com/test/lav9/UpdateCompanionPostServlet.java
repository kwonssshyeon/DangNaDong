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

@WebServlet("/UpdateCompanionPostServlet")
public class UpdateCompanionPostServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {


        // 클라이언트에서 전달한 데이터 가져오기
 
        String title = request.getParameter("title");
        String travelDate = request.getParameter("travelDate");
        String travelPeriod = request.getParameter("travelPeriod");
        String deadline = request.getParameter("deadline");
        String expectedCost = request.getParameter("expectedCost");
        int numberOfRecruited = Integer.parseInt(request.getParameter("numberOfRecruited"));
        String genderCondition = request.getParameter("genderCondition");
        String ageCondition = request.getParameter("ageCondition");
        String nationalityCondition = request.getParameter("nationalityCondition");
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
            String updateQuery = "UPDATE TRAVEL_COMPANION_POST SET Title=?, Travel_date=?, Travel_period=?, Deadline=?, Expected_cost=?,"
                    + " Number_of_recruited=?, Gender_condition=?, Age_condition=?, Nationality_condition=?, Content_text=? WHERE Post_id=?";

            pstmt = conn.prepareStatement(updateQuery);
            pstmt.setString(1, title);
            pstmt.setString(2, travelDate);
            pstmt.setString(3, travelPeriod);
            pstmt.setString(4, deadline);
            pstmt.setString(5, expectedCost);
            pstmt.setInt(6, numberOfRecruited);
            pstmt.setString(7, genderCondition);
            pstmt.setString(8, ageCondition);
            pstmt.setString(9, nationalityCondition);
            pstmt.setString(10, contentText);
            pstmt.setString(11, postId);

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
