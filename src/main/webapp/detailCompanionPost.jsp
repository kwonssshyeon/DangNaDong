<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>
<%@ page language="java" import="java.time.LocalDateTime,java.time.LocalDate" %>
<%@ page language="java" import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>여행동행글 상세보기</title>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script>
   $(function(){
	    $("#navbar").load("layout/navbar.html");
	    $("#footer").load("layout/footer.html");
	});
</script>
</head>
<body>
<div id="navbar"></div>
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
<%!
int post_id=1411;
String member_id="Mid1";
String my_id="Mid2";
String creationTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
%>
<div id="content">
<%
	//post 정보 가져오기
	String member_id="";
	String creation_time="";
	String title="";
	String content_text="";
	String travel_date="";
	String travel_period="";
	String cost="";
	
	String state="";
	String deadline="";
	int number_of_recruited=0;
	String gender_condition="";
	String age_condition="";
	String nationality_condition="";
	
	
		
	String selectSql = "select * from TRAVEL_COMPANION_POST where post_id="+ post_id;
	Statement stmt = conn.createStatement();
	try{
		rs = stmt.executeQuery(selectSql);
		while (rs.next()) {
			post_id = rs.getInt(1);
			member_id = rs.getString(2);
			creation_time = rs.getString(3);
			title = rs.getString(4);
			content_text = rs.getString(5);
			travel_date = rs.getString(6);
			travel_period = rs.getString(7);
			cost = rs.getString(8);
			state = rs.getString(9);
			deadline = rs.getString(10);
			gender_condition = rs.getString(11);
			age_condition = rs.getString(12);
			nationality_condition = rs.getString(13);
			number_of_recruited = rs.getInt(14);
         }
		//stmt.close();
	} catch (SQLException e) {
        out.println(e.getMessage());
    }
	//location정보 가져오기
	String nation="";
	
	String locationSql = "select nation from location natural join cpn_contain where post_id="+ post_id;
	stmt = conn.createStatement();
	try{
		rs = stmt.executeQuery(locationSql);
		while (rs.next()) {
			nation = rs.getString(1);
         }
	} catch (SQLException e) {
        out.println(e.getMessage());
    }
	
	//image정보 가져오기
	String imgSql = "select img_url from cpn_image where post_id="+post_id;
	String img="";
	stmt = conn.createStatement();
	try{
		rs = stmt.executeQuery(imgSql);
		while (rs.next()) {
			img = rs.getString(1);
         }
	} catch (SQLException e) {
        out.println(e.getMessage());
    }
	
	//좋아요정보 가져오기
	String likeSql = "select count(*) from like_post where post_id="+post_id;
	int like=0;
	stmt = conn.createStatement();
	try{
		rs = stmt.executeQuery(likeSql);
		while (rs.next()) {
			like = rs.getInt(1);
         }
	} catch (SQLException e) {
        out.println(e.getMessage());
    }
	%>
	<% 
	String applyNum = "select count(*) from application_info where post_id="+post_id;
	int aNum=0;
	stmt = conn.createStatement();
	try{
		rs = stmt.executeQuery(applyNum);
		while (rs.next()) {
			aNum = rs.getInt(1);
         }
	} catch (SQLException e) {
        out.println(e.getMessage());
    }
	
	
	%>
	<h1><%= nation %></h1>
	<h1><%= title %></h1>
	<h1><%= member_id %></h1>
	<p><%= creation_time %>        좋아요 수: <%=like %></p>
	<img src="<%=img%>">
	<p>여행날짜: <%= travel_date %>  /  여행기간:<%= travel_period %></p>	
	<p>비용:<%= cost %></p>
	<h4>모집조건</h4>
	<p>인원수: <%= number_of_recruited %></p>
	<p>성별: <%=gender_condition %>  /  나이: <%=age_condition %>  /  국적: <%=nationality_condition %></p>
	<h3><%= content_text %></h3>
	<h1>신청현황</h1>
	<%
	//신청현황정보 가져오기
		String applySql = "select nickname, profile_image from member natural join application_info where request_state='수락' and post_id="+post_id;
		String aNickname="";
		String aProfile_image="";
		stmt = conn.createStatement();
		try{
			rs = stmt.executeQuery(applySql);
			while (rs.next()) {
				aNickname = rs.getString(1);
				aProfile_image = rs.getString(2);
				out.print("<img src="+aProfile_image+">");
				out.print("<h4>"+aNickname+"</h4>");
	         }
			out.println("<h2>"+aNum+ " / " +number_of_recruited+"</h2>");
		} catch (SQLException e) {
	        out.println(e.getMessage());
	    }
	%>
	
	<button onclick="location.href='apply.html'">신청하기</button >
	<button onclick="location.href='chat.html'">채팅하기</button >
	
	


<div id="footer"></div>
</div>

</body>
</html>