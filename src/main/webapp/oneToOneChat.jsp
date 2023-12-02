<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>
<%@ page language="java" import="java.time.LocalDateTime,java.time.LocalDate" %>
<%@ page language="java" import="java.time.format.DateTimeFormatter" %>
<%@ page import="javax.servlet.*,javax.servlet.http.*" %>

<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm" crossorigin="anonymous"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<link rel="stylesheet" href="./css/oneToOneChat.css" />
<script>
   $(function(){
	    $("#navbar").load("layout/navbar.html");
	    $("#footer").load("layout/footer.html");
	});
</script>
<%!
int post_id;
String my_id;
int chat_room_id;
%>
<%
   my_id = request.getParameter("member");
   post_id = Integer.parseInt(request.getParameter("post"));
%>
<% 
	String serverIP = "localhost";
	String strSID = "orcl";
	String portNum = "1521";
	String user = "university";
	String pass = "comp322";
	String url = "jdbc:oracle:thin:@"+serverIP+":"+portNum+":"+strSID;

	Connection conn = null;
	PreparedStatement pstmt;
	Statement stmt;
	ResultSet rs;
	Class.forName("oracle.jdbc.driver.OracleDriver");
	conn = DriverManager.getConnection(url,user,pass);
%>

<script>
var message
function func() {
	message = document.getElementById("message").value;
}
$(document).ready(function() {
    var member_id = '<%= my_id %>';
    var post_id = <%= post_id %>;
    
    $("#chatBtn").on("click", function() {
        $.ajax({
            type: "POST",
            url: "oneToOneChat",
            data:{"member_id":member_id,
            		"post_id":post_id,
            		"message":message},
            		
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
</head>
<body>
<div id="navbar"></div>
<h3>채팅내역</h3>
<!-- 채팅히스토리 my_id랑 onetoonechat의 memberid가 같으면 본인 오/왼 구분 가능하면 -->
<!-- Comments section-->
<div class="main">
	<section class="mb-5">
	      <div class="card bg-light">
	          <div class="card-body">
	              
	              <!-- Single comment-->
	                <div class="d-flex">
	                <%
					//채팅내역 가져오기
					String findRoom="select chat_room_id from one_to_one_chat natural join chat_room where member_id='"+my_id+"' and post_id="+post_id;
	                int chatRoom=10000;
	                stmt = conn.createStatement();
	                try{
	                	rs = stmt.executeQuery(findRoom);
	                	while(rs.next()){
	                		chatRoom = rs.getInt(1);
	                	}
	                	
	                }catch (SQLException e) {
				        out.println(e.getMessage());
				    }
	                
					String chatSql = "select member_id, nickname, profile_image, message, creation_time from member natural join one_to_one_chat "+
								"where chat_room_id="+chatRoom+" order by creation_time";
					String cMember="";
					String cNickname="";
					String cProfile_image="";
					String cContent="";
					String cCreation_time="";
					stmt = conn.createStatement();
					try{
						rs = stmt.executeQuery(chatSql);
						while (rs.next()) {
							
							cMember = rs.getString(1);
							cNickname = rs.getString(2);
							cProfile_image = rs.getString(3);
							cContent = rs.getString(4);
							cCreation_time= rs.getString(5);
							if (my_id.equals(cMember)){
								out.print("<div class=right>");
								out.print("<div class='flex-shrink-0'><img class='rounded-circle' src="+cProfile_image+" width=50 height=50></div><div class='fw-bold'>"+cNickname+"</div>");
								out.print("<div class='ms-3'>");
								out.print(cContent);
								out.print("<div class='text-muted fst-italic mb-2'>"+cCreation_time+"</div>");
								out.print("</div>");
							}
							else{
								out.print("<div class='flex-shrink-0'><img class='rounded-circle' src="+cProfile_image+" width=50 height=50></div><div class='fw-bold'>"+cNickname+"</div>");
								out.print("<div class='ms-3'>");
								out.print(cContent);
								out.print("<div class='text-muted fst-italic mb-2'>"+cCreation_time+"</div>");
								out.print("</div>");
							}
							
							
				         }
					} catch (SQLException e) {
				        out.println(e.getMessage());
				    }
					%>
	                </div>
	            </div>
	        </div>
	    </section>
	    </div>
	<div class="input-group mb-3" >
		<input type="text" id="message" class="form-control" placeholder="메세지를 입력하세요" onchange='func()'>
		<button type="button" id="chatBtn" class="btn btn-primary">등록</button>
	</div>

<div id="footer"></div>
</body>
</html>