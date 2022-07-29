function(input, output, session){
  
  # Data table Output
  output$raw_numeric_table <- renderTable(ReviewLength_table,
                                          title ="Distribution of Review Length")
  
  output$raw_graphic <- renderPlot(raw_graphic_sum)
  
  
  pt1 <- reactive({
    if (input$data_type == "svd"){
      return(wordcloud(words = pos_head$term, freq = pos_head$count, scale = c(4, 1),
                       max.words=100, random.order=FALSE, rot.per=0.35,
                       colors=brewer.pal(8, "Dark2")))
    } else {
      return(NULL)
    }
  })

  pt2 <- reactive({
    if (input$data_type == "svd"){
      return(wordcloud(words = neg_head$term, freq = neg_head$count, scale = c(4, 1),
                       max.words=100, random.order=FALSE, rot.per=0.35,
                       colors=brewer.pal(8, "Dark2")))
    } else {
      return(NULL)
    }
  })
  
  
  output$plotgraph1 <- renderPlot({pt1()})
  output$plotgraph2 <- renderPlot({pt2()})
  
  # output$svd_graphic  <- renderPlot({
  #   if(input$data_type == "svd"){
  #     wordcloud(words = pos_head$term, freq = pos_head$count, scale = c(4, 1),
  #               max.words=100, random.order=FALSE, rot.per=0.35, 
  #               colors=brewer.pal(8, "Dark2"))} else{
  #     wordcloud(words = neg_head$term, freq = neg_head$count, scale = c(4, 1),
  #               max.words=100, random.order=FALSE, rot.per=0.35,
  #               colors=brewer.pal(8, "Dark2"))
  #     }
  # }
}
  
  # Render the box geader
  # output$header1 <- renderText(
  #   
  # )
