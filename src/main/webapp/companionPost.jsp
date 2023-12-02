<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>
<%@ page language="java" import="java.lang.Integer" %>
<%@ page language="java" import="java.time.LocalDateTime" %>
<%@ page language="java" import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>여행 동행글 쓰기</title>
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
	String max_query="SELECT MAX(Post_id) FROM TRAVEL_COMPANION_POST";
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
	String directory = "C:/SourceCode/2023_Database/DangNaDong/src/main/webapp/image/";
	int maxSize = 1024*1024*100;
	String encoding = "UTF-8";
	
	MultipartRequest multipartRequest = new MultipartRequest(request, directory, maxSize, encoding,
			new DefaultFileRenamePolicy());
	
	String query = "INSERT INTO TRAVEL_COMPANION_POST (Post_id, Member_id, Creation_time, Title, Content_text, Travel_date, Travel_period, Expected_cost, State, Deadline, Gender_condition, Age_condition, Nationality_condition, Number_of_recruited) " +
            "VALUES (?, ?, TO_TIMESTAMP(?, 'YYYY-MM-DD HH24:MI:SS'), ?, ?, TO_DATE(?, 'YYYY-MM-DD'), ?, ?, ?, TO_DATE(?, 'YYYY-MM-DD'), ?, ?, ?, ?)";


	try{
		pstmt = conn.prepareStatement(query);
		post_id=post_id+1;
		
		//int number_of_recruited = Integer.parseInt(multipartRequest.getParameter("number_of_recruited"));
		pstmt.setInt(1, post_id);
		pstmt.setString(2, "Mid1");
		pstmt.setString(3, creationTime);
		pstmt.setString(4, multipartRequest.getParameter("title"));
		pstmt.setString(5, multipartRequest.getParameter("content_text"));
		pstmt.setString(6, multipartRequest.getParameter("travel_date"));
		pstmt.setString(7, multipartRequest.getParameter("travel_period"));
		pstmt.setString(8, multipartRequest.getParameter("expected_cost"));
		pstmt.setString(9, "진행");
		pstmt.setString(10, multipartRequest.getParameter("deadline"));
		pstmt.setString(11, multipartRequest.getParameter("gender_condition"));
		pstmt.setString(12, multipartRequest.getParameter("age_condition"));
		pstmt.setString(13, multipartRequest.getParameter("nationality_condition"));
		pstmt.setString(14, multipartRequest.getParameter("number_of_recruited"));


		
		pstmt.executeUpdate();
		
		conn.commit();
		pstmt.close();
	} catch (SQLException e) {
        out.println(e.getMessage());
    }
	String image_url = multipartRequest.getOriginalFileName("image");
	String image_name = multipartRequest.getFilesystemName("image");


	String image_query = "INSERT INTO cpn_image " +
	        "VALUES (?, ?, ?)";

	try{
		pstmt = conn.prepareStatement(image_query);
		pstmt.setInt(1, post_id);
		pstmt.setString(2, "./image/"+image_url);
		//TODO: 문자열 크기 제한
		pstmt.setString(3, image_name);
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