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

    function acceptRequestState(userId, maxParticipants, acceptedApplications,Number_of_recruited,PostId) {
        var member_id = userId;
       
        if (acceptedApplications < maxParticipants) {
            $('#acceptModal').modal('show');
            
            handleState("수락", member_id,acceptedApplications,Number_of_recruited,PostId);
            setTimeout(function () {
            	 window.location.reload();
            	
            }, 1500);
        } else {
            // 정원 초과 모달 또는 다른 처리 추가
            alert("정원이 초과되었습니다.");
        }
        window.location.reload();
    }


    function rejectRequestState(userId, maxParticipants, acceptedApplications,Number_of_recruited,PostId) {
    	var member_id=userId;
        $('#rejectModal').modal('show');
        handleState("거절", member_id, acceptedApplications, Number_of_recruited, PostId);
        setTimeout(function () {
        	 window.location.reload();
           },1500);
        window.location.reload();
    }

    function handleState(requestState,member_id,acceptedApplications,Number_of_recruited,PostId) {
        var state = requestState;
        console.log('State:', state);
        console.log('Member ID:', member_id);
        // 여기서 서버로 이동
        $.ajax({
            type: "POST",
            url: "<%=request.getContextPath()%>" + "/handleStateServlet",
            data: {
                member_id: member_id, // 동행 요청을 한 멤버의 아이디
                state: state,
                acceptedApplications: acceptedApplications,
                Number_of_recruited:Number_of_recruited,
                PostId:PostId
            },
            success: function (response) {
                // 서버에서의 처리가 성공했을 때의 동작
                console.error("state Update succes:");
            },
            error: function (error) {
                // 서버에서의 처리가 실패했을 때의 동작
                console.error("state Update failed:", error);
            }
        });
        window.location.reload();
    }
</script>
    
  </head>
  <body>
    <div id="navbar"></div>

    <div class="frame">
      <nav class="navigator">
        <!-- ... 네비게이션 컨텐츠 ... -->
      </nav>

      <div class="centerFrame">
        <div class="contentArea">
          <h3 style="margin-bottom: 30px;">동행 요청 현황</h3>
