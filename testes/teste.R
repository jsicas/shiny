library(shiny)

ui <- fluidPage(
  titlePanel("Botão na Parte Inferior"),
  
  sidebarLayout(
    sidebarPanel(
      style = "display: flex; flex-direction: column; height: 100vh;",  # Configuração de layout
      fileInput("file", "Carregar Arquivo Personalizado", accept = ".csv"),
      div(style = "margin-top: auto;",  # Empurra o botão para o final
          actionButton("load_file", "Carregar Arquivo Padrão")
      )
    ),
    mainPanel(
      tableOutput("contents")  # Exibe os dados
    )
  )
)

server <- function(input, output) {
  # Reativo para armazenar os dados carregados
  dados <- reactiveVal()
  
  # Carregar o arquivo pré-definido ao clicar no botão
  observeEvent(input$load_file, {
    arquivo_padrao <- "caminho/do/seu/arquivo.csv"  # Insira o caminho do arquivo aqui
    if (file.exists(arquivo_padrao)) {
      dados(read.csv(arquivo_padrao))  # Lê o arquivo e atualiza os dados
    } else {
      showNotification("Arquivo não encontrado!", type = "error")
    }
  })
  
  # Carregar arquivo personalizado quando selecionado pelo usuário
  observeEvent(input$file, {
    req(input$file)
    dados(read.csv(input$file$datapath))  # Lê o arquivo carregado pelo usuário
  })
  
  # Renderizar os dados carregados
  output$contents <- renderTable({
    req(dados())  # Garante que os dados existam
    dados()
  })
}

shinyApp(ui, server)
