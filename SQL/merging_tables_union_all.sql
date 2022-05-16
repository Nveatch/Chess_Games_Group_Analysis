CREATE TABLE chess_data AS
(
SELECT * FROM games
UNION ALL
SELECT * FROM lichess_games_data);