<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*,javax.servlet.http.*" %>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <title>MyPage</title>
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <link rel="stylesheet" href="./css/myPageStyle.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <script>
      $(function () {
        $("#navbar").load("layout/navbar.html");
        $("#footer").load("layout/footer.html");
      });
    </script>
    
  </head>
  <body>
    <div id="navbar"></div>

    <div class="frame">
      <nav class="navigator">
      </nav>

      <div class="centerFrame">
        <div class="contentArea">
<h3 style="margin-bottom: 30px;">1:1채팅 목록</h3>
               <div class="row row-cols-1 row-cols-md-4" style="margin-left: 10px; margin-top: 10px;">
            <% 
              String serverIP = "localhost"; 
              String strSID = "orcl"; 
              String portNum = "1521";
              String user = "university"; 
              String pass = "comp322"; 
              String url = "jdbc:oracle:thin:@" + serverIP + ":" +portNum + ":" + strSID; 
              Connection conn = null; 
              PreparedStatement pstmt; 
              ResultSet rs;
              
              try {
                Class.forName("oracle.jdbc.driver.OracleDriver"); 
                conn = DriverManager.getConnection(url, user, pass); 
                

                HttpSession s = request.getSession();
                String currentMemberId = (String)s.getAttribute("member_id");
				
                //String currentMemberId = "Mid1"; // 실제로 로그인한 회원 ID로 대체하세요

                // 단계 1: 현재 멤버의 모든 채팅방을 가져오기
                String chatRoomsQuery = "with my_chat as (SELECT r.chat_room_id, r.post_id FROM chat_room r JOIN travel_companion_post p ON r.post_id = p.post_id WHERE r.applier_id = ? OR p.member_id = ?)"
                + "select p.title, m.nickname, c.chat_room_id from travel_companion_post p, member m, my_chat c where p.member_id = m.member_id and p.post_id = c.post_id";
                
                pstmt = conn.prepareStatement(chatRoomsQuery);
                pstmt.setString(1, currentMemberId);
                pstmt.setString(2, currentMemberId);
                rs = pstmt.executeQuery();
                
                while (rs.next()) {

                    String title = rs.getString(1);
                    String nickname = rs.getString(2);
                    int chatRoomId = rs.getInt(3);
                    
                    %>
                        <div class="col mb-4">
                        <div class="card" style="border: 1px solid #ffc300; border-radius: 5px; padding: 10px;">
                            <div class="card-body">
                                <h5 class="card-title" style="text-align:center;"><%= title %></h5>
                                <h5 class="card-title" style="text-align:center;"><%= nickname %></h5>
                                <a href="./chat.jsp?chat_room_id=<%= chatRoomId %>" class="btn btn-primary" style="background-color: #ffc300; color: #ffffff;">1:1 메세지</a>
                            </div>
                        </div>
                    	</div>
    				<%
                    }    
                rs.close(); 
                pstmt.close(); 
                conn.close(); 
              } catch (Exception e) {
                e.printStackTrace();
              }
            %>
            
          </div>
        </div>
 
        <div class="menuArea">
<div class="list-group">
  <a href="./myPage.jsp" class="list-group-item list-group-item-action">
    개인 정보 수정
  </a>
  <a href="./myPageCompanionPost.jsp" class="list-group-item list-group-item-action" >내 동행 게시글 조회</a>
  <a href="./myPageintroductionPost.jsp" class="list-group-item list-group-item-action" >내 여행 소개글 조회</a>
  <a href="./myPageAppliedInfo.jsp" class="list-group-item list-group-item-action"  >동행 요청 현황</a>
  <a href="./myPageApplyInfo.jsp" class="list-group-item list-group-item-action">동행 신청 현황</a>
  <a href="./myPageOneToOneChat.jsp" class="list-group-item list-group-item-action  active" aria-current="true" style="background-color: #ffc300";>1:1 채팅 목록</a>
  <a href="./myPageLikeList.jsp" class="list-group-item list-group-item-action">좋아요 글 목록</a>
  <a href="./myPageScrapList.jsp" class="list-group-item list-group-item-action">스크랩 글 목록</a>
 
</div>
        </div>
      </div>

      <div id="footer"></div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
    
  </body>
</html>
