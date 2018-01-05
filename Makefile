SRC=books

all: web_grasp web_lambda

web_grasp:
	make -C $(SRC) $@

web_lambda:
	make -C $(SRC) $@

web_grasp_test:
	make -C $(SRC) $@

clean:
	make -C $(SRC) $@

.PHONY: clean web all
