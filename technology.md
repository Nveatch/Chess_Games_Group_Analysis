# Technologies Used

## Data Cleaning and Analysis

Excess columns were initially removed from the dataset using Microsoft Excel. The features of our model are made up of qualitative data describing moves made during games of chess, so we will convert each unique move to a unique numerical value using Python and save the preprocessed data in a Pandas dataframe. We will then scale the unique numerical values down to a range between 0 and 1 using MinMaxScaler to be used in our machine learning model.

## Database Storage

The data will be stored in a postgres SQL database in pgAdmin. Each group member will have identical databases saved locally to ensure continuity.

## Machine Learning

We will use the SciKitLearn library to access machine learning models, and we will employ a neural network during our analysis.

## Dashboard

We will use Tableau to visualize the outcomes of our machine learning model.