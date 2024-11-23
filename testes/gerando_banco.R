require(dplyr)
require(tidyr)
require(ggplot2)
require(geobr)
require(readr)

# lendo estados
states <- read_state(year=2010, showProgress=F, simplified=T)

# leitura parcial dos dados
doses <- read.csv2('data/dosesAplicadas_2012.csv', nrows=27, skip=1, header=F,
                   col.names=c('estado', 'doses_aplicadas'), fileEncoding='latin1') |>
  separate(estado, sep=3, convert=T, into = c('code_state', 'name_state'))

mortalidade <- read.csv2('data/mortalidade_2012.csv', skip=4, header=F, nrows=27,
                         col.names=c('estado', 'obitos'), fileEncoding='latin1') |>
  separate(estado, sep=3, convert=T, into=c('code_state', 'name_state')) |>
  select(-'name_state')

natalidade <- read.csv2('data/nascimentos_2012.csv', skip=4, header=F, nrows=27,
                        col.names=c('estado', 'natalidade'), fileEncoding='latin1') |>
  separate(estado, sep=2, convert=T, into=c('code_state', 'name_state')) |>
  select(-'name_state')


pop <- read.csv2('data/popResidente_2012.csv', skip=4, header=F, nrows=27,
                 col.names=c('estado', 'pop_residente'), fileEncoding='latin1') |>
  separate(estado, sep=2, convert=T, into=c('code_state', 'name_state')) |>
  select(-'name_state')

db <- doses %>% 
  left_join(mortalidade, by='code_state') |> 
  left_join(natalidade, by='code_state') |>
  left_join(pop, by='code_state')

db$code_region <- states$code_region 

db <- db[,c('code_region', 'code_state', 'name_state', 'natalidade', 'doses_aplicadas',
       'pop_residente', 'obitos')]

db_teste <- db[,c('code_region', 'code_state', 'name_state', 'natalidade', 'obitos')]

write.csv(db, 'data/banco_de_dados.csv', row.names=F)
write.csv(db_teste, 'data/banco_exemplo.csv', row.names=F)
write_tsv(db, 'data/banco_nao_csv.tsv')


# graficos
no_axis <- theme_void() +
  theme(axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        plot.background = element_rect(fill = '#2d2d2d', color = NA),  # Fundo do painel
        panel.background = element_rect(fill = "transparent", color = NA)
  )

# pdf("mapa_brasil.pdf", width = 8, height = 8)  # Tamanho quadradostates  |>
states |>
  ggplot() +
  geom_sf(fill='#2D3E50', color='#FEBF57', size=.15, show.legend=F) +
  coord_sf(datum = NA) +
  no_axis
# dev.off()

ggplot(states) +
  geom_sf(fill = '#2D3E50', color = '#FEBF57', size = 0.15, show.legend = FALSE) +
  theme_void() +  # Tema sem eixos ou rótulos
  theme(
    axis.title = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    plot.background = element_rect(fill = '#2d2d2d', color = NA),  # Fundo do gráfico
    panel.background = element_rect(fill = '#2d2d2d', color = NA),  # Fundo do painel
    plot.margin = margin(0, 0, 0, 0)  # Remove margens
  )


ggplot(states) +
  geom_sf(fill = "lightblue", color = "black") +
  theme_void() +  # Remove eixos e grades
  theme(panel.background = element_rect(fill = "transparent", color = NA))



theme_set(
  theme_void() +
    theme(
      plot.background = element_rect(fill = "#2d2d2d",  color = "transparent"),  # Fundo do gráfico
      panel.background = element_rect(fill = "#2d2d2d",  color = "transparent")  # Fundo do painel
    )
)

ggplot(states) +
  geom_sf(fill = '#2D3E50', color = '#FEBF57', size = 0.15, show.legend = FALSE)

  theme_void() +  # Tema sem eixos ou rótulos

  theme(
    plot.background = element_rect(fill = "#2d2d2d", color = NA),  # Remove borda do gráfico
    panel.background = element_rect(fill = "#2d2d2d", color = NA),  # Fundo interno transparente
    plot.margin = margin(0, 0, 0, 0)  # Remove as margens extras
  )


