<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>
<%@ page language="java" import="java.time.LocalDateTime" %>
<%@ page language="java" import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>일정소개글 쓰기</title>
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
int post_id;
String member_id="Mid1";
String creationTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
%>

<%
	String max_query="SELECT MAX(Post_id) FROM TRAVEL_INTRODUCTION_POST";
	Statement stmt = conn.createStatement();
	ResultSet max_rs = stmt.executeQuery(max_query);
	if(max_rs.next())
		post_id = max_rs.getInt(1);
	max_rs.close();
	stmt.close();
%>

<h4>저장되었습니다.</h4>
<%
	conn.setAutoCommit(false);
	String directory = application.getRealPath("/image/");
	int maxSize = 1024*1024*100;
	String encoding = "UTF-8";
	
	MultipartRequest multipartRequest = new MultipartRequest(request, directory, maxSize, encoding,
			new DefaultFileRenamePolicy());
	
	String query = "INSERT INTO TRAVEL_INTRODUCTION_POST (Post_id, Member_id, Creation_time, Title, Content_text, Travel_date, Travel_period, Cost) " +
        "VALUES (?, ?, TO_TIMESTAMP(?, 'YYYY-MM-DD HH24:MI:SS'), ?, ?, TO_DATE(?, 'YYYY-MM-DD'), ?, ?)";

	try{
		pstmt = conn.prepareStatement(query);
		post_id=post_id+1;
		pstmt.setInt(1, post_id);
		pstmt.setString(2, "Mid1");
		pstmt.setString(3, creationTime);
		pstmt.setString(4, multipartRequest.getParameter("title"));
		pstmt.setString(5, multipartRequest.getParameter("content_text"));
		pstmt.setString(6, multipartRequest.getParameter("travel_date"));
		pstmt.setString(7, multipartRequest.getParameter("travel_period"));
		pstmt.setString(8, multipartRequest.getParameter("cost"));
		pstmt.executeUpdate();
		
		conn.commit();
		pstmt.close();
	} catch (SQLException e) {
        out.println(e.getMessage());
    }
	String image_name = multipartRequest.getOriginalFileName("image");
	String image_url = multipartRequest.getFilesystemName("image");



	String image_query = "INSERT INTO itr_image " +
	        "VALUES (?, ?, ?)";

	try{
		pstmt = conn.prepareStatement(image_query);
		pstmt.setInt(1, post_id);
		pstmt.setString(2, image_url);
		pstmt.setString(3, image_name.substring(8));
		pstmt.executeUpdate();
		
		conn.commit();
		pstmt.close();
	} catch (SQLException e) {
	    out.println(e.getMessage());
	}
	
%>






<div id="footer"></div>
</body>
</html>