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
<title>일정소개글 상세보기</title>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script>
   $(function(){
	    $("#navbar").load("layout/navbar.html");
	    $("#footer").load("layout/footer.html");
	    $("#reply").load("reply.jsp");
	    $("#replyForm").load("reply.html");
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
int post_id=2006;
int reply_id;
String member_id="Mid1";
String my_id="Mid2";
String creationTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
%>
<%
	String max_query="SELECT MAX(reply_id) FROM REPLY";
	Statement stmt = conn.createStatement();
	ResultSet max_rs = stmt.executeQuery(max_query);
	if(max_rs.next())
		reply_id = max_rs.getInt(1);
	max_rs.close();
	//stmt.close();
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
		
	String selectSql = "select * from TRAVEL_INTRODUCTION_POST where post_id="+ post_id;
	//Statement stmt = conn.createStatement();
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
         }
		//stmt.close();
	} catch (SQLException e) {
        out.println(e.getMessage());
    }
	//location정보 가져오기
	String nation="";
	
	String locationSql = "select nation from location natural join itr_contain where post_id="+ post_id;
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
	String imgSql = "select img_url from itr_image where post_id="+post_id;
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
	
	//스크랩정보 가져오기
	String scrapSql = "select count(*) from scrap where post_id="+post_id;
	int scrap=0;
	stmt = conn.createStatement();
	try{
		rs = stmt.executeQuery(scrapSql);
		while (rs.next()) {
			scrap = rs.getInt(1);
         }
	} catch (SQLException e) {
        out.println(e.getMessage());
    }
	
	
	%>
	<h1><%= nation %></h1>
	<h1><%= title %></h1>
	<h1><%= member_id %></h1>
	<p><%= creation_time %>        스크랩수: <%=scrap %></p>
	<br/>
	<img src="<%=img%>">
	<p>여행날짜: <%= travel_date %>  /  여행기간:<%= travel_period %>  /  여행비용:<%= cost %></p>	
	<h1><%= content_text %></h1>
	
	
	<div id="reply"></div>
	<div id="replyForm"></div>
	
	<%
	//댓글정보 가져오기
	out.println("<h1>댓글</h1>");
	String replySql = "select nickname, profile_image, content, creation_time from member natural join reply where post_id="+1193;
	String rNickname="";
	String rProfile_image="";
	String rContent="";
	String rCreation_time="";
	stmt = conn.createStatement();
	try{
		rs = stmt.executeQuery(replySql);
		while (rs.next()) {
			rNickname = rs.getString(1);
			rProfile_image = rs.getString(2);
			rContent = rs.getString(3);
			rCreation_time = rs.getString(4);
			out.print("<img src="+rProfile_image+">");
			out.print("<h4>"+rNickname+"</h4>");
			out.print("<h4>"+rCreation_time+"</h4>");
			out.print("<h4>"+rContent+"</h4>");
         }
	} catch (SQLException e) {
        out.println(e.getMessage());
    }
	
	
	//댓글 입력하기 ?!?!?!
	%>
	
	
	<%!
	public void insertR(Connection conn,String content){
		String insertReply = "INSERT INTO REPLY (reply_id, Member_id, Post_id, Content, Creation_time) VALUES (?, ?, ?, ?, TO_TIMESTAMP(?, 'YYYY-MM-DD HH24:MI:SS'))";
		try{
			PreparedStatement pstmt = conn.prepareStatement(insertReply);
			pstmt.setInt(1, reply_id);
			pstmt.setString(2, member_id);
			pstmt.setInt(3, post_id);
			pstmt.setString(4, content);
			pstmt.setString(5, creationTime);

			pstmt.executeUpdate();
			pstmt.close();
		} catch (SQLException e) {
			
		}
	}
	
	
	%>
</div>



<div id="footer"></div>
</body>
</html>