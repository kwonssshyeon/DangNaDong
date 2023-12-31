<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>
<%@ page language="java" import="java.time.LocalDateTime,java.time.LocalDate" %>
<%@ page language="java" import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>여행동행글 상세보기</title>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap-modal-js@2.0.1/dist/bootstrap-modal-js.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-modal-js@2.0.1/demoFiles/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="./css/detailCompanion.css" />
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
String my_id = (String)s.getAttribute("member_id");
int post_id = Integer.parseInt(request.getParameter("post_id"));
String creationTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
boolean isOwner=false;
String close = "진행";
%>

<script type="text/javascript">	
	var member_id = '<%= my_id %>';
	var post_id = <%= post_id %>;
	var apply = function(member_id,post_id) {			
		location.href = "apply.jsp?member="+member_id+"&post="+post_id;
	};	
	var chatting = function() {			
		location.href = "oneToOneChat.jsp?member="+member_id+"&post="+post_id;
	};
</script>

<script>
$(document).ready(function() {
    var member_id = '<%= my_id %>';
    var post_id = <%= post_id %>;
    
    $("#applyButton").on("click", function() {
        $.ajax({
            type: "POST",
            url: "applicate",
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
$(document).ready(function() {
    var member_id = '<%= my_id %>';
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
	close = state;
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
	
	if(my_id.equals(member_id))isOwner=true;
	%>
	
	
	<%
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
	            <% if (isOwner==false && !close.equals("마감")){
	            	out.print("<input type='button' class='btn btn-primary' value='채팅하기' onClick='chatting()' />");
	            }
	            else{
	            	out.print("<input type='button' class='btn btn-primary' disabled value='채팅하기' onClick='chatting('"+my_id+"',"+post_id+")'/>");
	            }
	            %>
	            	
	            </div>
	            </div>
	            <div class="card mb-4">
	            	<div class="d-grid gap-2">
	            	<% if (isOwner==false && !close.equals("마감")){
		            	out.print("<button type='button' class='btn btn-primary' data-bs-toggle='modal' data-bs-target='#exampleModal'>신청하기</button>");
		            }
		            else{
		            	out.print("<button type='button' class='btn btn-primary' disabled data-bs-toggle='modal' data-bs-target='#exampleModal'>신청하기</button>");
		            }
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
</div>

</body>
</html>