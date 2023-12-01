<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.lang.Integer" %>
<%@ page language="java" import="java.text.*,java.sql.*" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DND:Login</title>
</head>
<body>
<% 
	String directory = "C:/Users/owner/eclipse-Dangnadong/DangNaDong/src/main/webapp/image/";
	int maxSize = 1024*1024*100;
	String encoding = "UTF-8";

	MultipartRequest multipartRequest = new MultipartRequest(request, directory, maxSize, encoding,
		new DefaultFileRenamePolicy());

	String member_id = multipartRequest.getParameter("member_id");
	String password = multipartRequest.getParameter("user_password");
	String brith = multipartRequest.getParameter("b");
	String selfitr = multipartRequest.getParameter("self_introduction");
	String email = multipartRequest.getParameter("e_mail");
	String gender = multipartRequest.getParameter("gender");
	String nickname = multipartRequest.getParameter("nickname");
	String image_url = multipartRequest.getOriginalFileName("profile_image");
	//String image_name = multipartRequest.getFilesystemName("profile_image");
	
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
	
	String sql = "insert into member values('"+member_id+"','"+gender+"','"+brith+"','"+selfitr+"','"+email+"','"+nickname+"','"+password+"','"+image_url+"')";
	pstmt = conn.prepareStatement(sql);
	out.println(sql);
	rs = pstmt.executeQuery();
	
%>
<h2>Sign-up Successful! Welcome!</h2><br>
<h2>♣ DangNaDong 에서 여행을 함께해요 ♣</h2>

</body>
</html>