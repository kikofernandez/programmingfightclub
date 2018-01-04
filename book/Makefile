DEPENDENCIES=preface introduction case-study recap grasp-principles

# Production ready folder for web and epub
WEB_PROD=web_prod
EPUB_PROD=epub_prod
ASSETS=assets
DOCS=../docs

all: epub web

# Building and cleaning an .epub file
epub: clean
	@mkdir -p $(EPUB_PROD)/parts
	@cp -r parts $(EPUB_PROD)
	@find $(EPUB_PROD)/./ -type f -exec sed -i '' -e 's/MEDIA/./g' {} \;
	@pandoc -s --toc metadata.yaml $(addprefix $(EPUB_PROD)/parts/, $(DEPENDENCIES:=.md)) -o $(EPUB_PROD)/book.epub
epub_clean:
	@rm -rf $(EPUB_PROD)

# Building the web version
web: web_clean pandoc $(DEPENDENCIES)
	@mkdir -p $(DOCS)
	@cp -r ../web_assets $(DOCS)
	@mv $(WEB_PROD)/* $(DOCS)
	@cp parts/index.html $(DOCS)/index.html
	@rm -rf $(DOCS)/parts

web_clean:
	@rm -rf $(WEB_PROD) $(DOCS)

pandoc:
	@mkdir -p $(WEB_PROD)/parts # && cp $(ASSETS)/pandoc.css $(WEB_PROD)

$(DEPENDENCIES):
	@mkdir -p $(WEB_PROD)/$@
	@cp parts/$@.md $(WEB_PROD)/parts
	@sed -i '' -e 's/MEDIA/../g' $(WEB_PROD)/parts/$@.md
	@pandoc --toc web-metadata.yaml $(WEB_PROD)/parts/$@.md -c assets/pandoc.css -o $(WEB_PROD)/$@/index.html

clean: web_clean epub_clean

.PHONY: clean $(DEPENDENCIES) pandoc web_clean epub_clean epub
