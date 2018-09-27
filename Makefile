SRC=books

BOOKS=grasp_web_book pandoc_book

all: $(BOOKS)

$(BOOKS):
	@make -C $(SRC) $@

# this book is not ready.
web_lambda:
	@make -C $(SRC) $@

clean:
	@make -C $(SRC) $@

.PHONY: clean web all
