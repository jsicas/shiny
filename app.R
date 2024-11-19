# packages
library(shiny)
library(geobr)
library(ggplot2)
library(dplyr)
library(bslib)
library(DT)
library(shinythemes)


# carregando mapa para poupar tempo
states <- readRDS('grafico/states.RDS')
# db <- read.csv('data/banco_exemplo.csv')


ui <- page_sidebar(
  titlePanel('Não sei o que colocar aqui'),  # titulo
  
  # shinythemes::themeSelector(),  # seletor de tema
  # theme = shinytheme('flatly'),  # tema
  
  # theme = bs_theme(
  #   bg = "#f5f5f5",  # Cor de fundo
  #   fg = "#000000",  # Cor do texto
  #   primary = "#0072af"  # Cor principal (botões, links, etc.)
  # ),
  
  sidebar = sidebar(
    style = 'display: flex; flex-direction: column; height: 100vh;',  # Config layout
    radioButtons(
      'regiao',
      'Região:',
      c(
        'Todos' = 0, 'Norte' = 1, 'Nordeste' = 2,
        'Centro Oeste' = 5, 'Sudeste' = 3, 'Sul' = 4
      )
    ),
    div(style = 'margin-top: auto;',  # Empurra o botão para o final
        actionButton('load_file', 'Carregar Exemplo')
    ),
  ),
  
  navset_card_underline(
    nav_panel('Tabela',
              fileInput('file', 'Escolha um arquivo CSV',
                        accept = c('.csv')),
              DTOutput(outputId = 'tabela')
    ),
    nav_panel('Plot', plotOutput(outputId = 'mapa'))
  )
)

server <- function(input, output, session) {
  a <- reactive({  # usado para atulizar dependências da  região
    if (input$regiao == 0) 1:5 else input$regiao
  })
  
  dados_filtrados <- reactive({input$load_file
    read.csv('data/banco_exemplo.csv')
  })
  
  # dados_filtrados <- reactive({
  #   req(input$file)  # Garante que o arquivo foi carregado
  #   verific <- any(colnames(read.csv(input$file, nrows=1)) %in% 'code_region')
  #   if (verific) read.csv(input$file$datapath) |> filter(code_region %in% a())
  #   else left_join(read.csv(input$file$datapath),
  #                  states[c('code_state', 'code_region')], by='code_state') |>
  #     filter(code_region %in% a())
  # })
  
  
  
  output$tabela <- renderDT(
    dados_filtrados(),
    options = list(
      pageLength = 5, # número inicial de entradas exibidas
      lengthMenu = c(5, 10, 15, 20, 27) # opções para o usuário
    )
  )
  
  
  output$mapa <- renderPlot({
    # if (input$regiao != 0) a <- input$regiao
    states |> filter(code_region %in% a()) |>
      ggplot() +
      geom_sf(fill='#2D3E50', color='#FEBF57', size=.15, show.legend=F) +
      theme(axis.title=element_blank(), axis.text=element_blank(),
            axis.ticks=element_blank()) +
      theme_void()
  })
  
  
  
  
  # leitura do banco de dados
  # leitura <- reactive({
  #     req(input$file1) # Verifica se um arquivo foi carregado
  #     read.csv(input$file1$datapath)
  # })
  
  # atualiza opções da caixa
  # observeEvent(leitura(), {
  # updateSelectInput(session, inputId = 'estado', 
  #                   choices = sort(unique(db$state_name)))
  # })
  
  # output$grafico <- renderPlot({
  #     hist(db$doses_aplicadas)
  # })
}

shinyApp(ui = ui, server = server)
