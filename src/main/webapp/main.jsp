<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>
<%@ page language="java" import="java.time.LocalDateTime,java.time.LocalDate" %>
<%@ page language="java" import="java.time.format.DateTimeFormatter" %>
<%@ page import="javax.servlet.*,javax.servlet.http.*" %>
<%@ page import="com.chat" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>DND</title>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<link rel="stylesheet" href="./css/main.css" />
<script>
   $(function(){
	    $("#navbar").load("layout/navbar.html");
	    $("#footer").load("layout/footer.html");
	});
</script>
</head>
<body>
<div id="navbar"></div>


<div class="header">
	<div class="location">
		<form>
			<select name="continent">
				<option value="selection">대륙선택</option>
				<option value="아시아">아시아</option>
				<option value="유럽">유럽</option>
				<option value="아프리카">아프리카</option>
				<option value="북아메리카">북아메리카</option>
				<option value="남아메리카">남아메리카</option>
				<option value="오세아니아">오세아니아</option>
			</select>
			<select name="nation">
				<option value="selection">나라선택</option>
				<option value="KOR">한국</option>
				<option value="JPN">일본</option>
				<option value="CHN">중국</option>
				<option value="QAT">카타르</option>
				<option value="VNM">베트남</option>
				<option value="SGP">싱가포르</option>
			</select>
		</form>
	</div>
	
	<h2>한국</h2>
	
	<div class="write">
		<form action="" name="post">
			<select name="write" onchange="location=document.post.write.value">
				<option>글쓰기</option>
				<option value="companionPost.html">동행찾기 글쓰기</option>
				<option value="introducePost.html">일정소개 글쓰기</option>
			</select>
		</form>
	</div>
	
</div>

<img src="kor_main.jpg" alt="나라 별 사진 표시"><br>


<div class="btns">
	<div class="btn">
	    <button onclick="location.href='동행찾기글 보는 페이지'">동행 찾기 글 보기</button>
	 </div>
	 <div class="btn">
		<button onclick="location.href='itrPostList.jsp'">일정 소개 글 보기</button>
	</div>
</div>

<div class="realTChat">
<% 
	String serverIP = "localhost";
	String strSID = "orcl";
	String portNum = "1521";
	String user = "university";
	String pass = "comp322";
	String url = "jdbc:oracle:thin:@"+serverIP+":"+portNum+":"+strSID;

	Connection conn = null;
	PreparedStatement pstmt;
	ResultSet rs;
	Class.forName("oracle.jdbc.driver.OracleDriver");
	conn = DriverManager.getConnection(url,user,pass);
%>

<%
HttpSession s = request.getSession();
String member_id = (String)s.getAttribute("member_id");
//String member_id = "Mid1";
String location = "KOR";
%>

<script type="text/javascript">
var content
	function func() {
	content = document.getElementById("message").value;
	}

$(document).ready(function() {
    var member_id = '<%= member_id %>';
    var location = '<%= location %>';
    
    $("#sendBtn").on("click", function() {
    	func();
        $.ajax({
            type: "POST",
            url: "addChat",
            data:{"member_id":member_id,
            		"location":location,
            		"content":content},
            		
            success: function(response) {
                alert(response);
                
               
            },
            error: function(error) {
                alert(error);
            }
            
            location.reload();
        });
    });
});

</script>
  <section class="mb-5">
      <div class="card bg-light">
          <div class="card-body">
              <div class="chat-container mt-3">
				<%
				String sql = "select m.nickname, c.message, c.creation_time, c.sender_location from member m, real_time_chat c where c.member_id = m.member_id and c.location_id='KOR' order by c.creation_time asc";
				pstmt = conn.prepareStatement(sql);
				//out.println(sql);
				rs = pstmt.executeQuery();
				
				while (rs.next()) {
				
					String nickname = rs.getString(1);
				    String message = rs.getString(2);
				    String sendTime = rs.getString(3);
				    String senderLocation = rs.getString(4);
				    %>
			        <div class="chat-message">
			            <strong><%= nickname %>:</strong> <%= message %>
			            
			            <small><%= sendTime %>, <%= senderLocation %></small>
			        </div>
				<%
				}
				%>
                </div>
            </div>
        </div>
    </section>
    
    
<div class="input-group">
    <input type="text" id="message" class="form-control">
    <button type="submit" id="sendBtn" class="btn btn-primary">전송</button>
</div>
	
</div>

<div id="footer"></div>
</body>
</html>