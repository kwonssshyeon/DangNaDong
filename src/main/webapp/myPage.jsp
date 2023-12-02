<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <title>MyPage</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
	<link rel="stylesheet" href="./css/myPageStyle.css" />
    <link rel="stylesheet" href="./css/pop.css" />
	
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
	<script src="./js/myPage.js"></script>
	<script>
    
	 function handleUpdateComplete() {
         var nickname = document.getElementById("nickname").value;
         var introduction = document.getElementById("introduction").value;
         var email = document.getElementById("email").value;
         var birthdate = document.getElementById("birthdate").value;
         // 선택한 이미지 파일 가져오기
         var selectedImageFile = document.getElementById("fileInput").files[0];
         
         // 데이터 중 null 값 체크
         if (!nickname || !introduction || !email || !birthdate) {
           // 입력값 중 null 값 존재함.
           $("#invalidInfoModal").modal("show");
           return;
         }
         
         console.log("selectedImage : ",selectedImageFile);
		 console.log("selectedImage : ",selectedImageFile.name);
         
         	//여기서 서버로 이동
			$.ajax({
			  type: "POST",
			  url: "<%=request.getContextPath()%>" + "/UpdateMemberServlet" ,// 수정할 서블릿의 주소로 변경
           data: {
             member_id: "Mid1", // 수정 대상의 Member_id
             nickname: nickname,
             introduction: introduction,
             email: email,
             birthdate: birthdate,
             profile_image:selectedImageFile.name
           },
           success: function (response) {
             // 서버에서의 처리가 성공했을 때의 동작
             showPopup('successPopup');
             
             setTimeout(function () {
           	  window.location.href = "./myPage.jsp";
             }, 2000); // 1000 밀리초 = 1초
           },
           error: function (error) {
             // 서버에서의 처리가 실패했을 때의 동작
             console.error("Update failed:", error);
           }
         });
         showPopup('successPopup');  
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
          <h3 style="margin-bottom: 30px;">개인 정보 수정</h3>
          <div class="imageBtu">
         <% 
              String serverIP = "localhost"; 
              String strSID = "orcl"; 
              String portNum = "1521";
              String user = "university"; 
              String pass = "comp322"; 
              String url = "jdbc:oracle:thin:@" + serverIP + ":" +portNum + ":" + strSID; 
              Connection conn = null; 
              PreparedStatement pstmt = null; 
              ResultSet rs = null; 
                        
              String profileImageSrc = ""; // 초기화

              try {
                Class.forName("oracle.jdbc.driver.OracleDriver"); 
                conn = DriverManager.getConnection(url, user, pass); 
                

                String currentMemberId = "Mid1"; // 실제로 로그인한 회원 ID로 대체하세요

                String query = "select Profile_image from MEMBER where Member_id=?";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, currentMemberId);
                rs = pstmt.executeQuery();

                while (rs.next()) {
                    String profileImagePath = rs.getString(1);
                %>
				 <script>
		    // Wrap your code in a function
		    function updateProfileImage() {
		        var profileImagePath = '<%= profileImagePath %>';
		        console.log("profileImagePath test: " + profileImagePath);
		
		        // profileImagePath가 null이면 label과 input을 보여줌
		        if (profileImagePath === null) {
		            document.getElementById("profileImage").style.display = "block";
		        } else {
		            // profileImagePath가 null이 아니면 이미지를 보여줌
		            var selectedImage = document.getElementById("selectedImage");
		            if (selectedImage) {
		                selectedImage.src = profileImagePath;
		                selectedImage.style.display = "block";
            }
        }
    }

    // Call the function after the document has fully loaded
    document.addEventListener("DOMContentLoaded", updateProfileImage);
</script>

                <%
                }
              } catch (Exception e) {
                  e.printStackTrace();
              } finally {
                  try {
                      if (rs != null) rs.close();
                      if (pstmt != null) pstmt.close();
                      if (conn != null) conn.close();
                  } catch (SQLException e) {
                      e.printStackTrace();
                  }
              }
                %>
		<label class="imgBtu" for="fileInput" id="profileImage">프로필<img id="selectedImage" class="selected-image" src="" alt="Selected Image"></label>
		<input type="file" id="fileInput" class="file-input" onchange="handleFileSelect(this)">
          </div>
         <div class="mb-3">
		  <label for="formGroupExampleInput" class="form-label">닉네임</label>
		  <input type="text" class="form-control" id="nickname" placeholder="닉네임을 입력해주세요.">
		</div>
		<div class="mb-3">
		  <label for="formGroupExampleInput2" class="form-label">소개글</label>
		  <input type="text" class="form-control" id="introduction" placeholder="소개글을 입력해주세요.">
		</div>
		<div class="mb-3">
		  <label for="formGroupExampleInput" class="form-label">이메일을 입력해주세요</label>
		  <input type="text" class="form-control" id="email" placeholder="이메일을 입력해주세요">
		</div>
		<div class="mb-3">
		  <label for="formGroupExampleInput2" class="form-label">생년월일</label>
		  <input type="text" class="form-control" id="birthdate" placeholder="생년월일을 입력해주세요">
		</div>
        </div>
        <div class="menuArea">
<div class="list-group">
  <a href="./myPage.jsp" class="list-group-item list-group-item-action active" aria-current="true" style="background-color: #ffc300";  >
    개인 정보 수정
  </a>
  <a href="./myPageCompanionPost.jsp" class="list-group-item list-group-item-action">내 동행 게시글 조회</a>
  <a href="./myPageintroductionPost.jsp" class="list-group-item list-group-item-action">내 여행 소개글 조회</a>
  <a href="./myPageAppliedInfo.jsp" class="list-group-item list-group-item-action"  >동행 요청 현황</a>
  <a href="./myPageApplyInfo.jsp" class="list-group-item list-group-item-action">동행 신청 현황</a>
  <a href="./myPageOneToOneChat.jsp" class="list-group-item list-group-item-action">1:1 채팅 목록</a>
  <a href="./myPageLikeList.jsp" class="list-group-item list-group-item-action">좋아요 글 목록</a>
  <a href="./myPageScrapList.jsp" class="list-group-item list-group-item-action">스크랩 글 목록</a>
 
</div>
        </div>
      </div>
<div class="changeBtu">
    <button type="button" class="btn btn-warning" onclick="handleUpdateComplete()" style="background-color: #ffc300; color: #ffffff;">수정하기</button>
</div>
      <div id="footer"></div>
    </div>
    <!-- 수정 완료 팝업 -->
<div id="successPopup" class="popup">
  <div class="popup-content">
    <h3>수정 완료</h3>
    <p>수정이 완료되었습니다.</p>
    <span class="close" onclick="hidePopup('successPopup')">&times;</span>
  </div>
</div>
    <!-- "정확한 정보를 기입해주세요" 모달 -->
    <div class="modal" id="invalidInfoModal" tabindex="-1" role="dialog">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">입력 오류</h5>
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
            <p>정확한 정보를 기입해주세요.</p>
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