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
db <- read.csv('data/banco1.csv')

ui <- page_sidebar(
  # shinythemes::themeSelector(),  # seletor de tema
  # theme = shinytheme("flatly"),  # tema
  titlePanel('TESTE'),  # titulo
  
  sidebar = sidebar(
    
    radioButtons(
      'regiao',
      'Região:',
      c(
        'Todos' = 0, 'Norte' = 1, 'Nordeste' = 2,
        'Centro Oeste' = 5, 'Sudeste' = 3, 'Sul' = 4
      )
    ),
    # br(),
    # sliderInput(
    #   'n',
    #   'Number of observations:',
    #   value = 500,
    #   min = 1,
    #   max = 1000
    # )
  ),
  
  
  # column(3,
  #        selectInput(inputId = 'regiao',
  #                    label = 'Escolha a Região:',
  #                    choices = c('Todos' = 0, 'Norte' = 1, 'Nordeste' = 2,
  #                                'Centro Oeste' = 5, 'Sudeste' = 3, 'Sul' = 4))
  # selectInput(inputId = 'variavel',
  #             label = 'Escolha a variável:',
  #             choices = NULL)
  # ),
  # 
  # sidebarLayout(
  #     sidebarPanel(
  #         fileInput('file1', 'Escolha o arquivo:',
  #                   accept = c('.csv'))
  #     )),
  # 
  # mainPanel(
  #     tableOutput('mostra_banco') # exibe o banco de dados
  # ),
  
  navset_card_underline(
    nav_panel('Tabela', DTOutput(outputId = 'tabela')),
    nav_panel('Plot', plotOutput(outputId = 'mapa'))
  )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  a <- 1:5  # usado para atulizar dependências da  região
  
  output$tabela <- renderDT(
    db,
    options = list(
      pageLength = 5, # número inicial de entradas exibidas
      lengthMenu = c(5, 10, 15, 20, 27) # opções para o usuário
    )
  )
  
  
  # reactive(if (input$regiao == 'All') a <- 1:5 else a <- input$regiao)
  # a <- reactive(input$regiao)
  
  output$mapa <- renderPlot({
    if (input$regiao != 0) a <- input$regiao
    states |> filter(code_region %in% a) |>
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

# Run the application 
shinyApp(ui = ui, server = server)
