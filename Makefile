# NOTE: the name `dp` stands for `design patterns`
all:
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::epub_book')"

clean:
	rm -fr _book

.PHONY: all clean
