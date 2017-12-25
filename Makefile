DEPENDENCIES=introduction case-study recap grasp-principles
CSS=pandoc.css

all: epub $(DEPENDENCIES)

epub:
	@pandoc -s --toc metadata.yaml $(DEPENDENCIES:=.md) -o test.epub
	# pandoc -s --toc metadata.yaml introduction.md case-study.md \
	# recap.md grasp-principles.md -o test.epub

web: $(CSS) $(DEPENDENCIES)

$(CSS):
	@mkdir -p test && cp pandoc.css test

$(DEPENDENCIES):
	@pandoc --toc web-metadata.yaml $@.md --css pandoc.css -o test/$@.html

.PHONY: $(DEPENDENCIES) $(CSS)

clean:
	@rm -fr test/
