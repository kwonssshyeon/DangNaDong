<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>
<%@ page language="java" import="java.time.LocalDateTime,java.time.LocalDate" %>
<%@ page language="java" import="java.time.format.DateTimeFormatter" %>


<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script>
   $(function(){
	    $("#navbar").load("layout/navbar.html");
	    $("#footer").load("layout/footer.html");
	});
</script>
<%!
int post_id;
String my_id;
%>
<%
   my_id = request.getParameter("member");
   post_id = Integer.parseInt(request.getParameter("post"));
%>


</head>
<body>
<div id="navbar"></div>
신청서
<%=my_id %><%=post_id %>
<div id="footer"></div>
</body>
</html>