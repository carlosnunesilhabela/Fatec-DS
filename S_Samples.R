# ____________________ Introdução à linguagem R ______________________________________________ ----
# Tudo no R  é um objeto;

'Hello R Word'

# Declaração ----
meu_primeiro_objeto <- 15
vetor <- 2

15 + 2 #é o mesmo que:

meu_primeiro_objeto + 2


# operadores da linguagem R: ----
{
  2 + 2   #soma
  3 - 1   #subtração
  4 * 5   #multiplicação
  12 / 3  #divisão
  7 ^ 2   #exponenciação
  seq <- 0:100   #sequências
  
  3 == 3  #comparação de igualdade
  5 != 0  #comparação de diferenças
  2 > 9   #maior do que
  1 < 8   #menor do que
  5 >= 5  #maior ou igual
  4 <= 1  #menor ou igual
}

# Com o R, há que se haver o cuidado sobre o desejo de se sobrescrever objetos.

meu_primeiro_objeto <- 160

# Em nível de código, o R nunca vai te perguntar sobre a certeza de se querer fazer algo. 
# Atenção a isso!

# Também podemos guardar valores textuais em objetos:

nome <- rafael #errado

nome_1 <- "rafael" #correto

# Guardar valores lógicos (booleano) resultantes de uma comparação (True or False) ----

verdadeiro <- nome_1 == nome_2

verdadeiro 


falso <- nome_1 != nome_2

falso


# Valores lógicos importantes:

TRUE
T
FALSE
F
NULL
NA #Not Avaliable
Inf
-Inf

# Vetores (matriz de uma unica coluna) ----
# Podemos guardar bases de dados inteiras em objetos, porém, antes, devemos
# pensar sobre como guardar mais de uma informação em um objeto.


vetor <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)


lista <- c("mariana", "pedro", "daniela")


# Funções Nativas (ou provindas de pacotes) -------------------------------

# Funções são tipos especiais de objetos no R, cujo nome vem seguido de parêntesis. 
# Equivalem a ordens diretas à máquina.
# Funções são algoritmos. Cada algoritmo possui suas próprias atribuições e carrega dentro de si seu processo decisório. 

round(x = 3.141592)

round(x = 3.141592, digits = 3)

# Como saber quais os argumentos de uma dada função?

?round

vetor <- c(1,2,3,4)

# Coerção ----
# QUando guardado objetos numéricos e textuais num único objeto. 

nomes_e_idades <- c("mariana", 22, "pedro", 30, "daniela", 45)

nomes_e_idades

# Todas as observações internas ao objeto criado viraram textos, certo?
# Isso se chama coerção. Podemos comprovar com a função class():

class(nomes_e_idades)
class(meu_primeiro_objeto)
class(TRUE)


# Há uma hierarquia básica de valores no R, e é a seguinte: valores 
# textuais > valores numéricos > valores lógicos. Vamos expandir o exemplo
# da seguinte forma:

teste <- c("laranja", 230, FALSE)

teste

class(teste)

#Coerção para valores numericos

outro_teste <- c(12, 37, FALSE, TRUE, FALSE, TRUE, TRUE, TRUE, TRUE)

outro_teste

class(outro_teste)


# Os valores lógicos utilizados foram transformados em números, seguindo
# o padrão 0 para FALSE e 1 para TRUE. Diferentemente seria se utilizás-
# semos os valor lógico NA. O valor NA significa Not Available, e é como 
# o R explicita os missing values.

missings <- c(12, 37, FALSE, TRUE, FALSE, TRUE, TRUE, TRUE, TRUE, NA)

missings


# Variáveis categóricas (funçao factor) --------------------------------------------------

# O R identifica suas variáveis categóricas como pertencentes à classe factor. 
# Vamos criar um objeto que contenha o seguinte exemplo de variá-
# vel categórica policotômica:

tipo_sanguineo <- c("A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-")

tipo_sanguineo

class(tipo_sanguineo)

# Factor = categorização 

tipo_sanguineo <- factor(tipo_sanguineo)

