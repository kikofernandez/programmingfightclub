all:
	pandoc -S --toc -N --epub-metadata=metadata.xml -o build/asdbook.epub \
	chapters/intro.md chapters/grasp.md

clean:
	cd build && rm *.epub

# .PHONY:
