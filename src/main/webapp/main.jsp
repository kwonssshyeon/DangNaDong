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
    // ���ǿ��� ���̵� ��������
    HttpSession s = request.getSession();
    String member_id = (String) session.getAttribute("member_id");

    // ���̵� ������ �α��� �������� �̵�
    if (member_id == null) {
        response.sendRedirect("login.jsp");
    }
    
    out.println(member_id);
%>
</body>
</html>