tipo_sanguineo

class(tipo_sanguineo)

# Para a utilização dos valores declarados em técnicas direcionadas a 
# variáveis nominais, o procedimento acima basta e está completo.

# Para o caso de variáveis ordinais, o trabalho deve ser estendido. Vamos
# criar um objeto com novas categorias:

nivel_escolarizacao <- c("fundamental", "médio", "graduação")

nivel_escolarizacao

class(nivel_escolarizacao)

# Utilizando a função factor():

nivel_escolarizacao <- factor(nivel_escolarizacao)

class(nivel_escolarizacao)

nivel_escolarizacao

# Observem os levels. Não é essa a ordem comumente aceita. Como faremos
# para o R entender a ordem fundamental, médio, graduação?

# A resposta está na expansão da argumentação da função factor():

nivel_escolarizacao <- factor(nivel_escolarizacao,
                              levels = c("fundamental",
                                         "médio",
                                         "graduação"))

class(nivel_escolarizacao)

nivel_escolarizacao


# E se tivéssemos recebido uma base de dados cujos rótulos para as 
# categorias fossem números? Vamos assumir o exemplo de que em dada base
# o valor "0" equivale a "não"; o valor "1" equivale a sim; e o valor
# "99" equivale a "talvez".

respostas <- c(0, 1, 1, 1, 99, 0, 99, 0, 0, 0, 1, 99)

respostas

class(respostas)

# Transformando em categorias:

respostas <- factor(respostas)

respostas

class(respostas)

# Explicando para o R os novos rótulos, incluindo um sentido de ordem (não,
# talvez, sim):

respostas <- factor(respostas,
                    levels = c(0, 99, 1),
                    labels = c("não", "talvez", "sim"))

class(respostas)

respostas


# Juntando objetos para a criação de bases de dados -----------------------

empresas <- c("Empresa A", NA, "Empresa C", "Empresa D", "Empresa E")
funcionarios <- c(100, 5000, 230, 12000, 1700)
presenca_bolsa <- c(F,T,NA,T,T)
sede_brasil <- c(NA,0,1,0,0)
diretor_executivo <- c(NA,"daniel","carlos","carla","solange")

#Antes de juntarmos os vetores, devemos verificar se seus comprimentos são
#iguais:

length(empresas)
length(funcionarios)
length(presenca_bolsa)
length(sede_brasil)
length(diretor_executivo)

dados <- data.frame(empresas, funcionarios, presenca_bolsa, 
                    sede_brasil, diretor_executivo)


dados

View(dados)

#Os nomes dos vetores criados e posteriormente unidos pela função 
#data.frame() serão os nomes das variáveis da nova base de dados. Assim, 
#poderíamos propor outros nomes da seguinte maneira:

dados <- data.frame(companies = empresas, 
                    employees = funcionarios, 
                    stock_exchange = presenca_bolsa, 
                    brazil_hq = sede_brasil, 
                    ceo = diretor_executivo)

dados

View(dados)


# Salvando objetos carregados no R ----------------------------------------

# Para salvar objetos, independentemente de sua classe (e.g. gráficos, bases
# de dados, modelos de machine learning, arquivos pdf, arquivos do Microsoft
# Office, etc.), podemos utilizar a função save():

save(dados, file = "dados.RData")

# Caso quiséssemos carregar os objetos salvos num outro momento, deveríamos
# utilizar a função load(). Exemplo: load("dados.RData").


# Carregando objetos de extensão *.RData 

load("spam.RData")


# Carregando arquivos formato .csv -----------------

# Para carregar um arquivo *.csv, podemos, por exemplo:

library(readr)

bicicletas <- read_delim(file = "bicicletas.csv",
                         delim = ";", 
                         escape_double = FALSE, 
                         trim_ws = TRUE)

#Caso quiséssemos salvar o nosso data frame 'dados' em formato *.csv:
write.csv(dados, file = "dados.csv", row.names = FALSE)

#
#
#
# Para carregar um arquivo do tipo *.xlsx: ----
library(readxl)
stricto_2018 <- read_excel("stricto_2018.xlsx")

