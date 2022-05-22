CREATE TABLE chess_data AS
(
SELECT * FROM games
UNION ALL
SELECT * FROM lichess_games_data);

CREATE TABLE user_titles AS
(
    select * from black_user_titles
    UNION ALL
    select * from white_user_titles
);
