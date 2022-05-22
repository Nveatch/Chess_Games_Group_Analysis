# Chess Games Group Analysis

### Google Slides Link
https://docs.google.com/presentation/d/11254LDzm-sruI4YHZSqMZERHI9sCBM5osHUTU64EaXw/edit?usp=sharing

### Dashboard Link
https://public.tableau.com/app/profile/ravi7215/viz/Lichess_Games_Data_Visualization/Lichess_Games_Data_Visualization?publish=yes

## Introduction

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

Languages: Python, SQL

Database: PostgreSQL

Database Interface: PgAdmin 4

Preprocessing: Jupyter notebook, Pandas

Dashboard: Tableau

Visualizations: Tableau

Presentation: Google Slides

ML: Tensorflow library with jupyter notebook

Custom Tables: Excel

## Outline of Project

### I: Find Raw Datasets
For our analysis we used 2 different chess datasets sourced from Kaggle:

1. **Games.csv:** A random assortment of ~20,000 games played by chess teams on the chess website lichess.com, pulled via the Lichess API (https://www.kaggle.com/datasets/datasnaek/chess)

    -The following columns will be used for statistical analysis:
        
        -**Turns:** The number of moves played
        
        -**Winner:** Who won the game

        -**White/Black_id:** The ID of the player for the respective side

        -**White/Black_ELO:** The ELO rankings for the white and black players

        -**Opening_eco:** The generic ECO code for the opening

        -**Opening_name:** The specific name of the opening
    

    -The columns that will be used for the ML analysis are:

        -**Winner:** game result (as our labels)

        -**Moves:** Movements in the game (as our features)


2. **Chess_games.csv:** A collection of 6.25 million chess games played on lichess.org during July of 2016 (https://www.kaggle.com/datasets/arevel/chess-games)

    -We will be randomly sampling 1 million rows off of this table, to reduce the computational power needed to complete our analysis. We believe this sample size will still be sufficiently large to draw our conclusion
    
    -The following columns will be used for statistical analysis

        -Turns: Number of moves played (to be derived from the move list "AN")

        -Result: Who won the game

        -White/Black: The ID of the player for the respective side

        -White/BlackElo: The ELO rankings for the white and black players

        -*/BlackRatingDiff: The rating difference between the two players

        -ECO: The generic ECO code for the opening

        -Opening: The specific name of the opening


    -The columns that will be used for the ML analysis are:

        -Result: Game result (as our labels)

        -AN: Movements in the game (as our features)


 ### II. Build Custom Tables
 We made two additional tables (in csv format) to be used to answer our questions:

 1. **Chess_titles.csv:** A list of chess titles by ELO rating, from the FIDE (International Chess Federation) handbook (https://handbook.fide.com/chapter/B012022)
    
    -We used this table to determine each player's title from their rating in the raw datasets, in order to answer the "by ELO bracket" parts of our questions. It has two columns:
        
        -**ELO_rating:** the numerical rating, ranging from 0 to 3000

        -**Title:** The player title associated with each numerical rating


 2. **Chess_openings.csv:** A simplified version of chess openings by ECO (Encyclopedia of Chess Openings) code, with opening variations renamed as their parent opening (https://www.365chess.com/eco.php)

    -We used this table to determine both the most common openings, and the openings with the highest win rate, as per our questions. As there is very little difference between variations, we felt it was acceptable to group the variations together, in order to get more generalizable answers to our questions. In addition, some variations don't even have their own unique ECO code, so the data by its very nature already has some opening grouping.

    -The table has two columns:

        -ECO_code: The opening ECO code, with a letter prefix (A through E) and two digit number (00 through 99), resulting in 500 possible codes

        -ECO_title:*The name of the opening associated with that ECO code, with variations being changed to their parent name(ex. B28 (Sicilian Defense, O'Kelly Variation) is changed to match the parent opening B20 (Sicilian Defense))


### III. Raw Table Preprocessing (Data Exploration)

* Duplicate rows removed from datasets

* Rows (games) missing move information or player ratings removed from datasets

* **Chess_games.csv** randomly sampled for 1 million rows

* "Winner"/"Result" columns standardized to use same format (White, Black, or Draw)

* Game date and time standardized for both datasets

* Game moves cleaned up, removing turn numbers and in-line chess engine evaluations

* Columns other than the ones listed above dropped from datasets (aside from game date, which is kept for indexing purposes)

* Similar columns in both tables renamed to match each other

### IV: Build the Database

* **Chess**, **chess_games**, and **chess_titles** imported into PostgreSQL relational database

* **Chess** and **chess_games** merged to produce master **games** table (of all games) 

* Player data from master **games** table joined with **chess_titles** table to make **player_titles** table, for use in answering statistical analysis questions (player_id/player_rating/player_title)

*  Master **games** table exported out of database into jupyter notebook to replace opening names with simplified names from **chess_openings.csv**, as well as to remove rows without a winner, then imported back into database

### V: Build the Machine Learning (ML) Model

#### ML Model Design

**Model Choice**: Neural Network

**Benefits**:

-They excel at pattern recognition, and the game of chess is ultimately a game of pattern recognition, looking at a position for similarities to other games seen

-Openings are even more patternistic, as openings are just a pattern of moves, repeated at the beginning of every game. In addition, they don’t form a linear relationship with the outcome, and neural networks excel at analyzing non-linear relationships 

-Neural networks work best with large datasets, and our dataset has 1 million+ games

**Limitations**:

-Neural networks have a high likelihood of overfitting to the training data, and thus losing accuracy when tested

    -In our case, an example of this would be if a common set of the first 3 moves won often, and thus the model leans towards all openings with those 3 moves resulting in a win. The trend however, is more sophisticated than that, and thus results in a loss of accuracy.

    -To counter this, we’re using a large dataset, with the idea being that by providing the neural network with enough data, it won’t fall into that pitfall.

**Features:**

-White moves 1-5, Black moves 1-5 (in chess notation)

**Labels:**
-The result of the game:
* 1-0: White Wins
* 0-1: Black Wins
* ½-½: Draw

**Data-Split:** 75% training, 25% testing, using train_test_split from python’s sklearn library (sklearn.model_selection)

#### Feature Engineering for ML Model
-To answer our question, we needed to get the opening moves from our dataset (our features):
    -Our features were already in their own column (“moves”), but some transformation work was needed: The special symbols used in chess notation needed to be removed (ex.  “!” for a good move, “?” for a mistake), as for our analysis, we only care about the move itself, and thus want “e4” and “e4!” to be considered the same move

    -The first 10 moves were then split into their own columns, and labeled Wm1-Wm5 and Bm1-Bm5 (white and black moves 1-5,respectively)

    -These columns were then separated into their own “moves” dataset

-We needed the winner of each game for our label:

    -Our labels were also in their own column in the dataset (“result”), and thus just needed to be taken and added to the “moves” dataset (as “outcome”)

#### Standardization
-Each unique move was assigned its own unique number for each feature column (ex. “E4” was 0, "D4" was 1, etc.), and our “result” label column was also transformed with a unique number for each result:
    - 0: Draw
    
    - 1: White Wins
    
    - 2: Black wins

![ML Table](https://github.com/Nveatch/Chess_Games_Group_Analysis/blob/main/resources/ML_table.png)

### ML Results
 Since our last submission, we have evaluated an additional 5 models for a total of 6. The loss, accuracy scores, and parameters of our 6 models are shown below:

 ![ML Results](https://github.com/Nveatch/Chess_Games_Group_Analysis/blob/main/resources/ML_results.png)

The accuracy score for all 6 models was identical at 0.4983. An accuracy score of exactly 0.5 is the probability of randomly guessing the correct winner of a given game of chess, so the accuracy score of our models may reflect the difficulty of predicting a winner from only the first 10 moves of a game. Since games typically last far longer than 10 turns and the possible combinations of moves grow increasingly complex, this is not a surprising conclusion.

Loss function, on the other hand, was not constant. The two models with relu inputs (Models 2 and 5) had the greatest loss score, indicating that the relu activation function is likely not the best choice for our model. Additionally, the models with sigmoid outputs (Models 1, 2, and 3) had lower loss functions than their counterpart models with linear outputs (Models 4, 5, and 6 respectively). This is expected, as output from a sigmoid function tends to be very close to either 0 or 1. We are posing a question with a binary answer, so a sigmoid function is the best choice for an activation function for our output layer.

Given this information, our course of action for the final steps of completing this model will be to explore more varied input layers. This will be accomplished by varying the activation function (using sigmoid and tanh, leaving relu out), number of layers, number of nodes within each layer, and number of epochs used to train the model. We hypothesize that the sigmoid activation function will be the more appropriate choice for the input layer(s) for the same reasons it is the best choice for the output layer.

### VI: Build the Dashboard (Statistical Analysis/Data Analysis)

* Master games table imported into Tableau, to answer statistical analysis questions and generate visualizations

* Tableau Link to visualizations: https://public.tableau.com/app/profile/ravi7215/viz/Lichess_Games_Data_Visualization/Lichess_Games_Data_Visualization?publish=yes

### VII: Presentation
* Results from machine learning model and statistical analysis put together on Google Slides presentation

* Link to slides: https://docs.google.com/presentation/d/11254LDzm-sruI4YHZSqMZERHI9sCBM5osHUTU64EaXw/edit?usp=sharing

