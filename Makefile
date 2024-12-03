# Makefile

# Variáveis
PROJECT_DIR = .
PROFILE = academy_dbt_test

# Ambientes
.PHONY: dev prod

dev:
	dbt run --target dev
 

# Comandos básicos
.PHONY: deps build test clean docs seeds

deps:
	dbt deps

seeds:
	dbt seeds

build:
	dbt build --exclude seeds

test:
	dbt test

clean:
	dbt clean
	rm -rf target/
	rm -rf dbt_packages/
	rm -rf logs/

docs:
	dbt docs generate
	dbt docs serve

# Comandos específicos
.PHONY: stage intermediate staging marts test_marts build_marts build_stg build_int run_fact

intermediate:
	dbt run --select intermediate 

staging:
	dbt run --select staging 

marts:
	dbt run --select marts 

test_marts:
	dbt test --select marts 	

build_marts:
	dbt build --select marts 	

build_stg:
	dbt build --select staging 	

build_int:
	dbt build --select intermediate 	

run_fact:
	dbt build --select fato_vendas 

# Comandos compostos
.PHONY: full-build full-refresh

full-build: deps build test docs

full-refresh:
	dbt run --full-refresh
