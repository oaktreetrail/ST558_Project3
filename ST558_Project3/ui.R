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
                  radioButtons(inputId = "data_type" ,
                                     label = "Data Type",
                                     selected = "svd",
                                     c("Raw Review Data" = "raw",
                                       "Singular Vaule Decomposition" = "svd")),
                  numericInput(inputId = "norw",
                               label = "Select the number of rows",
                               value = 700,
                               min  = 500,
                               max = 700),
                  numericInput(inputId = "norw",
                               label = "Select the number of rows",
                               value = 700,
                               min  = 500,
                               max = 700)
                ),
                
                conditionalPanel(
                  'input.sidebarid == "eda" && input.data_type == "raw"',
                  radioButtons(inputId = "sum_type" ,
                               label = "Summary Type",
                               selected = NULL,
                               c("Numeric Summary" = "num",
                                 "Graphical Summary" = "plot"))
                ),
                # conditionalPanel(
                #   'input.sidebarid == "eda" && input.data_type == "svd"',
                #   checkboxGroupInput(inputId = "sen_type" ,
                #                      label = "Sentiment Type",
                #                      selected = "pos",
                #                      c("Positive" = "pos",
                #                        "Negative" = "neg"))
                # ),
                menuItem("Modeling", tabName = "model", icon = icon("chart-line")),
                menuItem("Dataset", tabName = "data", icon = icon("database"))
    )
  ),

  # body ----
  dashboardBody(
    tabItems(
      # About page ----
      tabItem(tabName = "about",
                            fluidPage(includeHTML("About.html"),
                                      br(),
                                      img(src = "IMDB.jpg",
                                          width="500px",
                                          height="520px",
                                          align = "left",
                                          alt = "Test Image")
                                     )
                            ),
      # EDA page ----
            tabItem(tabName = "eda",
                    includeHTML("data_type.html"),
                    fluidRow(box(tableOutput("raw_numeric_table"), title = "Summary of Review Length"),
                             box(plotOutput("raw_graphic")), title = "Distribution of Review Length with Sentiment Lables"),
                    fluidRow(box(plotOutput("plotgraph1"), title = "Word Cloud of positive reviews"),
                             box(plotOutput("plotgraph2"), title = "Word Cloud of negative reviews"))
                    
            ),

      # Modeling page ----
            tabItem(tabName = "model",
                     tabBox(id ="t1", width = 12,
                           tabPanel("Modeling Info", icon = icon("address-card")),
                           tabPanel("Model Fitting",  icon=icon("uncharted")),
                           tabPanel("Prediction", icon=icon("chart-pie"))
                    )
            ),
      # # Dataset page ----
            tabItem(tabName = "data",
                    tabBox(id ="t2", width = 12,
                           tabPanel("Data", dataTableOutput("dataT"), icon = icon("table")),
                           tabPanel("Structure", verbatimTextOutput("structure"), icon=icon("uncharted"))
                    )
            )
    )
  )
)


