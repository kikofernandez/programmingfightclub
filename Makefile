DEPENDENCIES=preface introduction case-study recap grasp-principles

# Media path for epub and web
# EPUB_MEDIA=
# WEB_MEDIA=..

# Production ready folder for web and epub
WEB_PROD=web_prod
EPUB_PROD=epub_prod
ASSETS=assets

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

web_clean:
	@rm -rf $(WEB_PROD)

pandoc:
	@mkdir -p $(WEB_PROD)/parts && cp $(ASSETS)/pandoc.css $(WEB_PROD)

$(DEPENDENCIES):
	@cp parts/$@.md $(WEB_PROD)/parts
	@sed -i '' -e 's/MEDIA/../g' $(WEB_PROD)/parts/$@.md
	@pandoc --toc web-metadata.yaml $(WEB_PROD)/parts/$@.md -c pandoc.css -o $(WEB_PROD)/$@.html

clean: web_clean epub_clean

.PHONY: clean $(DEPENDENCIES) pandoc web_clean epub_clean epub
