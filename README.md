# Desafio Certificação Analytics Engineer - Indicium Academy

Este repositório contém o projeto para a certificação de Analytics Engineer da Indicium Academy. O objetivo é realizar a ingestão e transformação dos dados do SAP da Adventure Works utilizando DBT Core e BigQuery.

## Dashboard do Projeto

O dashboard com as análises e visualizações dos dados pode ser acessado através do link abaixo:
[Adventure Works Dashboard](https://drive.google.com/file/d/1P5sIFxPpFo0O0Vb3xIx0Xd5AipQMJtO5/view?usp=sharing)


## Modelo Conceitual

O modelo conceitual do projeto pode ser acessado através do link abaixo:
[Modelo Conceitual](https://drive.google.com/file/d/1ltGTRQKS7peliVuWBNowrY_ltx8IU8oJ/view?usp=sharing)


## Pré-requisitos

- Python 3.8+
- Poetry (já instalado no ambiente)
- Conta Google Cloud com acesso ao BigQuery
- Git
- Make

## Configuração do Ambiente

### 1. Clone o Repositório

```bash
git clone https://github.com/danielmschaves/academy-dbt-test.git
cd academy-dbt-test
```

### 2. Ativação do Ambiente Virtual

```bash
# Ativar ambiente virtual do Poetry
poetry shell

# Instalar dependências do projeto
poetry install
```

### 3. Configuração do BigQuery

1. Faça o download do arquivo de credenciais (.json) do seu projeto no BigQuery
2. Crie uma pasta `temp` no diretório raiz do projeto
3. Mova o arquivo de credenciais para a pasta `temp`
4. Configure o arquivo `profiles.yml` na pasta `~/.dbt/` com as seguintes informações:

```yaml
default:
  outputs:
    dev:
      type: bigquery
      method: service-account
      project: nome-do-projeto
      dataset: nome-do-dataset 
      keyfile: temp/keyfile.json  
      location: US
  target: dev
```

5. Verifique a configuração executando:
```bash
make debug
```

## Comandos Make Disponíveis

### Comandos Básicos

```bash
# Instalar dependências do DBT
make deps

# Construir todos os modelos 
make build

# Executar todos os testes
make test

# Gerar e servir documentação
make docs

# Build completo (deps + build + test + docs)
make full-build
```

### Comandos por Camada

```bash
# Construir modelos de staging
make build_stg

# Construir modelos intermediários
make build_int

# Construir modelos marts
make build_marts

# Testar apenas marts
make test_marts

# Construir tabela fato_vendas
make run_fact
```

## Carregamento dos Dados (Seeds)

O projeto utiliza os dados do SAP da Adventure Works disponibilizados como seeds no DBT.

```bash
# Carregar todas as tabelas
make seeds
```

## Camadas do Projeto

- `staging/`: Primeira camada de transformação, padronização e limpeza dos dados brutos
- `intermediate/`: Camada para transformações intermediárias e preparação para os marts
- `marts/`: Modelos dimensionais finais organizados por assunto

## Documentação

Para gerar e visualizar a documentação do projeto:

```bash
make docs
```

A documentação ficará disponível em http://localhost:8080

## Solução de Problemas

- Se o comando `dbt seed` ficar executando indefinidamente mesmo após o carregamento das 64 tabelas, será necessário reiniciar o terminal.

- Em caso de problemas de conexão com o BigQuery, verifique:
  - Se o arquivo de credenciais (.json) está no caminho correto especificado no profiles.yml
  - Se o projeto e dataset do BigQuery existem e você tem as permissões necessárias
  - Se o arquivo profiles.yml está configurado corretamente

## Documentação e Recursos

- [Documentação do DBT](https://docs.getdbt.com/docs/introduction)
- [Documentação do BigQuery](https://cloud.google.com/bigquery/docs)
- [Fórum da Comunidade DBT](https://discourse.getdbt.com/)