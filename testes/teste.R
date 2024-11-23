library(shiny)
library(shinyjs)

ui <- fluidPage(
  useShinyjs(), # Necessário para manipulação dinâmica
  tags$head(
    tags$style(HTML("
      /* Estilo inicial do botão */
      #load_file {
        position: relative;
        overflow: hidden;
        background-color: white;
        color: black;
        border: 1px solid black;
        padding: 10px 20px;
        font-size: 16px;
        cursor: pointer;
        transition: background-color 3s ease-out;
      }

      /* Estilo da barra de progresso */
      #load_file .progress-bar {
        position: absolute;
        top: 0;
        left: 0;
        height: 100%;
        width: 0;
        background-color: red;
        z-index: -1;
        transition: width 7s ease-in-out;
      }

      /* Efeito de carregamento completo */
      #load_file.flash-fill {
        background-color: red;
      }

      /* Animação para o esmaecimento após o carregamento */
      @keyframes fadeOutEffect {
        0% {
          background-color: red;
        }
        100% {
          background-color: white;
        }
      }
    "))
  ),
  actionButton("load_file", "Carregar Arquivo CSV"),
  hidden(fileInput("file", "Escolha um arquivo CSV", accept = c(".csv")))
)

server <- function(input, output, session) {
  observeEvent(input$load_file, {
    # Simula clique no fileInput
    click("file")
    
    # Adiciona a barra de progresso ao botão
    shinyjs::runjs('
      $("#load_file").append("<div class=\"progress-bar\"></div>");
      $(".progress-bar").css("width", "100%");
    ')
    
    # Adiciona a classe flash-fill para o efeito de preenchimento vermelho
    shinyjs::addClass(selector = "#load_file", class = "flash-fill")
    
    # Após 7 segundos, começa o efeito de apagamento da cor vermelha
    shinyjs::delay(7000, {
      shinyjs::runjs('$(".progress-bar").css("width", "0%");');
      shinyjs::removeClass(selector = "#load_file", class = "flash-fill");
    })
  })
  
  observeEvent(input$file, {
    # Verifica se o arquivo não é .csv
    if (tools::file_ext(input$file$name) != "csv") {
      # Inicia o efeito de carregamento
      shinyjs::addClass(selector = "#load_file", class = "flash-fill")
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


# pisca vermelho
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
#' transition: background-color 3s ease-out;
#' }
#' 
#' /* Estilo da barra de progresso */
#'   #load_file .progress-bar {
#'   position: absolute;
#' top: 0;
#' left: 0;
#' height: 100%;
#' width: 0;
#' background-color: red;
#' z-index: -1;
#' transition: width 7s ease-in-out;
#' }
#' 
#' /* Efeito de carregamento completo */
#'   #load_file.flash-fill {
#'   background-color: red;
#' }
#' 
#' /* Animação para o esmaecimento após o carregamento */
#'   @keyframes fadeOutEffect {
#'     0% {
#'       background-color: red;
#'     }
#'     100% {
#'       background-color: white;
#'     }
#'   }