package com;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/updateNations")
public class countries extends HttpServlet {
	public static final String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
	public static final String USER_UNIVERSITY = "university";
	public static final String USER_PASSWD = "comp322";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
		Connection conn = null; // Connection object
	    Statement stmt = null;    // Statement object
	    List<Country> countries = new ArrayList<>();
	    
        String continent = request.getParameter("continent");
        System.out.println(continent);
        
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

        // 대륙에 따른 국가 목록 생성 (가상의 데이터 예시)
        String findNations = "select l.nation, l.location_id, count(*) from location l, travel_companion_post p, cpn_contain c where c.location_id = l.location_id and c.post_id = p.post_id and l.continent = ? group by l.nation, l.location_id having count(*) > 1";
		

	    try{
			PreparedStatement pstmt = conn.prepareStatement(findNations);
			pstmt.setString(1, continent);
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()){
				String nation_name = rs.getString(1);
				String natioin_id = rs.getString(2);
				int count = rs.getInt(3);
				
				countries.add(new Country(natioin_id, nation_name));
				
			}
			
		} catch (SQLException e) {
			System.out.print(e.getMessage());
		}
	    try {
			conn.commit();
		}catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

        // 국가 목록을 JSON 형식으로 변환
        String jsonCountries = toJson(countries);
        
        System.out.println(jsonCountries);

        // 응답으로 JSON 데이터 전송
        PrintWriter out = response.getWriter();
        out.print(jsonCountries);
        out.flush();
    }

    private String toJson(List<Country> countries) {
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < countries.size(); i++) {
            Country country = countries.get(i);
            json.append("{\"nationId\":\"").append(country.getNationId())
                .append("\",\"nationName\":\"").append(country.getNationName())
                .append("\"}");
            if (i < countries.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");
        return json.toString();
    }

    private static class Country {
        private String nationId;
        private String nationName;

        public Country(String nationId, String nationName) {
            this.nationId = nationId;
            this.nationName = nationName;
        }

        public String getNationId() {
            return nationId;
        }

        public String getNationName() {
            return nationName;
        }
    }
}