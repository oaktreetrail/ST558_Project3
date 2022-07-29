function(input, output, session){
  
  # EDA page 
  table1 <- reactive({
    if (input$data_type == "raw"){
      as.array(summary(train[sample(1:701, input$nrow),]$ReviewLength))
    } else {
      return(NULL)
    }
  })
  
  output$raw_numeric_table <- renderTable(table1(),
                                          title ="Distribution of Review Length")
  
  plot0 <- reactive({
    if (input$data_type == "raw" && input$plot_type == "box"){
      ggplot(train[sample(1:701, input$nrow),], aes(x = sentiment, y = ReviewLength, fill = sentiment)) +
        theme_bw() +
        geom_boxplot() +
        coord_flip() +
        labs(y = "Review Count", x = "Length of Review",
             title = "Boxplot of Review Length with Sentiment Lables")
    } else {
      return(NULL)
    }
  })

  output$raw_box <- renderPlot(plot0())
  
  plot1 <- reactive({
    if (input$data_type == "raw" && input$plot_type == "hist"){
        ggplot(train[sample(1:701, input$nrow),], aes(x = ReviewLength, fill = sentiment)) +
          theme_bw() +
          geom_histogram(binwidth = 50) +
          labs(y = "Review Count", x = "Length of Review",
          title = "Distribution of Review Length with Sentiment Lables")
    } else {
      return(NULL)
    }
  })

  output$raw_hist <- renderPlot(plot1())
  
  
  plot2 <- reactive({
    pos_train.tokens.matrix <- train.tokens.matrix[intersect(pos.indexes, sample(1:701, input$nrow)), ]
    
    pos_sums <- as.data.frame(colSums(pos_train.tokens.matrix))
    pos_sums <- rownames_to_column(pos_sums) 
    colnames(pos_sums) <- c("term", "count")
    pos_sums <- arrange(pos_sums, desc(count))
    pos_head <- pos_sums[1:75,]
    
    if (input$data_type == "token"){
      return(wordcloud(words = pos_head$term, freq = pos_head$count, scale = c(4, 1),
                       max.words=100, random.order=FALSE, rot.per=0.35,
                       colors=brewer.pal(8, "Dark2")))
    } else {
      return(NULL)
    }
  })

  plot3 <- reactive({
    neg_train.tokens.matrix <- train.tokens.matrix[intersect(neg.indexes, sample(1:701, input$nrow)), ]
    neg_sums <- as.data.frame(colSums(neg_train.tokens.matrix))
    neg_sums <- rownames_to_column(neg_sums) 
    colnames(neg_sums) <- c("term", "count")
    neg_sums <- arrange(neg_sums, desc(count))
    neg_head <- neg_sums[1:75,]
    
    if (input$data_type == "token"){
      return(wordcloud(words = neg_head$term, freq = neg_head$count, scale = c(4, 1),
                       max.words=100, random.order=FALSE, rot.per=0.35,
                       colors=brewer.pal(8, "Dark2")))
    } else {
      return(NULL)
    }
  })
  
  output$plotgraph1 <- renderPlot({plot2()})
  output$plotgraph2 <- renderPlot({plot3()})
  
  data1 <- reactive({
    correlation <- round(cor(train.svd[sample(1:701, input$nrow), sample(2:11, input$ncol)]), 3)
    correlation
  })
  
  output$dataTable1 <- renderDataTable({
    if (input$data_type == "svd"){
      data1()}else{
        return(NULL)
      }
  })
  
  output$plotgraph4 <- renderPlot({
    if (input$data_type == "svd"){
      corrplot(data1(), type = "upper",
               tl.pos = "lt")
      corrplot(data1(), type = "lower", method = "number",
               add = TRUE, diag = FALSE, tl.pos = "n")}else{
        return(NULL)
      }
  })
}
  

