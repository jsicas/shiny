# Instalar e carregar pacotes necessários
required_packages <- c(
  "shiny", "geobr", "ggplot2", "dplyr", "bslib", "DT", "shinyjs", "rsconnect", "yaml"
)

for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
  library(pkg, character.only = TRUE)  
}

# pre-carregando mapa para poupar tempo
states <- readRDS('grafico/states.RDS')

# lendo condiguracoes adicionais
config <- read_yaml('configuracoes/config.yaml')