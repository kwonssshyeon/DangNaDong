CREATE TABLE MEMBER(
    Member_id VARCHAR(20),
    Gender CHAR(1) not null,
    Birth DATE,
    Self_introdution VARCHAR(350),
    E_mail VARCHAR(40) not null,
    Nickname VARCHAR(30) not null,
    User_password VARCHAR(15) not null,
    Profile_image VARCHAR(200),
    PRIMARY KEY (Member_id),
    UNIQUE(E_mail,Nickname)
);


CREATE TABLE LOCATION(
    Location_id     char(3),
    Continent      varchar(10)  not null,
    Nation          varchar(22) not null,
    PRIMARY KEY(Location_id),
    UNIQUE(Nation)
);

CREATE TABLE TRAVEL_COMPANION_POST(
    Post_id NUMBER,
    Member_id VARCHAR(20) not null,
    Creation_time TIMESTAMP,
    Title VARCHAR(90) not null,
    Content_text VARCHAR(1000),
    Travel_date DATE,
    Travel_period VARCHAR(12),
    Expected_cost VARCHAR(20),
    State VARCHAR(10),
    Deadline DATE,
    Gender_condition CHAR(6),
    Age_condition VARCHAR(16),
    Nationality_condition VARCHAR(40),
    Number_of_recruited NUMBER,
    PRIMARY KEY (Post_id)
);

ALTER TABLE TRAVEL_COMPANION_POST ADD FOREIGN KEY (Member_id) REFERENCES MEMBER(Member_id) ON DELETE CASCADE;

CREATE TABLE CPN_CONTAIN(
    Post_id NUMBER not null,
    Location_id char(3) not null,
    PRIMARY KEY(Post_id,Location_id),
    FOREIGN KEY (Location_id) REFERENCES LOCATION(Location_id) ON DELETE CASCADE,
    FOREIGN KEY (Post_id) REFERENCES TRAVEL_COMPANION_POST (Post_id) ON DELETE CASCADE
);


CREATE TABLE TRAVEL_INTRODUCTION_POST(
    Post_id NUMBER,
    Member_id VARCHAR(20) not null,
    Creation_time TIMESTAMP,
    Title VARCHAR(90) not null,
    Content_text VARCHAR(1000) ,
    Travel_date DATE,
    Travel_period VARCHAR(12),
    Cost VARCHAR(20),
    PRIMARY KEY (Post_id)
);

ALTER TABLE TRAVEL_INTRODUCTION_POST ADD FOREIGN KEY (Member_id) REFERENCES MEMBER(Member_id) ON DELETE CASCADE;

CREATE TABLE ITR_CONTAIN(
    Post_id NUMBER not null,
    Location_id char(3) not null,
    PRIMARY KEY(Post_id,Location_id),
    FOREIGN KEY (Location_id) REFERENCES LOCATION(Location_id) ON DELETE CASCADE,
    FOREIGN KEY (Post_id) REFERENCES TRAVEL_INTRODUCTION_POST (Post_id) ON DELETE CASCADE
);

CREATE TABLE APPLICATION_INFO(
    Post_id NUMBER,
    Member_id VARCHAR(20) not null,
    Request_state VARCHAR(7),
    Application_time DATE,
    PRIMARY KEY (Post_id,Member_id),
    FOREIGN KEY (Post_id) REFERENCES TRAVEL_COMPANION_POST(Post_id) ON DELETE CASCADE,
    FOREIGN KEY (Member_id) REFERENCES MEMBER(Member_id) ON DELETE CASCADE
);

CREATE TABLE REPLY(
    reply_id NUMBER,
    Member_id VARCHAR(20) not null,
    Post_id NUMBER not null,
    Content VARCHAR(600),
    Creation_time TIMESTAMP,
    PRIMARY KEY (Post_id, reply_id),
    FOREIGN KEY (Member_id) REFERENCES MEMBER(Member_id) ON DELETE CASCADE,
    FOREIGN KEY (Post_id) REFERENCES TRAVEL_INTRODUCTION_POST(Post_id) ON DELETE CASCADE
);

CREATE TABLE ITR_IMAGE(
    Post_id NUMBER not null,
    Img_url VARCHAR(200) not null,
    Img_name VARCHAR(20) not null,
    PRIMARY KEY (Post_id, Img_name)
);

ALTER TABLE ITR_IMAGE ADD FOREIGN KEY (Post_id) REFERENCES TRAVEL_INTRODUCTION_POST(Post_id) ON DELETE CASCADE;

CREATE TABLE CPN_IMAGE(
    Post_id NUMBER not null,
    Img_url VARCHAR(200) not null,
    Img_name VARCHAR(20) not null,
    PRIMARY KEY (Post_id, Img_name)
);

ALTER TABLE CPN_IMAGE ADD FOREIGN KEY (Post_id) REFERENCES TRAVEL_COMPANION_POST(Post_id) ON DELETE CASCADE;

CREATE TABLE CHAT_ROOM(
    Chat_room_id NUMBER,
    Post_id NUMBER not null,
    Applier_id VARCHAR(20) not null,
    PRIMARY KEY (Chat_room_id),
    FOREIGN KEY (Post_id) REFERENCES TRAVEL_COMPANION_POST(Post_id) ON DELETE CASCADE,  
    FOREIGN KEY (Applier_id) REFERENCES MEMBER(Member_id) ON DELETE CASCADE
);

CREATE TABLE ONE_TO_ONE_CHAT (
    Chat_id NUMBER,
    Chat_room_id NUMBER not null,
    Member_id VARCHAR(20) not null,--메세지를 보낸사람
    Message VARCHAR(300),
    Creation_time TIMESTAMP,
    PRIMARY KEY (Chat_id, Chat_room_id, Member_id)
);

ALTER TABLE ONE_TO_ONE_CHAT ADD FOREIGN KEY (Member_id) REFERENCES MEMBER(Member_id) ON DELETE CASCADE;

ALTER TABLE ONE_TO_ONE_CHAT ADD FOREIGN KEY (Chat_room_id) REFERENCES CHAT_ROOM(Chat_room_id) ON DELETE CASCADE;

CREATE TABLE REAL_TIME_CHAT(
    Chat_id NUMBER,
    Location_id char(3) not null,
    Member_id VARCHAR(20) not null,
    Message VARCHAR(300),
    Creation_time TIMESTAMP,
    Sender_location VARCHAR(22),
    PRIMARY KEY (Chat_id)
);

ALTER TABLE REAL_TIME_CHAT ADD FOREIGN KEY (Member_id) REFERENCES MEMBER(Member_id) ON DELETE CASCADE;

ALTER TABLE REAL_TIME_CHAT ADD FOREIGN KEY (Location_id) REFERENCES LOCATION(Location_id) ON DELETE CASCADE;

CREATE TABLE LIKE_POST(
    Post_id NUMBER not null,
    Member_id VARCHAR(20) not null,
    PRIMARY KEY (Post_id,Member_id),
    FOREIGN KEY (Post_id) REFERENCES TRAVEL_COMPANION_POST(Post_id) ON DELETE CASCADE,  
    FOREIGN KEY (Member_id) REFERENCES MEMBER(Member_id) ON DELETE CASCADE
);

CREATE TABLE SCRAP(
    Post_id NUMBER not null,
    Member_id VARCHAR(20) not null,
    PRIMARY KEY (Post_id,Member_id),
    FOREIGN KEY (Post_id) REFERENCES TRAVEL_INTRODUCTION_POST(Post_id) ON DELETE CASCADE,  
    FOREIGN KEY (Member_id) REFERENCES MEMBER(Member_id) ON DELETE CASCADE
);

commit;