<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>
<%@ page language="java" import="java.lang.Integer" %>
<%@ page language="java" import="java.time.LocalDateTime" %>
<%@ page language="java" import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>여행 동행글 쓰기</title>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>

<script>
   $(function(){
	    $("#navbar").load("layout/navbar.html");
	    $("#footer").load("layout/footer.html");
	});
</script>
</head>
<body>
<%
int post_id;
HttpSession s = request.getSession();
String my_id = (String)s.getAttribute("member_id");
String nation_code=request.getParameter("nation");
String nation="";
%>
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
	
	String sql = "select nation from location where location_id='"+nation_code+"'";
	Statement stmt = conn.createStatement();
	ResultSet max_rs = stmt.executeQuery(sql);
	if(max_rs.next())
		nation = max_rs.getString(1);
	max_rs.close();
	stmt.close();

%>
	
<div id="navbar"></div>
	<form action="companionPostResult.jsp" method="POST" enctype="multipart/form-data" accept-charset="UTF-8">
		<div id="location" name="location"><%=nation %></div>
		<div class="mb-3">
		  <label for="formGroupExampleInput" class="form-label">제목</label>
		  <input type="text" name="title" class="form-control" id="formGroupExampleInput" placeholder="제목을 입력하세요" required >
		</div>
		<div class="input-group mb-3">
		  <span class="input-group-text" id="basic-addon1">여행날짜 선택</span>
		  <input type="date" id="currentDate" name="travel_date" min="2023-01-01" max="2023-12-31" class="form-control">
		  <span class="input-group-text" id="basic-addon1">여행기간</span>
		  <input type="text" name="travel_period" class="form-control" id="formGroupExampleInput" placeholder="O박O일">
		</div>
		
		  <div class="col-sm-5">
			  <div class="input-group mb-3">
			<span class="input-group-text" id="basic-addon1">모집마감일</span>
		    <input type="date" name="deadline" min="2023-01-01" max="2023-12-31" class="form-control" required>
		    </div>
		    <div class="input-group mb-3">
		  <span class="input-group-text" id="basic-addon1">예상비용</span>
		  <input type="text" name="expected_cost" class="form-control" placeholder="O만원대">
		</div>
		  </div>
		
		모집인원
		<div class="input-group mb-3">
		  <span class="input-group-text" id="basic-addon1">인원수</span>
		  <input type="number" name="number_of_recruited" class="form-control" id="formGroupExampleInput" required>
		  <span class="input-group-text" id="basic-addon1">성별</span>
		  <input type="text" name="gender_condition" class="form-control" id="formGroupExampleInput" placeholder="남/여/무관">
		  <span class="input-group-text" id="basic-addon1">나이</span>
		  <input type="text" name="age_condition" class="form-control" id="formGroupExampleInput" placeholder="O대/무관">
		  <span class="input-group-text" id="basic-addon1">국적</span>
		  <input type="text" name="nationality_condition" class="form-control" id="formGroupExampleInput">
		</div>
		
		
		<div class="mb-3">
		  <label for="formGroupExampleInput2" class="form-label">사진 첨부</label>
		  <input input type="file" name="image" class="form-control" id="formGroupExampleInput2" required>
		</div>
		<div class="mb-3">
			<label for="formGroupExampleInput" class="form-label">글쓰기</label>
		<div class="input-group">
			<textarea class="form-control" name="content_text" aria-label="With textarea" style="height: 300px;" placeholder="본문 내용입니다." required></textarea>
		</div>
		</div>
		
		<br/>
		

		
		
	
		<br/>
		<br/>
		<button type="reset" class="btn btn-primary">Reset</button>
		<button type="submit" class="btn btn-primary">Submit</button>
	</form>




<div id="footer"></div>
</body>
</html>