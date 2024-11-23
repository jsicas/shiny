# packages
library(shiny)
library(geobr)
library(ggplot2)
library(dplyr)
library(bslib)
library(DT)
library(shinyjs)
library(rsconnect)


# carregando mapa para poupar tempo
states <- readRDS('grafico/states.RDS')

# Adicionar source

ui <- page_sidebar(
  # configurações
  theme = bs_theme(bootswatch = 'darkly'),  # tema
  useShinyjs(),  # js
  tags$head(     # Animações do botão de carregar arquivo
    tags$style(HTML('
      #load_file {
        transition: background-color 1.75s ease-out;
      }
      
      #load_file.flash-fill1 {
        background-color: red;
      }
      
      #load_file.flash-fill2 {
        background-color: #00BC8C;
      }
      
      .shiny-notification-message {
        font-size: 19px;
        background-color: #00BC8C;
        color:#FFFFF3;
      }
      
      .shiny-notification-error {
        font-size: 19px;
        background-color: red;
        color:#FFFFF3;
      }
    '))
  ),
  
  # titulo
  titlePanel('Brasil por Estado e Regiões'),  
  
  sidebar = sidebar(
    style = 'display: flex; flex-direction: column; height: 100vh;',  # Config layout
    radioButtons(
      'regiao',
      'Região:',
      c(
        'Todos' = 0, 'Norte' = 1, 'Nordeste' = 2,
        'Centro Oeste' = 5, 'Sudeste' = 3, 'Sul' = 4
      ),
    ),
    div(style = 'display: flex; flex-direction: column; margin-top: auto;',  # Empurra o botão para o final
        actionButton('load_file', 'Carregar Arquivo CSV', style = 'margin-bottom: 20px;'),
        actionButton('load_exemplo', 'Carregar Exemplo'),
        hidden(fileInput('file', 'Escolha um arquivo CSV', accept = c('.csv'),
                         buttonLabel = 'Selecionar Arquivo',
                         placeholder = 'Nenhum arquivo selecionado'))
    ),
  ),
  
  navset_card_underline(
    nav_panel('Tabela',
              hidden(fileInput('file', 'Escolha um arquivo CSV',
                               accept = c('.csv'))),
              DTOutput(outputId = 'tabela')
    ),
    nav_panel('Mapa', plotOutput(outputId = 'mapa'))
  )
)

server <- function(input, output, session) {
  a <- reactive({  # usado para atulizar dependências da região (gráfico de mapa)
    if (input$regiao == 0) 1:5 else input$regiao
  })
  
  dados <- reactiveVal(NULL)  # variável reativa
  
  # Carregar os dados exemplo
  observeEvent(input$load_exemplo, {
    if (!is.null(dados())) {
      # Exibe confirmação para substituição dos dados
      showModal(modalDialog(
        title = 'Confirmar',
        'Você já tem dados carregados. Deseja carregar os dados de exemplo e sobrescrever os dados atuais?',
        easyClose = TRUE,
        footer = tagList(
          modalButton('Cancelar'),
          actionButton('confirmar_exemplo', 'Sim, carregar dados de exemplo')
        )
      ))
    } else {
      # se não tiver dados, carrega exemplo
      dados(read.csv('data/banco_exemplo.csv'))  # Atualiza os dados reativos
    }
  })
  
  observeEvent(input$confirmar_exemplo, {
    removeModal()
    dados(read.csv('data/banco_exemplo.csv'))
  })
  
  # escolher arquivo para carregar
  observeEvent(input$load_file, {
    click('file')
  })
  
  # efetivamente carregar o arquivo
  observeEvent(input$file, {
    if (tools::file_ext(input$file$name) != 'csv') {
      showNotification('Arquivo não foi importanto. Por favor, selecione um arquivo CSV.',
                       type='error', duration=7)
      addClass(selector = '#load_file', class = 'flash-fill1')
      delay(2500, {
        removeClass(selector = '#load_file', class = 'flash-fill1')
      })
    } else {
      dados(read.csv(input$file$datapath))
      showNotification('Arquivo importanto com sucesso.',
                       type='message', duration=7)
      addClass(selector = '#load_file', class = 'flash-fill2')
      delay(2500, {
        removeClass(selector = '#load_file', class = 'flash-fill2')
      })
    }
  })
  
  output$tabela <- renderDT({
    req(dados())  # Garante que dados() não seja NULL
    dados() |> filter(code_region %in% a()) |>
    datatable(options = list(
      pageLength = 5, # número inicial de entradas exibidas
      lengthMenu = c(5, 10, 15, 20, 27) # opções para o usuário
    ))
  })
  
  output$mapa <- renderPlot({
    states |> filter(code_region %in% a()) |>
      ggplot() +
      geom_sf(fill='#2D3E50', color='#FEBF57', size=.15, show.legend=F) +
      theme_void() 
    # theme(plot.background = element_rect(fill='#2d2d2d', color='transparent'),
    #       panel.background = element_rect(fill='#2d2d2d', color='transparent'))
  })
  
}

shinyApp(ui = ui, server = server)
