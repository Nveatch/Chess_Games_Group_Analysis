-- Creating White_Users Table and White_User_Titles thru joins

SELECT distinct on (white_id) white_id, white_rating, created_at
	into white_users
  FROM chess_data WHERE created_at IN (
    SELECT MAX(created_at)
      FROM chess_data GROUP BY white_id);
	  

select distinct white_id, white_rating, title
into white_user_titles
from white_users
  inner join chess_titles
on white_users.white_rating = chess_titles.elo_rating

select * from white_user_titles

-- Creating Black_Users Table and Black_User_Titles thru joins

SELECT distinct on (black_id) black_id, black_rating, created_at
	into black_users
  FROM chess_data WHERE created_at IN (
    SELECT MAX(created_at)
      FROM chess_data GROUP BY black_id);
	  

select distinct black_id, black_rating, title
into black_user_titles
from black_users
  inner join chess_titles
on black_users.black_rating = chess_titles.elo_rating

select * from black_user_titles