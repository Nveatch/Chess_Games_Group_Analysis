--Creating DB called "lichess_data" DB in pgAdmin
-- Import the data in pdAdmin from chess_archive.csv

CREATE TABLE chess_archive_data (

date VARCHAR,
score VARCHAR,
white_rating VARCHAR,
black_rating VARCHAR, 
turns VARCHAR,
moves VARCHAR
);