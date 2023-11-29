<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>DND:Login</title>
</head>
<body>
<% 

	String member_id = request.getParameter("member_id");
	String password = request.getParameter("user_password");
	String brith = request.getParameter("brith");
	String selfitr = request.getParameter("self_introduction");
	String email = request.getParameter("e_mail");
	String gender = request.getParameter("gender");
	String nickname = request.getParameter("nickname");
	String image = request.getParameter("profile_image");
	
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
	
	String sql = "insert into member values('"+member_id+"','"+gender+"','"+brith+"','"+selfitr+"','"+email+"','"+nickname+"','"+password+"','"+image+"')";
	pstmt = conn.prepareStatement(sql);
	out.println(sql);
	rs = pstmt.executeQuery();
	
%>
<h2>Sign-up Successful! Welcome!</h2><br>
<h2>♣ DangNaDong 에서 여행을 함께해요 ♣</h2>

</body>
</html>