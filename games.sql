--Creating DB called "lichess_data" DB in pgAdmin
-- Import the data in pdAdmin from games.csv
CREATE TABLE games (
     
id VARCHAR NOT NULL,
rated VARCHAR,
created_at VARCHAR,
last_move_at VARCHAR,
turns VARCHAR,
victory_status VARCHAR,
winner VARCHAR,
increment_code VARCHAR,
white_id VARCHAR,
white_rating VARCHAR,
black_id VARCHAR,
black_rating VARCHAR,
moves VARCHAR,
opening_eco VARCHAR,
opening_name VARCHAR,
opening_ply VARCHAR,
PRIMARY KEY (id)
     
);