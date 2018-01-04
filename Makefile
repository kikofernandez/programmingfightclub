SRC=book

all: web

web_prod:
	make -C $(SRC) $@

web_test:
	make -C $(SRC) $@

clean:
	make -C $(SRC) $@

.PHONY: clean web all
