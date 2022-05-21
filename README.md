# Chess Games Group Analysis

## Introduction

### Google Slides Link
https://docs.google.com/presentation/d/11254LDzm-sruI4YHZSqMZERHI9sCBM5osHUTU64EaXw/edit?usp=sharing

### Purpose
The purpose of our analysis was to use statistical and machine learning analysis on a large dataset of chess games, in order to answer broad questions about how the games of chess is generally played. It was our hope that the answers to these questions could be applied to our own chess games, and thus make us better players. As chess is ultimately a game of pattern recognition, looking for commonalities in positions you've seen before in order to win the game, it made sense to us to pick this as our topic, because machine learning excels at detecting patterns and trends in data at the macroscopic scale.

### Statistical Analysis Questions
1. What is the probability of win/lose/draw by color, and does that change by rating bracket?
    
2. What are your chances of winning based on ELO difference, for both white and black? Does that change per bracket?
    
3. What is the most commmon opening overall, and by ELO bracket?

4. What opening has the highest win chance by color and by ELO bracket?

5. By ELO bracket, what is the average number of games needed to improve?

### Machine Learning Question
1. Does the opening matter? If an opening is defined by the first 5 moves, can an ML model predict (*with a high degree of accuracy) a winner from a color's first five moves?

### Technologies

## Outline of Project

### I: Find Raw Datasets
For our analysis we used 2 different chess datasets sourced from Kaggle:

1. Games.csv: A random assortment of ~20,000 games played by chess teams on the chess website lichess.com, pulled via the Lichess API (https://www.kaggle.com/datasets/datasnaek/chess)

    -The following columns will be used for statistical analysis:
        
        -Turns: The number of moves played
        
        -Winner: Who won the game

        -White/Black_id: The ID of the player for the respective side

        -White/Black_ELO: The ELO rankings for the white and black players

        -Opening_eco: The generic ECO code for the opening

        -Opening_name: The specific name of the opening
    

    -The columns that will be used for the ML analysis are:

        -Winner: game result (as our labels)

        -Moves: Movements in the game (as our features)


2. Chess_games.csv: A collection of 6.25 million chess games played on lichess.org during July of 2016 (https://www.kaggle.com/datasets/arevel/chess-games)

    -We will be randomly sampling 1 million rows off of this table, to reduce the computational power needed to complete our analysis. We believe this sample size will still be sufficiently large to draw our conclusion
    
    -The following columns will be used for statistical analysis

        -Turns: Number of moves played (to be derived from the move list "AN")

        -Result: Who won the game

        -White/Black: The ID of the player for the respective side

        -White/BlackElo: The ELO rankings for the white and black players

        -White/BlackRatingDiff: The rating difference between the two players

        -ECO: The generic ECO code for the opening

        -Opening: The specific name of the opening


    -The columns that will be used for the ML analysis are:

        -Result: Game result (as our labels)

        -AN: Movements in the game (as our features)


 ### II. Build Custom Tables
 We made two additional tables (in csv format) to be used to answer our questions:

 1. Chess_titles.csv: A list of chess titles by ELO rating, from the FIDE (International Chess Federation) handbook (https://handbook.fide.com/chapter/B012022)
    
    -We used this table to determine each player's title from their rating in the raw datasets, in order to answer the "by ELO bracket" parts of our questions. It has two columns:
        
        -ELO_rating: the numerical rating, ranging from 0 to 3000

        -Title: The player title associated with each numerical rating


 2. Chess_openings.csv: A simplified version of chess openings by ECO (Encyclopedia of Chess Openings) code, with opening variations renamed as their parent opening (https://www.365chess.com/eco.php)

    -We used this table to determine both the most common openings, and the openings with the highest win rate, as per our questions. As there is very little difference between variations, we felt it was acceptable to group the variations together, in order to get more generalizable answers to our questions. In addition, some variations don't even have their own unique ECO code, so the data by its very nature already has some opening grouping.

    -The table has two columns:

        -ECO_code: The opening ECO code, with a letter prefix (A through E) and two digit number (00 through 99), resulting in 500 possible codes

        -ECO_title: The name of the opening associated with that ECO code, with variations being changed to their parent name(ex. B28 (Sicilian Defense, O'Kelly Variation) is changed to match the parent opening B20 (Sicilian Defense))


### III. Raw Table Preprocessing (Data Exploration)

* Duplicate rows removed from datasets

* Rows (games) missing move information or player ratings removed from datasets

* Chess_games.csv randomly sampled for 1 million rows

* "Winner"/"Result" columns standardized to use same format (White, Black, or Draw)

* Game date and time standardized for both datasets

* Game moves cleaned up, removing turn numbers and in-line chess engine evaluations

* Columns other than the ones listed above dropped from datasets (aside from game date, which is kept for indexing purposes)

* Similar columns in both tables renamed to match each other

### IV: Build the Database

* Chess, chess_games, and chess titles imported into PostgreSQL relational database

* Chess and chess_games merged to produce master games table (of all games) 

* Player data from master table joined with chess_titles table to make table of players with their rated titles

*  Master games table exported out of database into jupyter notebook to replace opening names with simplified names from chess_openings.csv, then imported back into database

### V: Build the Machine Learning Model

### VI: Build the Dashboard (Statistical Analysis/Data Analysis)

### VII: Presentation
* Results from machine learning model and statistical analysis put together on Google Slides presentation
