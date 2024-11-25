
# Aplicação Shiny: Brasil por Estado e Regiões

Recursos:

- Falar que o mapa já foi pre-carregado (pasta `./grafico/`), deixando
  seu arquivo no projeto, já que instalá-lo demorava alguns segundos;
- pasta `./data/` apresenta 3 bancos de dados `banco_exemplo.csv` (é ele
  que é carregado ao apertar no botão `carregar exemplo`),
  `banco_não_csv.tsv` (banco utilziado para validar o que ocorre ao
  tentar carregar aquivo que não é csv) e `banco_de_dados.csv` (uma
  alternativa de banco de dados, como se fosse o banco de dados da
  pessoa);
- tabela inicial (generalizar valores por meio do YAML)
- Gráfico de mapa;
- Precisa ter uma coluna com o código do estado chamada `code_state` e
  `code_region` (generalizar por meio do YAML);
- Leitura de um banco de dados em csv (colocar aviso caso o banco não
  seja csv);
- Banco exemplo, para o primeiro uso
- Todas as variáveis do banco precisam ser numéricas, usar o arquivo
  YAML para configurar variáveis a serem retiradas;
- Quando já há dados carregados e aperta-se para carregar os dados do
  exemplo, aparece uma caixa de dialogo pergutnando ao usuários se ele
  quer sobrescrever os dados;
- ao tentar carregar dados, se for CSV o botão pisca verde e aparece uma
  confirmação, se não for csv o botão pisca vermelho e aparece um aviso;
- Não esquecer de excluir a pasta `./testes/`;
- Colocar url para acessar o shiny desenvolvido pelo shiny app
  (<https://jsicas.shinyapps.io/shiny/>);
- `./configuracoes/` tem dois arquivos `config.yaml` responsável por
  passar algumas configurações adicionais, como colunas a serem
  ignoradas no selectInput e `configuracoes_iniciais.R` que carrega
  todos os pacotes necessários, lê o arquivo de configurações e
  pre-carrega os mapas para gerar o gráfico de mapa mais rápido.
- no arquivo yaml deve ser passado qual coluna tem a informação do
  código do estado, padrão é code_state;



# **Introdução**

A aplicação `nome` foi desenvolvida utilizando o framework Shiny, com o objetivo de realizar a análise e visualização de dados relacionados às unidades federativas brasileiras. Ela permite que o usuário carregue seus próprios bancos de dados e visualize as informações através de tabelas, gráficos e mapas interativos. Além disso, a aplicação oferece funcionalidades de filtragem por região e seleção de variáveis, aplicadas a todas as visualizações de forma integrada.

---

## **Mapa**

O mapa do Brasil foi pré-carregado através do pacote `geobr` e armazenado na pasta `./grafico` para otimizar o tempo de inicialização da aplicação, uma vez que a instalação do pacote pode ser demorada. Esse pré-carregamento permite que a geração de mapas seja rápida e eficiente, mesmo em ambientes com restrições de desempenho.

---

## **Configurações**

### **Requisitos para o Banco de Dados**
- A aplicação permite o **upload de arquivos no formato CSV**. Caso o arquivo enviado não seja um CSV, uma mensagem de erro será exibida.
- O banco de dados deve conter **apenas variáveis numéricas** para as análises.
- Duas colunas são obrigatórias para o funcionamento correto da aplicação:
  - `code_state`: Código oficial do estado brasileiro (IBGE).
  - `code_region`: Código que identifica a região à qual o estado pertence.

### **Configurações Personalizáveis**
- O nome das colunas obrigatórias (`code_state` e `code_region`) pode ser alterado no arquivo `config.yaml`, localizado na pasta `./configuracoes`.
- Colunas adicionais que não sejam relevantes para as análises podem ser ignoradas ao serem listadas no mesmo arquivo `config.yaml`.

### **Bancos de Dados de Exemplo**
Três bancos de dados são disponibilizados na pasta `./data`:
1. **`banco_exemplo.csv`**:
   - Carregado ao clicar no botão `Carregar exemplo`.
2. **`banco_nao_csv.tsv`**:
   - Pode ser usado para testar a validação de arquivos não compatíveis.
3. **`banco_de_dados.csv`**:
   - Simula um banco de dados alternativo para uso do usuário.

> **Nota**: As abas da aplicação só serão exibidas após o carregamento bem-sucedido de um banco de dados.

---

## **Visualização**

A aplicação oferece diferentes formas de visualização dos dados carregados:

### **1. Tabela**
- Exibe todas as variáveis do banco de dados carregado.
- **Funcionalidades**:
  - Ordenação e busca.
  - Ocultação de observações.

### **2. Gráfica**
- Permite visualizar distribuições e padrões das variáveis através de dois tipos de gráficos:
  - **Histograma**: Distribuição de frequência de uma variável numérica.
  - **Boxplot**: Resumo estatístico de uma variável.
- Os gráficos podem ser baixados utilizando o botão `Baixar gráfico`.

### **3. Geográfica**
- Apresenta um mapa do Brasil com a variável selecionada aplicada aos estados.
- As cores no mapa refletem os valores das variáveis por estado.
- O mapa gerado pode ser baixado utilizando o botão `Baixar gráfico`.

---

## **Filtragem**

- A aplicação permite filtrar os dados por região utilizando botões de opção.
- As regiões disponíveis são:
  - **Norte**, **Nordeste**, **Centro-Oeste**, **Sudeste** e **Sul**.
- A filtragem afeta todas as visualizações: tabela, gráficos e mapa.

---

## **Funcionalidades Adicionais**

- **Mensagens de Feedback**:
  - Arquivos CSV válidos:
    - Botão pisca **verde** e uma mensagem de sucesso é exibida.
  - Arquivos inválidos:
    - Botão pisca **vermelho** e uma mensagem de erro é exibida.
- **Confirmação para Sobrescrita**:
  - Ao tentar carregar o exemplo sobre dados já carregados, uma mensagem de confirmação é exibida.

---

## **Acesso**
A aplicação está disponível no ShinyApps.io no seguinte link:

[https://jsicas.shinyapps.io/shiny/](https://jsicas.shinyapps.io/shiny/)
