DEPENDENCIES=introduction case-study recap grasp-principles

# Media path for epub and web
# EPUB_MEDIA=
# WEB_MEDIA=..

# Production ready folder for web and epub
WEB_PROD=web_prod
EPUB_PROD=epub_prod
CSS=pandoc.css

all: epub web

epub:
	@mkdir -p $(EPUB_PROD)/parts
	@cp parts/$@.md $(EPUB_PROD)/parts
	@sed -ie 's/MEDIA//g' $(EPUB_PROD)/parts/$@.md
	@pandoc -s --toc metadata.yaml $(EPUB_PROD)$/parts/(DEPENDENCIES:=.md) -o book.epub
	# pandoc -s --toc metadata.yaml introduction.md case-study.md \
	# recap.md grasp-principles.md -o test.epub

web: web_clean $(CSS) $(DEPENDENCIES)

web_clean:
	@rm -rf $(WEB_PROD)

$(CSS):
	@mkdir -p $(WEB_PROD)/parts && cp pandoc.css $(WEB_PROD)

$(DEPENDENCIES):
	@cp parts/$@.md $(WEB_PROD)/parts
	@sed -ie 's/MEDIA/../g' $(WEB_PROD)/parts/$@.md
	@pandoc --toc web-metadata.yaml $(WEB_PROD)/parts/$@.md --css pandoc.css -o $(WEB_PROD)/$@.html

.PHONY: $(DEPENDENCIES) $(CSS)

clean:
	@rm -rf $(WEB_PROD) $(EPUB_PROD)
