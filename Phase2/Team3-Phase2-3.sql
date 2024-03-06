--Type1
--1
select m.nickname, m.e_mail, m.gender
from member m
where m.birth > to_date('20050101','YYYYMMDD');

--Type2
--2
SELECT distinct M.Member_id,M.Nickname, L.nation
FROM MEMBER M, LOCATION L,REAL_TIME_CHAT R
WHERE M.Member_id=R.Member_id AND R.Location_id=L.Location_id;

--Type3
--3
select l.nation, count(*) as number_of_post
from travel_introduction_post p, itr_contain c, location l
where c.post_id = p.post_id
and c.location_id = l.location_id
group by l.nation
having count(*) >=2
order by count(*) asc;

--Type4
--4
select title 
from travel_introduction_post
where member_id = (select r.member_id
                   from (select member_id
                        from reply
                        group by member_id
                        order by count(*) desc) r
                    where ROWNUM=1);

--Type5
--5
select distinct a.nickname,a.birth
from member a
where exists(select * 
            from member b
            where to_char(a.Birth,'MM-DD') = to_char(b.Birth,'MM-DD')
            and a.member_id != b.member_id)
order by to_char(a.Birth,'MM-DD');

--6
select m.e_mail
from member m
where exists (select *
	        from travel_introduction_post ip
	        where ip.member_id = m.member_id)
and m.gender = 'F';

--7(not exist)
select l.Contenient, l.nation
from Location l
where not exists(select *
                from ITR_CONTAIN i
                where i.location_id=l.location_id);


--Type6
--8
select c.post_id ,c.location_id, p.Title
from TRAVEL_COMPANION_POST p, CPN_CONTAIN c
where p.post_id = c.post_id
and c.location_id IN(select location_id
                    from LOCATION
                    where Contenient = '아프리카')
order by c.post_id;

--9
select c.post_id, c.location_id
from cpn_contain c
where c.post_id in (select p.post_id
	                from travel_companion_post p
	                where c.post_id = p.post_id
	                and p.state = '진행')
order by c.location_id ASC;

--10
SELECT Title, Travel_period, Cost
FROM TRAVEL_INTRODUCTION_POST
WHERE Content_text LIKE '%한국%' AND Travel_period IN ('3박4일','15박16일','12박13일');

--Type7
--11
select nickname, num
from (select nickname,count(*) as num
    from member natural join real_time_chat
    group by (nickname)
    order by count(*) desc, nickname asc)
where ROWNUM<=1;

--12
with popular_post as
    (select post_id
    from like_post
    group by post_id
    having count(*) >= 4)
select ap.post_id, count(*) as refused
from application_info ap, popular_post p
where ap.post_id = p.post_id
and ap.request_state = '거절'
group by ap.post_id;

--13
WITH person AS
    (SELECT Member_id
    FROM TRAVEL_COMPANION_POST
    WHERE Nationality_condition='무관' AND State='진행' AND Gender_condition='남')
SELECT M.Birth,M.Gender,M.Self_introdution,M.Nickname
FROM MEMBER M, person N
WHERE M.Member_id=N.Member_id;


--Type8
--14
select m.member_id, c.post_id as companion, i.post_id as introduction
from member m, travel_companion_post c, travel_introduction_post i
where i.member_id = m.member_id
and c.member_id = m.member_id
order by m.member_id asc;

--15
select l.Contenient, l.nation, count(*) as travel_cnt
from location l, cpn_contain c, application_info a, travel_companion_post t
where c.location_id = l.location_id
and t.post_id = c.post_id
and a.post_id = t.post_id
and a.request_state='수락'
group by l.Contenient, l.nation
order by count(*) desc;

--16
SELECT M.Nickname,I.Title,I.Content_text,I.Travel_date,I.Travel_period,I.Cost,R.Content
FROM MEMBER M,TRAVEL_INTRODUCTION_POST I,REPLY R 
WHERE I.Member_id=M.Member_id 
AND R.post_id=I.post_id 
AND I.Content_text LIKE ('%프랑스%') 
ORDER BY I.Travel_date DESC;

--Type9
--17
select m.Nickname, m.Birth, count(*) as post_num
from MEMBER m, TRAVEL_COMPANION_POST c,TRAVEL_INTRODUCTION_POST i
where m.member_id = c.member_id
and m.member_id=i.member_id
and m.Birth > '2000-01-01'
group by m.Nickname, m.Birth
order by count(*);

--18
select l.nation, count(*)
from travel_companion_post p, cpn_contain c, location l
where c.post_id = p.post_id
and c.location_id = l.location_id
and p.creation_time < TIMESTAMP '2020-01-01 00:00:00'
group by l.nation
order by l.nation asc;

--19
SELECT M.Member_id, COUNT(*) AS Number_of_Post
FROM TRAVEL_COMPANION_POST T,TRAVEL_INTRODUCTION_POST I, MEMBER M
WHERE T.Member_id=M.Member_id AND I.Member_id=M.Member_id
GROUP BY M.Member_id
HAVING COUNT(*) >=5
ORDER BY Number_of_Post;

--Type10
--20
select m.nickname
from member m
where exists((select p.post_id
            from LIKE_POST p
            where m.member_id = p.member_id)
            INTERSECT
            (select a.post_id
            from application_info a
            where m.member_id = a.member_id));

--21
select member_id
from member
where member_id in(
    (select member_id
    from scrap
    group by member_id
    having count(*) >=4)
    minus
    (select member_id
    from reply
    group by member_id
    having count(*) < 4));