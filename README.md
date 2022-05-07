# Group_1_Final_Project

## Overview

### Purpose
The purpose of our analysis was to use statistical and machine learning analysis on a large dataset of chess games, in order to answer broad questions about how the games of chess is generally played. It was our hope that the answers to these questions could be applied to our own chess games, and thus make us better players.


### Datasets
For our analysis we used 3 different chess datasets sourced from Kaggle:

1. A random assortment of ~20,000 games played by chess teams on the chess website lichess.com, pulled via the Lichess API

2. A collection of 6.25 million chess games played on lichess.org during July of 2016

3. A collection of 3.5 million chess games stored in the chess database ChessDB, with dates ranging from the late 1700s to the early 2000s

These datasets contain information on when the games were played, the identity and ratings of the players, the final result, and the moves played by each side.

## Big Picture Question: Can data analytics be used to make you a better chess player?

### Statistical Analysis Questions
1. What is the probability of win/lose/draw by color, and does that change by rating bracket?
    
    -Subset dfs by color and score ("white" and "win"), then #rows/total

    -Same thing for rating bracket, but also subset by rating bracket grouping

2. What is the average number of turns for a win or loss, by color, by bracket?
    
    -Subset df by color/result/bracket, then take avg

3. What are your chances of winning based on ELO difference, for both white and black? Does that change per bracket?
    
    -group table by ELO difference brackets (0-10, 10-30, 30-50, 50+), then calculate win chance 

4. What is the most commmon opening overall, and by ELO bracket?

    -overall: value counts opening column
    
    -by ELO bracket: value counts on ELO bracket subset dfs

5. What opening has the highest win chance by color and by ELO bracket?
    
    -by color: split df into white_win and black_win dfs, then value counts on opening column
    
    -by ELO bracket: split df into 4 rating dfs, then do same as by color
    
    -Was going to do overall as well, but I think that would be the same as "by color", as every game has a winner/loser for that opening 

6. By ELO bracket, what is the average number of games needed to improve?
    
    -Take rating bracket tables, look for duplicate usernames, then sortby date (avg(user_games/time/rating difference))


### Machine Learning Questions
1. Does the opening matter? If an opening is defined by the first 5 moves, can an ML model predict (*with a high degree of accuracy) a winner from a color's first five moves?
    
    -Variables: White move 1, black move 1, white move 2, black move 2, .......... white move 5, black move 5
    
    -Labels: Win, lose, or draw (0,1, or 1/2)

2. How predictable are chess players? Can an ML model guess accurately a players 11th move based on their first ten? Does that change with color or bracket?
    
    -Variables: White/black moves 1-10
    
    -Label: 11th move

3. Given an opening, player color, player rating, player rating difference, and number of moves, can a winner be predicted with an ML model?
    
    -Variables: Opening, player color, player rating, player rating difference, # of moves
    
    -Labels: Win, lose, or draw (0,1, or 1/2)