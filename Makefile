container = athornton/export-org:latest

.PHONY: help
help:
	@echo "Make targets for export-org example"
	@echo "make pdf - Make PDF of example"
	@echo "make reveal - Make Reveal.js version of example"
	@echo "make site - Make Reveal.js website directory"
	@echo "make clean - Remove artifacts"

.PHONY: docker-container
docker-container:
	docker run --rm $(container) /bin/true || \
	docker buildx build -t $(container) .

example.pdf: example.org docker-container
	./exporter.sh pdf example.org

example.html: example.org docker-container
	./exporter.sh html example.org

pdf: example.pdf

html: example.html

site: pdf html
	@mkdir -p ./site/assets
	cp example.html ./site/index.html
	cp example.pdf ./site/example.pdf
	cp -rp local.css ./site
	cp -rp Makefile ./site/assets
	cp -rp .github/workflows/ci.yaml ./site/assets
	cp -rp scripts/fix-texlive.bash ./site/assets

clean:
	@rm -rf ./site
	@rm -f ./example.html
	@rm -f ./example.pdf
	@rm -f ./example.tex
	@docker rmi athornton/export-org
