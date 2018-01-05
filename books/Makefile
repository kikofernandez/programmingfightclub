GRASP=grasp-book
LAMBDA=lambda-book

all: web_grasp web_lambda

# Build GRASP principles book
web_grasp:
	make -C $(GRASP) web_prod
web_grasp_test:
	make -C $(GRASP) web_test

# Build Lambda book
web_lambda:
	make -C $(LAMBDA) web_prod

.PHONY: web_grasp web_grasp_test web_lambda all
