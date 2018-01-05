# Framework for building ebooks and webs

## Structure

The code is structure around the following folders:

- `books`, contains the available and ongoing books, as they are written
- `index.html`, this file is maintained manually so careful when adding links.
   this file contains the main website of the editorial
- `web_assets`, contains the assets used by the `index.html`
- `Makefile`, used to build books

## Structure of each book

Each book contains / follows the following pattern:

- `assets` folder contains the css, images, etc of the book
- `epub_prod` folder contains the generated epub
- `metadata.yaml` metadata for the ebook, used by `pandoc`
- `parts` folder that contains each chapter in its own file
- `web-metadata` metadata for the generated web, used by `pandoc`

## Adding a new book

Copy the structure of an existing book, update the `Makefile`
to create a new folder that will be placed at the root directory,
similar to the one named `grasp-principles`, and edit the metadata files.
