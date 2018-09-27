GRASP=grasp-book
LAMBDA=lambda-book
PANDOC=pandoc-book

all: grasp_web_book web_lambda

# Build GRASP principles book
grasp_web_book:
	@make -C $(GRASP) $@

web_grasp_test:
	@make -C $(GRASP) web_test

# Build Lambda book
web_lambda:
	@make -C $(LAMBDA) web_prod

pandoc_book:
	@make -C $(PANDOC) epub

.PHONY: grasp_web_book web_grasp_test web_lambda pandoc_book all
