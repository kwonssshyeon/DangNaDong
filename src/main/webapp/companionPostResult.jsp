<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>
<%@ page language="java" import="java.lang.Integer" %>
<%@ page language="java" import="java.time.LocalDateTime" %>
<%@ page language="java" import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page language="java" import="java.util.concurrent.locks.Lock" %>
<%@ page language="java" import="java.util.concurrent.locks.ReentrantLock" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>여행 동행글 쓰기</title>
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
	try {
	    Class.forName("oracle.jdbc.driver.OracleDriver");
	} catch (ClassNotFoundException e) {
	    e.printStackTrace();
	}
	conn = DriverManager.getConnection(url,user,pass);
%>
<%!
int post_id;
String member_id="Mid1";
String creationTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
String nation_code="KOR";
boolean isOwner=false;
%>
<%
String posted="";
Cookie[] cookies = request.getCookies();
if (cookies != null) {
    for (Cookie cookie : cookies) {
        if (cookie.getName().equals("posted")) {
        	posted=cookie.getValue();
        }
    }
}
%>
<%
if(posted.equals("yes")){
	Lock lock = new ReentrantLock();
	lock.lock();
	String max_query="SELECT MAX(Post_id) FROM TRAVEL_COMPANION_POST";
	Statement stmt = conn.createStatement();
	ResultSet max_rs = stmt.executeQuery(max_query);
	if(max_rs.next())
		post_id = max_rs.getInt(1);
	max_rs.close();
	stmt.close();
%>
<%
	conn.setAutoCommit(false);
	Savepoint savePoint = null;
	try {
		savePoint = conn.setSavepoint("savePoint");
	} catch (SQLException e) {
		e.printStackTrace();
	}
	
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
		pstmt.close();
	} catch (SQLException e) {
		try {
			conn.rollback(savePoint);
		} catch (SQLException e1) {
			e1.printStackTrace();
		}
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
		
		pstmt.close();
	} catch (SQLException e) {
		try {
			conn.rollback(savePoint);
		} catch (SQLException e1) {
			e1.printStackTrace();
		}
	    out.println(e.getMessage());
	}
	
	String locSql="insert into cpn_contain values(?,?)";
	try{
		pstmt = conn.prepareStatement(locSql);
		pstmt.setInt(1, post_id);
		pstmt.setString(2, nation_code);
		
		pstmt.executeUpdate();
		conn.commit();
		pstmt.close();
	} catch (SQLException e) {
		try {
			conn.rollback(savePoint);
		} catch (SQLException e1) {
			e1.printStackTrace();
		}
	    out.println(e.getMessage());
	}
	
	lock.unlock();
	
	
	Cookie cookie = new Cookie("posted", "no");
    cookie.setMaxAge(60*60*60);
    cookie.setPath("/");
    response.addCookie(cookie);
}
%>






<script>

