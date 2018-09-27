# Write a book once: deploy a website and ePub

Pandoc is a command-line tool for converting files from one markup language
into another markup language. I have already covered
[what Pandoc is and basic examples of Pandoc](https://opensource.com/article/18/9/intro-pandoc) in the past.

This article is a deep dive into how to produce a website and an ePub
from single source files.
The article uses as an example the process of
writing a programming book using a per-chapter file, written in Markdown, keeping the
meta-information in its own files. The meta-information files define information
about your document, such as the style of your HTML and ePub, among other things.
Once we explain how Pandoc generates the HTML pages, we explain
how to deploy your website on Github Pages.
The article finishes by explaining how to generate an ePub file.

## Writing process

In the process of writing a programming book, there needs to be a table of contents,
preface and an introduction (files `toc.md`, `preface.md` and `intro.md`).
This example book teaches object-oriented
programming, so it will also contain chapters about
object-oriented programming and design patterns
(files `objects.md` and `design-patterns.md`).

Chapters are declared using markdown headings H1.
You can potentially create more than one chapter per file but I recommend
you against this, as it will be more difficult to find content and do
updates when needed.
An example of an introduction could be as follows:

```
# Introduction

Object-oriented programming is a well-established paradigm
based on the concepts of classes and objects. Classes
are similar to empty templates; objects are templates that
have been filled out.

More content...
```

Write chapters using Markdown syntax. HTML is also allowed but
I personally recommend you to stick to Markdown, given that
you are going to generate an ePub from the content of the files.
To keep some structure, place all your documents under a folder
named `chapters` (this will be important later on for the `Makefile`).

## Adding meta-information

When the book is ready, it has no format yet. Therefore, let's add the
meta-information for the website (the ePub meta-information will come later on).

### HTML meta-information

The meta-information file, `web-metadata.yaml`, is a simple YAML
file that contains information about the author, title, rights of your book,
content to be placed inside the `<head>`  tag or even content at the
end of the generated HTML file.

I recommend that you set up, at least, the following fields in the `web-metadata.yaml`:

`````YAML
---
title: <a href="/grasp-principles/toc/">GRASP principles for the Object-oriented mind</a>
author: Kiko Fernandez-Reyes
rights: 2017 Kiko Fernandez-Reyes, CC-BY-NC-SA 4.0 International
header-includes:
- |
  ```{=html}
  <link href="https://fonts.googleapis.com/css?family=Inconsolata" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css?family=Gentium+Basic|Inconsolata" rel="stylesheet">
  ```
include-before:
- |
  ```{=html}
  <p>If you like this book, please consider
      <a href="https://app.publica.com/grasp-principles">
          funding the book on the Public blockchain,
      <a/>
  </p>
  ```
include-after:
- |
  ```{=html}
  <div class="footnotes">
    <hr>
    <div class="container">
        <nav class="pagination" role="pagination">
          <ul>
          <p>
          <span class="page-number">Designed with</span> ❤️  <span class="page-number"> from Uppsala, Sweden</span>
           </p>
           <p>
           <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a>
           </p>
           </ul>
        </nav>
    </div>
  </div>
  ```
---
`````

TODO: the code above contains a link to my book. I can change that and write
something else instead. I just want to come out clean.

Interesting variables are the `heading-includes` which contains HTML
that will be embedded inside the `<head>` HTML tag. It is important to
do `- |` and that the next line aligns with the triple backquotes where the `|` starts
or Pandoc will reject it. The `{=html}` tells Pandoc that this is raw text and should
not be processed as Markdown[^footnote]. The variable `include-before`
adds HTML before the content of the book. I have added a
call-to-action so that readers can help you fund your book.
Finally, the `include-after` is used to show the license of your work.

[^footnote]: For this to work, you need to check that the `raw_attribute` extension in Pandoc is enable (which should be). To check it, type `pandoc --list-extensions | grep raw` which should return a list that contains one item named `+raw_html`. The plus sign indicates that it is enabled.

There are more fields available. To know which ones you can set up, you can take
a look at the template variables in HTML (this was covered in the
[introduction to Pandoc](https://opensource.com/article/18/9/intro-pandoc) article).

The website can be generated as a whole, resulting in a long page with all the content,
or split into chapters. This article shows how to split your website into chapters
so that the reader doesn't get intimidated by a long website.

To make the web easy to deploy on Github Pages, the generated
HTML chapters are created into its own folders, and the file content
is placed in a file named `index.html`. For example, the `intro.md` file
gets converted to a file named `index.html` that will be placed under
a folder named `intro` (`intro/index.html`).
By doing this, the user types `http://<your-website.com>/intro/`
and the browser shows the `index.html` file in the folder `intro`.

All these folders should be created inside a root folder named `docs`, which
is the one that Github Pages uses by default to render the website.

The following `Makefile` does all of this:

```
# Your book files
DEPENDENCIES= toc preface intro  objects design-patterns solutions

# Placement of your HTML files
DOCS=docs

all: web

web: setup $(DEPENDENCIES)
	@cp $(DOCS)/toc/index.html $(DOCS)


# Creation and copy of stylesheet and images into
# the assets folder. This is important to deploy the
# website to Github Pages.
setup:
	@mkdir -p $(DOCS)
	@cp -r assets $(DOCS)


# Creation of folder and index.html file on a
# per-chapter basis

$(DEPENDENCIES):
	@mkdir -p $(DOCS)/$@
	@pandoc -s --toc web-metadata.yaml chapters/$@.md \
	-c /assets/pandoc.css -o $(DOCS)/$@/index.html

clean:
	@rm -rf $(DOCS)

.PHONY: all clean web setup
```

The option `-c /$(DOCS)/assets/pandoc.css` declares
the CSS stylesheet to use, which will be fetch from
`/assets/pandoc.css`. That is, inside the `<head>` HTML tag
Pandoc adds the following line:

```HTML
<link rel="stylesheet" href="/assets/pandoc.css">
```

To generate your website type:

```
make
```

The root folder should contain now the following structure and files:

```
.---chapters
|    |--- toc.md
|    |--- preface.md
|    |--- intro.md
|    |--- objects.md
|    |--- design-patterns.md
|
|---docs
    |--- index.html
    |--- toc
    |     |--- index.html
    |
    |--- preface
    |     |--- index.html
    |
    |--- intro
    |     |--- index.html
    |
    |--- objects
    |     |--- index.html
    |
    |--- design-patterns
           |--- index.html
```

To deploy this website on Github Pages, simply follow these steps:

1. Create a new repository
2. Push the content of this tutorial to the repository
3. Go to the settings of the repository, Github Pages section
and select that Github will use the content from the `master` branch.

The official Github Pages steps can be found [here](https://pages.github.com/).

TODO: Should I show some image result? One can be found here
(https://www.programmingfightclub.com/grasp-principles/)
but I do want to state that this is my website and maybe you consider
this as promoting it or similar. Not my intention but is what inspired this post.

### ePub meta-information

The ePub meta-information (file `ePub-meta.yaml`) is similar to the HTML one.
The main difference is that there are other template variables such as
`publisher` and `cover-image`. The stylesheet your book uses
will probably be different from your the one on your website, so this book uses one
named `epub.css`.

```
---
title: 'GRASP principles for the Object-oriented Mind'
publisher: 'Programming Language Fight Club'
author: Kiko Fernandez-Reyes
rights: 2017 Kiko Fernandez-Reyes, CC-BY-NC-SA 4.0 International
cover-image: assets/cover.png
stylesheet: assets/epub.css
...
```

The previous `Makefile` gets extended with the following content:

```
epub:
	@pandoc -s --toc ePub-meta.yaml \
	$(addprefix chapters/, $(DEPENDENCIES:=.md)) -o $(DOCS)/assets/book.epub
```

The command for the `ePub` target takes all the dependencies, which were your
chapter names, appends them the Markdown extension and prepends them with
the path to the folder chapters, so that Pandoc knows how to process them.
For example, if `$(DEPENDENCIES)` were only `preface intro`, then
the Makefile actually calls:

```
@pandoc -s --toc ePub-meta.yaml \
chapters/preface.md chapters/intro.md -o $(DOCS)/assets/book.epub
```

Pandoc takes these two chapters, puts them together, generates
an ePub and places the book under the `assets` folder.


TODO: Should I put a link to an ePub generated from Markdown?
I am writing a book but I do not want to seem like I am putting this
behind anyones back. I can create otherwise a dummy example of
a book.

TODO: This post is based on this repo: https://github.com/kikofernandez/programmingfightclub
If you prefer that I do not promote the website that it links to,
I can create a new repo that contains a copy of the code I wrote.
The code I still need to test.
