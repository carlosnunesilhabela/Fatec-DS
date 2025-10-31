# SCRIPT: Baixa dados de receitas e despesas de diversos municípios x diversos anos

# Seção 0: Instala e/ou carrega pacotes ----
# Executar inicialmente as funções Funcion.ALL.R (Carrega todas as funçoes para o Environment) e download_despesas_TCE e download_receitas_TCE

# load_packages()

library(readxl)
library(writexl)
library(dplyr)
library(stringr)

configs()

# Seção 1: Define lista dos municipios a serem baixados (utilizar uma das opções abaixo) ----

lista_mun_rmvale <- read_xlsx("Tabelas/Municipios_RMVale.xlsx")   # 39 municipios da RM_Vale
lista_mun_rmvale <- dplyr::filter(lista_mun_rmvale, SELECAO == "S")
lista_municipios <- lista_mun_rmvale$nm_mun            # default = 39 municipios da rmvale
#                      ou
lista_municipios <- c("ilhabela") #, "ilhabela", "caraguatatuba", "sao-sebastiao", "ubatuba")

anos <- c("2008","2025") # 2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022", "2023", "2024")  # colocar nesta variável, todos os anos que pretende baixar
# anos <- readline(prompt = "Qual ano deseja baixar?: ")  # Opção: Digitar anos ou linha abaixo ou
# Fim do Bloco 1 

# Seção 2: Download - Atenção: para baixar arquivos da Web, certifique-se de estar conectado a uma rede WiFi ----
# set as variáveis abaixo ou check os valores no environment
    # anos_f             <- c("2018", "2019", "2020", "2021", "2022", "2023", "2024")  # colocar nesta variável, todos os anos que pretende baixar
    # lista_municipios_f <- "ilhabela"

download_receitas(anos, lista_municipios) #  grava o arquivo receitas_municio-ano.Rdata e xlsx
download_despesas(anos,lista_municipios)  #  grava o arquivo despesas_municio-ano.Rdata e xlsx
