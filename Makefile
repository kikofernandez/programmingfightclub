# NOTE: the name `dp` stands for `design patterns`
all:
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::epub_book')"
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"

clean:
	rm -fr _book

.PHONY: all clean
