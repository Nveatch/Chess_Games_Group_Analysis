# Chess Games Group Analysis

### Google Slides Link
https://docs.google.com/presentation/d/11254LDzm-sruI4YHZSqMZERHI9sCBM5osHUTU64EaXw/edit?usp=sharing

### Dashboard Link
https://public.tableau.com/views/Lichess_Games_Data_Visualization_16534458112280/Chess_Games_Group_Analysis?:language=en-US&publish=yes&:display_count=n&:origin=viz_share_link

## Introduction

### Purpose
The purpose of our analysis was to use statistical and machine learning analysis on a large dataset of chess games, in order to answer broad questions about how the games of chess is generally played. It was our hope that the answers to these questions could be applied to our own chess games, and thus make us better players. As chess is ultimately a game of pattern recognition, looking for commonalities in positions you've seen before in order to win the game, it made sense to us to pick this as our topic, because machine learning excels at detecting patterns and trends in data at the macroscopic scale.

### Statistical Analysis Questions
1. What is the probability of win/lose/draw by color, and does that change by rating bracket?
    
2. What is the distribution of rated titles?
    
3. What is the most common opening overall, and by rated title?

4. What opening has the highest win chance by color?

5. What is the average number of games played per day for each rated title?

### Machine Learning Question
1. Does the opening matter? If an opening is defined by the first 5 moves, can a machine learning model predict (with a high degree of accuracy) a winner from a color's first five moves?

### Technologies
* **Languages**: Python, SQL
* **Database**: PostgreSQL
* **Database Interface**: PgAdmin 4
* **Preprocessing**: Jupyter notebook, Pandas
* **Dashboard**: Tableau
* **Visualizations**: Tableau
* **Presentation**: Google Slides
* **Machine learning**: Tensorflow library with jupyter notebook
* **Custom Tables**: Excel

## Outline of Project

### I: Find Raw Datasets
For our analysis we used 2 different chess datasets sourced from Kaggle:

