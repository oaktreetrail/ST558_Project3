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
  
  # Fitting Models
  index <- reactive({
    createDataPartition(review.raw$sentiment, times = 1,
                        p = input$p, list = FALSE)
  })
  
  train_model <- reactive({review.raw[index(),]})
  test_moedl <- reactive({review.raw[-index(),]})
  
  trian.svd_data <- reactive({
    train <-train.svd[index(),]
    train 
  })
  
  test.svd_data <- reactive({
    train.svd[-index(),]
  })
  
  cntrl <- reactive({
    folds <- createMultiFolds(train_model()$sentiment, k = input$cv, times = 3)
    cntrl <- trainControl(method = "repeatedcv", number = 10,
                          repeats = 3, index = folds)
    cntrl
  })
  
  # 
  # # Create data frame using our document semantic space of 50 features (i.e., the V matrix from our SVD).
  # train.svd <- data.frame(Label = train$sentiment, train.irlba$v)
  
  var_model <- reactive({
    c(1, sample(2:51, input$nvar_model))
  })
  
  train_data <- reactive({
    trian.svd_data()[, var_model()]
  })
  
  test_data <- reactive({
    test.svd_data()[, var_model()]
  })
  

  # # Single decision trees
  treemodel <- eventReactive(input$fitmodel, {
    train(Label ~ ., data = train_data(), method = "rpart",
            trControl = cntrl(), tuneLength = 7)
  })

  output$treeoutput <-  renderPrint({
    treemodel()
  })
    
  # Random Forest
  rfmodel <- eventReactive(input$fitmodel, {
    train(Label ~ ., data = train_data(), method = "rf",
            trControl = cntrl(), tuneLength = 7)
  })
  
  output$rfoutput <-  renderPrint({
    rfmodel()
  })
  
  output$rf_imp <- renderPlot({
    if(input$fitmodel){
      plot(varImp(rfmodel()), top=10)
    }else{
      return(NULL)
    }
  }) 
  
  
  # Boosted Tree 
  bstmodel <- eventReactive(input$fitmodel, {
    train(Label ~ ., data = train_data(), method = "gbm",
          trControl = cntrl(), 
          preProcess = c("center", "scale"),
          tuneGrid = expand.grid(n.trees = c(10, 50), interaction.depth = c(1:4),
                                 shrinkage = c(0.001, 0.05), n.minobsinnode = c(5, 10)))
  })
  
  output$bstoutput <-  renderPrint({
    bstmodel()
  })
  
  # Comparison tab
  output$rpart_conf <- renderPrint({confusionMatrix(predict(treemodel(), test_data()), test_data()$Label)[2:3]})
  
  output$rf_conf <- renderPrint({confusionMatrix(predict(rfmodel(), test_data()), test_data()$Label)[2:3]})
  
  output$bst_conf <- renderPrint({confusionMatrix(predict(bstmodel(), test_data()), test_data()$Label)[2:3]})

  # Prediction tab
  test.svd <- eventReactive(input$text,{
    step1 <- tokens(input$text, what = "word", 
                           remove_numbers = TRUE, remove_punct = TRUE,
                           remove_symbols = TRUE, remove_hyphens = TRUE)
    step2 <- tokens_tolower(step1)
    step3 <- tokens_select(step2, stopwords(), 
                           selection = "remove")
    step4 <- tokens_wordstem(step3, language = "english")
    step5 <- tokens_ngrams(step4, n = 1:2)
    step6 <- dfm(step5)
    step7 <- as.matrix(dfm_match(step6, featnames(train.tokens.dfm)))
    test.tokens.df  <- apply(step7, 1, term.frequency)
    test.tokens.tfidf <- apply(test.tokens.df, 2, tf.idf, idf = train.tokens.idf)
    test.svd <- t(sigma.inverse * u.transpose %*% test.tokens.tfidf)
    test.svd
  })
  
  output$review_test <- renderText({
    data_pred <- data.frame(Label = "positive", test.svd())
    if(input$model_pred == "tree_pred"){
      pred <- predict(rpart.cv, data_pred)
    } else if(input$model_pred == "rf_pred"){
      pred <- predict(rf.cv, data_pred)
    } else{pred <- predict(bst.cv, data_pred)}
    
  })


}

