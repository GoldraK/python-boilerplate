.DEFAULT_GOAL := help 

.PHONY: help
help:  ## Show this help.
	@grep -E '^\S+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

.PHONY: local-setup
local-setup: ## Set up the local environment (e.g. install git hooks)
	scripts/local-setup.sh

.PHONY: build
build: ## Set up the local environment (e.g. install git hooks)
	docker build .

.PHONY: check-typing
check-typing:  ## Run a static analyzer over the code to find issues
	poetry run mypy .

.PHONY: check-format
check-format: ## Checks the code format
	poetry run yapf --diff --recursive **/*.py

.PHONY: check-style
check-style: ## Checks the code style
	poetry run flake8 .
	poetry run pylint ./**/*.py

.PHONY: reformat
reformat:  ## Format python code
	poetry run yapf --parallel --recursive -ir .

.PHONY: test
test: ## Run all the tests
	docker-compose run --rm --no-deps python-boilerplate poetry run pytest -n auto tests -ra

.PHONY: pre-commit
pre-commit: check-format check-typing check-style test