**Games.csv:** A random assortment of ~20,000 games played by chess teams on the chess website lichess.com, pulled via the Lichess API (https://www.kaggle.com/datasets/datasnaek/chess). The following columns will be used for statistical analysis:
* **Turns:** The number of moves played
* **Winner:** Who won the game
* **White/Black_id:** The ID of the player for the respective side
* **White/Black_ELO:** The ELO rankings for the white and black players
* **Opening_eco:** The generic ECO code for the opening
* **Opening_name:** The specific name of the opening
    
The following columns will be used for the machine learning analysis:
* **Winner:** game result (as our labels)
* **Moves:** Movements in the game (as our features)

**Chess_games.csv:** A collection of 6.25 million chess games played on lichess.org during July of 2016 (https://www.kaggle.com/datasets/arevel/chess-games). We will be randomly sampling 1 million rows off of this table to reduce the computational power needed to complete our analysis. We believe this sample size will still be sufficiently large to draw our conclusion. The following columns will be used for statistical analysis:
* **Turns**: Number of moves played (to be derived from the move list "AN")
* **Result**: Who won the game
* **White/Black**: The ID of the player for the respective side
* **White/BlackElo**: The ELO rankings for the white and black players
* **BlackRatingDiff**: The rating difference between the two players
* **ECO**: The generic ECO code for the opening
* **Opening**: The specific name of the opening

The following columns will be used for the machine learning analysis:
* **Result**: Game result (as our labels)
* **AN**: Movements in the game (as our features)


 ### II. Build Custom Tables
 We made two additional tables (in csv format) to be used to answer our questions:

**Chess_titles.csv:** A list of chess titles by ELO rating, from the FIDE (International Chess Federation) handbook (https://handbook.fide.com/chapter/B012022). We used this table to determine each player's title from their rating in the raw datasets, in order to answer the "by ELO bracket" parts of our questions. It has two columns:
* **ELO_rating:** the numerical rating, ranging from 0 to 3000
* **Title:** The player title associated with each numerical rating

**Chess_openings.csv:** A simplified version of chess openings by ECO (Encyclopedia of Chess Openings) code, with opening variations renamed as their parent opening (https://www.365chess.com/eco.php). We used this table to determine both the most common openings, and the openings with the highest win rate, as per our questions. As there is very little difference between variations, we felt it was acceptable to group the variations together, in order to get more generalizable answers to our questions. In addition, some variations don't even have their own unique ECO code, so the data by its very nature already has some opening grouping. The table has two columns:
* **ECO_code**: The opening ECO code, with a letter prefix (A through E) and two digit number (00 through 99), resulting in 500 possible codes
* **ECO_title**: The name of the opening associated with that ECO code, with variations being changed to their parent name (ex. B28 (Sicilian Defense, O'Kelly Variation) is changed to match the parent opening B20 (Sicilian Defense))

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
![Static Database](https://github.com/Nveatch/Chess_Games_Group_Analysis/blob/main/SQL/static_data_in_database_proof.png)

### V: Build the Machine Learning Model

#### Machine Learning Model Design

**Model Choice**: Neural Network

**Benefits**:
* They excel at pattern recognition, and the game of chess is ultimately a game of pattern recognition, looking at a position for similarities to other games seen
* Openings are even more patternistic, as openings are just a pattern of moves, repeated at the beginning of every game. In addition, they don’t form a linear relationship with the outcome, and neural networks excel at analyzing non-linear relationships
* Neural networks work best with large datasets, and our dataset has 1 million+ games

**Limitations**:
* Neural networks have a high likelihood of overfitting to the training data, and thus losing accuracy when tested
    * In our case, an example of this would be if a common set of the first 3 moves won often, and thus the model leans towards all openings with those 3 moves resulting in a win. The trend however, is more sophisticated than that, and thus results in a loss of accuracy
    * To counter this, we’re using a large dataset, with the idea being that by providing the neural network with enough data, it won’t fall into that pitfall.

**Features:**
* White moves 1-5 (in chess notation)
* Black moves 1-5 (in chess notation)

**Labels:**
* The result of the game

**Data-Split:** 75% training, 25% testing, using train_test_split from Python’s sklearn library (sklearn.model_selection)

#### Feature Engineering for Machine Learning Model
To answer our question, we needed to get the opening moves from our dataset (our features). Our features were already in their own column (“moves”), but some transformation work was needed. The special symbols used in chess notation needed to be removed (ex.  “!” for a good move, “?” for a mistake), as for our analysis, we only care about the move itself, and thus want “e4” and “e4!” to be considered the same move. The first 10 moves were then split into their own columns, and labeled Wm1-Wm5 and Bm1-Bm5 (white and black moves 1-5,respectively). These columns were then separated into their own “moves” dataset.

We needed the winner of each game to use as our label. These values were also in their own column in the dataset (“result”), and thus just needed to be taken and added to the “moves” dataset (as “outcome”).

#### Standardization
Each unique move was assigned its own unique number for each feature column (ex. “E4” was 0, "D4" was 1, etc.), and our “result” label column was also transformed with a unique number for each result:
* 0: Draw
* 1: White Wins
* 2: Black wins

![ML Table](https://github.com/Nveatch/Chess_Games_Group_Analysis/blob/main/resources/ML_table.png)

#### Machine Learning Results

**Stage 1**

For the first stage of this analysis, we tried 6 models of varying parameters. The loss, accuracy scores, and parameters of our 6 models are shown below:

| Model | Loss | Accuracy | Parameters |
| :---- | :--- | :------- | :--------- |
| 1 | 0.6819 | 0.4983 | Sigmoid input with 5 nodes, sigmoid output, 5 epochs |
| 2 | 0.6922 | 0.4983 | Relu input with 5 nodes, sigmoid output, 5 epochs |
| 3 | 0.6819 | 0.4983 | Tanh input with 5 nodes, sigmoid output, 5 epochs |
| 4 | 0.6826 | 0.4983 | Sigmoid input with 5 nodes, linear output, 5 epochs |
| 5 | 6.5152 | 0.4983 | Relu input wiht 5 nodes, linear output, 5 epochs |
| 6 | 0.6820 | 0.4983 | Tanh input with 5 nodes, linear output, 5 epochs |

The accuracy score for all 6 models was identical at 0.4983. An accuracy score of exactly 0.5 is the probability of randomly guessing the correct winner of a given game of chess, so the accuracy score of our models may reflect the difficulty of predicting a winner from only the first 10 moves of a game. Since games typically last far longer than 10 turns and the possible combinations of moves grow increasingly complex, this is not a surprising conclusion.

Loss function, on the other hand, was not constant. The two models with relu inputs (Models 2 and 5) had the greatest loss score, indicating that the relu activation function is likely not the best choice for our model. Additionally, the models with sigmoid outputs (Models 1, 2, and 3) had lower loss functions than their counterpart models with linear outputs (Models 4, 5, and 6 respectively). This is expected, as output from a sigmoid function tends to be very close to either 0 or 1. We are posing a question with a binary answer, so a sigmoid function is the best choice for an activation function for our output layer.

Given this information, our course of action for the final steps of completing this model will be to explore more varied input layers. This will be accomplished by varying the activation function (using sigmoid and tanh, leaving relu out), number of layers, number of nodes within each layer, and number of epochs used to train the model. We hypothesize that the sigmoid activation function will be the more appropriate choice for the input layer(s) for the same reasons it is the best choice for the output layer.

**Stage 2**

The next step of our analysis was to determine whether adding an additional input layer would assist in lowering loss or raising accuracy in our model. The loss, accuracy, and parameters for Models 7-10 are shown below:

| Model | Loss | Accuracy | Parameters |
| :---- | :--- | :------- | :--------- |
| 7 | 0.6817 | 0.4983 | Two sigmoid input layers with 5 nodes each, sigmoid output, 5 epochs |
| 8 | 0.6919 | 0.4983 | Sigmoid first input layer and tanh second input layer with 5 nodes each, sigmoid output, 5 epochs |
| 9 | 0.6816 | 0.4983 | Tanh first input layer and sigmoid second input layer with 5 nodes each, sigmoid output, 5 epochs |
| 10 | 0.6817 | 0.4983 | Two tanh input layers with 5 nodes each, sigmoid output, 5 epochs |

Accuracy continued to remain constant across all models, even when an additional input layer was added. Loss varied slightly, but not to a significant extent; the greatest difference in loss between the best models from Stage 1 and Stage 2 was 0.0003. As such, we can conclude that adding a second input layer is not likely to significantly improve the ability of our machine learning model to predict the winner of a chess game from the first 10 moves. Additionally, we cannot draw any further conclusions regarding the efficacy of the sigmoid and tanh activation functions in input layers given the very similar results between the two.

**Stage 3**

To determine whether the number of nodes affected the performance of our models, we ran single-layer models with varied numbers of nodes. The loss, accuracy, and parameters for Models 11-14 (as well as Models 1 and 3 for comparison) are shown below:

| Model | Loss | Accuracy | Parameters |
| :---- | :--- | :------- | :--------- |
| 1 | 0.6819 | 0.4983 | Sigmoid input with 5 nodes, sigmoid output, 5 epochs |
| 11 | 0.6817 | 0.4983 | Sigmoid input with 2 nodes, sigmoid output, 5 epochs |
| 12 | 0.6817 | 0.4984 | Sigmoid input with 8 nodes, sigmoid output, 5 epochs |
| 3 | 0.6818 | 0.4983 | Tanh input with 5 nodes, sigmoid output, 5 epochs |
| 13 | 0.6818 | 0.4983 | Tanh input with 2 nodes, sigmoid output, 5 epochs |
| 14 | 0.6818 | 0.4983 | Tanh input with 8 nodes, sigmoid output, 5 epochs |

Once again, loss and accuracy are more or less uniform. Model 12 is the first to show an accuracy score different from any other model, but a difference of 0.0001 is not significant. Given the results of Stage 3, we are unable to attribute number of nodes to model performance. Sigmoid and tanh input layers also continue to show no appreciable difference.

**Stage 4**

Finally, we tested the effect of number of epochs on model performance. The loss, accuracy, and parameters for Models 15-18 (as well as Models 1 and 3 for comparison) are shown below:

| Model | Loss | Accuracy | Parameters |
| :---- | :--- | :------- | :--------- |
| 1 | 0.6819 | 0.4983 | Sigmoid input with 5 nodes, sigmoid output, 5 epochs |
| 15 | 0.6817 | 0.4983 | Sigmoid input with 5 nodes, sigmoid output, 2 epochs |
| 16 | 0.6816 | 0.4983 | Sigmoid input with 5 nodes, sigmoid output, 10 epochs |
| 3 | 0.6818 | 0.4983 | Tanh input with 5 nodes, sigmoid output, 5 epochs |
| 17 | 0.6819 | 0.4983 | Tanh input with 5 nodes, sigmoid output, 2 epochs |
| 18 | 0.6818 | 0.4983 | Tanh input with 5 nodes, sigmoid output, 10 epochs |

As with all other parameters, adjusting the number of epochs had little to no impact on the performance of our machine learning models. Input function continued to show no impact as well.

**Conclusions**

For reference, the loss, accuracy, and parameters for all models are shown again below:

| Model | Loss | Accuracy | Parameters |
| :---- | :--- | :------- | :--------- |
| 1 | 0.6819 | 0.4983 | Sigmoid input with 5 nodes, sigmoid output, 5 epochs |
| 2 | 0.6922 | 0.4983 | Relu input with 5 nodes, sigmoid output, 5 epochs |
| 3 | 0.6819 | 0.4983 | Tanh input with 5 nodes, sigmoid output, 5 epochs |
| 4 | 0.6826 | 0.4983 | Sigmoid input with 5 nodes, linear output, 5 epochs |
| 5 | 6.5152 | 0.4983 | Relu input wiht 5 nodes, linear output, 5 epochs |
| 6 | 0.6820 | 0.4983 | Tanh input with 5 nodes, linear output, 5 epochs |
| 7 | 0.6817 | 0.4983 | Two sigmoid input layers with 5 nodes each, sigmoid output, 5 epochs |
| 8 | 0.6919 | 0.4983 | Sigmoid first input layer and tanh second input layer with 5 nodes each, sigmoid output, 5 epochs |
| 9 | 0.6816 | 0.4983 | Tanh first input layer and sigmoid second input layer with 5 nodes each, sigmoid output, 5 epochs |
| 10 | 0.6817 | 0.4983 | Two tanh input layers with 5 nodes each, sigmoid output, 5 epochs |
| 11 | 0.6817 | 0.4983 | Sigmoid input with 2 nodes, sigmoid output, 5 epochs |
| 12 | 0.6817 | 0.4984 | Sigmoid input with 8 nodes, sigmoid output, 5 epochs |
| 13 | 0.6818 | 0.4983 | Tanh input with 2 nodes, sigmoid output, 5 epochs |
| 14 | 0.6818 | 0.4983 | Tanh input with 8 nodes, sigmoid output, 5 epochs |
| 15 | 0.6817 | 0.4983 | Sigmoid input with 5 nodes, sigmoid output, 2 epochs |
| 16 | 0.6816 | 0.4983 | Sigmoid input with 5 nodes, sigmoid output, 10 epochs |
| 17 | 0.6819 | 0.4983 | Tanh input with 5 nodes, sigmoid output, 2 epochs |
| 18 | 0.6818 | 0.4983 | Tanh input with 5 nodes, sigmoid output, 10 epochs |

All four stages of this analysis showed that varying the parameters of our machine learning model had virtually no impact on both loss and accuracy. We were only able to draw conclusions regarding two of the five parameters examined: ruling out relu as an activation function and determining that sigmoid is the most appropriate output function. No conclusive evidence was found for the other three parameters. A summary of results can be found in the table below:

| Parameter | Findings |
| :---- | :--- | 
| Activation function | Relu ruled out, no evidence that either sigmoid or tanh is better than the other |
| Output function | Sigmoid deemed better than linear |
| Number of layers | No evidence that either 1 layer or 2 layers is better than the other |
| Number of nodes | No evidence that any of 2, 5, or 8 nodes is better than the others |
| Number of epochs | No evidence that any of 2, 5, or 10 epochs is better than the others |

All in all, the results of this study point to neural networks not being an effective means of predicting the winner of a game of chess given the first 10 moves. We supposed this was the case following the Stage 1 analysis, and Stages 2-4 supported the hypothesis. We cannot conclusively say that a neural network is entirely ineffective when trying to answer the question posed in this project since there are still many more combinations of parameters that could be tested, but the 18 models we examined gave us little reason to believe this is a path worth following.

As previously stated, chess is a complex game. The possible outcomes are difficult to map as each individual move begets an exponentially branching tree of possibilities. Since games of chess tend to last far longer than 10 turns, our analysis is only able to scratch the surface. We were limited by a number of factors, most notably time and computing power. In theory, we could have extended our analysis far past the first 10 turns. However, adding an extra turn creates another branch on the tree and multiplies the number of computations necessary to perform this analysis. As such, we decided to examine whether determining a winner given 10 turns is possible with resources accessible to a wider range of people. Since accuracy scores remained very close to the probability of guessing a winner entirely at random throughout the entire project, the ultimate answer to our question is negative.

**Future Analysis**

The only type of machine learning used in this project was a neural network. While this method proved ineffective, other types of machine learning may be more useful in answering our question. For example, the flow of a game of chess closely mimics a quickly branching set of choices ultimately culminating in a winner. A decision tree may be an interesting way to map out chess games, though said tree would have to be almost impossibly large to accurately capture every possible combination of moves in a game of chess.

Principal Component Analysis could possibly be used to incorporate more than 10 turns into the study without the number of input features reaching a problematically large number. This may be difficult given the qualitative nature of our input data, but it is an avenue to be explored.

Finally, a repetition of our analysis with more input features could be performed given more time and access to faster computing. It is not realistic for a student using a personal computer to perform this analysis with the first 50 turns of a game of chess using a sufficiently large dataset since it would likely take too long and use up too many resources, but given enough time and computing power, this could either corroborate our conclusions or show that neural networks may be viable solution after all.

### VI: Build the Dashboard (Statistical Analysis/Data Analysis)

#### Tableau Dashboard Link
https://public.tableau.com/views/Lichess_Games_Data_Visualization_16534458112280/Chess_Games_Group_Analysis?:language=en-US&publish=yes&:display_count=n&:origin=viz_share_link

#### Database to Tableau Preprocessing
* Master table of chess games reduced to games where both players are the same general title (novice, amateur, master, grandmaster), for use in opening visualizations by rating) (~800k games) (**chess_data_tableau.csv**)
* Unique list of chess users created from database, and combined with titles from chess_titles.csv (~110k users) (**chess_users_tableau.csv**)
* Chess users list reduced to users with all their games in the same month, then grouped by title for games/day analysis (~105k users) (**daily_games_tableau.csv**)

#### Statistical Analysis/Results
1. **What is the probability of win/lose/draw by color, and does that change by rating bracket?**     
White is favored to win at all rating levels with an average ~4% lead, though at the GM level, the difference decreases significantly to <1%, and draw percentage jumps to 7%  
![Win Percentage by Color](https://github.com/Nveatch/Chess_Games_Group_Analysis/blob/main/resources/wins_by_color.png)

2. **What is the distribution of rated titles?**  
![Title Distribution](https://github.com/Nveatch/Chess_Games_Group_Analysis/blob/main/resources/title_distribution.png)

3. **What is the most commmon opening overall, and by rated title?**  
The top 5 most common openings overall (in order) are the Queen's Pawn Game, Sicilian Defense, King's Pawn Game, French Defense, and the Polish Opening. While the order changes around depending on the player rating group (novice, amateur, master, grandmaster), the top 5 remain the same.  
![Opening Frequency](https://github.com/Nveatch/Chess_Games_Group_Analysis/blob/main/resources/opening_frequency.png)

4. **What opening has the highest win chance by color?**  
For black:  
![Best Openings for Black](https://github.com/Nveatch/Chess_Games_Group_Analysis/blob/main/resources/black_best_openings.png)  
For white:  
![Best Openings for White](https://github.com/Nveatch/Chess_Games_Group_Analysis/blob/main/resources/white_best_openings.png)

5. **What is the average number of games played per day for each rated title?**  
The games per day increase as rating increases, going from <1 game per day for novices, and just over 2 games per day.  
![Games per Day per Title](https://github.com/Nveatch/Chess_Games_Group_Analysis/blob/main/resources/games_per_day.png)

### VII: Presentation

Results from machine learning model and statistical analysis put together on Google Slides presentation linked below.

#### Link to slides:
https://docs.google.com/presentation/d/11254LDzm-sruI4YHZSqMZERHI9sCBM5osHUTU64EaXw/edit?usp=sharing

