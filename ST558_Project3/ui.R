library(shiny) # shiny features
library(shinydashboard) # shinydashboard functions
library(shinycssloaders) # to add a loader while graph is populating


dashboardPage(
  dashboardHeader(title = "Exploring the IMDB Dataset of 50K Movie Reviews with R Shiny Dashboard",
                  titleWidth = 800,
                  tags$li(class="dropdown",
                          tags$a(href="https://github.com/oaktreetrail/ST558_Project3", icon("github"), "Source Code", target="_blank"))
                  ),
  dashboardSidebar(
    sidebarMenu(id = "sidebar",
      menuItem("About",  tabName = "about", icon = icon("dashboard")),
      menuItem("Data Exploration", tabName = "eda", icon=icon("bar-chart-o"),
               conditionalPanel("input.sidebar == 'eda'", checkboxGroupInput(inputId = "data_type" ,
                                                                             label = "Data Type",
                                                                             selected = NULL,
                                                                             c("Raw Review Data" = "raw",
                                                                               "Singular Vaule Decomposition" = "svd"))),
                                                          checkboxGroupInput(inputId = "sum_type" ,
                                                                             label = "Summary Type",
                                                                             selected = NULL,
                                                                             c("Numeric Summary" = "num",
                                                                               "Graphical Summary" = "plot")),
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
      menuItem("Modeling", tabName = "model", icon = icon("chart-line")),
      menuItem("Dataset", tabName = "data", icon = icon("database"))
    )
  ),
  dashboardBody(
    # About Tab
    tabItems(
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
      
      # EDA tab 
      tabItem(tabName = "eda", h2("hello")
      ),
      
      # Modeling tab
      tabItem(tabName = "model",
              tabBox(id ="t1", width = 12,
                     tabPanel("Modeling Info", dataTableOutput("dataT"), icon = icon("address-card")), 
                     tabPanel("Model Fitting", verbatimTextOutput("model"), icon=icon("uncharted")),
                     tabPanel("Prediction", verbatimTextOutput("pred"), icon=icon("chart-pie"))
              )
      ),
      
      # Dataset tab
      tabItem(tabName = "data",
              tabBox(id ="t1", width = 12,
                     tabPanel("Data", dataTableOutput("dataT"), icon = icon("table")), 
                     tabPanel("Structure", verbatimTextOutput("structure"), icon=icon("uncharted"))
              )
      )
    )
    
    # Data Exploration Tab
    # tabItem(tabName = "eda".  
    #         tabBox(id="t2", width = 12, 
    #                tabPanel("About", icon=icon("address-card"),
    #                         tabPanel("Data", dataTableOutput("dataT"), icon = icon("table")), 
    #                         tabPanel("Structure", verbatimTextOutput("structure"), icon=icon("uncharted")),
    #                         tabPanel("Summary Stats", verbatimTextOutput("summary"), icon=icon("chart-pie"))
    #                )
    #         )
    # )
    )       
)



        
        