$(document).ready(function() {
    var member_id = '<%= member_id %>';
    var post_id = <%= post_id %>;
    
    $("#likeButton").on("click", function() {
        $.ajax({
            type: "POST",
            url: "like",
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
<div id="content">
<%
	//post 정보 가져오기
	String member_id="";
	String creation_time="";
	String title="";
	String content_text="";
	String travel_date="";
	String travel_period="";
	String cost="";
	
	String state="";
	String deadline="";
	int number_of_recruited=0;
	String gender_condition="";
	String age_condition="";
	String nationality_condition="";
	
	
	//동행글 정보 가져오기
	String selectSql = "select * from TRAVEL_COMPANION_POST where post_id="+ post_id;
	Statement stmt = conn.createStatement();
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
			state = rs.getString(9);
			deadline = rs.getString(10);
			gender_condition = rs.getString(11);
			age_condition = rs.getString(12);
			nationality_condition = rs.getString(13);
			number_of_recruited = rs.getInt(14);
         }
		//stmt.close();
	} catch (SQLException e) {
        out.println(e.getMessage());
    }
	//location정보 가져오기
	String nation="";
	
	String locationSql = "select nation from location natural join cpn_contain where post_id="+ post_id;
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
	String imgSql = "select img_url from cpn_image where post_id="+post_id;
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
	
	//좋아요정보 가져오기
	String likeSql = "select count(*) from like_post where post_id="+post_id;
	int like=0;
	stmt = conn.createStatement();
	try{
		rs = stmt.executeQuery(likeSql);
		while (rs.next()) {
			like = rs.getInt(1);
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
	
	
	//신청현황 정보 가져오기
	String applyNum = "select count(*) from application_info where request_state='수락' and post_id="+post_id;
	int aNum=0;
	stmt = conn.createStatement();
	try{
		rs = stmt.executeQuery(applyNum);
		while (rs.next()) {
			aNum = rs.getInt(1);
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
            <div class=info>좋아요 수: <%=like %>
            	<button type="button" id="likeButton" class="btn btn-primary">좋아요</button><br/>
            <h4>상태(<%=state %>)</h4></div>
            </div>
            <div class="text-muted fst-italic mb-2">Posted on <%= creation_time %></div>
            <!-- Post categories-->
        </div>
        <!-- Preview image figure-->
        <figure class="mb-4"><img class="img-fluid rounded" src="<%=img%>"/></figure>
    </article>
	
	<div class="row">
            <div class="col-lg-8">
                <!-- Post content-->
                <article>
                	<!--  -->
                	<section class="mb-5">
                	<ul class="list-group">
					  <li class="list-group-item">여행날짜: <%= travel_date %>  /  여행기간:<%= travel_period %></li>
					  <li class="list-group-item">모집마감 날짜 : <%=deadline %></li>
					  <li class="list-group-item">비용:<%= cost %></li>
					</ul>
					<br/>
					<ul class="list-group">
					  <li class="list-group-item">모집조건</li>
					  <li class="list-group-item">인원수: <%= number_of_recruited %></li>
					  <li class="list-group-item">성별: <%=gender_condition %>  /  나이: <%=age_condition %>  /  국적: <%=nationality_condition %></li>
					</ul>
                	</section>
                
                    <!-- Post content-->
                    <section class="mb-5">
                        <p class="fs-5 mb-4"><%= content_text %></p>
                    </section>
                </article>
               
            </div>
            <!-- Side widgets-->
            <div class="col-lg-4">
	            <div class="card mb-4">
	            <div class="d-grid gap-2">
	            <!-- 본인 글에는 신청/채팅할 수 없도록 -->
	            <% 
	            	out.print("<input type='button' class='btn btn-primary' disabled value='채팅하기'/>");
	            %>
	            	
	            </div>
	            </div>
	            <div class="card mb-4">
	            	<div class="d-grid gap-2">
	            	<%
		            out.print("<button type='button' class='btn btn-primary' disabled data-bs-toggle='modal' data-bs-target='#exampleModal'>신청하기</button>");
		            %>
					</div>
	            </div>
                
                <!-- Side widget-->
                <div class="card mb-4">
                    <div class="card-header">신청 현황</div>
                    <div class="card-body"><h2><%= aNum%> / <%= number_of_recruited%></h2></div>
                    <div class="card-body">함께하는 사람<br/>
                    <div class='companion'>
                    <%
					//신청현황정보 가져오기
						String applySql = "select nickname, profile_image from member natural join application_info where request_state='수락' and post_id="+post_id;
						String aNickname="";
						String aProfile_image="";
						stmt = conn.createStatement();
						try{
							rs = stmt.executeQuery(applySql);
							while (rs.next()) {
								aNickname = rs.getString(1);
								aProfile_image = rs.getString(2);
								out.print("<div class='person'><img src="+aProfile_image+" width=50 height=50><br/>"+aNickname+"</div>");
							
					         }
						} catch (SQLException e) {
					        out.println(e.getMessage());
					    }
					%>
					</div>

                    </div>
                </div>
            </div>
        </div>
    </div>
	

	
	<!-- Modal -->
	<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h1 class="modal-title fs-5" id="exampleModalLabel">동행 신청</h1>
	        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	      </div>
	      <div class="modal-body">
	        <%=nickname %>님의 '<%=title %>'에 동행을 신청하시겠습니까?
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
	        <button type="button" id="applyButton" class="btn btn-primary" data-bs-dismiss="modal">확인</button>
	      </div>
	    </div>
	  </div>
	</div>

<div id="footer"></div>
</body>
</html>