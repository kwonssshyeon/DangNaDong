<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*,javax.servlet.http.*" %>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <title>MyPage</title>
        <link rel="stylesheet" href="./css/myPageStyle.css" />
    <link rel="stylesheet" href="./css/myPageList.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script>
      $(function () {
        $("#navbar").load("layout/navbar.html");
        $("#footer").load("layout/footer.html");
      });
      
      function deleteCompanionPost(postId) {
    	  console.log(postId);
          // 서버로 해당 게시글의 Post_id를 전송하여 삭제 요청
          $.ajax({
              type: "POST",
              url: "<%=request.getContextPath()%>" + "/deletepost",
              data: {post_id: postId},
              success: function (response) {
                  // 성공적으로 삭제되었을 때의 동작
                  if (response === "Success") {
                	  $("#deleteModal").modal("show");
                	  location.reload(); 
                      
                  } else {
                      // 삭제 실패 시에 대한 처리
                      console.error("Delete failed:", response);
                  }
              },
              error: function (error) {
                  // 서버 통신 오류 시에 대한 처리
                  console.error("Delete failed:", error);
              }
          });
      }
      
    </script>

  </head>
  <body>
    <div id="navbar"></div>

    <div class="frame">
      <nav class="navigator">

      </nav>

      <div class="centerFrame">
        <div class="contentArea">
          <h3 style="margin-bottom: 30px;">내 동행 게시물 조회</h3>
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

              
              try {
                Class.forName("oracle.jdbc.driver.OracleDriver"); 
                conn = DriverManager.getConnection(url, user, pass); 
                String query = "SELECT TP.Title, TP.Content_text,TP.Post_id FROM TRAVEL_COMPANION_POST TP WHERE TP.Member_id = ?";
                pstmt = conn.prepareStatement(query);
                
                pstmt.setString(1, currentMemberId);
                rs = pstmt.executeQuery(); 
                
                while (rs.next()) {
                	int PostId=rs.getInt(3);
            %>
            <div class="col mb-4">
              <div class="card" style="border: 1px solid #ffc300; border-radius: 5px; padding: 10px;">
                <div class="card-body">
                  <h5 class="card-title" style="font-weight: bold;"><%= rs.getString(1) %></h5>
                  <p class="card-text"><%= rs.getString(2) %></p>
                  <a href="./detailCompanionPost.jsp?post_id=<%= PostId %>" class="btn btn-primary" style="background-color: #ffc300; color: #ffffff;">작성 글로 이동</a>
                  <a href="./companionPostEdit.jsp?post_id=<%= PostId %>" class="btn btn-primary" style="background-color: #ffc300; color: #ffffff;">수정</a>
        <button onclick="deleteCompanionPost(<%=PostId %>);" class="btn btn-primary" style="background-color: #ffc300; color: #ffffff;">삭제
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
  <a href="./myPage.jsp" class="list-group-item list-group-item-action">개인 정보 수정</a>
  <a href="./myPageCompanionPost.jsp" class="list-group-item list-group-item-action active" aria-current="true" style="background-color: #ffc300";>내 동행 게시글 조회</a>
  <a href="./myPageintroductionPost.jsp" class="list-group-item list-group-item-action">내 여행 소개글 조회</a>
  <a href="./myPageAppliedInfo.jsp" class="list-group-item list-group-item-action"  >동행 요청 현황</a>
  <a href="./myPageApplyInfo.jsp" class="list-group-item list-group-item-action">동행 신청 현황</a>
  <a href="./myPageOneToOneChat.jsp" class="list-group-item list-group-item-action">1:1 채팅 목록</a>
  <a href="./myPageLikeList.jsp" class="list-group-item list-group-item-action">좋아요 글 목록</a>
  <a href="./myPageScrapList.jsp" class="list-group-item list-group-item-action">스크랩 글 목록</a>
 
</div>
        </div>
      </div>

      <div id="footer"></div>
    </div>
     <!-- "삭제" 모달 -->
    <div class="modal" id="deleteModal" tabindex="-1" role="dialog">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">삭제 완료</h5>
            <button
              type="button"
              class="close"
              data-dismiss="modal"
              aria-label="Close"
            >
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <p>삭제가 완료되었습니다.</p>
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn btn-secondary"
              data-dismiss="modal"
            >
              닫기
            </button>
          </div>
        </div>
      </div>
    </div>
 
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
    
  </body>
</html>
