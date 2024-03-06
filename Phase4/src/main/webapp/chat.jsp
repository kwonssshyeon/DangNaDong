<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <title>MyPage</title>
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <link rel="stylesheet" href="./css/myPageStyle.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
        <style>
        .message-container {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            border: 1px solid #ffc300;
            border-radius: 5px; 
            padding: 10px;
            margin-bottom: 5px;
        }

        .message.sent {
        
            align-self: flex-end;
        }

        .message.received {
         
            align-self: flex-start;
        }
    </style>
    <script>
    $(function () {
        $("#navbar").load("layout/navbar.html");
        $("#footer").load("layout/footer.html");
    });
    var sendingMessage = false;
    function sendMessage() {
        if (sendingMessage) {
            return;
        }
        sendingMessage = true;
    	var message = document.getElementById('messageInput').value;

        console.log('Member ID(sender):', member_id); 
        console.log('message : ',message);
        console.log('chat room id : ',chat_room_id);
        
        if (!message) {
            // 메세지에 값을 입력하지 않음
            $('#rejectModal').modal('show');
            return;
        }
        // 여기서 서버로 이동
        $.ajax({
            type: "POST",
            url: "<%=request.getContextPath()%>" + "/ChatMessagesServlet",
            data: {
                member_id: member_id, // 메세지를 보내는 사람 ID 
                message: message,
                chat_room_id : chat_room_id
            },
            success: function (response) {
                // 서버에서의 처리가 성공했을 때의 동작
                console.error("sent successfully : ");

                // 모달을 보여줌
                $('#acceptModal').modal('show');
                setTimeout(function () {
               	  window.location.href = "./chat.jsp"+"?chat_room_id="+chat_room_id;
                 },1500);
            },
            error: function (error) {
                // 서버에서의 처리가 실패했을 때의 동작
                console.error("sent failed:", error);
            }
        });
        
        // 서버로 메시지 전송 후에
        sendingMessage = false;
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
<h3 style="margin-bottom: 30px;">1:1채팅 목록</h3>
<div class="container mt-5">
  <div class="row">
    <div class="col-md-8 offset-md-2">
      <div class="card">
        <div class="card-header">
          채팅방
        </div>
        <div class="card-body" style="height: 400px; overflow-y: scroll;">
        
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
                
                conn.setAutoCommit(false); // 트랜잭션 시작
                
                String chatRoomId = request.getParameter("chat_room_id");
                //String query = "select Chat_room_id,Member_id,Message from ONE_TO_ONE_CHAT where Member_id='Mid129'";  
                
                String query = "SELECT ONE_TO_ONE_CHAT.Member_id, ONE_TO_ONE_CHAT.Message, MEMBER.Nickname FROM ONE_TO_ONE_CHAT JOIN MEMBER ON ONE_TO_ONE_CHAT.Member_id = MEMBER.Member_id WHERE ONE_TO_ONE_CHAT.Chat_room_id = ? FOR UPDATE";
                
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, chatRoomId);
                
                rs = pstmt.executeQuery(); 
                
                conn.commit(); // 트랜잭션 커밋
                while (rs.next()) {
                    String chat_room_id = chatRoomId;
                    String member_id = rs.getString(1);
                    String message = rs.getString(2);
                    String nickname = rs.getString(3);
            %>
            <script>
			    var member_id = '<%= member_id %>';
			    var chat_room_id = '<%= chat_room_id %>';
			</script>
				    <div class="message-container">
				        <% if (member_id.equals("Mid267")) { %>  
						            <div class="message sent">
		                <p><strong>보내는 사람:</strong> <%= nickname %></p>
		                <p><strong>메시지:</strong> <%= message %></p>
		            </div>
		        <% } else { %>
		            <div class="message received">
		                <p><strong>보내는 사람:</strong> <%= nickname %></p>
		                <p><strong>메시지:</strong> <%= message %></p>
		            </div>
		        <% } %>
		    </div>
            <%
            
                } 
                rs.close(); 
                pstmt.close(); 
                conn.close(); 
              } catch (Exception e) {
            	  if (conn != null) {
            	        try {
            	            conn.rollback(); // 트랜잭션 롤백
            	        } catch (SQLException ex) {
            	            ex.printStackTrace();
            	        }
            	    }
                e.printStackTrace();
              }
            %>
        </div>
         </div>
        <div class="card-footer">
          <div class="input-group">
            <input type="text" id="messageInput" class="form-control" placeholder="메시지 입력">          
            <button type="button" class="btn btn-warning" onclick="sendMessage()" style="background-color: #ffc300; color: #ffffff;">전송하기</button>
          </div>
        </div>
      </div>
    </div>
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
    <div class="modal fade" id="acceptModal" tabindex="-1" role="dialog" aria-labelledby="acceptModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="acceptModalLabel">메세지를 전송하였습니다.</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
    </div>
  </div>
</div>

  <div class="modal fade" id="rejectModal" tabindex="-1" role="dialog" aria-labelledby="acceptModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="acceptModalLabel">올바른 값을 입력해주세요.</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
    </div>
  </div>
</div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
    
  </body>
</html>
