
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output, session) {
  
  #session$onSessionEnded(function() {
  #  stopApp()
  #})

  output$distPlot <- renderPlot({
    
    inFile1 <- input$file1
    inFile2 <- input$file2
    
    
    if (is.null(inFile1))
      return(NULL)
    if (is.null(inFile2))
      return(NULL)
    
    #Read in data and process CSV data
    data1=read.csv(inFile1$datapath, header=F, colClasses='character')
    data2=read.csv(inFile2$datapath, header=F, colClasses='character')
    
    #Deterime Plate Name
    plate1=unique(data2$V4)
    plate2=unique(data2$V4)  
    
    #Merge files
    merge=merge(data1[c(3,5)], data2[c(3,5)], by=c("V3"))
    
    merge$conflicts=merge$V5.x %in% merge$V5.y
    


    par(xpd=TRUE)
    plot=data.frame(row=substr(merge$V3, 1,1), col=as.numeric(substr(merge$V3, 2,3)), option=merge$conflicts, p1=merge$V5.x, p2=merge$V5.y) 
    
    
    #Recode no tube variable
    plot$p2 <- ifelse(plot$p2 == "No Tube", 
                      c(1), c(0))
    plot$p1 <- ifelse(plot$p1 == "No Tube", 
                      c(1), c(0)) 
    
    
    
    plot$option=as.numeric(plot$option)
    
    rown <- unique(plot$row)
    coln <- unique(plot$col)
    
    plot(NA,ylim=c(0.5,length(rown)+0.5),xlim=c(0.5,length(coln)+0.5),ann=FALSE,axes=FALSE)
    box()
    
    axis(2,at=seq_along(rown),labels=rev(rown),las=2)
    axis(3,at=seq_along(coln),labels=coln)
    
    symbols(plot$col,
            factor(plot$row, rev(levels(plot$row))),
            circles=rep(0.35,nrow(plot)),
            add=TRUE,
            inches=FALSE,
            bg=ifelse(plot$option == 1,'green','red'))
    
    points(plot$col[plot$p1==1],
           factor(plot$row[plot$p1==1], rev(levels(plot$row[plot$p1==1]))),
           pch=3, cex=3)
    
    points(plot$col[plot$p2==1],
           factor(plot$row[plot$p2==1], rev(levels(plot$row[plot$p2==1]))),
           pch=4, cex=3)
    
    
    mtext(paste(date()), 3, line = 3, cex=1)
    
    legend("bottomleft",
           horiz=T,
           legend=c("Identical","Mismatch"), inset=c(0.3,-0.15),
           bty = "n", cex=1, col=c("green","red"), pch=c(16,16,16))
    
    legend("bottomleft",
           horiz=T,
           legend=c("No Tube on Plate 1", "No Tube on Plate 2") , inset=c(0.15,-0.25),
           bty = "n", cex=1, pch=c(3,4))
    
    
    output$text1 <- renderDataTable({
      #Create summary statistics
      
      NumConflicts=length(setdiff(merge$V5.x, merge$V5.y))
      
      merge$conflicts=merge$V5.x %in% merge$V5.y
      
      summary=data.frame(subset(merge, conflicts==FALSE, select=1:3))
      
      names(summary)[1] <- "Position"
      names(summary)[2] <- "Plate1"
      names(summary)[3] <- "Plate2"
      summary
    })
    
  })
  
  session$onSessionEnded(function() {
    stopApp()
  })
  
    
})
