# packages
library(shiny)
library(geobr)
library(ggplot2)
library(dplyr)
library(bslib)
library(DT)
library(shinyjs)


# carregando mapa para poupar tempo
states <- readRDS('grafico/states.RDS')

# Adicionar source

ui <- page_sidebar(
  # configurações
  theme = bs_theme(bootswatch = 'darkly'),  # tema
  useShinyjs(),  # js
  
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
        textOutput('mensagem_erro'),
        tags$style('#mensagem_erro {color: red}'),
        actionButton('load_file', 'Carregar Arquivo CSV'), br(),
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
  mensagem_erro <- reactiveVal(NULL)  # variável reativa para a mensagem de erro
  
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
      mensagem_erro('O arquivo selecionado não é um CSV. Por favor, selecione um arquivo CSV válido.')
      shinyjs::show('mensagem_erro')  # Exibe a mensagem de erro
      shinyjs::delay(7000, shinyjs::hide('mensagem_erro'))
    } else {
      dados(read.csv(input$file$datapath))
      mensagem_erro(NULL)
      shinyjs::hide('mensagem_erro')
    }
  })
  
  output$mensagem_erro <- renderText({
    mensagem_erro()
  })
  
  output$tabela <- renderDT({
    req(dados())  # Garante que dados() não seja NULL
    datatable(dados(), options = list(
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
