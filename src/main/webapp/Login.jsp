<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

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
        out.println("<p>Login successful! Welcome, " + member_id + "!</p>");
    } else {
        out.println("<p>Login failed. Please check your ID and password.</p>");
    }	
%>
<div id="footer"></div>
</body>
</html>