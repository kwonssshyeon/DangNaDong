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
	
	   conn = null; 
	    pstmt = null; 
	    rs = null; 
	              
	    String profileImageSrc = ""; // 초기화
	    String title = null; // 변수 초기화
        String travelDateStr = "";
        String travelPeriod = "";
        String deadlineStr = "";
        String expectedCost = "";
        int numberOfRecruited = 0;
        String genderCondition = "";
        String ageCondition = "";
        String nationalityCondition = "";
        String contentText = "";
		
		//제목,여행날짜,여행기간,모집마감일,예상비용,인원수,성별,나이,국적,사진,글쓰기
		
		 Class.forName("oracle.jdbc.driver.OracleDriver"); 
	     conn = DriverManager.getConnection(url, user, pass); 
	     
	     String PostId = request.getParameter("post_id");	     
	     String query = "SELECT Title, Travel_date,Travel_period,Deadline,Expected_cost,Number_of_recruited,Gender_condition,Age_condition,Content_text,Nationality_condition FROM TRAVEL_COMPANION_POST WHERE Post_id=?";
	     
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
             
             // Deadline을 문자열로 변환
             java.sql.Date deadlineSql = rs.getDate(4);
             Date deadlineUtil = new Date(deadlineSql.getTime());
             deadlineStr = dateFormat.format(deadlineUtil);

             expectedCost = rs.getString(5);
             numberOfRecruited = rs.getInt(6);
             genderCondition = rs.getString(7);
             ageCondition = rs.getString(8);
             nationalityCondition = rs.getString(9);
             contentText = rs.getString(10);
	     };
	

%>
	
<div id="navbar"></div>
	<form action="companionPostResult.jsp" method="POST" enctype="multipart/form-data" accept-charset="UTF-8">
		<div id="location" name="location"><%=nation %></div>
		<div class="mb-3">
		  <label for="formGroupExampleInput" class="form-label">제목</label>
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
			<span class="input-group-text" id="basic-addon1">모집마감일</span>
		    <input type="date" name="deadline" min="2023-01-01" max="2023-12-31" class="form-control" value='<%= deadlineStr %>' required>
		    </div>
		    <div class="input-group mb-3">
		  <span class="input-group-text" id="basic-addon1">예상비용</span>
		  <input type="text" name="expected_cost" class="form-control" placeholder="O만원대" value='<%= expectedCost %>'>
		</div>
		  </div>
		
		모집인원
		<div class="input-group mb-3">
		  <span class="input-group-text" id="basic-addon1">인원수</span>
		  <input type="number" name="number_of_recruited" class="form-control" id="formGroupExampleInput" value='<%= numberOfRecruited %>' required>
		  <span class="input-group-text" id="basic-addon1">성별</span>
		  <input type="text" name="gender_condition" class="form-control" id="formGroupExampleInput" placeholder="남/여/무관" value='<%= genderCondition %>'>
		  <span class="input-group-text" id="basic-addon1">나이</span>
		  <input type="text" name="age_condition" class="form-control" id="formGroupExampleInput" placeholder="O대/무관" value='<%= ageCondition %>'>
		  <span class="input-group-text" id="basic-addon1">국적</span>
		  <input type="text" name="nationality_condition" class="form-control" id="formGroupExampleInput" value='<%= nationalityCondition %>'>
		</div>
		
		
		<div class="mb-3">
		  <label for="formGroupExampleInput2" class="form-label">사진 첨부</label>
		  <input input type="file" name="image" class="form-control" id="formGroupExampleInput2" required>
		</div>
		<div class="mb-3">
			<label for="formGroupExampleInput" class="form-label">글쓰기</label>
		<div class="input-group">
			<textarea class="form-control" name="content_text" aria-label="With textarea" style="height: 300px;" placeholder="본문 내용입니다." required><%= contentText %></textarea>
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