<div class="row row-cols-1 row-cols-md-2 row-cols-lg-3" style="margin-left: 10px; margin-top: 10px;">
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
                String query = "SELECT AP.Member_id, M.Nickname,TC.Title,AP.Request_state,TC.Post_id,TC.State,TC.Number_of_recruited FROM TRAVEL_COMPANION_POST TC JOIN APPLICATION_INFO AP ON AP.Post_id = TC.Post_id JOIN MEMBER M ON M.Member_id = AP.Member_id WHERE TC.Member_id = ?";     
				
                // (그룹 바이 포스트 아이디,멤버 아이디)로 통일
                //M.Meber_id : 신청한 유저 아이디
				//Where Member_id : 로그인 유저
                pstmt = conn.prepareStatement(query);
				pstmt.setString(1,currentMemberId);
                rs = pstmt.executeQuery(); 
                int acceptedApplications=0;
                String companionStatus = "";
                
                while (rs.next()) {
                	String member_id = rs.getString(1);
                	int PostId=rs.getInt(5);
                	int maxParticipants = rs.getInt(7);
                    String applyNumQuery = "SELECT COUNT(*) FROM APPLICATION_INFO WHERE REQUEST_STATE = '수락' AND POST_ID = ?";
                    try (PreparedStatement applyNumStmt = conn.prepareStatement(applyNumQuery)) {
                        applyNumStmt.setInt(1, PostId);
                        try (ResultSet applyNumRs = applyNumStmt.executeQuery()) {
                            if (applyNumRs.next()) {
                                acceptedApplications = applyNumRs.getInt(1);
                            }}}
            %>
            <script>
			    var member_id = '<%= member_id %>';
			    var maxParticipants ='<%= maxParticipants %>';
			    var acceptedApplications= '<%= acceptedApplications %>';
			</script>
            <div class="col mb-4">
              <div class="card" style="border: 1px solid #ffc300; border-radius: 5px; padding: 10px;">
                <div class="card-body">
                  <h5 class="card-title" style="font-weight: bold;"><%= rs.getString(3) %></h5>
                  <p class="card-text">신청하는 유저 아이디 : <%= rs.getString(2) %></p>
                  <p class="card-text">현재 요청 상태 : <%= rs.getString(4) %></p>
                  
                                    <% 
                        String updateStatusQuery="";    
                        if (acceptedApplications == rs.getInt(7)) {
                            // 게시글 동행 상황이 "마감"인 경우 업데이트 수행
                            updateStatusQuery = "UPDATE TRAVEL_COMPANION_POST SET STATE = '마감' WHERE POST_ID = ?";
                        } else if (acceptedApplications < rs.getInt(7)) {
                            // 수락된 인원수가 모집 인원보다 작으면 "진행"으로 표시
                            updateStatusQuery = "UPDATE TRAVEL_COMPANION_POST SET STATE = '진행' WHERE POST_ID = ?";

                        } try (PreparedStatement updateStatusStmt = conn.prepareStatement(updateStatusQuery)) {
                            updateStatusStmt.setInt(1, PostId);
                            updateStatusStmt.executeUpdate();
                        }
                        
                        
                    %>
                   <p class="card-text">게시글 동행 상황 : <%= rs.getString(6) %></p>
                  <p class="card-text">모집 인원 : <%= rs.getString(7) %></p>
                  <p class="card-text">수락된 인원 수 : <%= acceptedApplications %></p>
                  <a href="./detailCompanionPost.jsp?post_id=<%= PostId %>" class="btn btn-primary" style="background-color: #ffc300; color: #ffffff;">작성 글로 이동</a>
            				<button type="button" class="btn btn-warning"
                                onclick="acceptRequestState('<%= rs.getString(1) %>', <%= maxParticipants %>, <%= acceptedApplications %>,'<%= rs.getString(7) %>','<%= rs.getString(5) %>')"
                                data-member-id="<%= rs.getString(1) %>"
                                style="background-color: #ffc300; color: #ffffff;">수락</button>
                            <button type="button" class="btn btn-warning"
                                onclick="rejectRequestState('<%= rs.getString(1) %>', <%= maxParticipants %>, <%= acceptedApplications %>, '<%= rs.getString(7) %>', '<%= rs.getString(5) %>')"
                                data-member-id="<%= rs.getString(1) %>"
                                style="background-color: #ffc300; color: #ffffff;">거절</button>
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
  <a href="./myPageCompanionPost.jsp" class="list-group-item list-group-item-action">내 동행 게시글 조회</a>
  <a href="./myPageintroductionPost.jsp" class="list-group-item list-group-item-action">내 여행 소개글 조회</a>
  <a href="./myPageAppliedInfo.jsp" class="list-group-item list-group-item-action active" aria-current="true" style="background-color: #ffc300"; >동행 요청 현황</a>
  <a href="./myPageApplyInfo.jsp" class="list-group-item list-group-item-action">동행 신청 현황</a>
  <a href="./myPageOneToOneChat.jsp" class="list-group-item list-group-item-action">1:1 채팅 목록</a>
  <a href="./myPageLikeList.jsp" class="list-group-item list-group-item-action">좋아요 글 목록</a>
  <a href="./myPageScrapList.jsp" class="list-group-item list-group-item-action">스크랩 글 목록</a>
 
</div>
        </div>
        </div>
      </div>

      <div id="footer"></div>
 <!-- Bootstrap Modal for Accept -->
<div class="modal fade" id="acceptModal" tabindex="-1" role="dialog" aria-labelledby="acceptModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="acceptModalLabel">동행을 수락하셨습니다.</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
    </div>
  </div>
</div>

<!-- Bootstrap Modal for Reject -->
<div class="modal fade" id="rejectModal" tabindex="-1" role="dialog" aria-labelledby="rejectModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="rejectModalLabel">동행을 거절하셨습니다.</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <!-- You can add additional content here -->
      </div>
    </div>
  </div>
</div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
    
  </body>
</html>
