package com.test.lav9;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String member_id = request.getParameter("member_id");
        String nickname = request.getParameter("nickname");
        String introduction = request.getParameter("introduction");
        String email = request.getParameter("email");
        String birthdateStr = request.getParameter("birthdate");
        String profile_image = request.getParameter("profile_image");

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

            // 중복된 닉네임 또는 이메일이 있는지 확인
            if (isNicknameOrEmailAlreadyExists(conn, member_id, nickname, email)) {
                // 중복된 경우 처리 (이미 다른 회원이 사용 중인 닉네임 또는 이메일입니다)
                conn.rollback();
                response.getWriter().write("DuplicateNicknameOrEmail");
                return;
            }

            // 중복이 없으면 프로필 업데이트
            updateProfile(conn, member_id, nickname, introduction, email, birthdate, profile_image);

            // 트랜잭션 커밋
            conn.commit();
            response.getWriter().write("Success");
        } catch (SQLException e) {
            // 오류 발생 시 롤백
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException e1) {
                    e1.printStackTrace();
                }
            }
            response.getWriter().write("Error");
        } catch (ClassNotFoundException e) {
            // 드라이버 연결 실패
            e.printStackTrace();
            response.getWriter().write("Error");
        } finally {
            // 리소스 정리
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private boolean isNicknameOrEmailAlreadyExists(Connection conn, String member_id, String nickname, String email)
            throws SQLException {
        String query = "SELECT COUNT(*) FROM MEMBER WHERE (Nickname = ? OR E_mail = ?) AND Member_id != ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, nickname);
            pstmt.setString(2, email);
            pstmt.setString(3, member_id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    return count > 0;
                }
            }
        }
        return false;
    }

    private void updateProfile(Connection conn, String member_id, String nickname, String introduction, String email,
            Date birthdate, String profile_image) throws SQLException {
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
        }
    }
}

