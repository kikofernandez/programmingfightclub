# List of dependencies and special treatment
DEPENDENCIES=introduction case-study type-systems recap grasp-principles
SPECIAL_DEPENDENCIES=toc preface
DEPS=$(SPECIAL_DEPEDENCIES) $(DEPENDENCIES)

# Production ready folder for web and epub
WEB_PROD=web_prod
EPUB_PROD=epub_prod

# Assets folder for formatting web and epub
ASSETS=assets

# Folder to deploy changes on Github
DOC_FOLDER=docs

# Book folder and subpath on the web
BOOK_FOLDER=grasp-principles

# Path to build production website
DOCS=../../$(DOC_FOLDER)/$(BOOK_FOLDER)

# Internals variables used in book
WEB=http:\/\/www.programmingfightclub.com
MEDIA=

all: epub web

# Building and cleaning an .epub file
epub: epub_clean
	@mkdir -p $(EPUB_PROD)/parts
	@cp -r parts $(EPUB_PROD)
	@sed -i '' -e 's/WEB/$(WEB)/g' $(EPUB_PROD)/parts/recap.md
	@find $(EPUB_PROD)/./ -type f -exec sed -i '' -e 's/MEDIA/./g' {} \;
	@pandoc -s --toc metadata.yaml $(addprefix $(EPUB_PROD)/parts/, $(DEPS:=.md)) -o $(EPUB_PROD)/book.epub
epub_clean:
	@rm -rf $(EPUB_PROD)

# Building the web version
web_test: web_clean pandoc $(DEPS) local

web_prod: web_clean pandoc $(SPECIAL_DEPENDENCIES) $(DEPENDENCIES)
	@mkdir -p $(DOCS)
	@cp -r assets $(DOCS)
	@mv $(WEB_PROD)/* $(DOCS)
	@cp $(DOCS)/toc/index.html $(DOCS)
	@rm -rf $(DOCS)/parts

web_clean:
	@rm -rf $(WEB_PROD) $(DOCS)

pandoc:
	@mkdir -p $(WEB_PROD)/parts

$(SPECIAL_DEPENDENCIES):
	@mkdir -p $(WEB_PROD)/$@
	@cp parts/$@.md $(WEB_PROD)/parts
	@sed -i '' -e 's/MEDIA/../g' $(WEB_PROD)/parts/$@.md
	@sed -i '' -e 's/WEB/$(WEB)/g' $(WEB_PROD)/parts/$@.md
	@cat parts/mailinglist.html >> $(WEB_PROD)/parts/$@.md
	@pandoc --toc web-metadata.yaml $(WEB_PROD)/parts/$@.md -c /$(BOOK_FOLDER)/assets/pandoc.css -o $(WEB_PROD)/$@/index.html

$(DEPENDENCIES):
	@mkdir -p $(WEB_PROD)/$@
	@cp parts/$@.md $(WEB_PROD)/parts
	@sed -i '' -e 's/MEDIA/../g' $(WEB_PROD)/parts/$@.md
	@sed -i '' -e 's/WEB/$(WEB)/g' $(WEB_PROD)/parts/$@.md
	@pandoc --toc web-metadata.yaml $(WEB_PROD)/parts/$@.md -c /$(BOOK_FOLDER)/assets/pandoc.css -o $(WEB_PROD)/$@/index.html

local:
	for chapter in $(DEPENDENCIES); do \
	  pandoc --toc web-metadata.yaml $(WEB_PROD)/parts/$$chapter.md -c "../assets/pandoc.css" -o $(WEB_PROD)/$$chapter.html ; \
	done

clean: web_clean epub_clean

.PHONY: clean $(DEPS) pandoc web_clean epub_clean epub web_prod local
