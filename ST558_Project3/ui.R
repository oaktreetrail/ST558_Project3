library(shiny) # shiny features
library(shinydashboard) # shinydashboard functions

dashboardPage(
  dashboardHeader(title = "Exploring the IMDB Dataset of 50K Movie Reviews with R Shiny Dashboard",
                  titleWidth = 800,
                  tags$li(class="dropdown",
                          tags$a(href="https://github.com/oaktreetrail/ST558_Project3", icon("github"), "Source Code", target="_blank"))
                  ),
  dashboardSidebar(
    sidebarMenu(id = "sidebar",
      menuItem("About", tabName = "about", icon = icon("dashboard")),
      menuItem("Data Exploration", tabName = "eda", icon=icon("bar-chart-o")),
      menuItem("Modeling", tabName = "model", icon = icon("chart-line")),
      menuItem("Dataset", tabName = "data", icon = icon("database"))
    )
  ),
  dashboardBody(
    #About Tab
    tabItems(
      tabItem(tabName = "about",
              h1("placehoder")
              ),
      
      
      tabItem(tabName = "eda",
              tabBox(id ="t1", width = 12,
                     tabPanel("Data", dataTableOutput("dataT"), icon = icon("table")), 
                     tabPanel("Structure", verbatimTextOutput("structure"), icon=icon("uncharted"))
              )
      ),
      
      tabItem(tabName = "model",
              tabBox(id ="t1", width = 12,
                     tabPanel("Modeling Info", dataTableOutput("dataT"), icon = icon("address-card")), 
                     tabPanel("Model Fitting", verbatimTextOutput("model"), icon=icon("uncharted")),
                     tabPanel("Prediction", verbatimTextOutput("pred"), icon=icon("chart-pie"))
              )
      ),
      
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



        
        