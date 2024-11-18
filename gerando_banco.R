require(dplyr)
require(tidyr)
require(ggplot2)
require(geobr)


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

write.csv(db, 'data/banco1.csv', row.names=F)


# lendo estados
states <- read_state(year=2010, showProgress=F, simplified=T)

no_axis <- theme(axis.title=element_blank(),
                 axis.text=element_blank(),
                 axis.ticks=element_blank()) + 
  theme_void()

if (input == 'All') a <- 1:5 else a <- input
states |> filter(code_region %in% a) |>
  ggplot() +
  geom_sf(fill='#2D3E50', color='#FEBF57', size=.15, show.legend=F) +
  no_axis




