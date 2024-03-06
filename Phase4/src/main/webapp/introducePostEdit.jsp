<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>
<%@ page language="java" import="java.lang.Integer" %>
<%@ page language="java" import="java.time.LocalDateTime" %>
<%@ page language="java" import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>일정소개글 쓰기</title>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<%
String PostId = request.getParameter("post_id");	 
HttpSession s = request.getSession();
String my_id = (String)s.getAttribute("member_id");
String nation_code=request.getParameter("nation");
String nation="";
%>
<script>
   $(function(){
	    $("#navbar").load("layout/navbar.html");
	    $("#footer").load("layout/footer.html");
	});
   function setCookie(cName, cValue, cDay){
	      var expire = new Date();
	      expire.setDate(expire.getDate() + cDay);
	      cookies = cName + '=' + escape(cValue) + '; path=/ ';
	      if(typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
	      document.cookie = cookies;
	}
	function getCookie(cName) {
	      cName = cName + '=';
	      var cookieData = document.cookie;
	      var start = cookieData.indexOf(cName);
	      var cValue = '';
	      if(start != -1){
	        start += cName.length;
	        var end = cookieData.indexOf(';', start);
	        if(end == -1)end = cookieData.length;
	        cValue = cookieData.substring(start, end);
	      }
	      return unescape(cValue);
	}

	function UpdateintroPost() {
		console.log("UpdateCompanionPost function called");
	    var title = document.getElementsByName("title")[0].value;
	    var travelDate = document.getElementById("currentDate").value;
	    var travelPeriod = document.getElementsByName("travel_period")[0].value;
	   	var expectedCost = document.getElementsByName("cost")[0].value;
	    var contentText = document.getElementsByName("content_text")[0].value;
	    var imageName = document.getElementsByName('image')[0].files[0].name;



	   console.log(title);
	    // Ajax 요청을 보냄
	    $.ajax({
	        type: "POST",
	        url:"<%=request.getContextPath()%>" + "/UpdateIntroPostServlet",
	        data: {
	            title: title,
	            travelDate: travelDate,
	            travelPeriod: travelPeriod,
	            expectedCost: expectedCost, // 추가한 부분
	            contentText: contentText, // 추가한 부분
	            imageName: imageName,
	            memberId: '<%= my_id %>', // 세션에서 가져온 멤버 ID
	            postId: '<%= PostId %>' // 게시물 ID
	        },
	        success: function(response) {
	            // 서버에서의 응답에 따른 동작
	            console.log(response);
	        },
	        error: function(error) {
	            // 에러 핸들링
	            console.error(error);
	        }
	    });
	}
</script>
<script>
setCookie("posted", "yes", 1);
</script>
</head>
<body>

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
	
    String title = null; // 변수 초기화
    String travelDateStr = "";
    String travelPeriod = "";
    String Cost = "";
    String contentText = "";
	
	Class.forName("oracle.jdbc.driver.OracleDriver");
	conn = DriverManager.getConnection(url,user,pass);
	
	     
	String query = "SELECT Title, Travel_date,Travel_period,Cost,Content_text FROM TRAVEL_INTRODUCTION_POST WHERE Post_id=?";
	     
	pstmt = conn.prepareStatement(query);
	pstmt.setString(1, PostId);
	     
	rs = pstmt.executeQuery(); 

	 while (rs.next()) {
         title = rs.getString(1);

         // Travel_date를 java.sql.Date로 받아오기
         java.sql.Date travelDateSql = rs.getDate(2);

         // java.sql.Date를 java.util.Date로 변환 (생략 가능)
         Date travelDateUtil = new Date(travelDateSql.getTime());

         // SimpleDateFormat을 사용하여 문자열로 변환
         SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
         travelDateStr = dateFormat.format(travelDateUtil);

         travelPeriod = rs.getString(3);
         
         Cost = rs.getString(4);
         contentText = rs.getString(5);
     };

	rs.close();
	pstmt.close();

%>

<div id="navbar"></div>

	<form action="introducePostResult.jsp" method="POST" enctype="multipart/form-data" accept-charset="UTF-8">
		<div id="location" name="location"><%=nation %></div>
		<div class="mb-3">
		  <label for="formGroupExampleInput" class="form-label" >제목</label>
		  <input type="text" name="title" class="form-control" id="formGroupExampleInput" placeholder="제목을 입력하세요" value='<%= title %>' required >
		</div>
		<div class="input-group mb-3">
		  <span class="input-group-text" id="basic-addon1">여행날짜 선택</span>
		  <input type="date" id="currentDate" name="travel_date" min="2023-01-01" max="2023-12-31" class="form-control" value='<%= travelDateStr %>'>
		  <span class="input-group-text" id="basic-addon1">여행기간</span>
		  <input type="text" name="travel_period" class="form-control" id="formGroupExampleInput" placeholder="O박O일" value='<%= travelPeriod %>'>
		</div>
		
		  <div class="col-sm-5">
		    <div class="input-group mb-3">
		  <span class="input-group-text" id="basic-addon1">비용</span>
		  <input type="text" name="cost" class="form-control" placeholder="O만원대" value='<%= Cost %>'>
		</div>
		  </div>

		
		
		<div class="mb-3">
		  <label for="formGroupExampleInput2" class="form-label">사진 첨부</label>
		  <input input type="file" name="image" class="form-control" id="formGroupExampleInput2" required >
		</div>
		<div class="mb-3">
			<label for="formGroupExampleInput" class="form-label">글쓰기</label>
		<div class="input-group">
			<textarea class="form-control" name="content_text" aria-label="With textarea" style="height: 300px;"placeholder="본문을 입력하세요" required ><%= contentText %></textarea>
		</div>
		</div>
		
		<br/>
		

		
		
	
		<br/>
		<br/>
		<button type="reset" class="btn btn-primary">Reset</button>
		<a href="./detailIntroducePost.jsp?post_id=<%= PostId %>" class="btn btn-primary" role="button" onclick="UpdateintroPost()">Submit</a>

		
	</form>


<div id="footer"></div>
</body>
</html>
