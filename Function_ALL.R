#____________________ Carrega funções auxiliares (CTLR+O - Descolapsar: CTLR+SHIFT+O) ______________
# Colapsar: 
# Função: configs ----

configs <- function() {

    library(readxl)
    library(dplyr)
  
    diretorio <- getwd()
    
   #localização das Bases históricas caso deseja-se juntar com a atual
   dir_desp_2014_2025 <- paste0(diretorio,"/Orçamento_Publico/Despesas-LN-2008-atual.xlsx")
   dir_rec_2014_2025  <- paste0(diretorio,"/Orçamento_Publico/Receitas-LN-2008-atual.xlsx")
   
  
   ### Define municipios de interesse            
   dir_rmvale <- paste0(diretorio,"/Tabelas/Municipios_RMVale.xlsx")
   lista_mun_rmvale <- read_excel(
                       path =  dir_rmvale,
                       sheet = "municipios_rmvale" ) # 39 municipios da RM_Vale
   
   lista_mun_rmvale <- lista_mun_rmvale |> 
                       filter(CD_SUB_REG == "SR5")
   
   lista_municipios <- lista_mun_rmvale$nm_mun       # separa apenas o nome do Municipio minusculo

  } #  FUNÇÃO: configs (configurações) 

#______________________________________________________________________________________________________________
# Função: load_packages ----
load_packages <- function() {
  
  install.packages(c('readxl', 'dplyr'))  # pacotes minimos para executar a função
  library('readxl')
  library('dplyr')
  
  pacotes_df <- read_xlsx("Tabelas/pacotes.xlsx")    #le planilha de pacotes e grava data frame
  pacotes_df <- filter(pacotes_df, carregar == "S")
  pacotes    <- as.vector( pacotes_df$pacote)
  
  pacotes_df$carregar
  
  
  print (pacotes)
  
  if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){ # retorna matriz pacotes ja instalados
    instalador <- pacotes[!pacotes %in% installed.packages()]   # isola os pacotes não instalados 
    for(i in 1:length(instalador)) {
      install.packages(instalador, dependencies = T)
      break()}
    sapply(pacotes, require, character = T) 
  } else {
    sapply(pacotes, require, character = T)  # opção: lapply(carregar, require, character.only = TRUE)   
  }
  
  # Observação:
  # O pacote rayshader que está no CRAN, no momento, possui alguns bugs. 
  # A versão que está no GitHub do autor do pacote já é mais funcional. Para instalá-la: (responder 3 na console)
  # devtools::install_github("tylermorganwall/rayshader")  #(só a primeira vez)
  # Para carregar o rayshader  (faz graficos tridimensionais - barras sobre o mapa)
  # library(rayshader)
  
} # FUNÇÃO: carrega pacotes

#______________________________________________________________________________________________________________

# Função: rm_accent (remove acentos)  ----
rm_accent <- function(str,pattern="all") {
  # FUNÇÃO: rm_accent - Remove acentuações
  # Rotinas e funções úteis V 1.0
  # rm.accent - REMOVE ACENTOS DE PALAVRAS
  # Função que tira todos os acentos e pontuações de um vetor de strings.
  # Parâmetros:
  # str - vetor de strings que terão seus acentos retirados.
  # patterns - vetor de strings com um ou mais elementos indicando quais acentos deverão ser retirados.
  #            Para indicar quais acentos deverão ser retirados, um vetor com os símbolos deverão ser passados.
  #            Exemplo: pattern = c("´", "^") retirará os acentos agudos e circunflexos apenas.
  #            Outras palavras aceitas: "all" (retira todos os acentos, que são "´", "`", "^", "~", "¨", "ç")
  if(!is.character(str))
    str <- as.character(str)
  
  pattern <- unique(pattern)
  
  if(any(pattern=="Ç"))
    pattern[pattern=="Ç"] <- "ç"
  
  symbols <- c(
    acute = "áéíóúÁÉÍÓÚýÝ",
    grave = "àèìòùÀÈÌÒÙ",
    circunflex = "âêîôûÂÊÎÔÛ",
    tilde = "ãõÃÕñÑ",
    umlaut = "äëïöüÄËÏÖÜÿ",
    cedil = "çÇ"
  )
  
  nudeSymbols <- c(
    acute = "aeiouAEIOUyY",
    grave = "aeiouAEIOU",
    circunflex = "aeiouAEIOU",
    tilde = "aoAOnN",
    umlaut = "aeiouAEIOUy",
    cedil = "cC"
  )
  
  accentTypes <- c("´","`","^","~","¨","ç")
  
  if(any(c("all","al","a","todos","t","to","tod","todo")%in%pattern)) # opcao retirar todos
    return(chartr(paste(symbols, collapse=""), paste(nudeSymbols, collapse=""), str))
  
  for(i in which(accentTypes%in%pattern))
    str <- chartr(symbols[i],nudeSymbols[i], str)
  
  return(str)
}  # FUNÇÃO: rm_accents - Remove acentuações

