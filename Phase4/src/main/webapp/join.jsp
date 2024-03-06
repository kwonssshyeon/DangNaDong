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
<link rel="stylesheet" href="./css/signup.css">
<title>DND:Sign-up Successful</title>
</head>
<body>
<%
//변경된 경로
	String directory = "C:/SourceCode/2023_Database/DangNaDong/src/main/webapp/image/";
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
	image_url = "./image/"+image_url;
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
	
	try{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = "insert into member values('"+member_id+"','"+gender+"','"+brith+"','"+selfitr+"','"+email+"','"+nickname+"','"+password+"','"+image_url+"')";
		pstmt = conn.prepareStatement(sql);
		//out.println(sql);
		rs = pstmt.executeQuery();
%>
		<div class="welcome">
			<h2>♣ DangNaDong 에서 여행을 함께해요 ♣</h2>
			<a href="signin.html">Go to Login</a>
		</div>
<%		
	}catch(SQLException e) {
    // SQL 예외 처리
    String errorMessage = "";
    int errorCode = e.getErrorCode();

    if (errorCode == 1) {
    	//무결성 위반 처리
        errorMessage = "아이디, 별명, 이메일 중 이미 사용중인 것이 있습니다. 다른 값을 입력해주세요.";
    } else if (errorCode >= 17000 && errorCode <= 17999){
    	//syntax error 처리
    	errorMessage = "형식이 맞지 않습니다. 확인 후 다시 회원가입 하세요.";
    } else if (errorCode == 1400) {
    	//not null 처리
    	errorMessage = "입력하지 않은 요소가 있거나 형식이 맞지 않습니다. 확인 후 다시 회원가입 하세요.";
    }
    else {
        errorMessage = "회원가입 중 알 수 없는 오류가 발생했습니다.";
    }
%>

    <!-- 에러 코드에 따라 alert 하고 다시 회원가입 페이지로 -->
    <script type="text/javascript">
        alert("<%= errorMessage %>");
        window.location = "join.html";
    </script>

<%
}
%>
</body>
</html>