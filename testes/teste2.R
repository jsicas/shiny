library(shiny)
library(tidyverse)

ui <- fluidPage(
  plotOutput("myplotout"),
  downloadLink("download_grafico", "Download Plot")
)

server <- function(input, output) {
  # Our dataset
  
  
  myplot <- reactive({
    ggplot(data=iris,
           mapping = aes(x=Petal.Width,y=Sepal.Width,colour=Species)) + geom_point()
  })
  output$myplotout <- renderPlot({
    myplot()
  })
  
  output$download_grafico <- downloadHandler(
    filename = function() {
      paste("myplot", Sys.Date(), ".png", sep="")
    },
    content = function(file) {
      pdf(file=file)
      plot(myplot())
      dev.off()
    }
  )
}

shinyApp(ui, server)