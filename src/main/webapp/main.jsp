<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>COMP322: Introduction to Databases</title>
</head>
<body>
<% 
	String serverIP = "localhost";
	String strSID = "orcl";
	String portNum = "1521";
	String user = "university";
	String pass = "comp322";
	String url = "jdbc:oracle:thin:@"+serverIP+":"+portNum+":"+strSID;
	
	//System.out.println(url);
	//out.println(url);
	Connection conn = null;
	PreparedStatement pstmt;
	ResultSet rs;
	Class.forName("oracle.jdbc.driver.OracleDriver");
	conn = DriverManager.getConnection(url,user,pass);
	String query = "select dnumber,dname,Mgr_ssn,Mgr_start_date "+"from department order by dnumber";
	//out.println(query);
	//System.out.println(query);
	pstmt = conn.prepareStatement(query);
	rs = pstmt.executeQuery();
%>

<h4>------ A List of DEPARTMENT tuples --------</h4>
<%
	out.println("<table border=\"1\">");
	ResultSetMetaData rsmd = rs.getMetaData();
	int cnt = rsmd.getColumnCount();
	for(int i =1;i<=cnt;i++){
		out.println("<th>"+rsmd.getColumnName(i)+"</th>");
	}
	while(rs.next()){
		out.println("<tr>");
		out.println("<td>"+rs.getString(1)+"</td>");
		out.println("<td>"+rs.getString(2)+"</td>");
		out.println("<td>"+rs.getString(3)+"</td>"); // html 
		SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd");
		Date mgrStartDate = rs.getDate(4);
		String strMSDate = sdfDate.format(mgrStartDate);
		out.println("<td>"+strMSDate+"</td>");
		out.println("</tr>");		
	}
	out.println("</table>");
	rs.close();
	pstmt.close();
	conn.close();
%>
</body>
</html>