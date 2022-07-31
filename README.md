# ST558_Project3
Create a nice looking shiny app that can be used to explore data and model it

### The Purpose of this App: 
##### This application was developed using an IMDB dataset. Briefly, the dataset was split into training and test data. Single decision tree, random forest model and boosted tree were built using the training date. These three models were compared on the test data set by confusion matrix. THe models can be used to predict the sentiment of reviews.

### List of Packages Needed to Run the App:
library(caret) # for training our models, we used caret to train all four of our models.
library(corrplot) # for creating a detailed correlation plot of variables.
library(DT) # to interface to the JavaScript library DataTables.
library(doSNOW) # to parallel processing, particularly when we get to the random forest model and boosted model since they are computationally expensive.
library(ggtext) # provides simple Markdown and HTML rendering for ggplot2.
library(irlba) # to compute a partial SVD, principal components, and some specialized partial eigenvalue decompositions.
library(lsa) # to create semantic spaces spaces based on the LSA algorithm.
library(parallel) # to use detectCores()
library(quanteda) # for managing and analyzing textual data 
library(randomForest) # to build random forest model 
library(shiny) # to build interactive web apps straight from R. 
library(shinycssloaders) # to add a loader while graph is populating
library(shinydashboard) # shinydashboard functions
library(SnowballC) # to parallel processing, particularly when we get to the random forest model and boosted model since they are computationally expensive.
library(stringr) # provide a cohesive set of functions designed to make working with strings as easy as possible
library(syuzhet) # Extracts Sentiment and Sentiment-Derived Plot Arcs from Text
library(textdata) # to provide access to text-related data sets 
library(tidytext) # to allow conversion of text to and from tidy formats
library(tidyverse) # for data cleaning and transforming with dplyr, and plotting with ggplot2.
library(tm) # Text Mining Package
library(wordcloud) # to build wordclouds in R
library(xlsx) # to read and write xlsx files       


### The Code to Install All the Packcages
install.packages(c("caret", "corrplot", "DT", "doSNOW", "ggtext", "irlba", "lsa", 
  "parallel",  "quanteda", "randomForest", "shiny", "shinycssloaders", "shinydashboard",
  "SnowballC", "stringr", "syuzhet", "textdata", "tidytext", "tidyverse", "tm",
  "wordcloud", "xlsx"))
  
### The Code to Share the App on GitHub
shiny::runGitHub(repo = "ST558_Project3", username = "oaktreetrail", ref = "main")
