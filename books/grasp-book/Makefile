# List of dependencies and special treatment
DEPENDENCIES=toc preface introduction type-systems case-study recap grasp-principles
BLOG_DEPENDENCIES=table-of-contents type-systems-post

# Production ready folder for web and epub
WEB_PROD=web_prod
BLOG_PROD=blog_prod
EPUB_PROD=epub_prod

# Assets folder for formatting web and epub
ASSETS=assets

# Folder to deploy changes on Github
DOC_FOLDER=docs

# Book folder and subpath on the web
BOOK_FOLDER=grasp-principles
BLOG_FOLDER=blog

# Path to build production website
DOCS=../../$(DOC_FOLDER)/$(BOOK_FOLDER)


# Data-dir
DATADIR=../../data-dir

# Internals variables used in book
WEB=http:\/\/www.programmingfightclub.com
MEDIA=

all: epub web_prod

##########################################
##
## Epub generation
##
##########################################

# Building and cleaning an .epub file
# Override the data-dir to remove the inner styles to code listings.
# The overrided data-dir/templates/default.epub contains that inner styles in the .css
epub: epub_clean
	@mkdir -p $(EPUB_PROD)/parts
	@cp -r parts $(EPUB_PROD)
	@sed -i '' -e 's/WEB/$(WEB)/g' $(EPUB_PROD)/parts/recap.md
	@find $(EPUB_PROD)/./ -type f -exec sed -i '' -e 's/MEDIA/./g' {} \;
	pandoc -s --data-dir=$(DATADIR) --template=mytemplate.epub --toc metadata.yaml $(addprefix $(EPUB_PROD)/parts/, $(DEPENDENCIES:=.md)) -o $(EPUB_PROD)/book.epub

##########################################
##
## Web generation
##
##########################################

web_prod: web_clean folder_gen $(DEPENDENCIES)
	@mkdir -p $(DOCS)
	@cp -r assets $(DOCS)
	@mv $(WEB_PROD)/* $(DOCS)
	@cp $(DOCS)/toc/index.html $(DOCS)
	@rm -rf $(DOCS)/parts


blog_prod: blog_clean $(BLOG_DEPENDENCIES)
	mkdir -p $(DOCS)/$(BLOG_FOLDER)/
	cp -r assets $(DOCS)/
	cp -r $(BLOG_PROD)/* $(DOCS)/$(BLOG_FOLDER)/
	cp $(DOCS)/$(BLOG_FOLDER)/table-of-contents/index.html $(DOCS)/$(BLOG_FOLDER)
	rm -rf $(BLOG_PROD)/*

$(BLOG_DEPENDENCIES):
	mkdir -p $(BLOG_PROD)/$@
	pandoc -s --toc blog-metadata.yaml parts/$(BLOG_FOLDER)/$@.md -c /$(BOOK_FOLDER)/assets/pandoc.css -o $(BLOG_PROD)/$@/index.html

$(DEPENDENCIES):
	@mkdir -p $(WEB_PROD)/$@
	@cp parts/$@.md $(WEB_PROD)/parts
	@sed -i '' -e 's/MEDIA/../g' $(WEB_PROD)/parts/$@.md
	@sed -i '' -e 's/WEB/$(WEB)/g' $(WEB_PROD)/parts/$@.md
	@cat parts/mailinglist.html >> $(WEB_PROD)/parts/$@.md
	@pandoc -s --toc web-metadata.yaml $(WEB_PROD)/parts/$@.md -c /$(BOOK_FOLDER)/assets/pandoc.css -o $(WEB_PROD)/$@/index.html


##########################################
##
## Building the testing web version
##
##########################################

web_test: web_clean pandoc $(DEPENDENCIES) local

local:
	for chapter in $(DEPENDENCIES); do \
	  pandoc --toc web-metadata.yaml $(WEB_PROD)/parts/$$chapter.md -c "../assets/pandoc.css" -o $(WEB_PROD)/$$chapter.html ; \
	done

##########################################
##
## Helper targets
##
##########################################

folder_gen:
	@mkdir -p $(WEB_PROD)/parts


##########################################
##
## Cleaning
##
##########################################

clean: web_clean epub_clean

epub_clean:
	@rm -rf $(EPUB_PROD)

web_clean:
	@rm -rf $(WEB_PROD) $(DOCS)

blog_clean:
	@rm -rf $(BLOG_PROD)

.PHONY: clean $(DEPENDENCIES) $(BLOG_DEPENDENCIES) pandoc web_clean epub_clean epub web_prod local
