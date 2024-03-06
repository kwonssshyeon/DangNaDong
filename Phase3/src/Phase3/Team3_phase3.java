/**************************************************
 * Copyright (c) 2023 KNU DACS Lab. To Present
 * All rights reserved. 
 **************************************************/
package Phase3;

import java.io.File;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.Arrays;
import java.util.List; // import JDBC package
import java.util.Scanner;
import java.util.Date;
import java.text.SimpleDateFormat;

/**
 * Sample Code for JDBC Practice
 * @author yksuh
 */
public class Team3_phase3{
   public static final String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
   public static final String USER_UNIVERSITY = "university";
   public static final String USER_PASSWD = "comp322";
   public static final List<String> TABLES_NAME = Arrays.asList("APPLICATION_INFO", "CPN_CONTAIN", "CPN_IMAGE",
         "ITR_CONTAIN", "ITR_IMAGE", "LIKE_POST", "LOCATION", "MEMBER", "ONE_TO_ONE_CHAT", "REAL_TIME_CHAT", "REPLY", "SCRAP",
         "TRAVEL_COMPANION_POST", "TRAVEL_INTRODUCTION_POST", "CHAT_ROOM");
   public static String memberId = null;
   public static String location = null;

   public static int postId = 1001;
   private static int replyId = 5000;


   public static void main(String[] args) {
      Connection conn = null; // Connection object
      Statement stmt = null;    // Statement object
      Scanner scanner = new Scanner(System.in);


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
         System.out.println("Connected.");
      } catch (SQLException ex) {
         ex.printStackTrace();
         System.err.println("Cannot get a connection: " + ex.getLocalizedMessage());
         System.err.println("Cannot get a connection: " + ex.getMessage());
         System.exit(1);
      }
      try {
         stmt = conn.createStatement();
      } catch (SQLException e) {
         // TODO Auto-generated catch block
         System.out.println(e.getMessage());
      }

//-----기본세팅----------------------------------------------------------------------------------------------//

      //1.drop table -> create table -> insert values
      initDatabase(conn, stmt);

      //2. 로그인,회원가입,
      login(conn, stmt);
      System.out.println("\n현재 로그인된 회원 : " + memberId);

      //3.회원정보수정,삭제
      System.out.println("회원정보를 변경하시겠습니까?");
      System.out.print("1.수정 2.삭제 3.변경하지 않습니다 :");
      int op = scanner.nextInt();

      switch (op) {
         case 1:
            update_member(conn, stmt);
            break;
         case 2:
            delete_member(conn, stmt);
            break;
         default:
            break;
      }
      //4. 나라입력하여 선택
      selectLocation(conn, stmt);
      
//-----------------------------------------------------------------------------------------------------//
      
      System.out.println("\n\n원하시는 메뉴을 선택하세요.");
      System.out.println("1. 게시글 작성하기");
      System.out.println("2. '동행 찾기'게시글에 동행 신청하기");
      System.out.println("3. 내가 쓴 '동행 찾기' 게시글 신청정보 조회 및 수정하기");
      System.out.println("4. '일정 소개' 게시글에 댓글 작성하기");
      System.out.println("5. 다른 다양한 기능 더보기");
      
      System.out.print("기능 선택 : ");
      int func = scanner.nextInt();
      
      System.out.println();
      System.out.println();
      
      
      switch(func) {
      case 1:
          //게시글 작성
          System.out.println("글을 작성/수정 하시겠습니까?");
          System.out.print("1.작성 2.수정 3.삭제 4.나가기 :");
          int opPost = scanner.nextInt();
          switch (opPost) {
             case 1:
                writePost(conn,memberId);
                break;
             case 2:
                updatePost(conn,memberId);
                break;
             case 3:
                deletePost(conn,memberId);
                break;
             default:
                break;
          }
      case 2:
    	//동행 신청하기
          System.out.println("선택한 여행지("+location+")에 대해 동행을 신청하시겠습니까?");
          System.out.print("1.동행 신청하기 2.종료  : ");
          int selected1 = scanner.nextInt();

          switch(selected1) {
             case 1:
                applyForComp(conn,stmt);
                break;
             case 2: break;
             default : break;
          }
      case 3: 
    	//내 게시글 신청정보 조회 & 수락,거절
          System.out.println("\n[" + memberId + "]님의 동행자 구인 게시글에 대한 신청 정보를 조회하시겠습니까?");
          System.out.print("1.신청정보 조회하기  2.종료  : ");
          int selected2 = scanner.nextInt();

          switch(selected2) {
             case 1:
                applicationInfo(conn,stmt);
                break;
             case 2:
                System.out.println("종료를 선택하셨습니다.");
                break;
             default : break;
          }
      case 4:
          writeComment(conn,memberId);
      case 5: 
    	  break;

      }
      
//------쿼리 관련 기능-----------------------------------------------------------------------------//
    
