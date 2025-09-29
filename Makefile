.PHONY: help serve build clean

TODAY := $(shell date +"%m-%d")

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

serve: ## Starts Jekyll server that auto-builds on file changes
	jekyll serve --watch -P 4002

build: ## Builds website once
	jekyll build

clean: ## Removes generated files
	rm -rf _site .jekyll-cache .sass-cache

push: ## pushes changes
	git add -A
	git commit -m "update $(TODAY)" --allow-empty
	git pull origin main
	git push origin main
