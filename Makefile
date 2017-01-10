# NOTE: the name `dp` stands for `design patterns`
all:
	cd chapters && Rscript -e "rmarkdown::render_site()"

clean:
	cd chapters && rm -fr _book

.PHONY: all clean
