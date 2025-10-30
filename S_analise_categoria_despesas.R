
# executar o script Function_ALL.R primeiramente (Cria as funções a serem utilizadas)dsname <- "Despesas-Ilhabela-2008-2023(out).xlsx" # Substituir DSN do arquivo de despesas a ser trabalhado 

library(dplyr)
library(readxl)
library(writexl)
library(stringr)
getwd()

dsname   <- "Despesas_Ilhabela_2025.xlsx"  # Substituir DSN do arquivo de despesas a ser categorizado
dir_dsn  <- paste0(getwd(),"/Orçamento_Publico/",dsname)

print(excel_sheets(dir_dsn)) # verifica quais abas existem na planilha excel

despesas_acum <- read_xlsx(
  path = dir_dsn,
  sheet = "Despesas_Ilhabela_2025" # opcional - ler uma aba específica
)

                  # Colunas:  
                  # Col V - Categoria Econômica e Descrição  da Despesa (ds_elemento) 
                  # Col W - Histórico da despesa (historico_despesa)
                  # Col X - historico_std
                  # Col Y - categoria
                  # Col X - subcategoria

dsname_words     <- "Tabelas/Lista_de_Keywords_para_categorizacao.xlsx"  # Substituir DSN
palavras_cat_lida <- read_excel(dsname_words)

{ #Repetir esse bloco para cada palavra
  
# Categorias disponíveis
categoria_sel <- #"Consultoria;" 
                 #"Desapropriações;"   
                 #"Ecoturismo;"
                 #"Mobilidade;"
                 #"Obras;"
                 #"OCA;"
                 #"Publicidade;"
                 #"Resíduos-Solidos;"
                  "Shows-e-Eventos;"
                 #"TPA;#
                 #"Pessoal;"
                 #"Segurança;"


palavras_cat = palavras_cat_lida  %>% filter(categoria == categoria_sel & Meio_Selecao == "Keyword")  
palavras_sel <- palavras_cat$Valor

# despesas_acum$categoria <- " "
num_ocorrencias <- 0

for (j in 1:nrow(despesas_acum)) {
  
  tem_evento = 0
  for (i in 1:length(palavras_sel)) {
   
    evento_sim <- str_detect(despesas_acum$historico_std[j], palavras_sel[i])  
    
    if (evento_sim) {
      tem_evento <- tem_evento +1
    }  # end if
    
  } # end for interno - busca de todas as palavras
  
  if (tem_evento > 0) {
    despesas_acum[j,25] <- paste(despesas_acum[j,25], categoria_sel, sep="")
    num_ocorrencias = num_ocorrencias + 1
    }
   
} #end for externo (Verifica se na linha tem historico com categoria)

print( paste("Número de ocorrências encontradas na categoria",categoria_sel,num_ocorrencias))

} #Repetir esse bloco para cada palavra

write_xlsx(despesas_acum, dsname) #grava data frame em formato *.xlsx
# file.remove(dsname)
# remove(despesas_acum)

# despesas_acum <- data.frame(despesas_acum)
# save(despesas, file = "Despesas_municipios.Rdata") # Salva em formato RData
