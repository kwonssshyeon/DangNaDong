package com;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/scrap")
public class scrap extends HttpServlet {
	public static final String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
    public static final String USER_UNIVERSITY = "university";
    public static final String USER_PASSWD = "comp322";

    public String member_id = null;
    public int post_id;
    
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
	   
	   member_id = request.getParameter("member_id");
	   post_id = Integer.parseInt(request.getParameter("post_id"));
	   
	   String result = createScrap(member_id,post_id);

       response.getWriter().write(result);
   }
    
    public String createScrap(String member_id,int post_id) {
	      Connection conn = null; // Connection object
	      Statement stmt = null;    // Statement object
	      
	      String result="";

	      try {
	         // Load a JDBC driver for Oracle DBMS
	         Class.forName("oracle.jdbc.driver.OracleDriver");
	         // Get a Connection object 
	         System.out.println("Success!");
	      } catch (ClassNotFoundException e) {
	         System.err.println("error = " + e.getMessage());
	         System.exit(1);
	      }

	      // Make a connection
	      try {
	         conn = DriverManager.getConnection(URL, USER_UNIVERSITY, USER_PASSWD);
	         conn.setAutoCommit(false);
	         System.out.println("Connected.");
	      } catch (SQLException ex) {
	         ex.printStackTrace();
	         System.err.println("Cannot get a connection: " + ex.getLocalizedMessage());
	         System.err.println("Cannot get a connection: " + ex.getMessage());
	         System.exit(1);
	      }

	      String insertReply = "INSERT INTO scrap (Post_id, Member_id) VALUES (?, ?)";
	      
	      try{
				PreparedStatement pstmt = conn.prepareStatement(insertReply);
				pstmt.setInt(1, post_id);
				pstmt.setString(2, member_id);
				
				pstmt.executeUpdate();
				System.out.print(pstmt);
				result="successfully submmited";
				pstmt.close();
				} catch (SQLException e) {
					System.out.print(e.getMessage());
					result="failed to submmit. you've already submitted.";
				}
	      try {
	    	  conn.commit();
	      }catch (SQLException e) {
	    	  e.printStackTrace();
	      }
	    
	      return result;
	     
	      

	}


}
