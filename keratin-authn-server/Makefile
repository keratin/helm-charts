.DEFAULT_GOAL := help

## Requirements:
## - helm and chart-releaser are installed
## - CR_TOKEN env variable is exported containing github token

.PHONY: update
update: ## Update charts dependencies
	helm dep update .

.PHONY: release
release: ## Full cycle of release
	@make -s clean
	@make -s build
	@make -s upload
	@make -s index

.PHONY: index
index: ## Creates or refreshes index.yaml file
	cr index  --owner keratin --git-repo helm-charts --charts-repo http://keratin.github.io/helm-charts --package-path ./build/ --index-path ./../index.yaml

.PHONY: upload
upload: ## Uploads the release and
	cr upload --owner keratin --git-repo helm-charts --package-path ./build/

.PHONY: build
build: ## Building a package from current version
	helm dep build .
	helm package . --logtostderr --destination ./build/

.PHONY: clean
clean: ## Cleans and prepare the workspace
	mkdir -p build
	rm -fr build/* charts/*

.PHONY: help
help: ## Help
	@grep -E '^[0-9a-zA-Z_/()$$-]+:.*?## .*$$' $(lastword $(MAKEFILE_LIST)) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'