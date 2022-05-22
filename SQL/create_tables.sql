CREATE TABLE lichess_games_data (
     
id VARCHAR not null,
created_at timestamp,
turns VARCHAR,
winner VARCHAR,
white_id VARCHAR,
white_rating VARCHAR,
black_id VARCHAR,
black_rating VARCHAR,
rating_difference VARCHAR,
opening_eco VARCHAR,
opening_name VARCHAR,
moves VARCHAR,
PRIMARY KEY (id)
     
);


CREATE TABLE games (
     
id VARCHAR not null,
created_at timestamp,
turns VARCHAR,
winner VARCHAR,
white_id VARCHAR,
white_rating VARCHAR,
black_id VARCHAR,
black_rating VARCHAR,
rating_difference VARCHAR,
opening_eco VARCHAR,
opening_name VARCHAR,
moves VARCHAR,
PRIMARY KEY (id)
     
);

CREATE TABLE chess_titles(
elo_rating VARCHAR,
title VARCHAR

);