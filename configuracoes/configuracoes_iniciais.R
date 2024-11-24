# packages
library(shiny)
library(geobr)
library(ggplot2)
library(dplyr)
library(bslib)
library(DT)
library(shinyjs)
library(rsconnect)
library(yaml)

# pre-carregando mapa para poupar tempo
states <- readRDS('grafico/states.RDS')

# lendo condiguracoes adicionais
config <- read_yaml('configuracoes/config.yaml')