<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>
<%@ page language="java" import="java.time.LocalDateTime,java.time.LocalDate" %>
<%@ page language="java" import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.chat" %> 
<%@ page import="com.countries" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DND</title>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<link rel="stylesheet" href="./css/main.css" />
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
	String member_id = (String)s.getAttribute("member_id");
%>

<script type="text/javascript">
function updateCountries() {
    var continentSelect = document.getElementById("continent");
    var nationSelect = document.getElementById("nation");
    var selectedContinent = continentSelect.value;
    var selectedNation = nationSelect.value;
    // 국가 옵션 초기화
    nationSelect.innerHTML = "<option value='selection'>나라선택</option>";
    // AJAX를 사용하여 서버에 대륙 정보를 전송하고 나라 목록을 받아옴
    $.ajax({
        type: "POST",
        url: "updateNations",  // 실제 서버 엔드포인트로 변경해야 함
        data: {"continent": selectedContinent},
        dataType: "json",  // 서버에서 반환되는 데이터 타입 (JSON 예상)
        success: function(response) {
            // 서버에서 받은 JSON 데이터를 기반으로 나라 옵션을 동적으로 업데이트
            for (var i = 0; i < response.length; i++) {
                addOption(nationSelect, response[i].nationId, response[i].nationName);
            }
            //window.location.reload();
        },
        error: function(error) {
            console.error("Error fetching countries: ", error);
        }
    });
}

function addOption(selectElement, value, text) {
    var option = document.createElement("option");
    option.value = value;
    option.text = text;
    selectElement.add(option);
}

function nationSelection() {
    // 나라를 선택했을 때 실행할 로직 추가
   	var selectedNationId = document.getElementById("nation").value;
   	var selectedNationName = document.getElementById("nation").text;
    //console.log("Selected Continent: ", selectedNation);
    console.log("Selected Nation: ", selectedNationId);
    
    var url = 'main.jsp?nation=' + selectedNationId;
    window.location = url;
}

function getParameterByName(name, url) {
    if (!url) {
        url = window.location.href;
    }
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

var nationParameter = getParameterByName('nation');
//console.log("Nation Parameter: ", nationParameter);
var content

function func() {
content = document.getElementById("message").value;
}

$(document).ready(function() {
var member_id = '<%= member_id %>';
//console.log(selectedNation);
$("#sendBtn").on("click", function() {
	
    $.ajax({
        type: "POST",
        url: "addChat",
        data:{"member_id":member_id,
        		"location":nationParameter,
        		"content":content},
        		
        success: function(response) {
            alert(response);
            //var url = 'main.jsp?nation=' + selectedNationId;
            //window.location = url;
            location.reload();
           
        },
        error: function(error) {
            alert(error);
        }
        
    });
});
});
    
</script>
<div class="header">
	<div class="location">
		<form>
			<select id="continent" name="continent" onchange="updateCountries()">
				<option value='selection'>대륙선택</option>
				<option value="아시아">아시아</option>
				<option value="유럽">유럽</option>
				<option value="아프리카">아프리카</option>
				<option value="북아메리카">북아메리카</option>
				<option value="남아메리카">남아메리카</option>
				<option value="오세아니아">오세아니아</option>
			</select>
			<select id="nation" name="nation" onchange="nationSelection()">
				<option value='selection'>나라선택</option>
			</select>
		</form>
	</div>
<%
   
   	String nation = request.getParameter("nation");
	String natoin_name = "";
	
	String sql_nation_name = "select nation from location where location_id = ?";
	pstmt = conn.prepareStatement(sql_nation_name);
	pstmt.setString(1, nation);
	//out.println(sql);
	rs = pstmt.executeQuery();
	
	while(rs.next()){
		natoin_name = rs.getString(1);
	}
%>
	
	<h2><%= natoin_name %></h2>
	
	<div class="write">
		<form action="" name="post">
			<select name="write" onchange="location=document.post.write.value">
				<option>글쓰기</option>
				<option value="companionPost.jsp?nation=<%=nation%>">동행찾기 글쓰기</option>
				<option value="introducePost.jsp?nation=<%=nation%>">일정소개 글쓰기</option>
			</select>
		</form>
	</div>

</div>

<img src="<%= nation %>.png" alt="나라 별 사진 표시"><br>


<div class="btns">
	<div class="btn">
	    <button onclick="location.href='cpnPostList.jsp?nation=<%=nation%>'">동행 찾기 글 보기</button>
	 </div>
	 <div class="btn">
		<button onclick="location.href='itrPostList.jsp?nation=<%=nation%>'">일정 소개 글 보기</button>
	</div>
</div>
<div class="realTChat">
  <section class="mb-5">
      <div class="card bg-light">
          <div class="card-body">
              <div class="chat-container mt-3">
				<%
				String nationParameter = request.getParameter("nation");
				
				String sql = "select m.nickname, c.message, c.creation_time, c.sender_location from member m, real_time_chat c where c.member_id = m.member_id and c.location_id=? order by c.creation_time asc";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, nationParameter);
				//out.println(sql);
				rs = pstmt.executeQuery();
				
				while (rs.next()) {
				
					String nickname = rs.getString(1);
				    String message = rs.getString(2);
				    String sendTime = rs.getString(3);
				    String senderLocation = rs.getString(4);
				    %>
			        <div class="chat-message">
			            <strong><%= nickname %>:</strong> <%= message %>
			            
			            <small> | <%= sendTime %>, <%= senderLocation %></small>
			        </div>
				<%
				}
				%>
                </div>
            </div>
        </div>
    </section>
    
    
<div class="input-group">
    <input type="text" id="message" class="form-control" onchange='func()'>
    <button type="button" id="sendBtn" class="btn btn-primary">전송</button>
</div>
	
</div>
<div id="footer"></div>
</body>
</html>