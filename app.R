# packages
library(shiny)
library(geobr)
library(DT)

# carregando mapa para poupar tempo
states <- readRDS('grafico/states.RDS')
db <- read.csv('data/banco1.csv')

ui <- fluidPage(
    # titulo
    titlePanel('TESTE'),
    
    column(3,
           selectInput(inputId = 'estado',
                       label = 'Escolha o Estado:',
                       choices = c('All', sort(unique(db$name_state)))),
           selectInput(inputId = 'regiao',
                       label = 'Escolha a Região:',
                       choices = c('All', c('a'=1, 'b'=2)))
           # selectInput(inputId = 'variavel',
           #             label = 'Escolha a variável:',
           #             choices = NULL)
    ),
    
    # sidebarLayout(
    #     sidebarPanel(
    #         fileInput('file1', 'Escolha o arquivo:',
    #                   accept = c('.csv'))
    #     )),
    
    # mainPanel(
    #     tableOutput('mostra_banco') # exibe o banco de dados
    # ),
    
    column(6,
           dataTableOutput(outputId = 'tabela')
    ),
    
    textOutput('text')
    
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
    
    output$tabela <- renderDT(
        if (input$estado == 'All') db
        else db[db$name_state == input$estado,],
                              options = list(
                                  pageLength = 5, # número inicial de entradas exibidas
                                  lengthMenu = c(5, 10, 15, 20, 27) # opções para o usuário
                              )
    )
    
    renderText(input$regiao)
    
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
