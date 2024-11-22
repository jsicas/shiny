library(shiny)
library(shinyjs)

ui <- fluidPage(
  useShinyjs(), # Necessário para manipulação dinâmica
  tags$head(tags$style(HTML("
 @keyframes fillAndFade {
  0% {
    background-size: 0% 100%;
    opacity: 1;
  }
  80% {
    background-size: 100% 100%;
    opacity: 1;
  }
  100% {
    background-size: 100% 100%;
    opacity: 0;
  }
}

.flash-fill {
  background: red;
  background-size: 0% 100%;
  height: 6px; /* Altura da barra */
  animation: fillAndFade 7s forwards;
}
  "))),
  actionButton("load_file", "Carregar Arquivo CSV"),
  hidden(fileInput("file", "Escolha um arquivo CSV", accept = c(".csv")))
)

server <- function(input, output, session) {
  observeEvent(input$load_file, {
    # Simula clique no fileInput
    click("file")
  })
  
  observeEvent(input$file, {
    # Verifica se o arquivo tem extensão .csv
    if (tools::file_ext(input$file$name) != "csv") {
      shinyjs::addClass("load_file", "flash-fill") # Adiciona animação
      shinyjs::delay(2000, shinyjs::removeClass("load_file", "flash-fill")) # Remove após 2s
    }
  })
}

shinyApp(ui, server)



#' .flash-fill {
#'   background: linear-gradient(to right, red 50%, transparent 50%);
#'   background-size: 200% 100%;
#'   animation: fillEffect 7s forwards;
#' }
#' 
#' @keyframes fillEffect {
#'   0% {
#'     background-position: 100% 0;
#'   }
#'   50% {
#'     background-position: 0 0;
#'   }
#'   100% {
#'     background-position: 100% 0;
#'   }
#' }


