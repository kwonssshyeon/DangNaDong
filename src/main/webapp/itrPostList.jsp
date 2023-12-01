<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>
<%@ page import="java.io.*,java.util.*" %>
<%@ page import="javax.servlet.*,javax.servlet.http.*" %>
<%@ page import="java.text.SimpleDateFormat,java.util.Date" %>
<%@ page language="java" import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>

<title>DND:일정소개글</title>

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
	SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-M-d HH:mm:ss");
	SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd");

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

<div class="container mt-5">
    <div class="row row-cols-1 row-cols-md-3 g-4">
        
        <div class="col">
            <%
            	String sql = "select p.title, p.travel_period, m.nickname, p.creation_time from travel_introduction_post p, member m, itr_contain l where p.member_id = m.member_id and p.post_id = l.post_id and l.location_id = 'KOR'";
            	pstmt = conn.prepareStatement(sql);
            	rs = pstmt.executeQuery();
            	
            	while (rs.next()) {
            		String title = rs.getString(1);
            		String period = rs.getString(2);
            		String nickname = rs.getString(3);
            		String inputDate = rs.getString(4);
            		
            		Date dateForm = inputFormat.parse(inputDate);
            		String date = outputFormat.format(dateForm);
            %>
            	<div class="card">
            		<div class="card-body">
	                    <h5 class="card-title"><%= title %></h5>
	                    <p class="card-text"><%= period %></p>
	                    <p class="card-text"><%= nickname %></p>
	                    <p class="card-text"><%= date %></p>
	                    <a href="#" class="btn btn-primary">자세히 보기</a>
                	</div>
                </div>
            		
            <%		
            	}
            %>
                <!--<img src="https://via.placeholder.com/150" class="card-img-top" alt="게시글 이미지">-->
                
           
        </div>
        <!-- 게시글이 추가될 때마다 위의 카드를 복사하여 추가하면 됩니다. -->
    </div>
</div>
</body>
</html>