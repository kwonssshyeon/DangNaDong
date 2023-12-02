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
<link rel="stylesheet" href="./css/PostList.css" />

<title>DND:�����û��</title>

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
	HttpSession s = request.getSession();
	String my_id = (String)s.getAttribute("member_id");
%>
<h4>������ ã�� ��</h4>
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
    <div class="row row-cols-md-3">
            <%
            	String sql = "select p.title, p.travel_period, m.nickname, p.creation_time, p.post_id, p.state, p.expected_cost from travel_companion_post p, member m, cpn_contain l where p.member_id = m.member_id and p.post_id = l.post_id and l.location_id = 'KOR'";
            	pstmt = conn.prepareStatement(sql);
            	rs = pstmt.executeQuery();
            	
            	while (rs.next()) {
            		String title = rs.getString(1);
            		String period = rs.getString(2);
            		String nickname = rs.getString(3);
            		String inputDate = rs.getString(4);
            		int post_id = rs.getInt(5);
            		String state = rs.getString(6);
            		String exp_cost = rs.getString(7);
            		
            		Date dateForm = inputFormat.parse(inputDate);
            		String date = outputFormat.format(dateForm);
            %>
            <div class="col mb-4">
            	<div class="card">
            	<!--<img src="https://via.placeholder.com/150" class="card-img-top" alt="�Խñ� �̹���">-->
            		<div class="card-body">
            			<h6 class="card-title"><strong>[<%= state %>]</strong></h6>
	                    <h5 class="card-title"><strong><%= title %></strong></h5>
	                    <p class="card-text"><strong><%= period %></strong>, <strong><%= exp_cost %></strong></p>
	                    <div class="bottom d-flex justify-content-between">
		                    <div class="nick-date">
			                    <p class="card-text"><%= nickname %></p>
			                    <p class="card-text"><%= date %></p>
		                    </div>
	                    	<a href="detailCompanionPost.jsp?post_id=<%= post_id %>" id="detailBtn" class="btn btn-primary d-flex align-items-center justify-content-center">�ڼ��� ����</a>
	                    </div>
                	</div>
                </div>
            </div>	
            <%		
            	}
            %>   
    </div>
</div>

<div id="footer"></div>
</body>
</html>