#______________________________________________________________________________________________________________
# Função: std_str (Padronização dos caracteres) ----
std_str <- function(str2) {
 
  str2 <- tolower(str2)                             # coloca tudo em lowercase - para Uppercase seria toupper(str_origem) 
  str2 <- rm_accent(str2)                           # Remove todas acentuações 
  str2 <- str_replace_all(str2, "[^[:alnum:]]", "") # remove non alphanumeric characters
  return(str2)
} # FUNÇÃO: std_str - Padronização dos caracteres especiais, uppercase, etc.
#______________________________________________________________________________________________________________


# Função: Download Despesas do TCE  - municípios da lista_mun_minusculas ----

download_despesas <- function(anos_f, lista_municipios_f) {
  
  library(dplyr)
  library(readxl)
  library(writexl)
  library(stringr)
  library(utils)
  library(tidyverse)
  
  getwd()
  
  tipo = "despesas"
  
  despesas_acum <- read.csv(file = "Orçamento_Publico/despesas_vazia.csv", 
                            sep = ";", 
                            header = TRUE,
                            encoding = "latin1" )
  
  # Opção para acumular as despesas baixadas em arquivo histórico
  # despesas_acum <- read_xlsx("Despesas-Ilhabela_2008-2022.xlsx") # opção para juntar base até 2022dados 
  
  for(ano in anos_f) {
    
    for(mun in lista_municipios_f) {
      
      print (paste("baixando", tipo, "de:", mun, "ano:", ano))
      
      url_baixar <- paste("https://transparencia.tce.sp.gov.br/sites/default/files/csv/", tipo, "-", mun, "-", ano, ".zip",sep = "")
      
      df_name_zip   <- paste(tipo, "-", mun, "-", ano, ".zip",     sep = "")
      df_name_csv   <- paste(tipo, "-", mun, "-", ano, ".csv", sep = "")
      df_name_pasta <- paste(tipo, "-", mun, "-", ano,             sep = "")
      
      download.file(url = url_baixar, 
                    destfile = df_name_zip,
                    mode = "wb")               #traz para meu diretorio (vem zipado)
      
      
      unzip(                                  #Unzipa   
        zipfile = df_name_zip,
        exdir = df_name_pasta)
      
      dir_csv <- paste(df_name_pasta, "/", df_name_csv, sep="")
      despesas <- read.csv(file = dir_csv, sep = ";", header = T, 
                           encoding = "latin1", dec = ",")
      
      
      # Cria Novas Colunas
      despesas$historico_std     <- ''
      despesas$categoria         <- ''
      despesas$subcategoria      <- ''
      despesas$eventos           <- ''
      despesas$selecao           <- ''
      despesas$otmu              <- ''
      
      despesas_vl <- filter(despesas, tp_despesa == "Valor Liquidado")
      
      despesas_acum <- rbind.data.frame(despesas_acum, despesas_vl)
      
      rm (despesas, despesas_vl)
      
      file.remove(df_name_zip)
      file.remove(df_name_pasta)
      
    }  # Fim do loop de município  
  }  # Fim do loop de ano
  
  despesas_acum$historico_std <- std_str(despesas_acum$historico_despesa)  # cria campo histórico padronizado (sem acentuação)
  
  colnames(despesas_acum) <- c('identificação da despesa detalhe',
                               'ano exercicio',
                               'municipio',
                               'Orgão',
                               'mês',
                               'mês extenso',
                               'tipo despesa',	
                               'Num. Empenho (interno)',	
                               'identificador despesa',
                               'destino da despesa (Fornecedor)',
                               'data emissao despesa',
                               'Valor',
                               'funcao de governo',
                               'subfuncao governo',
                               'codigo do programa',
                               'descrição do programa',	
                               'cód Ação',	
                               'descrição da acao',	
                               'Fonte de Recurso',	
                               'código da aplicacao fixo',	
                               'modalidade de licitação',
                               'Categoria Econômica e Descrição  da Despesa',	
                               'Histórico da despesa',
                               'historico_std',
                               'categoria',
                               'subcategoria',
                               'eventos',
                               'selecão',
                               'OTMU')
  
  
  dsname_Rdata <- paste(tipo, "-", "municipios", "-", ano, ".Rdata",sep = "")
  save(despesas_acum, file = dsname_Rdata) # grava resultado em formato RData
  
  dsname_xlsx <- paste(tipo, "-", "municipios", "-", ano, ".xlsx",sep = "")
  write_xlsx(despesas_acum, dsname_xlsx) #grava data frame em formato *.xlsx
  
} # FUNÇÃO: download_despesas TCE
# Função: Download de receitas do TCE-SP ----