#Caso quiséssemos salvar o nosso data frame 'dados' em formato *.xlsx

install.packages("writexl")

library(writexl)

write_xlsx(dados, "dados.xlsx")

#
#
#
# Para carregar uma base de dados do SPSS / Stata: ----

library(haven)

bolsa_estudos <- read_sav("bolsa_estudos.sav")

#Caso quiséssemos salvar o nosso data frame 'dados' em formato *.sav
write_sav(dados, "dados.sav")

#
#
#
#Para carregar uma base de dados do Stata:
vestibular <- read_dta("vestibular.dta")

#Caso quiséssemos salvar o nosso data frame 'dados' em formato *.dta
write_dta(dados, "dados.dta")

write_sas(dados, "dados")

# Podemos, inclusive, carregar bases de dados disponibilizadas on-line:

# Importando os dados de 210 países sobre a COVID19
covid <- read.csv("https://opendata.ecdc.europa.eu/covid19/casedistribution/csv", 
                  na.strings = "", 
                  fileEncoding = "UTF-8-BOM")



# Introdução à manipulação de dados ---------------------------------------

# Há algumas bases de dados interessantes já armazenadas no R compiladas em
# um pacote chamado 'datasets'

# Para ver a documentação ou buscar ajuda a respeito de algum pacote:

help(package = "datasets")

# Para carregarmos uma base de dados interna, utilizamos a função data():

data("mtcars")

# Para melhor entendermos o que há na base de dados chamada 'mtcars', pode-
# mos comandar o seguinte:

?mtcars

# Se você está aqui é porque se interessa por dados, e pode ser que as bases de
# dados que você utiliza sejam extensas! Assim, por enquanto, vamos dar
# preferência às funções head() e tail() no lugar da função View():

head(x = mtcars)
tail(x = mtcars)

head(mtcars, n = 1)
tail(mtcars, n = 10)

# Outra função interessante é a função str():

str(mtcars)

# Também podemos obter informações a respeito do número de linhas e de colu-
# nas da base de dados com as funções nrow(), ncol() e dim():

nrow(mtcars)
ncol(mtcars)
dim(mtcars)

# Podemos, ainda, ter acesso aos nomes das variáveis da base de dados com o
# auxílio da função names():

names(mtcars)


rm() # Removendo o objeto - # Deletar da base de dados do nosso ambiente de trabalho com a função
rm(mtcars)   #Exemplo

gc( ) #  (Garbage Collection) Otimizando o uso de memória na sessão de R

data("mtcars") # Carregar base de dados mtcars (base de exemplos)

#Podemos acessar uma variável da nossa base de dados com o operador $:
mtcars$mpg
mtcars$cyl

#Também podemos acessar uma variável com o uso do operador [ , ]:
mtcars[, 10]

#Há, ainda, a função attach() que facilita bastante!
attach(mtcars)
gear
detach(mtcars)

#Podemos acessar as observações com o uso semelhante do operador [ , ]:
mtcars[1, ]

#Assim, é possível acessar valores específicos ao combinarmos o aprendido:
mtcars[2, 1]
mtcars[4, 5]

#Podemos, ainda, combinar as posições com o nome das variáveis:
mtcars[1, "mpg"]

#Não podemos, porém, comandar o seguinte:
mtcars[, "mpg" : "disp"]

#E agora? A declaração abaixo funcionará?
mtcars[ ,c("mpg", "cyl", "disp")]

#Outra forma interessante de seleção de valores:
mtcars[, -c(3:11)]


# Criando e excluindo variáveis em uma base de dados ----------------------

#O operador $ também é útil para criarmos variáveis:
mtcars$var_nova <- NA

head(mtcars)

#Ainda para criarmos variáveis, poderíamos declarar o seguinte:
mtcars["nova_var"] <- NA

head(mtcars)

#Para excluir uma coluna de nossa base de dados, utilizamos o valor lógico NULL:

mtcars$var_nova <- NULL

head(mtcars)

mtcars$nova_var <- NULL

head(mtcars)


# Editando valores das observações ----------------------------------------

#Há várias formas de editar os valores de uma base de dados. Propomos três que
#julgamos mais relevantes: as funções gsub(), replace() e edit():

#A função gsub() - Suponhamos que se queria mudar o valor da célula [1,1] da
#base de dados mtcars de 21.0 para 82.0. Então:

mtcars[1, 1] <- gsub(x = mtcars[1, 1],
                     pattern = 21.0,
                     replacement = 82.0)

mtcars[1, ]

#A função replace():
mtcars$mpg <- replace(mtcars$mpg, mtcars$mpg == 82, 777)
mtcars

#A função edit() - Suponhamos que se queira desfazer a última alteração, 
#isto é, mudar o valor 82.0 para 21.0 da célula [1,1] da base mtcars:

mtcars <- edit(mtcars) #Utilizar o mouse e o teclado

mtcars[1, ]

# Download dados abertos

# https://transparencia.tce.sp.gov.br/sites/default/files/csv/receitas-sao-sebastiao-2025.zip
# https://transparencia.tce.sp.gov.br/sites/default/files/csv/despesas-sao-sebastiao-2025.zip

tipo  <- "receitas"
mun   <- "sao-sebastiao" 
ano   <- "2025"
df_name_zip <- "receitas-sao-sebastiao-2025.zip"
df_name_csv <- "receitas-sao-sebastiao-2025.csv"

url_baixar <- paste0("https://transparencia.tce.sp.gov.br/sites/default/files/csv/", tipo, "-", mun, "-", ano, ".zip",sep = "")
url_baixar

download.file(url_baixar, df_name_zip)               #traz para meu diretorio (vem zipado)
unzip(df_name_zip, files = df_name_csv)              #Unzipa 


# Funções if, else e ifelse -----------------------------------------------

#if() e else - exemplos:

vetor <- 2

if(vetor > 1){
  print("oi!")
}

#Porém:
if(vetor > 5){
  print("oi!")
}

#O R não respondeu nada. Por quê?

#Corrigindo:
if(vetor > 5){
  print("oi!")
} else {
  print("voltei!")
}

#Entendendo como o R 'pensa':

vetor <-  7

if(vetor > 8){
  print("O objeto é maior do que 8")
}else if(vetor > 7){
  print("O objeto é maior do que 7")
}else if(vetor > 6){
  print("O objeto é maior que 6")
}else if(vetor > 5){
  print("O objeto é maior do 5")
} else {
  print("O objeto é maior do que 4")
}

#ifelse() - exemplo:

ifelse(vetor == 7, 
       yes = "o objeto é igual a 7", 
       no = "o objeto é diferente de 7")


# Funções iterativas ------------------------------------------------------

#A função for():

y <- 10

for(i in 1:5){
  print(y + i)
}

#De onde veio o i? Você consegue entender o que ocorreu?

#Não há a necessidade de se trabalhar apenas com números! Exemplo:

vetor_regioes <- c("norte", "nordeste", "sudeste", "sul", "centro-oeste")

for(regiao in vetor_regioes){
  print(regiao)
}

#A função while():

z <- 0

while(z < 10){
  print(z)
  z <- z + 1
}

#A função repeat

w <- 3

repeat{
  print(w)
  w <- w + 2
  if(w > 18) break()
}

# Limpa console ----
cat("\014") 

# _________________________________Samples de códigos_______________________________ ----


# Função configurações ----
configs()

# Carrega Pacotes ----
{ load_packages() # Função criada por CRNunes que carrega todos pacotes da Tabela Pacotes
  
  library(tidyverse)  #pacote para manipulacao de dados
  library(cluster)    #algoritmo de cluster
  library(dendextend) #compara dendogramas
  library(factoextra) #algoritmo de cluster e visualizacao
  library(fpc)        #algoritmo de cluster e visualizacao
  library(gridExtra)  #para a funcao grid arrange
  library(readxl)
  library(ggplot2)
  library(stringr)
  library(dplyr)
  library(sparklyr)
  library(writexl)
  library(readxl)
}

# lista variáveis  do Environment ----
ls() 

# Remove ----
rm (a) # remove arquivos e variáveis do Environment
rm (List = ls()) # remove todos arquivos e variáveis do Environment

# Cria um vetor ----
x <- c(1:5)

matriz <- matrix(df_ln, nrow=3, ncol=3)


# Load/save - Carrega e Grava arquivos no formato RData ----
{ load("data.RData") # To load the data again
save(data1, file = "data.RData") # Saving on object in RData format
save(data1, data2, file = "data.RData") # Save multiple objects
save.image(file = "meu_espaco_de_trabalho.RData") # Salvar todo o espaço de trabalho
}

# Referencia função de um determinado pacote - pacote::funcao (Utiliza-se 2 pontos duplos) ----

# Read / Write .csv ----
receitas_acum <- read.csv(file = "Orçamento_Publico/receitas_vazia.csv", 
                          sep = ";", 
                          header = TRUE,
                          encoding = "latin1" )

# outra alternativa com o pacote utils
rec <- utils::read.table("receitas_vazia.csv", header = TRUE,
                         sep = ";", dec = ",")
utils::write.csv(dados, file = "/Users/Eugenia/MQ/dados.csv") 

# Read / Write .xlsx ----
{ Arquivo <- read_xlsx("Info_Mun.xlsx", sheet = 1, skip = 1, col_names = columns); 
    writexl::write_xlsx(ABT, "ABT_MDR_PNUD.xlsx")  }
  
# Stardardização de campos  ----
{ fild1 <- tolower(fild1)       # coloca tudo em lowercase - para Uppercase seria toupper(str_origem) 
  fild1 <- rm_accent(fild1)     # Remove todas acentuações 
  fild1 <- str_replace_all(fild1, "[^[:alnum:]]", "")  # remove non alphanumeric characters
}

# Junta (Append) dataframes (roll bind) ----
{  
 df_total <- rbind.data.frame(df1, df2) } 

