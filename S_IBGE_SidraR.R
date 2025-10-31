# Carregar pacotes
library(sidrar)   # Para baixar dados do IBGE
library(writexl)  # Para exportar para Excel
library(dplyr)    # Para manipulação e organização dos dados
library(tidyr)    # Função separate

# para confirar os parâmetros para a API
# Pesquisar a tabela desejada no site: https://sidra.ibge.gov.br/acervo#/S/Q (Opção acervo)
# Na opção Links a compartilhar, copiar a URL da API (Parâmetros para a API) 
# Manter apenas o conteúdo após a palavra 'values'

api_par <- "/t/9954/n1/all/n125/all/v/all/p/all/c2/all/c287/100362/c1/6795"

# Baixar a tabela do SIDRA
dados_ibge <- get_sidra(api = api_par)


# Organizar colunas (ajuste os nomes e seleção das colunas de interesse)
dados_ind_ibge_sp <- dados_ibge %>%
  select(`Nível Territorial`,
         `Variável`,
          Valor,
         `Brasil e Terra Indígena por Unidade da Federação`, 
          Ano,                    
          Sexo ) %>%
  rename(nivel_territorial = `Nível Territorial`,
         populacao = Valor,
         variavel = `Variável`,
         nome_terra_indigena_uf = `Brasil e Terra Indígena por Unidade da Federação`) %>%
  filter(nivel_territorial != "Brasil")   %>% # Excluir o nivel (total) nacional
  separate(
    col = nome_terra_indigena_uf,             # Coluna a ser dividida
    into = c("nome_terra_indigena", "uf"),    # Nomes das novas colunas
    sep = " - " ) %>%                         # O separador (neste caso, o hífen)
  filter(uf == "SP") 

nome_arquivo <- "Censo_Indigena_IBGE_2022.xlsx" # Nome do arquivo de saída

write_xlsx(dados_ind_ibge_sp, path = nome_arquivo) # Exportar para Excel
 
cat("\n✅ Dados baixados e exportados com sucesso para:", nome_arquivo ,"\n")


# Baixar tabelas com acima de 50 mil registros (dividir em partes)  ----
# cria o vetor das apis
vetor_api_sidra <- c('/t/4094/n1/all/n2/all/n3/all/n6/all/v/4096,4099,12466/p/all/c58/allxt/d/v4096%201,v4099%201,v12466%201',
                     '/t/4094/n1/all/n2/all/n3/all/n6/all/v/4104,4106,4108/p/all/c58/allxt/d/v4104%201,v4106%201,v4108%201',
                     '/t/4094/n1/all/n2/all/n3/all/n6/all/v/4110,4112/p/all/c58/allxt/d/v4110%201,v4112%201')

lista_dataframes <- list() #Cria lista de dataframes

for (api in vetor_api_sidra) { # Loop sobre as APIs
     pnadct <- get_sidra(api = api)
     lista_dataframes[[api]] <- pnadct # Adiciona o dataframe resultante à lista
     } #fim Loop sobre as APIs

pnadctGR <- bind_rows(lista_dataframes) # Junta dataframes em um único dataframe usando bind_rows