download_receitas <- function(anos_f, lista_municipios_f) {
  
  library(readxl)
  library(writexl)
  
  tipo                <- "receitas"
  diretorio           <- getwd()
  
  nloop               <- 0
    
    for(ano in anos_f) { #Looping para baixar todos os anos e municipios recebidos no argumento da função
      
      for(mun in lista_municipios_f) { #Looping para baixar todos os municípios
        nloop   <- nloop +1
         
        url_baixar <- paste("https://transparencia.tce.sp.gov.br/sites/default/files/csv/", tipo, "-", mun, "-", ano, ".zip",sep = "")
        print (paste(nloop,"-baixando", tipo, "-", mun, "-", ano, url_baixar))
        
        # setar nome do arquivo .csv baixado 
        if (ano < "2018") {  #  após 2018 foi retirado o .zip
          df_name_csv   <- paste0(tipo, "-", mun, "-", ano, ".zip.csv")
        } else {
          df_name_csv   <- paste0(tipo, "-", mun, "-", ano, ".csv")  }
        df_name_zip   <- paste0(tipo, "-", mun, "-", ano, ".zip")
        df_name_pasta <- paste0(tipo, "-", mun, "-", ano)
        
        download.file(url_baixar, df_name_zip)               #traz para meu diretorio (vem zipado)
        unzip(df_name_zip, files = df_name_csv)              #Unzipa           
        
        receitas <- read.csv(file = df_name_csv, sep = ";", header = T, encoding = "latin1",dec = ",")
        
        if("data_atualizacao" %in% names(receitas)) {  # 2008 à 2017 tinha a coluna data de atlz - não serve para nada
            receitas$data_atualizacao <- NULL }
       
        if("ds_d1" %in% names(receitas))           { # a partir de 2022 essa colunas aparecem com outros nomes
           receitas <- rename( receitas,
                               ds_rubrica   = ds_d1,
                               ds_alinea    = ds_dd2,
                               ds_subalinea = ds_d3)  }
        
        if(!("ds_tipo" %in% names(receitas))) {
           receitas$ds_tipo <- ""   }    
        
        receitas <- receitas %>%
                    select(id_rec_arrec_detalhe,    ano_exercicio,    ds_municipio, 
                    ds_orgao,                mes_referencia,   mes_ref_extenso, 
                    ds_poder,                ds_fonte_recurso, ds_cd_aplicacao_fixo, 
                    ds_cd_aplicacao_variavel,ds_categoria,     ds_subcategoria, 
                    ds_fonte,                ds_rubrica,       ds_alinea, 
                    ds_subalinea,            ds_tipo,          vl_arrecadacao)
  
        if (nloop == 1) {
          if (exists("receitas_acum")) {
            rm(receitas_acum)
          }
          receitas_acum <- receitas
        } else {
          receitas_acum <- rbind.data.frame(receitas_acum, receitas)
        }
       
        #    remove arquivos temporários
             unlink(df_name_zip)
             file.remove(df_name_csv)
             print(paste("file deletado: ", df_name_csv))
             
      }  # Fim do loop de município  
    }  # Fim do loop de ano
    
    receitas_acum$Categoria  <- ''   #Cria nova coluna Categoria (uso futuro para categorização das receitas)
    receitas_acum$vl_arrecadacao  <- as.numeric(receitas_acum$vl_arrecadacao)
  
      colnames(receitas_acum) <-    #Rename nas colunas para terem nomes mais compreensíveis
      c('Identificação da Receita',	
        'Ano',	
        'Municipio',	
        'Orgão',	
        'Mês',	
        'Mês extenso',	
        'Poder',	
        'Fonte de Recurso',	
        'Código aplicacao fixo',	
        'Código aplicação variavel',	
        'Categoria Econômica',	
        'Sub Categoria',	
        'Fonte',	
        'Rubrica',	
        'Alínea',	
        'Sub Alínea',
        'tipo',
        'Valor arrecadacao',
        'Categoria')
    
    dsname_xlsx <- paste0(tipo, "-", "baixadas", ".xlsx")
    
    write_xlsx(receitas_acum, dsname_xlsx) #grava data frame em formato *.xlsx
    
    print(paste("Arquivo gravado - ", dsname_xlsx, " - num.linhas:", nrow(receitas_acum)))
  
} # FUNÇÃO download_receitas do TCE  - municípios da lista_mun_minusculas

# Função: Standardização do histórico das despesas (retira caracteres especiais, numeros e uppercase) ----

std_histdesp <- function(dsname) {
  
  # Lê o arquivo de dsname (despesas a ser trabalhado)
  
  # Colunas
  #27 - eventos
  #26 - subcategorias
  #25 - categoria
  #24 - historico_std
  #23 - historico_despesa
  
  despesas_acum <- read_xlsx(dsname)
  
  # Executa função de padronização (retorna msg de erro mas executa a função)
  despesas_acum$historico_std <- std_str(despesas_acum$historico_despesa)
  
  despesas_acum <-data.frame(despesas_acum)
  
  # save(despesas_acum, file = "Despesas_municipios.Rdata") # Salva em formato RData
  
  write_xlsx(despesas_acum, dsname) #grava data frame em formato *.xlsx
  
  
  return()
} # FUNÇÃO: std_histdesp - Padronização do historico das despesas