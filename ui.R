
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Compare Barcoded Plates"),
  
  p("This Shiny application compares two CSV files for similarities and inconsitencies \n from barcoded tubes from a 96-well rack scanned using a VisionMate Scanner"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      fileInput('file1', 'Choose Plate1 CSV file',
                accept = c(
                  'text/csv',
                  'text/comma-separated-values',
                  '.csv'
                )
      ),
      fileInput('file2', 'Choose Plate2 CSV file',
                accept = c(
                  'text/csv',
                  'text/comma-separated-values',
                  '.csv'
                )
      )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot",  height = 400, width = 600),
      h2("Conflicting Samples"),
      dataTableOutput("text1")
    )
  )
))
