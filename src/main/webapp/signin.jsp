<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>
<%@ page import="java.io.*,java.util.*" %>
<%@ page import="javax.servlet.*,javax.servlet.http.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DND:Login Success</title>
<link rel="stylesheet" href="./css/loginFail.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script>
   $(function(){
	    $("#navbar").load("layout/navbar.html");
	    $("#footer").load("layout/footer.html");
	});
</script>

</head>
<body>

<% 

	String member_id = request.getParameter("member_id");
	String password = request.getParameter("user_password");
	
	
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
	
    String sql = "SELECT * FROM member WHERE member_id='"+member_id+"' AND user_password='"+password+"'";
    pstmt = conn.prepareStatement(sql);
    //out.println(sql);
    rs = pstmt.executeQuery();
    
    if (rs.next()) {
        HttpSession s = request.getSession();
        s.setAttribute("member_id", member_id);
        //메인으로 바로 이동
        response.sendRedirect("main.jsp");
    } else {
%>
       <div class="fail">
			<h2>! 로그인 실패 !</h2>
			<h2>아이디와 비밀번호를 확인하세요.</h2>
			<h2>아직 DangNaDong 회원이 아니신가요?</h2>
			<a href="join.html">회원가입하기</a>
		</div>
<%
    }	
%>



<div id="footer"></div>
</body>
</html>