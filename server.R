
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

source("src/BarcodeCompare.R")


shinyServer(function(input, output, session) {
  
  #session$onSessionEnded(function() {
  #  stopApp()
  #})

  output$distPlot <- renderPlot({
    
    inFile1 <- input$file1
    inFile2 <- input$file2
    
    

    merge <- mergeBarcodeTable(inFile1, inFile2)
    
    plotBarcodeCompare(merge)

    
    output$text1 <- renderDataTable({

      #Create summary statistics
      summariseBarcodeCompare(merge)
    })
    
  })
  
  session$onSessionEnded(function() {
    stopApp()
  })
  
    
})
