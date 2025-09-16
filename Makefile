.PHONY: help
help:
	@echo "Make targets for export-org example"
	@echo "make pdf - Make PDF of example"
	@echo "make reveal - Make Reveal.js version of example"
	@echo "make site - Make Reveal.js website directory"
	@echo "make clean - Remove artifacts"

.PHONY: docker-container
docker-container:
	docker build -t athornton/export-org .

example.pdf: example.org docker-container
	./exporter.sh pdf example.org

example.html: example.org docker-container
	./exporter.sh html example.org

pdf: example.pdf

html: example.html

site: pdf html
	@mkdir -p ./site
	cp example.html ./site/index.html
	cp example.pdf ./site/example.pdf
	cp -rp local.css ./site

clean:
	@rm -rf ./site
	@rm -f ./example.html
	@rm -f ./example.pdf
	@rm -f ./example.tex
	@docker rmi athornton/export-org
