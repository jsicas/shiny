# Adicionar source
source('configuracoes/configuracoes_iniciais.R')

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
    card(card_header('Configurações'),
         radioButtons(
           'regiao',
           label = 'Região:',
           c(
             'Todas' = 0, 'Norte' = 1, 'Nordeste' = 2, 'Centro Oeste' = 5,
             'Sudeste' = 3, 'Sul' = 4
           )
         )
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
    nav_panel('Análise',
              fluidRow(
                column(9, plotOutput(outputId = 'grafico_analise')),
                column(3,
                       card(card_header('Configurações'),
                            selectInput('variavel', 'Selecione uma Variável:', choices=NULL,
                                        selectize = FALSE),
                            selectInput('tipo_grafico', 'Tipo do Gráfico:',
                                        choices=c('Histograma', 'Boxplot'),
                                        selectize = FALSE),
                            downloadButton('download_grafico', 'Baixar Gráfico',
                                           style = 'margin-top: 30px;'),
                       )
                )
              )
    ),
    nav_panel('Mapa',
              fluidRow(
                column(9, plotOutput(outputId = 'mapa')),
                column(3, 
                       card(card_header('Configurações'),
                            selectInput('variavel_mapa', 'Selecione uma Variável:',
                                        choices=NULL, selectize = FALSE),
                            downloadButton('download_mapa', 'Baixar Gráfico',
                                           style = 'margin-top: 30px;'),
                       ),
                )
              )
    )
  )
)

server <- function(input, output, session) {
  a <- reactive({  # usado para atulizar dependências da região (gráfico de mapa)
    if (input$regiao == 0) 1:5 else input$regiao
  })
  
  dados <- reactiveVal(NULL)  # variável reativa
  
  tema <- theme_minimal() +
    theme(panel.background = element_rect(fill='#2d2d2d'),
          plot.background = element_rect(fill='#2d2d2d', color='transparent'),
          # axis.title = element_text('white'),
          axis.title.x = element_text(color = 'white', size = 18),
          axis.text.x = element_text(color = 'white', size=14),
          axis.title.y = element_text(color = 'white', size = 18),
          axis.text.y = element_text(color = 'white', size=14)
    )
  
  grafico_analise <- reactive(
    switch(input$tipo_grafico,
           'Histograma' = dados() |> filter(code_region %in% a()) |>
             ggplot(aes(x = !!sym(input$variavel))) +
             geom_histogram(col='black', fill='turquoise') +
             labs(y = 'Contagem') +
             tema,
           'Boxplot' = dados() |>
             ggplot(aes(x = !!sym(input$variavel))) +
             geom_boxplot(col='white', fill='darkturquoise') +
             tema +
             theme(axis.text.y = element_blank(),
                   panel.grid.major.y = element_blank(),
                   panel.grid.minor.y = element_blank())
    )
  )
  
  cores <- c(
    '1' = '#408f70',    # Norte
    '2' = '#fe0000',    # Nordeste
    '3' = '#9091c9',    # Sudeste
    '4' = '#ff8c4d',    # Sul
    '5' = '#e6ec16'     # Centro-Oeste
  )
  
  mapa <- reactive({
    dados_filtrados <- states %>%
      filter(code_region %in% a())
    
    # Criar uma coluna de cores para os estados
    dados_filtrados$cor <- as.factor(dados_filtrados$code_region)
    
    dados_filtrados <- left_join(dados_filtrados, dados(),
                                 by=join_by('code_state' == !!sym(config$code_state)))
    
    ggplot(data = dados_filtrados) +
      geom_sf(aes(fill = cor), color = 'gray10', size = 0.15, show.legend = FALSE) +
      geom_sf_label(aes(label = paste0(abbrev_state, ': ', get(input$variavel_mapa))),
                    size = 3.5, alpha = 0.55) +
      theme_void() +
      scale_fill_manual(
        values = cores,
        breaks = names(cores)) +
      theme(plot.title = element_text(hjust = 0.5))
  })
  
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
      dados(read.csv('data/banco_exemplo.csv'))  # atualiza os dados reativos
      updateSelectInput(inputId = 'variavel',  # atualiza variaveis 
                        choices = names(dados())[!(names(dados()) %in% c(config$ignorar,
                                                                         config$code_state,
                                                                         config$code_region))])
      updateSelectInput(inputId = 'variavel_mapa',  # atualiza variaveis 
                        choices = names(dados())[!(names(dados()) %in% c(config$ignorar,
                                                                         config$code_state,
                                                                         config$code_region))])
    }
  })
  
  observeEvent(input$confirmar_exemplo, {
    removeModal()
    dados(read.csv('data/banco_exemplo.csv'))
    updateSelectInput(inputId = 'variavel',  # atualiza variaveis 
                      choices = names(dados())[!(names(dados()) %in% c(config$ignorar,
                                                                       config$code_state,
                                                                       config$code_region))])
    updateSelectInput(inputId = 'variavel_mapa',  # atualiza variaveis 
                      choices = names(dados())[!(names(dados()) %in% c(config$ignorar,
                                                                       config$code_state,
                                                                       config$code_region))])
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
      updateSelectInput(inputId = 'variavel',  # atualiza variaveis 
                        choices = names(dados())[!(names(dados()) %in% c(config$ignorar,
                                                                         config$code_state,
                                                                         config$code_region))])
      updateSelectInput(inputId = 'variavel_mapa',  # atualiza variaveis 
                        choices = names(dados())[!(names(dados()) %in% c(config$ignorar,
                                                                         config$code_state,
                                                                         config$code_region))])
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
    dados() |> filter(!!sym(config$code_region) %in% a()) |>
      datatable(options = list(
        pageLength = 5, # número inicial de entradas exibidas
        lengthMenu = c(5, 10, 15, 20, 27) # opções para o usuário
      ))
  })
  # aes(label=paste0(abbrev_state, ': ', qtd_state, '\n', qtd_state_percent, '%'))
  output$mapa <- renderPlot({
    req(dados())
    mapa()
  })
  
  output$grafico_analise <- renderPlot({
    req(dados())
    req(grafico_analise())
    grafico_analise()
  })
  
  output$download_grafico <- downloadHandler(
    filename = function() {
      paste0('grafico_', input$tipo_grafico, '.pdf')
    },
    content = function(file) {
      pdf(file=file)
      plot(grafico_analise())
      dev.off()
    }
  )
  
  output$download_mapa <- downloadHandler(
    filename = function() {
      paste0('mapa_', input$regiao, '.pdf')
    },
    content = function(file) {
      pdf(file=file)
      plot(mapa())
      dev.off()
    }
  )
}

shinyApp(ui = ui, server = server)