      int flag = 0;
      while(flag == 0) {
    	  System.out.println("\n\n쿼리문을 실행할 수 있습니다. 기능을 선택하세요.");
          
          System.out.println("1. 특정 시점 이후에 태어난 회원의 정보를 조회하기");
          System.out.println("2. 여행일정을 소개하는 글이 일정한 개수 이상인 국가를 순서대로 정렬하기");
          System.out.println("3. 남긴 댓글의 개수가 상위 n등 이내의 사람이 쓴 일정글 제목을 조회하기");
          System.out.println("4. 생일 같은 사람이 몇명 이상인 경우를 모두 조회하여라");
          
          System.out.println("5. 여행 소개글 중 아직 스크랩 되지 못한 대륙과 국가를 조회하기");
          System.out.println("6. 채팅 횟수가 가장 많은 회원의 닉네임과 그 횟수를 반환하기");
          System.out.println("7. 동행을 구하는 게시글 중 진행 중인 게시물의 국가 아이디를 조회하기");
          
          System.out.println("8. 특정 날짜 이전에 쓰여진 동행글과 여행지 보기");
          System.out.println("9. 국적, 성별 조건 선택하여 구인 '진행'상태의 동행글 조회하기");
          System.out.println("10. 좋아요 수에 따른 동행글과 신청'거절'수 조회하기");
          
          System.out.println("11. 종료하기");
          System.out.print("선택 : ");
          int queryOption = scanner.nextInt();
         
    		
          switch(queryOption) {
          case 1:
        	  Query1(conn,stmt);
        	  break;
          case 2:
        	  Query3(conn,stmt);
        	  break;
          case 3:
        	  Query4(conn,stmt);
        	  break;
          case 4:
        	  Query5(conn,stmt);
        	  break;
          case 5:
        	  executeQuery5(stmt,conn);
        	  break;
          case 6:
        	  executeQuery6(stmt,conn);
        	  break;
          case 7:
        	  executeQuery7(stmt,conn);
        	  break;
          case 8:
        	  query8(conn,stmt);
        	  break;
          case 9:
        	  query9(conn,stmt);
        	  break;
          case 10:
        	  query10(conn,stmt);
        	  break;
	      case 11:
	    	  flag=1;
	    	  break;
	      }
      }
      
      
      
      
      
      
      
      
      try {
         // Close the Statement object.
         conn.commit();
         stmt.close();
         // Close the Connection object.
         scanner.close();
         conn.close();

      } catch (SQLException e) {
         // TODO Auto-generated catch block
         System.out.println(e.getMessage());
      }

   }

   public static void initDatabase(Connection conn, Statement stmt) {
      String sql = ""; // an SQL statement 

      //1. drop
      try {
         conn.setAutoCommit(false);
         int res = 0;

         // 1. Drop all tables
         for (String TABLE_NAME : TABLES_NAME) {
            sql = "DROP TABLE " + TABLE_NAME + " CASCADE CONSTRAINT";

            try {
               res = stmt.executeUpdate(sql);
               if (res == 0)
                  System.out.println("Table " + TABLE_NAME + " was successfully dropped.");
            } catch (Exception ex) {
               System.out.println(ex.getMessage());
            }
         }
      } catch (Exception e) {
         System.out.println(e.getMessage());
      }


      //2. create
      try {
         Scanner scanner = new Scanner(new File("./Team3-Phase2-1.sql"));
         scanner.useDelimiter("\\n");

         String create = "";
         while (scanner.hasNext()) {

            String line = scanner.next().replace(";", "");
            if (line.isEmpty()) {
               System.out.println(create);

               try {
                  if (create != null && !create.isEmpty()) {
                     int res = stmt.executeUpdate(create);
                  }

               } catch (Exception ex) {
                  System.out.println(ex.getMessage());
               }
               create = "";
            } else {
               create += (line + "\r\n");
            }
         }

      } catch (Exception e) {
         System.out.println(e.getMessage());
      }


      //3. insert
      try {
         Scanner scanner = new Scanner(new File("./Team3-Phase2-2.sql"));
         scanner.useDelimiter("\\n");

         while (scanner.hasNext()) {
            String insert = scanner.next().replace(";", "");
            if (insert.isEmpty() || insert.contains("--")) {
               continue;
            } else {
               System.out.println(insert);

               try {
                  int res = stmt.executeUpdate(insert);
               } catch (Exception ex) {
            	  System.out.println(insert);
                  System.out.println(ex.getMessage());
               }
            }
         }

      } catch (Exception e) {
         System.out.println(e.getMessage());
      }


      //4. commit
      try {
         conn.commit();
      } catch (SQLException e) {
         System.out.println(e.getMessage());
      }


   }
   public static void writeComment(Connection conn, String memberId) {
	    Scanner sc = new Scanner(System.in);

	    System.out.print("댓글을 작성하시겠습니까? (1: 예, 2: 아니오): ");
	    int choice = sc.nextInt();
	    sc.nextLine(); // 개행 문자 처리

	    if (choice == 1) {
	        System.out.println("어떤 글에 댓글을 작성하시겠습니까? ");
	        String postType = "TRAVEL_INTRODUCTION_POST";

	        // 선택된 타입에 따라 게시물 목록을 표시
	        displayPostList(conn, postType);

	        System.out.print("댓글을 작성하고 싶은 글의 ID를 입력하세요: ");
	        int postId = sc.nextInt();

	        if (postId != -1) {
	            System.out.print("댓글 내용을 입력하세요: ");
	            sc.nextLine(); // 개행 문자 처리
	            String commentContent = sc.nextLine();

	            String creationTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

	            // REPLY_ID 증가 및 댓글 삽입
	            replyId++;
	            insertComment(conn, memberId, postId, commentContent, creationTime);
	            System.out.println("댓글이 작성되었습니다.");

	            // 댓글 삽입 후 COMMIT 수행
	            try {
	                conn.commit();
	                
	            } catch (SQLException e) {
	                System.err.println("COMMIT 오류: " + e.getMessage());
	            }
	        } else {
	            System.out.println("입력한 ID의 글을 찾을 수 없습니다.");
	        }
	    } else {
	        System.out.println("댓글 작성을 취소했습니다.");
	    }
	}



	// 선택된 타입에 따라 게시물 목록을 표시
	private static void displayPostList(Connection conn, String postType) {
	    try {
	        String query = "SELECT Post_id, Title FROM " + postType;
	        try (PreparedStatement preparedStatement = conn.prepareStatement(query)) {
	            try (ResultSet resultSet = preparedStatement.executeQuery()) {
	                System.out.println("현재 " + postType + "에 작성된 글 목록:");
	                while (resultSet.next()) {
	                    int postId = resultSet.getInt("Post_id");
	                    String postTitle = resultSet.getString("Title");
	                    System.out.println("글 ID: " + postId + ", 제목: " + postTitle);
	                }
	            }
	        }
	    } catch (SQLException e) {
	        System.err.println("SQL 오류: " + e.getMessage());
	    }
	}


	// 해당하는 글의 post_id를 조회하는 메소드
	private static int getPostIdByTitleAndType(Connection conn, String postType, String postTitle) {
	    int postId = -1;

	    try {
	        String query = "SELECT Post_id FROM " + postType + " WHERE Title = ?";
	        try (PreparedStatement preparedStatement = conn.prepareStatement(query)) {
	            preparedStatement.setString(1, postTitle);

	            try (ResultSet resultSet = preparedStatement.executeQuery()) {
	                if (resultSet.next()) {
	                    postId = resultSet.getInt("Post_id");
	                }
	            }
	        }
	    } catch (SQLException e) {
	        System.err.println("SQL 오류: " + e.getMessage());
	    }

	    return postId;
	}

	// 댓글을 DB에 저장하는 메소드
    private static void insertComment(Connection conn, String memberId, int postId, String content, String creationTime) {
        try {
            // REPLY_ID 전역 변수를 사용하여 댓글 ID 설정
            replyId++;
            
            String query = "INSERT INTO REPLY (reply_id, Member_id, Post_id, Content, Creation_time) VALUES (?, ?, ?, ?, TO_TIMESTAMP(?, 'YYYY-MM-DD HH24:MI:SS'))";
            try (PreparedStatement preparedStatement = conn.prepareStatement(query)) {
                preparedStatement.setInt(1, replyId);
                preparedStatement.setString(2, memberId);
                preparedStatement.setInt(3, postId);
                preparedStatement.setString(4, content);
                preparedStatement.setString(5, creationTime);

                preparedStatement.executeUpdate();
            }
        } catch (SQLException e) {
            System.err.println("SQL 오류: " + e.getMessage());
        }
    }


   public static void login(Connection conn, Statement stmt) {
      //로그인 -> 일치하는 id 없으면 회원가입 -> 1. 로그인 완료 / 2. 회원정보를 수정하시겠습니까? 3. 회원정보를 삭제하시겠습니까? 
      ResultSet rs = null;
      Scanner scanner = new Scanner(System.in);

      System.out.println("<< login >>");
      System.out.print("id를 입력하세요(Mid1) : ");
      String id = scanner.next();
      System.out.print("비밀번호를 입력하세요(@lydFWn72(G) : ");
      String pw = scanner.next();

      String sql = "select member_id from member where member_id='" + id + "' and user_password='" + pw + "'";


      try {
         rs = stmt.executeQuery(sql);
         int flag = 0;
         while (rs.next()) {
            flag = 1;
            memberId = rs.getString(1);
         }
         rs.close();


         if (flag == 0) {
            //로그인 실패 회원가입
            singUp(conn, stmt);
         }
         //수정, 삭제

      } catch (SQLException e) {
         System.out.println(e.getMessage());
      }


   }

   public static void singUp(Connection conn, Statement stmt) {
      Scanner scanner = new Scanner(System.in);
      System.out.println("\n존재하지 않는 회원입니다. 회원가입을 진행하세요");
      System.out.print("아이디 : ");
      String memberid = scanner.next();
      System.out.print("성별 : ");
      String gender = scanner.next();
      System.out.print("생년월일 : ");
      String birth = scanner.next();
      System.out.print("자기소개 한문장 : ");
      String self_introdution = scanner.next();
      System.out.print("이메일 : ");
      String e_mail = scanner.next();
      System.out.print("별명 : ");
      String nickname = scanner.next();
      System.out.print("비밀번호 : ");
      String user_password = scanner.next();
      String profile_image = "https://dang-na-dong.s3.ap-northeast-2.amazonaws.com/profile1.jpg";
      System.out.println("프로필 이미지 : " + profile_image + "(콘솔에서 입력이 안돼 직접입력함.)");

      String insert_member = "insert into member values('" + memberid + "','" + gender + "','" + birth + "','" + self_introdution + "','" + e_mail + "','" + nickname + "','" + user_password + "','" + profile_image + "')";
      int res;
      try {
         res = stmt.executeUpdate(insert_member);
         memberId = memberid;
      } catch (SQLException e) {
         System.out.println(e.getMessage());
      }


   }

   public static void update_member(Connection conn, Statement stmt) {
      Scanner scanner = new Scanner(System.in);
      ResultSet rs = null;


      String sql = "select gender,birth,self_introdution,e_mail,nickname,user_password from member where member_id='" + memberId + "'";
      try {
         rs = stmt.executeQuery(sql);
         String gender = "";
         String birth = "";
         String self_introdution = "";
         String e_mail = "";
         String nickname = "";
         String user_password = "";

         while (rs.next()) {
            gender = rs.getString(1);
            birth = rs.getString(2);
            self_introdution = rs.getString(3);
            e_mail = rs.getString(4);
            nickname = rs.getString(5);
            user_password = rs.getString(6);
         }

         System.out.println("\n수정할 정보를 입력하세요(아이디와 프로필 이미지는 수정이 불가하며 공백입력시 기존값을 유지합니다.)");
         System.out.print("성별(M or F) : ");
         String Ngender = scanner.next();
         System.out.print("생년월일(0000-00-00) : ");
         String Nbirth = scanner.next();
         System.out.print("자기소개 한문장 : ");
         String Nself_introdution = scanner.next();
         System.out.print("이메일 : ");
         String Ne_mail = scanner.next();
         System.out.print("별명 : ");
         String Nnickname = scanner.next();
         System.out.print("비밀번호 : ");
         String Nuser_password = scanner.next();

         if (Ngender.isEmpty()) Ngender = gender;
         if (Nbirth.isEmpty()) Nbirth = birth;
         if (Nself_introdution.isEmpty()) Nself_introdution = self_introdution;
         if (Ne_mail.isEmpty()) Ne_mail = e_mail;
         if (Nnickname.isEmpty()) Nnickname = nickname;
         if (Nuser_password.isEmpty()) Nuser_password = user_password;


         sql = "update member set gender='" + Ngender + "'"
               + ",birth='" + Nbirth + "'"
               + ",self_introdution='" + Nself_introdution + "'"
               + ",e_mail='" + Ne_mail + "'"
               + ",nickname='" + Nnickname + "'"
               + ",user_password='" + user_password + "'"
               + "where member_id='" + memberId + "'";
         int res = stmt.executeUpdate(sql);
         if (res != 0) System.out.println("수정이 완료되었습니다.");

      } catch (SQLException e) {
         System.out.println(e.getMessage());
      }

   }

   public static void delete_member(Connection conn, Statement stmt) {
      String sql = "delete from member where member_id='" + memberId + "'";
      try {
         int res = stmt.executeUpdate(sql);
         if (res != 0) System.out.println("삭제가 완료되었습니다.");
      } catch (SQLException e) {
         //System.out.println(e.getMessage());
         System.out.println("연관된 기록이 남아있어 회원을 삭제할 수 없습니다.");
      }
   }

   public static void selectLocation(Connection conn, Statement stmt) {
      Scanner scanner = new Scanner(System.in);
      System.out.print("\n\n여행가고 싶은 나라를 입력하세요(ex.한국) : ");
      String Nation = scanner.next();
      String sql = "select Location_id from LOCATION where Nation='" + Nation + "'";
      try {
         ResultSet rs = stmt.executeQuery(sql);
         while (rs.next()) {
            location = rs.getString(1);
            System.out.println("선택된 여행지 코드 : " + location);
         }

      } catch (SQLException e) {
         System.out.println(e.getMessage());
      }
   }

   public static void writePost(Connection conn, String memberId) {
      Scanner sc = new Scanner(System.in);


      System.out.println("작성할 게시글 타입을 결정해주세요(TRAVEL_COMPANION_POST or TRAVEL_INTRODUCTION_POST");
      String postType = sc.nextLine();
      String creationTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

      System.out.print("\n\n제목 입력해주세요 : ");
      String title = sc.nextLine();

      System.out.print("내용 입력해주세요 : ");
      String contentText = sc.nextLine();

      System.out.print("여행 기간을 입력해주세요 (yyyy-MM-dd 형식): ");
      String travelDate = sc.nextLine();

      System.out.print("여행 일수를 입력해주세요 (몇박 몇일 형식): ");
      String travelPeriod = sc.nextLine();

      
      int postId=getMaxPostIdByType(conn,postType)+1;
      
      // 공통된 부분
      if (postType.equals("TRAVEL_COMPANION_POST")) {
         System.out.print("여행 경비를 입력해주세요 : ");
         String expectedCost = sc.nextLine();

         System.out.println("글 작성 시, 구인 상황은 진행으로 설정된다.(진행/마감) ");
         String state = "진행";

         System.out.print("구인 게시글 마감일을 입력해주세요 (yyyy-MM-dd 형식): ");
         String deadline = sc.nextLine();

         System.out.print("성별 조건을 입력해주세요 (남/여/무관) : ");
         String genderCondition = sc.nextLine();

         System.out.print("나이 제한을 입력해주세요 : ");
         String ageCondition = sc.nextLine();

         System.out.print("국적 조건을 입력해주세요 : ");
         String nationalityCondition = sc.nextLine();

         System.out.print("모집 인원을 입력해주세요 : ");
         String numberOfRecruited = sc.nextLine();

         insertTravelCompanionPost(conn, memberId, postId, creationTime, title, contentText, travelDate, travelPeriod,
               expectedCost, state, deadline, genderCondition, ageCondition, nationalityCondition, numberOfRecruited);
      } else if (postType.equals("TRAVEL_INTRODUCTION_POST")) {
         System.out.print("여행 경비를 입력해주세요 : ");
         String cost = sc.nextLine();

         insertTravelIntroductionPost(conn, memberId, postId, creationTime, title, contentText, travelDate, travelPeriod, cost);
      }
      System.out.println("작성이 완료되었습니다.");   }
   
   private static int getMaxPostIdByType(Connection conn,String postType) {
      String query="SELECT MAX(Post_id) FROM "+ postType;
      try(Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(query)){
         if(rs.next()) {
            return rs.getInt(1);
         }
               
            }catch (SQLException e) {
               e.printStackTrace();
            }
      return 0;
   }
   public static void deletePost(Connection conn, String memberId) {
	    Scanner sc = new Scanner(System.in);
	    Map<String, Integer> titleToPostIdMap = new HashMap<>();

	    System.out.println("삭제할 게시글 타입을 결정해주세요(TRAVEL_COMPANION_POST 또는 TRAVEL_INTRODUCTION_POST)");
	    String postType = sc.nextLine();
	    displayUserPosts(conn, memberId, titleToPostIdMap, postType);

	    // 입력한 제목이 목록에 있는지 확인
	    Integer postIdToDelete = getPostIdToUpdate(sc, titleToPostIdMap);

	    if (postIdToDelete != null) {
	        try {
	            String deleteQuery = "DELETE FROM " + postType + " WHERE Post_id = ?";
	            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteQuery)) {
	                deleteStmt.setInt(1, postIdToDelete);

	                int rowsAffected = deleteStmt.executeUpdate(); // 영향을 받은 행의 수를 반환.
	                if (rowsAffected > 0) {
	                    System.out.println("글이 삭제되었습니다.");
	                    
	                    // 삭제 작업 후에 커밋 수행
	                    conn.commit();
	                } else {
	                    System.out.println("글 삭제에 실패했습니다.");
	                }
	            }
	        } catch (SQLException e) {
	            System.out.println("글 삭제 중 오류가 발생했습니다.");
	            e.printStackTrace();
	        }
	    } else {
	        System.out.println("입력한 제목의 글을 찾을 수 없습니다.");
	    }
   }

   private static void insertTravelCompanionPost(Connection conn, String memberId, int postId, String creationTime,
                                      String title, String contentText, String travelDate, String travelPeriod, String expectedCost, String state,
                                      String deadline, String genderCondition, String ageCondition, String nationalityCondition,
                                      String numberOfRecruited) {
      // SQL INSERT 문 생성
      String insertTravelCompanionPost = "INSERT INTO TRAVEL_COMPANION_POST (Post_id, Member_id, Creation_time, Title, Content_text, Travel_date, Travel_period, Expected_cost, State, Deadline, Gender_condition, Age_condition, Nationality_condition, Number_of_recruited) " +
            "VALUES (?, ?, TO_TIMESTAMP(?, 'YYYY-MM-DD HH24:MI:SS'), ?, ?, TO_DATE(?, 'YYYY-MM-DD'), ?, ?, ?, TO_DATE(?, 'YYYY-MM-DD'), ?, ?, ?, ?)";

      try (PreparedStatement pstmt = conn.prepareStatement(insertTravelCompanionPost)) {
         pstmt.setInt(1, postId);
         pstmt.setString(2, memberId);
         pstmt.setString(3, creationTime);
         pstmt.setString(4, title);
         pstmt.setString(5, contentText);
         pstmt.setString(6, travelDate);
         pstmt.setString(7, travelPeriod);
         pstmt.setString(8, expectedCost);
         pstmt.setString(9, state);
         pstmt.setString(10, deadline);
         pstmt.setString(11, genderCondition);
         pstmt.setString(12, ageCondition);
         pstmt.setString(13, nationalityCondition);
         pstmt.setString(14, numberOfRecruited);

         pstmt.executeUpdate();
      } catch (SQLException e) {
         e.printStackTrace();
      }
   }

   private static void insertTravelIntroductionPost(Connection conn, String memberId, int postId, String creationTime,
                                        String title, String contentText, String travelDate, String travelPeriod, String cost) {
      // SQL INSERT 문 생성
      String insertTravelIntroductionPost = "INSERT INTO TRAVEL_INTRODUCTION_POST (Post_id, Member_id, Creation_time, Title, Content_text, Travel_date, Travel_period, Cost) " +
            "VALUES (?, ?, TO_TIMESTAMP(?, 'YYYY-MM-DD HH24:MI:SS'), ?, ?, TO_DATE(?, 'YYYY-MM-DD'), ?, ?)";

      try (PreparedStatement pstmt = conn.prepareStatement(insertTravelIntroductionPost)) {
         pstmt.setInt(1, postId);
         pstmt.setString(2, memberId);
         pstmt.setString(3, creationTime);
         pstmt.setString(4, title);
         pstmt.setString(5, contentText);
         pstmt.setString(6, travelDate);
         pstmt.setString(7, travelPeriod);
         pstmt.setString(8, cost);
         pstmt.executeUpdate();
      } catch (SQLException e) {
         e.printStackTrace();
      }
   }

   public static void displayUserPosts(Connection conn, String memberId, Map<String, Integer> titleToPostIdMap, String postType) {
      try {
         String query = "SELECT Title, Post_id FROM " + postType + " WHERE Member_id = ?";
         try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, memberId);

            try (ResultSet rs = pstmt.executeQuery()) {
               while (rs.next()) {
                  String title = rs.getString("Title");
                  int postId = rs.getInt("Post_id");
                  titleToPostIdMap.put(title, postId);
               }
            }
         }
      } catch (SQLException e) {
         e.printStackTrace();
      }

      System.out.println(memberId + "님의 작성한 글 목록 :");
      for (String title : titleToPostIdMap.keySet()) {
         System.out.println("글 ID: " + titleToPostIdMap.get(title)+", 글 제목: " + title );
      }
   }


   public static Integer getPostIdToUpdate(Scanner sc, Map<String, Integer> titleToPostIdMap) {
      System.out.print("\n\n수정을 원하는 게시글 제목 입력해주세요 : ");
      String oldTitle = sc.nextLine();

      // 입력한 제목이 목록에 있는지 확인
      return titleToPostIdMap.get(oldTitle);
   }


   public static void updatePost(Connection conn, String memberId) {
      //memberId 파라미터로 받음 => travel 글 목록 조회/출력 => 수정하고 싶은 글로 이동 => 수정 내용(옵션) 선택 => 수정

      Scanner sc = new Scanner(System.in);
      Map<String, Integer> titleToPostIdMap = new HashMap<>();

      System.out.println("수정할 게시글 타입을 결정해주세요(TRAVEL_COMPANION_POST or TRAVEL_INTRODUCTION_POST");
      String postType = sc.nextLine();
      displayUserPosts(conn, memberId, titleToPostIdMap, postType);

      // 입력한 제목이 목록에 있는지 확인
      Integer postIdToUpdate = getPostIdToUpdate(sc,titleToPostIdMap);

      if (postIdToUpdate != null) {

         printOption(postType);

         int option = sc.nextInt();
         sc.nextLine(); // 입력 버퍼 비우기
         switch (option) {
                  case 1:
                     updateTitle(conn, postIdToUpdate, sc, postType);
                     break;
                  case 2:
                     updateContent(conn, postIdToUpdate, sc, postType);
                     break;
                  case 3:
                     updateTravelDate(conn, postIdToUpdate, sc, postType);
                     break;
                  case 4:
                     updateTravelPeriod(conn, postIdToUpdate, sc, postType);
                     break;
                  case 5:
                     updateExpectedCost(conn, postIdToUpdate, sc, postType);
                     break;
                  case 6:
                     updateState(conn, postIdToUpdate, sc, postType);
                     break;
                  case 7:
                     updateDeadline(conn, postIdToUpdate, sc, postType);
                     break;
                  case 8:
                     updateGenderCondition(conn, postIdToUpdate, sc, postType);
                     break;
                  case 9:
                     updateAgeCondition(conn, postIdToUpdate, sc, postType);
                     break;
                  case 10:
                     updateNationalityCondition(conn, postIdToUpdate, sc, postType);
                     break;
                  case 11:
                     updateNumberOfRecruited(conn, postIdToUpdate, sc, postType);
                     break;
                  default:
                     System.out.println("올바른 옵션을 선택해주세요.");
               }
         }
       else {
         System.out.println("입력한 제목의 글을 찾을 수 없습니다.");
      }
   }

   private static void printOption(String postType) {
      System.out.println("\n\n수정할 내용을 선택해주세요:");
      System.out.println("1. 제목 수정");
      System.out.println("2. 내용 수정");
      System.out.println("3. 여행 기간 수정");
      System.out.println("4. 여행 일수 수정");
      System.out.println("5. 여행 경비 수정");
      if (!postType.equals("TRAVEL_INTRODUCTION_POST")) {
         System.out.println("6. 구인 상황 수정");
         System.out.println("7. 구인 게시글 마감일 수정");
         System.out.println("8. 성별 조건 수정");
         System.out.println("9. 나이 제한 수정");
         System.out.println("10. 국적 조건 수정");
         System.out.println("11. 모집 인원 수정");
      }
   }

   public static void updateTitle(Connection conn, int postIdToUpdate, Scanner sc, String postType) {
      System.out.print("수정할 제목 입력해주세요: ");
      String updatedTitle = sc.nextLine();

      String updateTitleQuery = "UPDATE " + postType + " SET Title = ? WHERE Post_id = ?";
      try (PreparedStatement updateTitleStmt = conn.prepareStatement(updateTitleQuery)) {
         updateTitleStmt.setString(1, updatedTitle);
         updateTitleStmt.setInt(2, postIdToUpdate);
         updateTitleStmt.executeUpdate();
         System.out.println("제목이 수정되었습니다.");
      } catch (SQLException e) {
         e.printStackTrace();
      }
   }

   public static void updateContent(Connection conn, int postIdToUpdate, Scanner sc, String postType) {
      System.out.print("수정할 내용 입력해주세요: ");
      String updatedContent = sc.nextLine();

      String updateContentQuery = "UPDATE " + postType + " SET Content_text = ? WHERE Post_id = ?";
      try (PreparedStatement updateContentStmt = conn.prepareStatement(updateContentQuery)) {
         updateContentStmt.setString(1, updatedContent);
         updateContentStmt.setInt(2, postIdToUpdate);
         updateContentStmt.executeUpdate();
         System.out.println("내용이 수정되었습니다.");
      } catch (SQLException e) {
         e.printStackTrace();
      }
   }

   public static void updateTravelDate(Connection conn, int postIdToUpdate, Scanner sc, String postType){

      System.out.print("수정할 여행 기간 입력해주세요 (yyyy-MM-dd 형식): ");
      String updatedTravelDate = sc.nextLine();
      // 여기에 해당하는 SQL UPDATE 문 작성 및 실행
      String updateTravelDateQuery = "UPDATE TRAVEL_COMPANION_POST SET Travel_date = TO_DATE(?, 'YYYY-MM-DD') WHERE Post_id = ?";
      try (PreparedStatement updateTravelDateStmt = conn.prepareStatement(updateTravelDateQuery)) {
         updateTravelDateStmt.setString(1, updatedTravelDate);
         updateTravelDateStmt.setInt(2, postIdToUpdate);
         updateTravelDateStmt.executeUpdate();
         System.out.println("여행 기간이 수정되었습니다.");
      } catch (SQLException e) {
         e.printStackTrace();
      }

   }

   public static void updateTravelPeriod(Connection conn, int postIdToUpdate, Scanner sc, String postType){
      System.out.print("수정할 여행 일수를 입력해주세요 : ");
      String updatedTravelPeriod = sc.nextLine();
      // 여기에 해당하는 SQL UPDATE 문 작성 및 실행
      String updateTravelPeriodQuery = "UPDATE TRAVEL_COMPANION_POST SET Travel_period = ? WHERE Post_id = ?";
      try (PreparedStatement updateTravelPeriodStmt = conn.prepareStatement(updateTravelPeriodQuery)) {
         updateTravelPeriodStmt.setString(1, updatedTravelPeriod);
         updateTravelPeriodStmt.setInt(2, postIdToUpdate);
         updateTravelPeriodStmt.executeUpdate();
         System.out.println("여행 일수가 수정되었습니다.");
      } catch (SQLException e) {
         e.printStackTrace();
      }
   }

   public static void updateExpectedCost(Connection conn, int postIdToUpdate, Scanner sc, String postType){
      System.out.print("수정할 여행 경비를 입력해주세요 : ");
      String updatedExpectedCost = sc.nextLine();
      // 여기에 해당하는 SQL UPDATE 문 작성 및 실행
      String updateExpectedCostQuery = "UPDATE TRAVEL_COMPANION_POST SET Expected_cost = ? WHERE Post_id = ?";
      try (PreparedStatement updateExpectedCostStmt = conn.prepareStatement(updateExpectedCostQuery)) {
         updateExpectedCostStmt.setString(1, updatedExpectedCost);
         updateExpectedCostStmt.setInt(2, postIdToUpdate);
         updateExpectedCostStmt.executeUpdate();
         System.out.println("여행 경비가 수정되었습니다.");
      } catch (SQLException e) {
         e.printStackTrace();
      }
   }

   public static void updateState(Connection conn, int postIdToUpdate, Scanner sc, String postType){
      System.out.println("수정할 여행 구인 상황을 입력해주세요.(진행/마감) ");
      String updatedState = sc.nextLine();
      // 여기에 해당하는 SQL UPDATE 문 작성 및 실행
      String updateStateQuery = "UPDATE TRAVEL_COMPANION_POST SET State = ? WHERE Post_id = ?";
      try (PreparedStatement updateStateStmt = conn.prepareStatement(updateStateQuery)) {
         updateStateStmt.setString(1, updatedState);
         updateStateStmt.setInt(2, postIdToUpdate);
         updateStateStmt.executeUpdate();
         System.out.println("구인 상황이 수정되었습니다.");
      } catch (SQLException e) {
         e.printStackTrace();
      }
   }

   public static void updateDeadline(Connection conn, int postIdToUpdate, Scanner sc, String postType){
      System.out.print("수정할 구인 게시글 마감일을 입력해주세요 (yyyy-MM-dd 형식): ");
      String updatedDeadline = sc.nextLine();
      // 여기에 해당하는 SQL UPDATE 문 작성 및 실행
      String updateDeadlineQuery = "UPDATE TRAVEL_COMPANION_POST SET Deadline = TO_DATE(?, 'YYYY-MM-DD') WHERE Post_id = ?";
      try (PreparedStatement updateDeadlineStmt = conn.prepareStatement(updateDeadlineQuery)) {
         updateDeadlineStmt.setString(1, updatedDeadline);
         updateDeadlineStmt.setInt(2, postIdToUpdate);
         updateDeadlineStmt.executeUpdate();
         System.out.println("구인 게시글 마감일이 수정되었습니다.");
      } catch (SQLException e) {
         e.printStackTrace();
      }
   }

   public static void updateGenderCondition(Connection conn, int postIdToUpdate, Scanner sc, String postType){
      System.out.print("수정할 성별 조건을 입력해주세요 (남/여/무관) : ");
      String updatedGenderCondition = sc.nextLine();
      // 여기에 해당하는 SQL UPDATE 문 작성 및 실행
      String updateGenderConditionQuery = "UPDATE TRAVEL_COMPANION_POST SET Gender_condition = ? WHERE Post_id = ?";
      try (PreparedStatement updateGenderConditionStmt = conn.prepareStatement(updateGenderConditionQuery)) {
         updateGenderConditionStmt.setString(1, updatedGenderCondition);
         updateGenderConditionStmt.setInt(2, postIdToUpdate);
         updateGenderConditionStmt.executeUpdate();
         System.out.println("성별 조건이 수정되었습니다.");
      } catch (SQLException e) {
         e.printStackTrace();
      }
   }

   public static void updateAgeCondition(Connection conn, int postIdToUpdate, Scanner sc, String postType){
      System.out.print("나이 제한을 입력해주세요 : ");
      String updatedAgeCondition = sc.nextLine();
      // 여기에 해당하는 SQL UPDATE 문 작성 및 실행
      String updateAgeConditionQuery = "UPDATE TRAVEL_COMPANION_POST SET Age_condition = ? WHERE Post_id = ?";
      try (PreparedStatement updateAgeConditionStmt = conn.prepareStatement(updateAgeConditionQuery)) {
         updateAgeConditionStmt.setString(1, updatedAgeCondition);
         updateAgeConditionStmt.setInt(2, postIdToUpdate);
         updateAgeConditionStmt.executeUpdate();
         System.out.println("나이 제한이 수정되었습니다.");
      } catch (SQLException e) {
         e.printStackTrace();
      }
   }

   public static void updateNationalityCondition(Connection conn, int postIdToUpdate, Scanner sc, String postType){
      System.out.print("국적 조건을 입력해주세요 : ");
      String updatedNationalityCondition = sc.nextLine();
      // 여기에 해당하는 SQL UPDATE 문 작성 및 실행
      String updateNationalityConditionQuery = "UPDATE TRAVEL_COMPANION_POST SET Nationality_condition = ? WHERE Post_id = ?";
      try (PreparedStatement updateNationalityConditionStmt = conn.prepareStatement(updateNationalityConditionQuery)) {
         updateNationalityConditionStmt.setString(1, updatedNationalityCondition);
         updateNationalityConditionStmt.setInt(2, postIdToUpdate);
         updateNationalityConditionStmt.executeUpdate();
         System.out.println("국적 조건이 수정되었습니다.");
      } catch (SQLException e) {
         e.printStackTrace();
      }
   }

   public static void updateNumberOfRecruited(Connection conn,int postIdToUpdate,Scanner sc,String postType){
      System.out.print("모집 인원을 입력해주세요 : ");
      String updatedNumberOfRecruited = sc.nextLine();
      // 여기에 해당하는 SQL UPDATE 문 작성 및 실행
      String updateNumberOfRecruitedQuery = "UPDATE TRAVEL_COMPANION_POST SET Number_of_recruited = ? WHERE Post_id = ?";
      try (PreparedStatement updateNumberOfRecruitedStmt = conn.prepareStatement(updateNumberOfRecruitedQuery)) {
         updateNumberOfRecruitedStmt.setString(1, updatedNumberOfRecruited);
         updateNumberOfRecruitedStmt.setInt(2, postIdToUpdate);
         updateNumberOfRecruitedStmt.executeUpdate();
         System.out.println("모집 인원이 수정되었습니다.");
      } catch (SQLException e) {
         e.printStackTrace();
      }
   }

   public static void applyForComp(Connection conn, Statement stmt) {
      Scanner scanner = new Scanner(System.in);
      Date date = new Date();
      Timestamp timestamp = new Timestamp(date.getTime());
      SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
      String applyDate = dateFormat.format(timestamp);

      String sql_1 = "select p.post_id, p.title from travel_companion_post p join cpn_contain c on p.post_id = c.post_id where c.location_id = '"+location+"'";

      try {
         ResultSet rs = stmt.executeQuery(sql_1);
         System.out.println("\n\n선택하신 여행지("+location+")에 대한 동행자를 구하는 게시글의 postId와 Title 입니다.\n");

         while(rs.next()) {
            Long postId = rs.getLong(1);
            String title = rs.getString(2);

            System.out.println("postId : " + postId + ", Title : " + title);
         }

      } catch (SQLException e) {
         System.out.println(e.getMessage());
      }

      System.out.println("동행을 신청하고 싶은 게시글이 있다면 postId를 입력하세요.");
      System.out.print("postId : ");
      Long post_id = scanner.nextLong();


      String sql_2 = "insert into application_info values("+post_id+",'"+memberId+"','대기','"+applyDate+"')";

      try {
         ResultSet rs1 = stmt.executeQuery(sql_2);
         System.out.println("[" + memberId + "]님, [postId:" + post_id + "] 동행글에 동행신청 되었습니다.");

      } catch (SQLException e) {
         System.out.println(e.getMessage());
      }
   }


   public static void applicationInfo(Connection conn, Statement stmt) {
      Scanner scanner = new Scanner(System.in);
      SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

      String sql1 = "select post_id, title from travel_companion_post where member_id = '"+memberId+"'";

      try {
         ResultSet rs1 = stmt.executeQuery(sql1);
         System.out.println("\n["+memberId+"]님이 작성하신 동행 게시물의 postId와 Title입니다.\n");
         System.out.println("postId\t| Title");
         System.out.println("-----------------------------");

         while(rs1.next()) {
            Long postId = rs1.getLong(1);
            String title = rs1.getString(2);

            System.out.printf("%d\t| %s\n", postId, title);
         }
      } catch (SQLException e) {
         System.out.println(e.getMessage());
      }

      System.out.print("\n\n신청 상태를 조회하고 싶은 게시글의 postId를 입력하세요 : ");
      Long postId = scanner.nextLong();

      String sql2 = "select member_id, request_state, application_time from application_info where post_id = '"+postId+"'";

      try {
         ResultSet rs2 = stmt.executeQuery(sql2);
         System.out.println("\n선택한 게시글에 대한 신청정보입니다.");
         System.out.println(" 신청자Id\t| 신청상태\t| 신청날짜");
         System.out.println("-----------------------------");

         while(rs2.next()) {
            String member_id = rs2.getString(1);
            String state = rs2.getString(2);
            Date date = rs2.getDate(3);
            String applyDate = dateFormat.format(date);

            System.out.printf(" %s\t| %s\t| %s\n",member_id, state, applyDate);
         }
      } catch (SQLException e) {
         System.out.println(e.getMessage());
      }

      System.out.println("\n\n신청 상태를 변경하시겠습니까?");
      System.out.print("1.신청상태변경 2.종료 : ");
      int op = scanner.nextInt();

      switch (op){
         case 1:
            updateState(conn, stmt, postId);
            break;
         case 2:
            System.out.println("종료를 선택하셨습니다.");
            break;
         default:
            break;
      }

   }

   public static void updateState(Connection conn, Statement stmt, Long post_id) {
      Scanner scanner = new Scanner(System.in);
      SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

      System.out.print("\n신청 상태를 변경하고 싶은 신청자의 Id를 입력하새요 : ");
      String member = scanner.next();

      System.out.print("변경 상태를 선택하세요.(대기, 수락, 거절) : ");
      String state = scanner.next();

      String sql = "update application_info set request_state = '"+state+"' where post_id = "+post_id+" and member_id = '"+member+"'";

      try {
         ResultSet rs = stmt.executeQuery(sql);
         System.out.println("\n\n신청 상태가 변경되었습니다.");

         String sql2 = "select member_id, request_state, application_time from application_info where post_id = "+post_id+" and member_id = '"+member+"'";
         ResultSet rs1 = stmt.executeQuery(sql2);

         System.out.println(" 신청자Id\t| 신청상태\t| 신청날짜");
         System.out.println("-----------------------------");
         rs1.next();
         String member_id = rs1.getString(1);
         String new_state = rs1.getString(2);
         Date date = rs1.getDate(3);
         String applyDate = dateFormat.format(date);

         System.out.printf(" %s\t| %s\t| %s\n",member_id, new_state, applyDate);


      } catch (SQLException e) {
         System.out.println(e.getMessage());
      }

   }
   
   
   public static void Query1(Connection conn, Statement stmt) {
		ResultSet rs = null;
		//System.out.println("<<Query 1>>");
		//System.out.println("특정 시점 이후에 태어난 회원의 정보를 조회하여라");
		System.out.print("언제부터 조회할까요?(20050101 의 형태로 입력하세요) : ");
		Scanner sc = new Scanner(System.in);
		int date = sc.nextInt();
		
		String sql = "select m.nickname, m.e_mail, m.gender\r\n"
				+ "from member m\r\n"
				+ "where m.birth > to_date('"+date+"','YYYYMMDD')";

		try {
			
			rs = stmt.executeQuery(sql);
			System.out.println("\n<<Query1 result>>");
			System.out.println("nickname          | e_mail                    | gender  ");
			System.out.println("----------------------------------------------------------");
			

			while(rs.next()) {
				String nickname = rs.getString(1);
				String e_mail = rs.getString(2);
				String gender = rs.getString(3);
				
				System.out.println(String.format("%16s | %20s | %1s",nickname,e_mail,gender));
				
			}rs.close();
		
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
		
		
	
	}
   
	//사용안하는 쿼리
	public static void Query2(Connection conn, Statement stmt) {
		ResultSet rs = null;
		try {
			//System.out.println("<<Query 2>>");
			
			String sql = "SELECT distinct M.Member_id,M.Nickname, L.nation\r\n"
					+ "FROM MEMBER M, LOCATION L,REAL_TIME_CHAT R\r\n"
					+ "WHERE M.Member_id=R.Member_id AND R.Location_id=L.Location_id";
			rs = stmt.executeQuery(sql);
			
			//System.out.println("실시간 채팅에 참여하고 있는 회원의 정보와 채팅을 하는 국가의 정보를 조회하여라");
			
			System.out.println("\n<<Query2 result>>");
			System.out.println("nickname          | e_mail                    | gender  ");
			System.out.println("------------------------------------------------------------");
			while(rs.next()) {
				// Fill out your code	
				String member = rs.getString(1);
				String nickname = rs.getString(2);
				String nation = rs.getString(3);
				System.out.println(String.format("%10s| %18s|%15s",member , nickname, nation ));
			}
			
			rs.close();
			
			
			
		}catch(Exception e) {
			System.out.println(e.getMessage());
		}
		
		
		
	}
	
	
	
	
	public static void Query3(Connection conn, Statement stmt) {
		ResultSet rs = null;
		
		try {
//			System.out.println("<<Query 3>>");
//			
//			System.out.println("여행일정을 소개하는 글이 일정한 개수 이상인 국가를 순서대로 정렬하여라");
			System.out.print("몇개 이상인 국가만 보여줄까요 ? : ");
			Scanner sc = new Scanner(System.in);
			int num = sc.nextInt();
			
			String sql = "select l.nation, count(*) as number_of_post\r\n"
					+ "from travel_introduction_post p, itr_contain c, location l\r\n"
					+ "where c.post_id = p.post_id\r\n"
					+ "and c.location_id = l.location_id\r\n"
					+ "group by l.nation\r\n"
					+ "having count(*) >=" + num +"\r\n"
					+ "order by count(*) asc";
			
			
			rs = stmt.executeQuery(sql);
			
			System.out.println("\n<<Query 3 result>>");
			System.out.println("nation        | post_count |");
			System.out.println("-----------------------------------");
			while(rs.next()) {
				// Fill out your code	
				String nation = rs.getString(1);
				int count = rs.getInt(2);
				System.out.println(String.format("%12s| %10s|",nation , count ));
			}
			
			rs.close();
	
			
			
			
		}catch(Exception e) {
			System.out.println(e.getMessage());
		}
		
		
		
	}
	
	
	
	public static void Query4(Connection conn, Statement stmt) {
		ResultSet rs = null;
//		System.out.println("<<Query 4>>");
//		System.out.println("남긴 댓글의 개수가 상위 n등 이내의 사람이 쓴 일정글 제목은 무엇인가 ?");
		System.out.print("n을 얼마로 할까요 ? : ");
		Scanner sc = new Scanner(System.in);
		int num = sc.nextInt();

		
		String sql = "select title \r\n"
				+ "from travel_introduction_post\r\n"
				+ "where member_id IN (select r.member_id\r\n"
				+ "                   from (select member_id\r\n"
				+ "                        from reply\r\n"
				+ "                        group by member_id\r\n"
				+ "                        order by count(*) desc) r\r\n"
				+ "                    where ROWNUM<="+num+")";

		try {
			
			rs = stmt.executeQuery(sql);
			System.out.println("\n<<Query4 result>>");
			System.out.println("title                    |");
			System.out.println("--------------------------");
			

			while(rs.next()) {
				String title = rs.getString(1);

				
				System.out.println(title);
				
			}rs.close();
		
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
		
		
	
	}
	public static void Query5(Connection conn, Statement stmt) {
		ResultSet rs = null;
//		System.out.println("<<Query 5>>");
//		System.out.println("생일 같은 사람이 몇명 이상인 경우를 모두 조회하여라");
		System.out.print("몇명 이상으로 할까요(최소2이상) ? : ");
		Scanner sc = new Scanner(System.in);
		int num = sc.nextInt();

		
		String sql = "select distinct a.nickname,a.birth\r\n"
				+ "from member a\r\n"
				+ "where exists(select member_id,to_char(a.Birth,'MM-DD')\r\n"
				+ "            from member b\r\n"
				+ "            where to_char(a.Birth,'MM-DD') = to_char(b.Birth,'MM-DD')\r\n"
				+ "            and a.member_id != b.member_id\r\n"
				+ "            group by to_char(a.Birth,'MM-DD')\r\n"
				+ "            having count(*)>="+num+")\r\n"
				+ "order by to_char(a.Birth,'MM-DD')";

		try {
			
			rs = stmt.executeQuery(sql);
			System.out.println("\n<<Query5 result>>");
			System.out.println("nickname                    |birth          ");
			System.out.println("--------------------------------------------");
			

			while(rs.next()) {
				String nickname = rs.getString(1);
				String birthday = rs.getString(2).split(" ")[0];

				
				System.out.println(String.format("%20s| %10s|",nickname , birthday ));
				
			}rs.close();
		
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
		
		
	
	}
	
	// 7번 쿼리 수행 메소드
    private static void executeQuery5(Statement stmt, Connection conn) {
       try {
          // 사용자로부터 입력 받기
          Scanner scanner = new Scanner(System.in);
          System.out.print("조회할 대륙을 입력하세요 (예: 아프리카, 남아메리카, 유럽, 아시아 등): ");
          String continentInput = scanner.nextLine();

          // 동적으로 쿼리문 생성
          String sqlQuery = "SELECT l.Contenient, l.nation " +
                  "FROM Location l " +
                  "WHERE l.Contenient = ? " +
                  "AND NOT EXISTS(SELECT * FROM ITR_CONTAIN i WHERE i.location_id = l.location_id)";

          // PreparedStatement 생성
          PreparedStatement preparedStatement = conn.prepareStatement(sqlQuery);

          // 플레이스홀더에 값 설정
          preparedStatement.setString(1, continentInput);

          // SQL 쿼리 실행
          ResultSet rs = preparedStatement.executeQuery();

          System.out.println("여행 소개글 중 아직 스크랩 되지 못한 " + continentInput + " 대륙과 국가를 조회하여라.");
          while (rs.next()) {
             String continent = rs.getString("Contenient");
             String nation = rs.getString("nation");
             System.out.println("대륙: " + continent + ", 국가: " + nation);
          }
       } catch (SQLException e) {
          System.err.println("SQL 오류: " + e.getMessage());
       }
    }


    // 11번 쿼리 수행 메소드
    private static void executeQuery6(Statement stmt, Connection conn) {
       try {
          // 사용자로부터 ROWNUM 입력 받기
          Scanner scanner = new Scanner(System.in);
          System.out.print("상위 몇개의 회원을 조회할까요? : ");
          int rownumLimit = scanner.nextInt();

          String sqlQuery = "SELECT nickname, num " +
                  "FROM (SELECT nickname, count(*) as num " +
                  "FROM member NATURAL JOIN real_time_chat " +
                  "GROUP BY nickname " +
                  "ORDER BY count(*) DESC, nickname ASC) " +
                  "WHERE ROWNUM <= ?";


          PreparedStatement preparedStatement = conn.prepareStatement(sqlQuery);
          preparedStatement.setInt(1, rownumLimit);
          ResultSet rs = preparedStatement.executeQuery();

          System.out.println("채팅 횟수가 가장 많은 회원의 닉네임과 그 횟수를 반환하여라");
          while (rs.next()) {
             String nickName = rs.getString("Nickname");
             int chatNum = rs.getInt("num");
             System.out.println("회원 닉네임: " + nickName + ", 채팅 횟수 " + chatNum);
          }
       } catch (SQLException e) {
          System.err.println("SQL 오류: " + e.getMessage());
       }
    }
    // 9번 쿼리 수행 메소드
    private static void executeQuery7(Statement stmt, Connection conn) {
       try {
          // 사용자로부터 입력 받기
          Scanner scanner = new Scanner(System.in);
          System.out.print("게시물 상태를 입력하세요 ('진행' 또는 '마감'): ");
          String postState = scanner.nextLine();

          // 동적으로 쿼리문 생성
          String sqlQuery = "SELECT c.post_id, c.location_id " +
                  "FROM cpn_contain c " +
                  "WHERE c.post_id IN " +
                  "(SELECT p.post_id FROM travel_companion_post p WHERE c.post_id = p.post_id AND p.state = ?) " +
                  "ORDER BY c.location_id ASC";

          // PreparedStatement 생성
          PreparedStatement preparedStatement = conn.prepareStatement(sqlQuery);

          // 플레이스홀더에 값 설정
          preparedStatement.setString(1, postState);

          // SQL 쿼리 실행
          ResultSet rs = preparedStatement.executeQuery();

          System.out.println("동행을 구하는 게시글 중 " + postState + " 중인 게시물의 국가 아이디를 조회하여라.");
          while (rs.next()) {
             int postId = rs.getInt("post_id");
             String locationId = rs.getString("location_id");
             System.out.println("게시물 ID: " + postId + ", 위치 ID: " + locationId);
          }
       } catch (SQLException e) {
          System.err.println("SQL 오류: " + e.getMessage());
       }
    }




   public static void query8(Connection conn, Statement stmt) {
		Scanner scanner = new Scanner(System.in);

		System.out.print("\n특정 날짜 이전에 쓰여진 동행글과 그 나라를 알 수 있습니다. 날짜를 입력하세요.(예:2020-01-01) : ");
		String ans = scanner.next();
		
		String sql = "select l.nation, p.post_id, p.title\r\n"
				+ "from travel_companion_post p, cpn_contain c, location l\r\n"
				+ "where c.post_id = p.post_id\r\n"
				+ "and c.location_id = l.location_id\r\n"
				+ "and p.creation_time < TIMESTAMP '"+ans+" 00:00:00'";
		
		//System.out.println(sql);
		
		try {
			ResultSet rs = stmt.executeQuery(sql);
			System.out.println("\n조회 결과 입니다.");
			System.out.println(" 여행지Id\t| 게시글Id\t| 제목");
			System.out.println("----------------------------------------");
			
			while(rs.next()) {
				String nation = rs.getString(1);
				Long post_id = rs.getLong(2);
				String title = rs.getString(3);
				
				System.out.printf(" %s\t| %d\t| %s\n",nation, post_id, title);
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
	}
	
	public static void query9(Connection conn, Statement stmt) {
		Scanner scanner = new Scanner(System.in);
		
		System.out.println("\n국적, 성별 조건을 선택하여 '진행'상태의 동행글을 조회합니다.");
		System.out.print("국적 조건(한국, 아시아, 유럽, 아프리카, 북아메리카, 남아메리카, 오세아니아, 남극): ");
		String nation = scanner.next();
		System.out.print("성별 조건(남/여/무관): ");
		String gender = scanner.next();
		
		String sql = "select post_id, title\r\n"
				+ "from travel_companion_post\r\n"
				+ "where nationality_condition ='"+nation+"' and state ='진행' and gender_condition = '"+gender+"'\r\n";
				
		try {
			ResultSet rs = stmt.executeQuery(sql);
			System.out.println("\n조회 결과 입니다.");
			System.out.println(" 게시글Id\t| 제목");
			System.out.println("----------------------------------------");
			
			while(rs.next()) {
				Long post_id = rs.getLong(1);
				String title = rs.getString(2);
				
				System.out.printf(" %d\t| %s\n", post_id, title);
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}

	}
	
	public static void query10(Connection conn, Statement stmt) {
		Scanner scanner = new Scanner(System.in);

		System.out.println("\n입력하신 숫자 이상의 '좋아요'수를 가진 동행글과, 해당 글의 신청'거절'수를 보여드립니다.");
		System.out.print("좋아요 수를 입력하세요: ");
		int like = scanner.nextInt();
		
		String sql ="SELECT ap.post_id, COUNT(*) AS refused\r\n"
				+ "FROM application_info ap\r\n"
				+ "WHERE ap.request_state = '거절'\r\n"
				+ "AND ap.post_id IN (\r\n"
				+ "    SELECT post_id\r\n"
				+ "    FROM like_post\r\n"
				+ "    GROUP BY post_id\r\n"
				+ "    HAVING COUNT(*) >= "+like+")\r\n"
				+ "GROUP BY ap.post_id\r\n";
		
		//System.out.println(sql);
				
		try {
			ResultSet rs = stmt.executeQuery(sql);
			System.out.println("\n좋아요 "+like+"개 이상 게시불에 대한 신청'거절' 수 조회 결과 입니다.");
			System.out.println(" 게시글Id\t| 신청거절수");
			System.out.println("----------------------");
			
			while(rs.next()) {
				Long post_id = rs.getLong(1);
				int refused = rs.getInt(2);
				
				System.out.printf(" %d\t| %d\n", post_id, refused);
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
	}
}