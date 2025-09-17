container = athornton/export-org:latest
target = example

.PHONY: help
help:
	@echo "Make targets for export-org $(target):"
	@echo ""
	@echo "make pdf - Make PDF of $(target)"
	@echo "make reveal - Make Reveal.js version of $(target)"
	@echo "make site - Make Reveal.js website directory"
	@echo "make clean - Remove artifacts"

.PHONY: docker-container
docker-container:
	docker run --rm $(container) /bin/true || \
	docker buildx build -t $(container) .

$(target).pdf: $(target).org docker-container
	./exporter.sh pdf $(target).org

$(target).html: $(target).org docker-container
	./exporter.sh html $(target).org

pdf: $(target).pdf

html: $(target).html

site: pdf html
	@mkdir -p ./site/assets
	@mkdir -p ./site/css
	cp $(target).html ./site/index.html
	cp $(target).pdf ./site/$(target).pdf
	cp -rp css/* ./site/css
	cp -p assets/coffee.png ./site/assets
	cp -p Makefile ./site/assets
	cp -p .github/workflows/ci.yaml ./site/assets
	cp -p scripts/fix-texlive.bash ./site/assets

clean:
	-@rm -rf ./site
	-@rm -f ./$(target).html
	-@rm -f ./$(target).pdf
	-@rm -f ./$(target).tex
	-@docker rmi athornton/export-org
