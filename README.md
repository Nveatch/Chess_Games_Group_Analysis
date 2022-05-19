# Chess Games Group Analysis

## Overview

### Google Slides Link
https://docs.google.com/presentation/d/11254LDzm-sruI4YHZSqMZERHI9sCBM5osHUTU64EaXw/edit?usp=sharing

### Purpose
The purpose of our analysis was to use statistical and machine learning analysis on a large dataset of chess games, in order to answer broad questions about how the games of chess is generally played. It was our hope that the answers to these questions could be applied to our own chess games, and thus make us better players. As chess is ultimately a game of pattern recognition, looking for commonalities in positions you've seen before in order to win the game, it made sense to us to pick this as our topic, because machine learning excels at detecting patterns and trends in data at the macroscopic scale.

### Workflow Outline
1. Raw datasets downloaded and imported into jupyter notebook

2. Chess_games.csv randomly sampled for 1 million rows

3. Datasets modified to remove un-needed columns, and columns renamed to mirror each other

4. Datasets were cleaned up, through processes such as removing unnecessary info from "moves" column, and converting date and time columns to datetime

5. Datasets exported to PgAdmin database

6. In PgAdmin, datasets merged into one table

7. Dataset imported into Tableau to answer statistical analysis questions/create visualizations

8. Dataset imported back into jupyter notebook to perform machine learning analysis

9. Visualizations from Tableau combined with machine learning analysis on google slides for final presentation

## Datasets
For our analysis we used 3 different chess datasets sourced from Kaggle:

1. A random assortment of ~20,000 games played by chess teams on the chess website lichess.com, pulled via the Lichess API

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



2. A collection of 6.25 million chess games played on lichess.org during July of 2016
    
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
    

    -We will be randomly sampling 1 million rows off of this table, to reduce the computational power needed to complete our analysis. We believe this sample size will still be sufficiently large to draw our conclusion


### Statistical Analysis Questions
1. What is the probability of win/lose/draw by color, and does that change by rating bracket?
    
2. What are your chances of winning based on ELO difference, for both white and black? Does that change per bracket?
    
3. What is the most commmon opening overall, and by ELO bracket?

4. What opening has the highest win chance by color and by ELO bracket?

5. By ELO bracket, what is the average number of games needed to improve?
    
### Machine Learning Question
1. Does the opening matter? If an opening is defined by the first 5 moves, can an ML model predict (*with a high degree of accuracy) a winner from a color's first five moves?
     
## Dataset Links
1. https://www.kaggle.com/datasets/datasnaek/chess

2. https://www.kaggle.com/datasets/arevel/chess-games
