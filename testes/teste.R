library(shiny)
library(shinyjs)

ui <- fluidPage(
  useShinyjs(), # Necessário para manipulação dinâmica
  tags$head(
    tags$style(HTML("
  /* Estilo inicial do botão */
    #load_file {
    transition: background-color 3s ease-out;
  }
  
  /* Efeito de carregamento completo */
    #load_file.flash-fill1 {
    background-color: red;
  }
  /* Efeito de carregamento completo */
    #load_file.flash-fill2 {
    background-color: #2D3E50;
  }
    "))
  ),
  actionButton("load_file", "Carregar Arquivo CSV"),
  hidden(fileInput("file", "Escolha um arquivo CSV", accept = c(".csv")))
)

server <- function(input, output, session) {
  observeEvent(input$load_file, {
    addClass(selector = "#load_file", class = "flash-fill2")
    delay(3500, {
      removeClass(selector = "#load_file", class = "flash-fill2");
    })
  })
  
}

shinyApp(ui, server)



# loading vermelho
#' #load_file.flash-fill {
#' background: linear-gradient(to right, red 50%, transparent 50%);
#' background-size: 200% 100%;
#' animation: fillEffect 7s forwards;
#' }
#' 
#' /* Animação apenas para avançar */
#'   @keyframes fillEffect {
#'     0% {
#'       background-position: 100% 0;
#'     }
#'     100% {
#'       background-position: 0 0;
#'     }
#'   }

# pisca vermelho minimalista
# /* Estilo inicial do botão */
#   #load_file {
#   transition: background-color 3s ease-out;
# }
# 
# /* Efeito de carregamento completo */
#   #load_file.flash-fill {
#   background-color: red;
# }


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



# loading vermelho
#' /* Estilo inicial do botão */
#'   #load_file {
#'   position: relative;
#' overflow: hidden;
#' background-color: white;
#' color: black;
#' border: 1px solid black;
#' padding: 10px 20px;
#' font-size: 16px;
#' cursor: pointer;
#' }
#' 
#' /* Efeito de carregamento */
#'   #load_file.flash-fill {
#'   background: linear-gradient(to right, red 50%, transparent 50%);
#' background-size: 200% 100%;
#' animation: fillEffect 7s forwards;
#' }
#' 
#' /* Animação apenas para avançar */
#'   @keyframes fillEffect {
#'     0% {
#'       background-position: 100% 0;
#'     }
#'     100% {
#'       background-position: 0 0;
#'     }
#'   }
