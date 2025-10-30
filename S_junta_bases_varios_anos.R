# Junta arquivo historio das despesas/receitas 
library(dplyr)
library(readxl)
library(writexl)
getwd()

{ ####### Bloco Junta datasets de despesas ############################################

  dsname   <- "Despesas_LN_2014-atual.xlsx"  # Substituir DSN do arquivo com as planilhas históricas 
  dir_dsn  <- paste0(getwd(),"/Orçamento_Publico/",dsname)
  
  Planilhas <- print(excel_sheets(dir_dsn))    # verifica quais abas existem na planilha excel
  nPlanilhas <- length(excel_sheets(dir_dsn))  # verifica quantas planilhas existem
  
  for(i in 1:nPlanilhas) {
     
    despesas_lidas <- read_xlsx(
                      path = dir_dsn,
                      sheet = Planilhas[i])
    
      despesas_lidas <- despesas_lidas %>%
      mutate(
        across(c(1:4, 6:10, 13:29 ), as.character),
        `mês` = as.Date(`mês`, format = "%m"), 
        `data emissao despesa` = as.Date(`data emissao despesa`, format = "%Y-%m-%d"),
        Valor = as.numeric(Valor)
      )
    
    print(paste("Planilha", Planilhas[i], " - Número de linhas: ", nrow(despesas_lidas)))
    
    # 1 - Despesas_Ilhabela_2025           13.012
    # 2 - Despesas_SaoSebastiao_2025       10.871
    # 3 - Despesas_Caragua_2014-2024      285.611
    # 4 - Despesas_Ilhabela_2014-2024     209.553
    # 5 - Despesas_SaoSebastiao_2014-2024 194.578
    # 6 - Despesas_Ubatuba_2014-2024      206.859
        
    if (i == 1) {
      despesas_acum <- despesas_lidas }
     else {
      despesas_acum <- bind_rows(despesas_acum, despesas_lidas)  # bind acumula arquivos de mesmo layout
    } #Fim if-else
  } # fim do looping for 
  
  print(paste("Número Total: ", nrow(despesas_acum))) 
  
  dir_Rdata <- paste0(getwd(),"/Orçamento_Publico/Despesas_LN_2014-atual.Rdata")
  save(despesas_acum, file = dir_Rdata) # grava resultado em formato RData
  
} ####### fim do bloco junta datasets de despesas


{ ####### Bloco Junta datasets de receitas ##############################################
  
  dsname   <- "Receitas-LN-2014-atual.xlsx"  # Substituir DSN do arquivo com as planilhas históricas 
  dir_dsn  <- paste0(getwd(),"/Orçamento_Publico/",dsname)
  
  Planilhas <- print(excel_sheets(dir_dsn))    # verifica quais abas existem na planilha excel
  nPlanilhas <- length(excel_sheets(dir_dsn))  # verifica quantas planilhas existem

  for(i in 1:nPlanilhas) {
    
    receitas_lidas <- read_xlsx(
      path = dir_dsn,
      sheet = Planilhas[i])
    
    receitas_lidas <- receitas_lidas %>%
      mutate(
        across(c(1:4, 6:17, 19 ), as.character),
        `Mês` = as.Date(`Mês`, format = "%m"), 
        `Valor arrecadacao`= as.numeric(`Valor arrecadacao`)
      )
    
    receitas_lidas$Seleção <- ""
    
    print(paste("Planilha", Planilhas[i], " - Número de linhas: ", nrow(receitas_lidas)))
    
    # 1 - Receitas_Ilhabela_2025           1.252
    # 2 - Receitas_SaoSebastiao_2025         986
    # 3 - Receitas_Caragua_2014-2024      16.106
    # 4 - Receitas_Ilhabela_2014-2024     17.240
    # 5 - Receitas_SaoSebastiao_2014-2024 18.782
    # 6 - Receitas_Ubatuba_2014-2024      22.529
    
    if (i == 1) {
      receitas_acum <- receitas_lidas }
      else {
        receitas_acum <- bind_rows(receitas_acum, receitas_lidas)  # bind empilha (apend) arquivos de mesmo layout
    } #Fim if-else
  } # fim do looping for 
  
  print(paste("Número Total: ", nrow(receitas_acum))) 
  
  dir_Rdata <- paste0(getwd(),"/Orçamento_Publico/Receitas_LN_2014-atual.Rdata")
  save(receitas_acum, file = dir_Rdata) # grava resultado em formato RData
  
}  ##### fim do bloco junta bases receitas
