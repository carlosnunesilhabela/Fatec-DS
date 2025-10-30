# 1. Instalar pacotes se ainda não estiverem instalados
install.packages("readxl")
install.packages("DBI")
install.packages("RSQLite")

# 2. Carregar os pacotes
library(readxl)
library(DBI)
library(RSQLite)

# 3. Definir o caminho para o arquivo Excel e o nome do banco de dados

nome_xlsx  <- "receitas-municipios-2024.xlsx"  # Altere se o diretorio se não estiver no diretório de trabalho
nome_db    <- "DBs/db_fatec_ads.db"  # O SQLite geralmente usa a extensão .sqlite ou .db
nome_tab   <- "tab_receitas"

# 4. Ler a planilha Excel (Por padrão, 'read_excel' lê a primeira planilha)
dados_receitas <- read_excel(nome_xlsx)

# 5. Conectar ou criar o banco de dados SQLite (Se o arquivo de banco de dados não existir, ele será criado)
conexao <- dbConnect(RSQLite::SQLite(), dbname = nome_db)

# 6. Gravar a tabela no banco de dados (argumentos 'overwrite = TRUE' ou 'append = TRUE')
dbWriteTable(conexao, name = nome_tab, value = dados_receitas, overwrite = TRUE)

# 7. (Opcional) Verificar se a tabela foi criada
tabelas_no_banco <- dbListTables(conexao)
print(paste("Tabelas no banco de dados:", toString(tabelas_no_banco)))

# 8. (Opcional) Ler e exibir algumas linhas da nova tabela para confirmar
# consulta <- paste0("SELECT * FROM ", nome_tabela, " LIMIT 5")
# dados_lidos <- dbGetQuery(conexao, consulta)
# print("Primeiras 5 linhas da nova tabela no SQLite:")
# print(dados_lidos)

# 9. Desconectar do banco de dados (muito importante!)
dbDisconnect(conexao)
