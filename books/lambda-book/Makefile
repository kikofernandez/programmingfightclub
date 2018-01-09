DEPENDENCIES=toc

# Production ready folder for web and epub
WEB_PROD=web_prod

# Enable for an ebook
# EPUB_PROD=epub_prod

ASSETS=assets
BOOK_FOLDER=lambda-calculus
DOC_FOLDER=docs
DOCS=../../$(DOC_FOLDER)/$(BOOK_FOLDER)

all: web

# Enable for an ebook
# Building and cleaning an .epub file
# epub: epub_clean
# 	@mkdir -p $(EPUB_PROD)/parts
# 	@cp -r parts $(EPUB_PROD)
# 	@find $(EPUB_PROD)/./ -type f -exec sed -i '' -e 's/MEDIA/./g' {} \;
# 	@pandoc -s --toc metadata.yaml $(addprefix $(EPUB_PROD)/parts/, $(DEPENDENCIES:=.md)) -o $(EPUB_PROD)/book.epub
# epub_clean:
# 	@rm -rf $(EPUB_PROD)

# Building the web version
web_test: web_clean pandoc $(DEPENDENCIES) local

web_prod: web_clean pandoc $(DEPENDENCIES)
	@mkdir -p $(DOCS)
	@cp -r assets $(DOCS)
	@mv $(WEB_PROD)/* $(DOCS)
	@cp $(DOCS)/toc/index.html $(DOCS)
	@rm -rf $(DOCS)/parts

web_clean:
	@rm -rf $(WEB_PROD) $(DOCS)

pandoc:
	@mkdir -p $(WEB_PROD)/parts

$(DEPENDENCIES):
	@mkdir -p $(WEB_PROD)/$@
	@cp parts/$@.md $(WEB_PROD)/parts
	@sed -i '' -e 's/MEDIA/../g' $(WEB_PROD)/parts/$@.md
	@pandoc --toc web-metadata.yaml $(WEB_PROD)/parts/$@.md -c /$(BOOK_FOLDER)/assets/pandoc.css -o $(WEB_PROD)/$@/index.html

local:
	for chapter in $(DEPENDENCIES); do \
	  pandoc --toc web-metadata.yaml $(WEB_PROD)/parts/$$chapter.md -c "../assets/pandoc.css" -o $(WEB_PROD)/$$chapter.html ; \
	done

clean: web_clean #epub_clean

.PHONY: clean $(DEPENDENCIES) pandoc web_clean web_prod local #epub_clean epub
