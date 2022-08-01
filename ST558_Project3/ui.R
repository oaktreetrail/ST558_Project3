library(shiny) # shiny features
library(shinydashboard) # shinydashboard functions
library(shinycssloaders) # to add a loader while graph is populating

dashboardPage(

  # title ----
  dashboardHeader(title = "Exploring the IMDB Dataset of 50K Movie Reviews with R Shiny Dashboard",
                  titleWidth = 800,
                  tags$li(class="dropdown",
                          tags$a(href="https://github.com/oaktreetrail/ST558_Project3", icon("github"), "Source Code", target="_blank"))
                  ),

  # sidebar ----
  dashboardSidebar(
    sidebarMenu(id = "sidebarid",
                menuItem("About", tabName = "about", icon = icon("dashboard")),
                menuItem("Data Exploration", tabName = "eda", icon = icon("bar-chart-o")),

                conditionalPanel(
                  'input.sidebarid == "eda"',
                  sliderInput(inputId = "nrow",
                              label = "Select the number of rows",
                              value = 700,
                              min  = 500,
                              max = 700,
                              step = 5),
                  
                  radioButtons(inputId = "data_type" ,
                              label = "Data Type",
                              selected = NULL,
                              c("Raw Review Data" = "raw",
                                "Token Data" = "token", 
                                "Singular Vaule Decomposition Data" = "svd"))
                                ),
                
                menuItem("Modeling", tabName = "model", icon = icon("chart-line")),
                menuItem("Data", tabName = "data", icon = icon("database")
                         ),
                conditionalPanel('input.sidebarid == "data"',
                                 radioButtons(inputId = "data_type_download" ,
                                              label = "Data Type",
                                              selected = NULL,
                                              c("Raw Review Data" = "raw_download",
                                                "Token Data" = "token_download", 
                                                "Singular Vaule Decomposition Data" = "svd_download")),
                                 radioButtons(inputId = "sen_download",
                                             label = "Positive or Negative Review",
                                             selected = "pos_download",
                                             c("Postive Dataset" = "pos_download",
                                               "Negative Dataset" = "neg_download",
                                               "Full Dataset" = "full_download"))
                                 )
    )
  ),

  # body ----
  dashboardBody(
    tabItems(
      # About page ----
      tabItem(tabName = "about",
                fluidPage(h3(strong("The Purpose of the App")),
                          h4("This application was developed using an IMDB dataset. Briefly, the dataset was split into training and test data. Single decision tree, random forest model and boosted tree were built using the training date. These three models were compared on the test data set by confusion matrix. THe models can be used to predict the sentiment of reviews.")),
                fluidPage(h3(strong("The data and its source")),
                          h4("IMDB dataset having 50K movie reviews for natural language processing or Text analytics. This is a dataset for binary sentiment classification containing substantially more data than previous benchmark datasets. We provide a set of 25,000 highly polar movie reviews for training and 25,000 for testing. So, predict the number of positive and negative reviews using either classification or deep learning algorithms."),
                          h4("The dataset can be downloaded through", a(href="https://www.kaggle.com/datasets/lakshmi25npathi/imdb-dataset-of-50k-movie-reviews?datasetId=134715&language=R/", "Kaggle.", target="_blank")), 
                          h4("For more dataset information, please go through the following link", a(href="http://ai.stanford.edu/~amaas/data/sentiment/","IMDB ",target="_blank")
                            )
                          ),
                 fluidPage(h3(strong("The Purpose of Each Tab of the App")),
                           br(),
                           fluidPage(box(h3(strong("About Tab")),
                                         h4("This page includes the description of the app, the data and its source, the purpose of each tab, and the pictures of the reviews.")),
                                     box(h3(strong("Data Exploration Tab")),
                                         h4("The numeric and graphical summaries of the three data sets used in this app would be displaued in this page. The users are able to select the vatiables and rows to summarize and plot."))),
                           fluidPage(box(h3(strong("Modeling Tab")),
                                         h4("The data set would be split into trainging and test data. Single decision tree, random forest model and boosted tree were built using the training date. These three models were compared on the test data set by confusion matrix. THe models can be used to predict the sentiment of reviews.")),
                                     box(h3(strong("Data Tab")),
                                         h4("The users can select and subset any of the three data sets that used in this project, and save it as a csv file.")))),
              
                 fluidPage(h3(strong("The Pictures of the Reviews")),
                           br(),
                           br(),
                              img(src = "IMDB.jpg",
                               width="500px",
                               height="520px",
                               align = "left",
                               alt = "Test Image"),
                           img(src = "imdb.png",
                               width="500px",
                               height="520px",
                               align = "left",
                               alt = "Test Image")
                           )
               ),
      # EDA page ----
            tabItem(tabName = "eda",
                    fluidRow(column(12, h3(strong("Raw Rrview Data:"), h4("This dataset includs the Sentiments, Review and Length of Review"))),
                      tags$div(align="center", box(tableOutput("raw_numeric_table"), 
                                                   title = "Summary of Review Length", 
                                                   collapsible = TRUE, status = "primary",  
                                                   collapsed = TRUE, solidHeader = TRUE)),
                      tags$div(align="center", box(radioButtons(inputId = "plot_type" ,
                                                                label = "Plot Type",
                                                                selected = "hist",
                                                                c("Histogram" = "hist",
                                                                  "Box Plot" = "box")),
                                                   conditionalPanel(condition = "input.plot_type == 'hist'",
                                                                    plotOutput("raw_hist")),
                                                   conditionalPanel(condition = "input.plot_type == 'box'",
                                                                    plotOutput("raw_box")),
                                                   title = "Distribution of Review Length with Sentiment Lables",
                                                   collapsible = TRUE, status = "primary",  
                                                   collapsed = TRUE, solidHeader = TRUE))
                    ),
                   
                    fluidRow(column(12, h3(strong("Token Data:")), h4("First step in represntation is decomposing a text document into tokens."),
                                    p(h5("1. Remove numbers, punctuation"),
                                      h5("2. Change all the tokens into lower case."),
                                      h5("3. Stemming, put all similar words into one word."),
                                      h5("4. Add N-grams."),
                                      h5("5. Normalize documents based on their length and Penalize terms that occur frequency across the corpus."))),
                             tags$div(align="center", box(plotOutput("plotgraph1"), 
                                                      title = "Word Cloud of positive reviews", 
                                                      collapsible = TRUE, status = "primary",  
                                                      collapsed = TRUE, solidHeader = TRUE)),
                             tags$div(align="center", box(plotOutput("plotgraph2"), 
                                                      title = "Word Cloud of negative reviews", 
                                                      collapsible = TRUE, status = "primary",  
                                                      collapsed = TRUE, solidHeader = TRUE))),
                             
                    fluidRow(column(12, h3(strong("Singular Vaule Decomposition (SVD) Data Data:")),
                                    h4("Remendiate the demensionality problem in text analytics vsi Singular value decomposition (SVD).")),
                             br(), 
                             column(12, conditionalPanel("input.data_type == 'svd'",
                                                         sliderInput(inputId = "ncol",
                                                                     label = "Select the number of variables of the SVD data",
                                                                     value = 5,
                                                                     min  = 2,
                                                                     max = 10))),
                             tags$div(align="center", box(dataTableOutput("dataTable1"), 
                                                          title = "Correlation of the variables in SVD data", 
                                                          collapsible = TRUE, status = "primary",  
                                                          collapsed = TRUE, solidHeader = TRUE)),
                             tags$div(align="center", box(plotOutput("plotgraph4"), 
                                                          title = "Correlation Plot of the variables in SVD data", 
                                                          collapsible = TRUE, status = "primary",  
                                                          collapsed = TRUE, solidHeader = TRUE)))
            ),
      # Modeling page ----
            tabItem(tabName = "model",
                     tabBox(id ="t1", width = 12,
                           tabPanel("Modeling Info", icon = icon("address-card"),
                                    fluidPage(a(href ="https://dhirajkumarblog.medium.com/top-5-advantages-and-disadvantages-of-decision-tree-algorithm-428ebd199d9a", h3(strong("Decision Trees"))),
                                              p("Decision Tree is a very popular machine learning algorithm. Decision Tree solves the problem of machine learning by transforming the data into a tree representation. Each internal node of the tree representation denotes an attribute and each leaf node denotes a class label."),
                                              p("A decision tree algorithm can be used to solve both regression and classification problems."),
                                              box(h4(strong("Advantages:")),
                                                  p("1. Compared to other algorithms decision trees requires less effort for data preparation during pre-processing."),
                                                  p("2. A decision tree does not require normalization of data."),
                                                  p("3. A decision tree does not require scaling of data as well."),
                                                  p("4. Missing values in the data also do NOT affect the process of building a decision tree to any considerable extent."),
                                                  p("5. A Decision tree model is very intuitive and easy to explain to technical teams as well as stakeholders.")),
                                              box(h4(strong("Disadvantage:")),
                                                  p("1. A small change in the data can cause a large change in the structure of the decision tree causing instability."),
                                                  p("2. For a Decision tree sometimes calculation can go far more complex compared to other algorithms."))),
                                              
                                    fluidPage(a(href = "http://theprofessionalspoint.blogspot.com/2019/02/advantages-and-disadvantages-of-random.html", h3(strong("Random Forest"))),
                                              p("Random Forest is a powerful algorithm in Machine Learning. It is based on the Ensemble Learning technique (bagging)."),
                                              withMathJax(),
                                              p("We basically need to know the impurity of our dataset and we’ll take that feature as the root node which gives the lowest impurity or say which has the lowest Gini index. Mathematically Gini index can be written as:"),
                                              uiOutput("gini"),
                                              box(h4(strong("Advantages:")),
                                                  p("1. Random Forest is based on the bagging algorithm and uses Ensemble Learning technique. It creates as many trees on the subset of the data and combines the output of all the trees. In this way it reduces overfitting problem in decision trees and also reduces the variance and therefore improves the accuracy."),                         p("2. Random Forest can be used to solve both classification as well as regression problems."),
                                                  p("3. Random Forest works well with both categorical and continuous variables."),
                                                  p("4. Random Forest can automatically handle missing values."),
                                                  p("5. No feature scaling required: No feature scaling (standardization and normalization) required in case of Random Forest as it uses rule based approach instead of distance calculation.")
                                                  ),
                                              box(h4(strong("Disadvantages")),
                                                  p("1. Complexity: Random Forest creates a lot of trees (unlike only one tree in case of decision tree) and combines their outputs. To do so, this algorithm requires much more computational power and resources."),
                                                  p("2. Longer Training Period: Random Forest require much more time to train as compared to decision trees as it generates a lot of trees (instead of one tree in case of decision tree) and makes decision on the majority of votes."))),
                                    
                                    fluidPage(a(href = "https://corporatefinanceinstitute.com/resources/knowledge/other/boosting/", h3(strong("Boosted Tree"))),
                                              p("Boosted tree, just like any other ensemble machine learning procedure, sequentially adds predictors to the ensemble and follows the sequence in correcting preceding predictors to arrive at an accurate predictor at the end of the procedure."),
                                              box(h4(strong("Advantages:")),
                                                  p("There are several reasons as to why you would consider using boosted tree algorithms:"),
                                                  p("1. Generally more accurate compare to other modes,"),
                                                  p("2. Some of them handle missing values natively.")),
                                              box(h4(strong("Advantages:")),
                                                  p("1. Prone to overfitting"),
                                                  p("2. Hard to interpret the final models.")))),
                                    
                           tabPanel("Model Fitting",  icon=icon("uncharted"),
                                    fluidPage(
                                      column(4, sliderInput(inputId = "p",
                                                            label = "Select the Proportion to Split the Data",
                                                            value = 0.5,
                                                            min  = 0.5,
                                                            max = 1,
                                                            step = 0.1)),
                                      column(4, sliderInput(inputId = "nvar_model",
                                                            label = "Number the Varaibles in the Model",
                                                            value = 10,
                                                            min  = 10,
                                                            max = 50,
                                                            step = 5)),
                                      column(4, sliderInput(inputId = "cv",
                                                              label = "Number of CV fold",
                                                              value = 5,
                                                              min  = 5,
                                                              max = 10))
                                            ),
                                    
                                    fluidPage(actionButton("fitmodel", "Start Fitting Models"),
                                              align="center"),
                                    
                                    fluidPage(box(shinycssloaders::withSpinner(verbatimTextOutput("treeoutput")), title = h4(strong("Single Decision Tree")))),
                                    fluidPage(box(shinycssloaders::withSpinner(verbatimTextOutput("rfoutput")), title = h4(strong("Random Forest"))),
                                              box(h4(strong("Random Forest Variable Importance")), plotOutput("rf_imp"))),
                                    fluidPage(box(shinycssloaders::withSpinner(verbatimTextOutput("bstoutput")), title = h4(strong("Boosted Tree"))),
                                              box(h3(strong("Model Comparasion on the Test Model")),
                                                 fluidPage(fluidRow(h4(strong("Confusion Matrix of Single Decision Tree")), 
                                                                    verbatimTextOutput("rpart_conf")
                                                                   ),
                                                          fluidRow(h4(strong("Confusion Matrix of Random Forest")),
                                                                   verbatimTextOutput("rf_conf")
                                                                  ),
                                                          fluidRow(h4(strong("Confusion Matrix of Boosted Tree")), 
                                                                   verbatimTextOutput("bst_conf")
                                                                   )
                                                          )))         
                                    ),  
                           tabPanel("Prediction", icon=icon("chart-pie"),
                                    fluidPage(textAreaInput(inputId = "text",
                                                            label = "Enter review below:",
                                                            value = "Good Movie"),
                                              radioButtons(inputId = "model_pred",
                                                           label = "Select the Model for prediction",
                                                           c("Single Decision Tree" = "tree_pred",
                                                             "Random Forest" = "rf_pred",
                                                             "Boosted Tree" = "bst_pred"))
                                              ),
                                    fluidPage(h5(strong("Prediction")), verbatimTextOutput("review_test")))
                    )
            ),
      # # Dataset page ----
            tabItem(tabName = "data",
                    fluidPage(downloadButton("downloadData", "Download")),
                    br(),
                    br(),
                    fluidPage(conditionalPanel("input.data_type_download == 'token_download'",
                                                sliderInput(inputId = "nvar_token_download",
                                                           label = "Select the Numbers of Variables in Token Data",
                                                           value = 500,
                                                           min = 100,
                                                           max = 1000,
                                                           step = 50)),
                              conditionalPanel("input.data_type_download == 'svd_download'",
                                               sliderInput(inputId = "nvar_svd_download",
                                                           label = "Select the Numbers of Variables in SVD Data",
                                                           value = 30,
                                                           min = 10,
                                                           max = 50,
                                                           step = 5)),
                              dataTableOutput("finalTable")
                              
                              
                      )
                    
            )
    )
  )
)



