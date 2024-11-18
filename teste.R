library(shiny)
library(bslib)

ui <- page_sidebar(
  title = "Tabsets",
  
  sidebar = sidebar(
    
    radioButtons(
      "dist",
      "Distribution type:",
      c(
        "Normal" = "norm",
        "Uniform" = "unif",
        "Log-normal" = "lnorm",
        "Exponential" = "exp"
      )
    ),
    br(),
    sliderInput(
      "n",
      "Number of observations:",
      value = 500,
      min = 1,
      max = 1000
    )
  ),
  
  navset_card_underline(
    nav_panel("Plot", plotOutput("plot")),
    nav_panel("Summary", verbatimTextOutput("summary")),
    nav_panel("Table", tableOutput("table"))
  )
)

server <- function(input, output) {
  d <- reactive({
    dist <- switch(
      input$dist,
      norm = rnorm,
      unif = runif,
      lnorm = rlnorm,
      exp = rexp,
      rnorm
    )
    
    dist(input$n)
  })
  
  output$plot <- renderPlot({
    dist <- input$dist
    n <- input$n
    
    hist(
      d(),
      main = paste("r", dist, "(", n, ")", sep = ""),
      col = "#75AADB",
      border = "white"
    )
  })
  
  output$summary <- renderPrint({
    summary(d())
  })
  
  output$table <- renderTable({
    d()
  })
}

shinyApp(ui, server)
