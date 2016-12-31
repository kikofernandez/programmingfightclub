# NOTE: the name `dp` stands for `design patterns`
RELEASE=build
OUTPUT=asd-book
SRC=chapters
TITLE="Design Patterns for the Object-oriented and functional mind"
AUTHOR="Kiko Fernandez-Reyes"
# CHAPTERS=prologue.md intro.md recap.md grasp.md dp-creational.md \
# 	dp-structural.md dp-behavioral.md

all: epub

epub:
	pandoc -S --toc -N --epub-metadata=metadata.xml -o $(RELEASE)/$(OUTPUT).epub \
	$(SRC)/prologue.md $(SRC)/intro.md $(SRC)/recap.md $(SRC)/uml.md $(SRC)/solid.md \
	$(SRC)/grasp.md $(SRC)/dp-creational.md $(SRC)/dp-structural.md \
	$(SRC)/dp-behavioral.md $(SRC)/cheatsheet.md

html:
	pandoc -S --toc -N -c styles/html.css -o $(RELEASE)/$(OUTPUT).html \
	$(SRC)/prologue.md $(SRC)/intro.md $(SRC)/recap.md $(SRC)/uml.md $(SRC)/solid.md \
	$(SRC)/grasp.md $(SRC)/dp-creational.md $(SRC)/dp-structural.md \
	$(SRC)/dp-behavioral.md $(SRC)/cheatsheet.md

pdf:
	pandoc -V language=english -V lang=english \
	-V author=$(AUTHOR) \
	-V title=$(TITLE) \
	-S --latex-engine=xelatex \
	-o $(RELEASE)/$(OUTPUT).pdf \
	$(SRC)/prologue.md $(SRC)/intro.md $(SRC)/recap.md $(SRC)/uml.md $(SRC)/solid.md \
	$(SRC)/grasp.md $(SRC)/dp-creational.md $(SRC)/dp-structural.md \
	$(SRC)/dp-behavioral.md $(SRC)/cheatsheet.md \
	--toc

clean:
	cd $(RELEASE) && rm *.epub *.pdf

.PHONY: epub pdf html
