# Chess Games Group Analysis

## Overview

### Purpose
The purpose of our analysis was to use statistical and machine learning analysis on a large dataset of chess games, in order to answer broad questions about how the games of chess is generally played. It was our hope that the answers to these questions could be applied to our own chess games, and thus make us better players. As chess is ultimately a game of pattern recognition, looking for commonalities in positions you've seen before in order to win the game, it made sense to us to use machine learning to do our analysis, as it excels at detecting patterns and trends in data at the macroscopic scale.

### Datasets
For our analysis we used 3 different chess datasets sourced from Kaggle:

1. A random assortment of ~20,000 games played by chess teams on the chess website lichess.com, pulled via the Lichess API

2. A collection of 6.25 million chess games played on lichess.org during July of 2016

3. A collection of 3.5 million chess games stored in the chess database ChessDB, with dates ranging from the late 1700s to the early 2000s

These datasets contain information on when the games were played, the identity and ratings of the players, the final result, and the moves played by each side.

### Statistical Analysis Questions
1. What is the probability of win/lose/draw by color, and does that change by rating bracket?
    
2. What are your chances of winning based on ELO difference, for both white and black? Does that change per bracket?
    
3. What is the most commmon opening overall, and by ELO bracket?

4. What opening has the highest win chance by color and by ELO bracket?

5. By ELO bracket, what is the average number of games needed to improve?
    
### Machine Learning Questions
1. Does the opening matter? If an opening is defined by the first 5 moves, can an ML model predict (*with a high degree of accuracy) a winner from a color's first five moves?
    
2. Given an opening, player color, player rating, player rating difference, and number of moves, can a winner be predicted with an ML model?
 
## Dataset References
1. https://www.kaggle.com/datasets/datasnaek/chess

2. https://www.kaggle.com/datasets/arevel/chess-games

3. https://www.kaggle.com/datasets/milesh1/35-million-chess-games
