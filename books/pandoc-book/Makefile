# missing: toc.md slides.md makefile.md write-filter.md
DEPENDENCIES=copyright toc front-matter why pandoc markdown motivation web-epub research-paper
MD_DEPS= $(DEPENDENCIES:=.md)

EPUB_FOLDER=epub_prod

all: epub

##########################################
##
## Epub generation
##
##########################################

# Building and cleaning an .epub file
epub: $(DEPS)
	@mkdir -p $(EPUB_FOLDER)/parts
	@cp -r parts $(EPUB_FOLDER)

	@pandoc -s -t epub -F pandoc-crossref \
	--number-sections meta.yaml \
	$(addprefix $(EPUB_FOLDER)/parts/, $(MD_DEPS)) -o $(EPUB_FOLDER)/book.epub
	@rm -rf $(EPUB_FOLDER)/parts/

odt: $(DEPS)
	@pandoc -s -F pandoc-crossref --reference-doc=custom-reference.odt \
	--number-sections --no-highlight meta.yaml \
	$(addprefix parts/, $(MD_DEPS)) -o book.odt

odt2epub:
	@pandoc -s meta.yaml custom-reference.odt -o $(EPUB_FOLDER)/book2.epub

clean:
	@rm -rf $(EPUB_FOLDER)

.PHONY: epub clean all
