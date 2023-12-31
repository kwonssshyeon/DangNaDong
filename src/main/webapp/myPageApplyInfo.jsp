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
    <link rel="stylesheet" href="./css/myPageList.css" />
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
          <h3 style="margin-bottom: 30px;">동행 신청 현황</h3>
  <div class="row row-cols-1 row-cols-md-2" style="margin-left: 10px; margin-top: 10px;">
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
              
              HttpSession s = request.getSession();
              String currentMemberId = (String)s.getAttribute("member_id");
				
              //String currentMemberId = "Mid1"; // 실제로 로그인한 회원 ID로 대체하세요

              int acceptedApplications=0;
              try {
                Class.forName("oracle.jdbc.driver.OracleDriver"); 
                conn = DriverManager.getConnection(url, user, pass); 
                
                
                String query = "SELECT AP.Member_id, TC.Title, AP.Request_state,AP.Post_id,TC.State,TC.Number_of_recruited FROM TRAVEL_COMPANION_POST TC JOIN APPLICATION_INFO AP ON AP.Post_id = TC.Post_id WHERE AP.Member_id = ?"; 				
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1,currentMemberId);
                rs = pstmt.executeQuery(); 
                
            
                while (rs.next()) {
                    int PostId = rs.getInt(4);

                    String applyNumQuery = "SELECT COUNT(*) FROM APPLICATION_INFO WHERE REQUEST_STATE = '수락' AND POST_ID = ?";
                    try (PreparedStatement applyNumStmt = conn.prepareStatement(applyNumQuery)) {
                        applyNumStmt.setInt(1, PostId);
                        try (ResultSet applyNumRs = applyNumStmt.executeQuery()) {
                            if (applyNumRs.next()) {
                                acceptedApplications = applyNumRs.getInt(1);
                            }
                        }
                    }

                    // 여기에 게시글 동행 상황 업데이트 코드 추가
                    String updateStateQuery;
                    if (acceptedApplications == rs.getInt(6)) {
                        // 수락된 인원이 모집 인원과 같으면 "마감"으로 업데이트
                        updateStateQuery = "UPDATE TRAVEL_COMPANION_POST SET STATE = '마감' WHERE POST_ID = ?";
                    } else {
                        // 수락된 인원이 모집 인원보다 작으면 "진행"으로 업데이트
                        updateStateQuery = "UPDATE TRAVEL_COMPANION_POST SET STATE = '진행' WHERE POST_ID = ?";
                    }

                    try (PreparedStatement updateStateStmt = conn.prepareStatement(updateStateQuery)) {
                        updateStateStmt.setInt(1, PostId);
                        updateStateStmt.executeUpdate();
                    }
                %>

            <div class="col mb-4">
              <div class="card" style="border: 1px solid #ffc300; border-radius: 5px; padding: 10px;">
                <div class="card-body">
                  <h5 class="card-title" style="font-weight: bold;"><%= rs.getString(2) %></h5>
                  <p class="card-text">현재 요청 상태 : <%= rs.getString(3) %></p>
                  <p class="card-text">게시글 동행 상황 : <%= rs.getString(5) %></p>
                  <p class="card-text">모집 인원 : <%= rs.getString(6) %></p>
                  <p class="card-text">수락된 인원 수 : <%= acceptedApplications %></p>
                  <a href="./detailCompanionPost.jsp?post_id=<%= PostId %>"class="btn btn-primary" style="background-color: #ffc300; color: #ffffff;">작성 글로 이동</a>
                  
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
  <a href="./myPageCompanionPost.jsp" class="list-group-item list-group-item-action " >내 동행 게시글 조회</a>
  <a href="./myPageintroductionPost.jsp" class="list-group-item list-group-item-action">내 여행 소개글 조회</a>
  <a href="./myPageAppliedInfo.jsp" class="list-group-item list-group-item-action"  >동행 요청 현황</a>
  <a href="./myPageApplyInfo.jsp" class="list-group-item list-group-item-action active" aria-current="true" style="background-color: #ffc300";>동행 신청 현황</a>
  <a href="./myPageOneToOneChat.jsp" class="list-group-item list-group-item-action">1:1 채팅 목록</a>
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
