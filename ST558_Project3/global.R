library(DT)  # for DT tables
library(ggtext) # beautifying text on top of ggplot
library(tidyverse) # data visualization 
library(caret) # truncated SVD
library(quanteda) # Text analytics 
library(irlba) # Singular value decomposition 
library(randomForest)
library(stringr)
library(doSNOW)
library(parallel)
library(SnowballC)
library(lsa)
library(tidytext)
library(syuzhet)
library(textdata)
library(tm)
library(wordcloud)
library(xlsx)      
library(corrplot)

set.seed(558)
# Parallel Processing
cores <- detectCores()
cl <- makeCluster(cores, type = "SOCK")
registerDoSNOW(cl)

################
# Read In Data # 
################

# Read in the data set
setwd("F:\\Graduate\\NCSU_courses\\ST558\\projects\\project_3\\ST558_Project3\\ST558_Project3")
review.raw <- read.csv("IMDB Dataset.csv", nrows = 1000, stringsAsFactors = FALSE)

########################
# Create the functions #
########################


#The function for calculating relative term frequency (TF)
term.frequency <- function(row) {
  row / sum(row)
}

#The function for calculating inverse document frequency (IDF)
inverse.doc.freq <- function(col) {
  corpus.size <- length(col)
  doc.count <- length(which(col > 0))
  
  log10(corpus.size / doc.count)
}

#Our function for calculating TF-IDF.
tf.idf <- function(tf, idf) {
  tf * idf
}


################
# Prepare Data #
################

# Add a variable to show the length of reviews.
review.raw$ReviewLength <- nchar(review.raw$review)

# Convert our sentiment label into a factor 
review.raw$sentiment <- as.factor(review.raw$sentiment)


# Create a 70%/ 30% stratified split
indexes <- createDataPartition(review.raw$sentiment, times = 1,
                               p = 1, list = FALSE)

train <- review.raw[indexes,]
test <- review.raw[-indexes,]

pos.indexes <- which(train$sentiment == "positive")
neg.indexes <- which(train$sentiment == "negative")

# Tokenize IMDB review: First, I use tokens() function to tokenize all these tests into words per review, by removing digits, punctuation, symbols and hyphens.
train.tokens <- tokens(train$review, what = "word", 
                       remove_numbers = TRUE, remove_punct = TRUE,
                       remove_symbols = TRUE)

#Then, lower case the tokens, using tokens_tolower() function. 
train.tokens <- tokens_tolower(train.tokens)

#Stop words,such as "the", are common words that are used in language that are typically used to male language flow. But in general, they don't add anything in terms of semantics. Thus, removed. 
train.tokens <- tokens_select(train.tokens, stopwords(), 
                              selection = "remove")

# Perform stemming on the tokens using tokens_wordstem() function. Stemming is the way we take words that very similar(run, ran, running) and we collapse them down into essentially a single column in our term frequnecy matrix.  
train.tokens <- tokens_wordstem(train.tokens, language = "english")


# N-grams allow us to augment our document-term frequency matrices with word ordering. This often leads to increased performance (e.g., accuracy) for machine learning models trained with more than just unigrams (i.e., single terms). Let's add bigrams to our training data and the TF-IDF transform the expanded featre matrix to see if accuracy improves.

#Add bigrams to our feature matrix.
train.tokens <- tokens_ngrams(train.tokens, n = 1:2)

# Create the bag-of-words model by dfm() function (dfm is short for document-feature matrix).
train.tokens.dfm <- dfm(train.tokens, tolower = FALSE)

# Transform to a matrix and inspect.
train.tokens.matrix <- as.matrix(train.tokens.dfm)

# First step, normalize all documents via TF.
# train.tokens.df <- apply(train.tokens.matrix, 1, term.frequency)
# 
# # Second step, calculate the IDF vector that we will use - both
# train.tokens.idf <- apply(train.tokens.matrix, 2, inverse.doc.freq)
# 
# # Lastly, calculate TF-IDF for our training corpus.
# train.tokens.tfidf <-  apply(train.tokens.df, 2, tf.idf, idf = train.tokens.idf)
# 
# # Transpose the matrix
# train.tokens.tfidf <- t(train.tokens.tfidf)
# 
# saveRDS(train.tokens.idf, "train.idf")

train.tokens.idf <- readRDS("train.idf")
# 
# # Perform SVD. Specifically, reduce dimensionality down to 50 columns for our latent semantic analysis (LSA).
# train.irlba <- irlba(t(train.tokens.tfidf), nv = 50, maxit = 100)
# 
# saveRDS(train.irlba, "train.irlba.rds")
train.irlba <- readRDS("train.irlba.rds")
# 
# # Create data frame using our document semantic space of 50 features (i.e., the V matrix from our SVD).
# train.svd <- data.frame(Label = as.factor(train$sentiment), train.irlba$v)
# 
# # Saving train.svd in RData format
# write.csv(train.svd, file = "svd.csv")

