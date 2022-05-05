--Creating DB called "lichess_data" DB in pgAdmin


CREATE TABLE lichess_games_data (

Event VARCHAR,
white_id VARCHAR,
black_id VARCHAR,
Result VARCHAR,
UTCDate VARCHAR,
UTCTime VARCHAR,
white_rating VARCHAR,
black_rating VARCHAR,
WhiteRatingDiff VARCHAR,
BlackRatingDiff VARCHAR,
opening_eco VARCHAR,
opening_name VARCHAR,
TimeControl VARCHAR,
Termination VARCHAR,
moves VARCHAR
);