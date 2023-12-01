<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
<%
    // 세션에서 아이디 가져오기
    HttpSession s = request.getSession();
    String member_id = (String) session.getAttribute("member_id");

    // 아이디가 없으면 로그인 페이지로 이동
    if (member_id == null) {
        response.sendRedirect("login.jsp");
    }
    
    out.println(member_id);
%>
</body>
</html>