sigma.inverse <- 1 / train.irlba$d
u.transpose <- t(train.irlba$u)


# To load the data again
train.svd <- read.csv("svd.csv")[-1]
train.svd <- data.frame(Label = as.factor(train.svd$Label),train.svd[-1])

token_down <- data.frame(Label = as.factor(train.svd$Label),train.tokens.matrix)
#######
# EDA #
#######

# First, take a look at distribution of sentiment labels (i.e., positive vs. negative)
prop_table <- prop.table(table(review.raw$sentiment))


# let's get a feel for the distribution of text lengths of the review 
ReviewLength_table <- as.array(summary(review.raw$ReviewLength))

# Visualize distribution with ggplot2, adding segmentation for positive/ negative
raw_graphic_sum <- ggplot(review.raw, aes(x = ReviewLength, fill = sentiment)) +
                     theme_bw() +
                     geom_histogram(binwidth = 50) +
                     labs(y = "Review Count", x = "Length of Review",
                     title = "Distribution of Review Length with Sentiment Lables")

# WordCloud
# pos_train.tokens.matrix <- train.tokens.matrix[intersect(pos.indexes, sample(1:1000, input$nrow)), ]
# 
# pos_sums <- as.data.frame(colSums(pos_train.tokens.matrix))
# pos_sums <- rownames_to_column(pos_sums) 
# colnames(pos_sums) <- c("term", "count")
# pos_sums <- arrange(pos_sums, desc(count))
# pos_head <- pos_sums[1:75,]

# pos_wordCloud <- wordcloud(words = pos_head$term, freq = pos_head$count, scale = c(4, 1),
#                    max.words=100, random.order=FALSE, rot.per=0.35, 
#                    colors=brewer.pal(8, "Dark2"))

# neg_train.tokens.matrix <- train.tokens.matrix[intersect(neg.indexes, sample(1:1000, input$nrow)), ]
# neg_sums <- as.data.frame(colSums(neg_train.tokens.matrix))
# neg_sums <- rownames_to_column(neg_sums) 
# colnames(neg_sums) <- c("term", "count")
# neg_sums <- arrange(neg_sums, desc(count))
# neg_head <- neg_sums[1:75,]

# neg_wordCloud <- wordcloud(words = neg_head$term, freq = neg_head$count, scale = c(4, 1),
#                            max.words=100, random.order=FALSE, rot.per=0.35, 
#                            colors=brewer.pal(8, "Dark2"))



# Use caret to create stratified folds for 10-fold cross validation repeated 3 times (i.e., create 30 random stratified samples)
cv.folds <- createMultiFolds(train$sentiment, k = 10, times = 3)

cv.cntrl <- trainControl(method = "repeatedcv", number = 10,
                         repeats = 3, index = cv.folds)

# Single decision trees
# rpart.cv <- train(Label ~ ., data = train.svd, method = "rpart", 
#                     trControl = cv.cntrl, tuneLength = 7)
# 
# # Check out our results.
# saveRDS(rpart.cv, file = "rpart.cv.rds")

rpart.cv <- readRDS("rpart.cv.rds")
# # Random Forest
# # start.time <- Sys.time()
# rf.cv <- train(Label ~ ., data = train.svd, method = "rf",
#                  trControl = cv.cntrl, tuneLength = 7)
# 

# 
# # Total time of execution on workstation was
# total.time <- Sys.time() - start.time
# total.time
# 
# saveRDS(rf.cv, "rf.rds")

rf.cv <- readRDS("rf.rds")
# # 
# # # Boosted Trees
# # 
# # Values of n.trees
# nTrees <- c(10, 50)
# # Values of interaction.depth
# intDepth <- c(1:4)
# # Value of shrinkage
# shrink <- c(0.001, 0.05)
# # Value of n.minobsinnode
# nodeMinN <- c(5, 10)
# 
# start.time <- Sys.time()
# bst.cv <- train(Label ~ ., data = train.svd, method = "gbm",
#                trControl = cv.cntrl,
#                preProcess = c("center", "scale"),
#                tuneGrid = expand.grid(n.trees = nTrees, interaction.depth = intDepth,
#                                       shrinkage = shrink, n.minobsinnode = nodeMinN)
#                )
# 
# 
# # Total time of execution on workstation was
# total.time <- Sys.time() - start.time
# total.time
# 
# bst.cv
# 
# saveRDS(bst.cv, "bst.cv.rds")

bst.cv <- readRDS("bst.cv.rds")
