# Makefile

# Variáveis
PROJECT_DIR = .
PROFILE = academy_dbt_test

# Ambientes
.PHONY: dev prod

dev:
	dbt run --target dev

prod:
	dbt run --target prod

# Comandos básicos
.PHONY: deps build test clean docs

deps:
	dbt deps

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
	dbt run --select intermediate --target prod

staging:
	dbt run --select staging --target prod

marts:
	dbt run --select marts --target prod

test_marts:
	dbt test --select marts --target prod	

build_marts:
	dbt build --select marts --target prod	

build_stg:
	dbt build --select staging --target prod	

build_int:
	dbt build --select intermediate --target prod	

run_fact:
	dbt build --select fato_vendas --target prod

# Comandos compostos
.PHONY: full-build full-refresh

full-build: deps build test docs

full-refresh:
	dbt run --full-refresh