# juntando dados (col bind) ----
{ municipios2 <- read.table("dados/municipios.csv", sep = ";", header = T, dec = ",")
municipiosfit <- data.frame(municipios.k6$cluster)

# Agrupar cluster e base ----
MunicipioFinal <-  cbind(municipios2, municipiosfit)

# Rename de colunas ----
{ dados <- rename(dados, new_name = old_name)
  colnames(dados)[5] <- "sp"
  
  names(df_desp_mun_tidy)[2:3]<- c("desp_legislativa","desp_administracao")
  }

# transforma em tibble ----
{
  iris <- as_tibble(iris) # transformando em tibble (não é necessário)
}

# Sumarização ----
{ BCP_sum <- BCP %>% group_by(MÊS.COMPETÊNCIA, CÓDIGO.MUNICÍPIO.SIAFI) %>% 
  summarise(quantidade = n())
#Opções
  summarise(tempo_médio = mean(tempo),
          mínimo = min(tempo),
          máximo = max(tempo),
          contagem = n()) %>% 
  arrange(desc(máximo))
}  

# Vetores Factor (quando a Sequência importa) ----
# A resposta está na expansão da argumentação da função factor():

nivel_escolarizacao <- factor(nivel_escolarizacao,
                              levels = c("fundamental",
                                         "médio",
                                         "graduação"))

class(nivel_escolarizacao)
  
# Filtro de linhas ----
{  
  dataset_filtrado <- dataset2 %>%
    dplyr::filter(campo1 == 10 & (campo2 == "abc" | campo2 == "bcd"))
}  

# Cria time series (sequencia de datas) ----
{
times = seq(as.Date('2016-01-01'), as.Date('2017-08-01'),  #Ajustar
            by='month') }

# Join (pacote sparklyr) ----
{
shp_municipios_df <- shp_municipiossc_df %>% 
  sparklyr::left_join(dados_sc, by = "CD_GEOCMU")
}

# Baixar um arquivo diretamente da internet ----
{
download.file("https://www.gov.br/mdr/pt-br/centrais-de-conteudo/publicacoes/protecao-e-defesa-civil-sedec/lista_municipios_prioritarios_1972_anexos_I_e_II_20240606.pdf", "1403.2805.pdf", mode = "wb")
}

# Retirar notacao cientifica no R ----
{
  options(scipen = 999) }

# Concatenar campos ----
{ resultado <- paste("campo1"," - ", "campos2", sep="") }

# Padroniza variáveis (Z Score) ----
consumo_z <- scale(consumo[,-1])

# Seleciona colunas ----

consumo[,-2] #exceto segunda coluna
consumo[,2:3]


# Converte para numero para alfa e vice-versa ----
numero <- as.numeric(texto)
alfa <- stringr::str_pad(cadunico$CD_MUN,0)  # ou
RMVale$COD_MUN <- as.character(RMVale$COD_MUN)


# Tibbles ----

#Tibbles são data frames com ajustes que as deixam mais amigáveis a nós cientistas de dados. Elas são parte do pacote {tibble}. Assim, para começar a usá-las, instale e carregue o pacote.
install.packages("tibble")
library(tibble)
mtcar_tib <- as_tibble(mtcars)



# Classificar arquivos (arrange) ----
# Classifica de forma Crescente (padrão) pela coluna id_despesa
library(dplyr)
dataset_cassificado <- arrange(dataset, (campo1, desc(campo2))
despesas_ordenadas <- despesas %>% arrange(id_despesa) # default é asc - ou arrange(desc(id_despesa))

# Remove registros duplicados ----
{ 
  cod2 <-cod_[!duplicated(cod_[c("Cod_IBGE_Mun")]),]
}

# Sub strings ----
{
Sub_var <- substr(variavel, inicio, fim)) # veja que é diferente de outras linguagens que normalmente fornece o tamanho
}

# Rename de colunas ----
{
covid_sp <- covid_sp %>% 
  rename(data_sintomas = DT_SIN_PRI,
         municipio = ID_MN_RESI)
}

# Delete colunas ----
{
covid_sp <- covid_sp %>% select(-c(VACINA_COV,DT_EVOLUCA))
}

# Transforma todas as counas em numericas ----
{
df2 = as.data.frame(sapply(df,as.numeric)) #transforma todas colunas em numericas
}


# Sumarização de valores (agrupado por um campo)  ----
{
# ideal (mas não obrigatório) que o campo chave da sumarização seja CHAR
  
    tab_pagtos$Cod_Mun_IBGE <- stringr::str_pad(tab_pagtos$Cod_Mun_IBGE,0) # transforma cod ibge em char
  
    danos_sum <- mapa_danos %>% dplyr::group_by(Cod_Mun_IBGE) %>% 
    dplyr::summarise(Num_mortes_total         = sum (DH_MORTOS),
                     Danos_Humanos_total      = sum(DH_total_danos_humanos),
                     Danos_Materiais_total    = sum(DM_total_danos_materiais),
                     Valor_pago_2012_2024     = sum(Valor_Pago),
                     Num_ocorrencias_total    = n(),
                     num_anos_rep_total       = n_distinct(year(Data_Registro)))
    
}

# Instalar de fonte alternativa ao C-RAN ----
install.packages("Rserve",,"http://rforge.net")

# Ler uma sheet (aba) dentro do arquivo excel ----
print(excel_sheets(dir_dsn)) # verifica quais abas existem na planilha excel

despesas_acum <- read_xlsx(
  path = dir_dsn,
  sheet = "Despesas_Ilhabela_2025"           # opcional - ler uma aba específica de um arquivo excel
)

# if then else ----
if (a == 1) {
  x <- 0
} else {
  x <- 10
}

# Loopings ----

#A função while(): - repita enquanto

z <- 0

while(z < 10){
  print(z)
  z <- z + 1
}

#A função repeat

w <- 3

repeat{
  print(w)
  w <- w + 2
  if(w > 18) break()  #Cuidado: Sem break o processo entra em Looping
}

