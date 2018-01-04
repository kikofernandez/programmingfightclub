SRC=book

all: web

web:
	make -C $(SRC) $@

clean:
	make -C $(SRC) $@

.PHONY: clean web all
