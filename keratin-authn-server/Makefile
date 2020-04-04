.DEFAULT_GOAL := help

## Requirements:
## helm and chart-releaser are installed
## CR_TOKEN env variable is exported containing github token (for releases upload)

.PHONY: release
release: ## Creates or refreshes index.yaml file
	# @make -s upload
	cr index  --owner keratin --git-repo helm-charts --charts-repo http://keratin.github.io/ --package-path ./build/ --index-path ./../index.yaml


.PHONY: upload
upload: ## Uploads the release and
	@make -s package
	cr upload --owner keratin --git-repo helm-charts --package-path ./build/


.PHONY: update
update: ## Update charts dependency
	helm dep up .

.PHONY: package
package: ## Building a package from current version
	@make -s clean
	helm package . --logtostderr --destination ./build/


.PHONY: clean
clean: ## Cleans and prepare the workspace
	mkdir -p build
	rm -fr build/*

.PHONY: help
help: ## Help
	@grep -E '^[0-9a-zA-Z_/()$$-]+:.*?## .*$$' $(lastword $(MAKEFILE_LIST)) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'