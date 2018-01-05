GRASP=grasp-book

all: web_prod

web_grasp:
	make -C $(GRASP) web_prod

web_grasp_test:
	make -C $(GRASP) web_test

clean:
	make -C $(SRC) $@

.PHONY: clean web all GRASP
