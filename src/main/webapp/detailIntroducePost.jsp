<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>
<%@ page language="java" import="java.time.LocalDateTime,java.time.LocalDate" %>
<%@ page language="java" import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.reply" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>일정소개글 상세보기</title>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<link rel="stylesheet" href="./css/detailInroduce.css" />
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


<%
HttpSession s = request.getSession();
int post_id = Integer.parseInt(request.getParameter("post_id"));
int reply_id;
//String member_id="Mid1";
String my_id = (String)s.getAttribute("member_id");
String creationTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
%>
<script type="text/javascript">
var content
	function func() {
	content = document.getElementById("replyText").value;
	}

$(document).ready(function() {
    var member_id = '<%= my_id %>';
    var post_id = <%= post_id %>;
    
    $("#replyBtn").on("click", function() {
        $.ajax({
            type: "POST",
            url: "submitReply",
            data:{"member_id":member_id,
            		"post_id":post_id,
            		"content":content},
            		
            success: function(response) {
                alert(response);
                location.reload();
            },
            error: function(error) {
                alert(error);
            }
        });
    });
});

$(document).ready(function() {
    var member_id = '<%= my_id %>';
    var post_id = <%= post_id %>;
    
    $("#scrapButton").on("click", function() {
        $.ajax({
            type: "POST",
            url: "scrap",
            data:{"member_id":member_id,
            		"post_id":post_id},
            		
            success: function(response) {
                alert(response);
                location.reload();
            },
            error: function(error) {
                alert(error);
            }
        });
    });
});
</script>
<%
	String max_query="SELECT MAX(reply_id) FROM REPLY";
	Statement stmt = conn.createStatement();
	ResultSet max_rs = stmt.executeQuery(max_query);
	if(max_rs.next())
		reply_id = max_rs.getInt(1);
	max_rs.close();
%>

<%
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
	
	
	//사용자 닉네임 가져오기
		String userSql = "select nickname,profile_image from member where member_id='"+member_id+"'";
		String nickname="";
		String profileImg="";
		stmt = conn.createStatement();
		try{
			rs = stmt.executeQuery(userSql);
			while (rs.next()) {
				nickname = rs.getString(1);
				profileImg = rs.getString(2);
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
	
	
	
	<article>
        <!-- Post header-->
        <div class="mb-4">
            <!-- Post title-->
            <a class="badge bg-secondary text-decoration-none link-light" ><%= nation %></a>
            <h1 class="fw-bolder mb-1"><%= title %></h1>
            <!-- Post meta content-->
            <div class="meta_info">
            <div class=info><img src="<%= profileImg%>" width="50" width="50"/><%=nickname %></div>
            <div class=info>스크랩 수: <%=scrap %>
            	<button type="button" id="scrapButton" class="btn btn-primary">스크랩</button><br/>
            </div>
            </div>
            <div class="text-muted fst-italic mb-2">Posted on <%= creation_time %></div>
            <!-- Post categories-->
        
        <!-- Preview image figure-->
        <figure class="mb-4"><img class="img-fluid rounded" src="<%=img%>"/></figure>
    </article>
    <ul class="list-group">
	  <li class="list-group-item">여행날짜: <%= travel_date %>  /  여행기간:<%= travel_period %></li>
	  <li class="list-group-item">여행비용: <%= cost %></li>
	</ul>
					
    <section class="mb-5">
        <p class="fs-5 mb-4"><%= content_text %></p>
    </section>
    
	
	
	
	
  <!-- Comments section-->
  <section class="mb-5">
      <div class="card bg-light">
          <div class="card-body">
              
              <!-- Single comment-->
                <div class="d-flex">
                <%
				//댓글정보 가져오기
				out.println("<h3>댓글</h3>");
				String replySql = "select nickname, profile_image, content, creation_time from member natural join reply where post_id="+post_id;
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
						out.print("<div class='flex-shrink-0'><img class='rounded-circle' src="+rProfile_image+" width=50 height=50></div><div class='fw-bold'>"+rNickname+"</div>");
						out.print("<div class='ms-3'>");
						out.print(rContent);
						out.print("<div class='text-muted fst-italic mb-2'>"+rCreation_time+"</div>");
						out.print("</div>");
						
			         }
				} catch (SQLException e) {
			        out.println(e.getMessage());
			    }
				%>
                </div>
            </div>
        </div>
    </section>


	

	
	<div class="input-group mb-3">
  	<input type="text" id="replyText" class="form-control" placeholder="댓글을 입력하세요" onchange='func()'>
  	<button type="button" id="replyBtn" class="btn btn-primary">등록</button>
	</div>

	



<div id="footer"></div>
</body>
</html>