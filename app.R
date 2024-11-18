# packages
library(shiny)
library(geobr)

# carregando mapa para poupar tempo
states <- readRDS('grafico/states.RDS')


# Define UI for application that draws a histogram
ui <- fluidPage(
    # titulo
    titlePanel('TESTE'),
    
    sidebarLayout(
        sidebarPanel(
            fileInput("file", "Escolha o arquivo", 
                      accept = c(".csv", ".xlsx"))
        ),
        mainPanel(
            tableOutput("preview") # Exibe uma prévia do banco de dados
        )
    )
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
}

# Run the application 
shinyApp(ui = ui, server = server)
