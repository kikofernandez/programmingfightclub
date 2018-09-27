# How to produce a research paper

This article is a deep dive into how to produce a research paper using
(mostly) Markdown syntax. The article covers how to create and reference sections,
figures (in Markdown and LaTeX) and bibliography,
and which cases are troublesome and why writing those bits in LaTeX
is the right approach.

## Research

Research papers usually contain references to sections, figures, tables and bibliography.
Pandoc by itself cannot easily cross-reference these. However,
Pandoc can leverage the filter [pandoc-crossref](http://lierdakil.github.io/pandoc-crossref/)
to do the automatic numbering and cross-referencing of sections, figures and tables.

To show how to create a research paper, let's rewrite an example
of an [educational research paper](#), originally written in LaTeX,
using Markdown, Pandoc and Pandoc-crossref.

### Adding and referencing sections

Sections are automatically numbered and must be written
using Markdown headings H1. Subsections are written with
subheadings H2 -- H4 (it is uncommon to need more than that).
For example, to write a section titled "Implementation" one writes
`# Implementation {#sec:implementation}` and
Pandoc produces `3. Implementation` (or the corresponding numbered section).
The title "Implementation" uses heading H1 and declares a label `{#sec:implementation}`
that authors can use to refer to that section. To reference a section,
type the symbol `@` followed by the label of the section and enclose it within square brackets,
e.g. `[@sec:implementation]`.
In this paper we find the following example:

```
we lack experience (consistency between TAs, [@sec:implementation]).
```

and Pandoc produces:

```
we lack experience (consistency between TAs, Section 4).
```

Sections are numbered automatically (how to do this in the `Makefile`, at the end of the article).
To create unnumbered sections type the title
of the section followed by `{-}`. For example,
`### Designing a game for maintainability {-}` creates
an unnumbered subsection with the title "Designing a game for maintainability".


### Adding and referencing figures

Adding and referencing a figure is mixed to referencing
a section and adding a Markdown image:

```
![Scatterplot matrix](data/scatterplots/RScatterplotMatrix2.png){#fig:scatter-matrix}
```

The line above tells Pandoc that there is a figure with the caption *Scatterplot matrix*
and the path to the image is `data/scatterplots/RScatterplotMatrix2.png`.
The `{#fig:scatter-matrix}` declares the name that we should use to
reference the figure.

An example from the paper which refers to a figure is below:

```
The boxes "Enjoy", "Grade" and "Motivation" ([@fig:scatter-matrix]) ...
```

Pandoc produces the following output:

```
The boxes "Enjoy", "Grade" and "Motivation" (Fig. 1) ...
```

### Adding and referencing bibliography

Research papers normally keep references in a BibTeX database file.
In this example, this file is named
[biblio.bib](https://github.com/kikofernandez/pandoc-examples/blob/master/research-paper/biblio.bib) and contains all the references of the paper.
An example of how this file looks like is below:

```bibtex
@inproceedings{wrigstad2017mastery,
    Author =       {Wrigstad, Tobias and Castegren, Elias},
    Booktitle =    {SPLASH-E},
    Title =        {Mastery Learning-Like Teaching with Achievements},
    Year =         2017
}

@inproceedings{review-gamification-framework,
  Author =       {A. Mora and D. Riera and C. Gonzalez and J. Arnedo-Moreno},
  Publisher =    {IEEE},
  Booktitle =    {2015 7th International Conference on Games and Virtual Worlds
                  for Serious Applications (VS-Games)},
  Doi =          {10.1109/VS-GAMES.2015.7295760},
  Keywords =     {formal specification;serious games (computing);design
                  framework;formal design process;game components;game design
                  elements;gamification design frameworks;gamification-based
                  solutions;Bibliographies;Context;Design
                  methodology;Ethics;Games;Proposals},
  Month =        {Sept},
  Pages =        {1-8},
  Title =        {A Literature Review of Gamification Design Frameworks},
  Year =         2015,
  Bdsk-Url-1 =   {http://dx.doi.org/10.1109/VS-GAMES.2015.7295760}
}

...
```

The first line, `@inproceedings{wrigstad2017mastery,`,
declares the type of publication (`inproceedings`) and the labelled used to refer to that
paper (`wrigstad2017mastery`).

To cite the paper with title *Mastery Learning-Like Teaching with Achievements*
one can write:

```
the achievement-driven learning methodology [@wrigstad2017mastery]
```

Pandoc will output:

```
the achievement- driven learning methodology [30]
```

In the paper that we are going to produce,
there is a bibliography section that contains numbered references,
such as:

![](https://github.com/kikofernandez/pandoc-examples/raw/master/research-paper/bibliography-example.png)

Citing a bunch of articles is easy, one just cites the articles separating the
labelled references using a `;` punctuation symbol. If there were
two labelled references `SEABORN201514` and `gamification-leaderboard-benefits`
one can cite them together as follows:

```
Thus, the most important benefit is its potential to increase students' motivation
and engagement [@SEABORN201514;@gamification-leaderboard-benefits].
```

Pandoc will produce:

```
Thus, the most important benefit is its potential to increase students’ motivation
and engagement [26, 28]
```

## Problematic cases

The main problem refers to objects that may not fit in the page.
These objects are then free to float to a position where they can be placed.
However, it can happen that the object goes to the last page or a page
where the reader would not expect it. For example,
a paper is easier to read when the authors mention figures or tables
and these appear close to their mention, instead of at the last page of the paper.

Thus far in this article, figures will float to wherever they fit better.
Sometimes the author needs to have some degree of control to where
the figures float. For this reason, I
recommend the use of the `figure` LaTeX environment
which has facilities for controlling, to some degree, the positioning of the figures.

Let's rewrite the figure example from before from:

```
![Scatterplot matrix](data/scatterplots/RScatterplotMatrix2.png){#fig:scatter-matrix}
```

To one that is written in LaTeX:

```
\begin{figure}[t]
\includegraphics{data/scatterplots/RScatterplotMatrix2.png}
\caption{\label{fig:matrix}Scatterplot matrix}
\end{figure}
```

In LaTeX the `[t]` option in the `figure` environment declares
that the image should be put at the top of the page. There are some
other options and we refer the reader to the following
[article](https://en.wikibooks.org/wiki/LaTeX/Floats,_Figures_and_Captions#Figures).


## How to produce the paper

So far the article has introduced how to add and reference (sub-)sections,
figures and cite bibliography but not how to produce the intended research
paper in PDF format. To generate the PDF, we are going to use Pandoc to generate a LaTeX file
that can be compiled to the final PDF.
In this section we dive into how to generate the research paper in LaTeX
using a customised template and a meta-information file and how to
compile the LaTeX document into its final PDF form.

Most conferences provide a `.cls` file that controls the look of the paper, i.e.
it is a template that already contains the whether the paper is a two-column paper
and other formatting information. In the example's
research paper, the conference provided a file named `acmart.cls`.

The research paper expected the authors to introduce the institution that they belong
to. However, this was not in the default Pandoc's LaTeX template[^footnote]. To include the affiliation,
let's take the default Pandoc's LaTeX template and add a new field.
The Pandoc template was copied into a file named `mytemplate.tex` as follows:

[^footnote]: The Pandoc template can be inspected by typing `pandoc -D latex`]

```
pandoc -D latex > mytemplate.tex
```

The default template contains the following code:

```latex
$if(author)$
\author{$for(author)$$author$$sep$ \and $endfor$}
$endif$
$if(institute)$
\providecommand{\institute}[1]{}
\institute{$for(institute)$$institute$$sep$ \and $endfor$}
$endif$
```

However, the template should include the author's affiliation and email address,
among other things. Therefore, we updated the template to include
these fields (other changes were made as well but are not present
due to the file length):

```latex
$for(author)$
    $if(author.name)$
        \author{$author.name$}
        $if(author.affiliation)$
            \affiliation{\institution{$author.affiliation$}}
        $endif$
        $if(author.email)$
            \email{$author.email$}
        $endif$
    $else$
        $author$
    $endif$
$endfor$
```

With these changes in place, we should have the following files:

* `main.md` contains the research paper
* `biblio.bib` contains the bibliographic database
* `acmart.cls` is the class of the document that we should use
* `mytemplate.tex` is the template file to use (instead of the default one)

Let's add the meta-information of the paper in a `meta.yaml` file:

````
---
template: 'mytemplate.tex'
documentclass: acmart
classoption: sigconf
title: The impact of opt-in gamification on `\\`{=latex} students' grades in a software design course
author:
- name: Kiko Fernandez-Reyes
  affiliation: Uppsala University
  email: kiko.fernandez@it.uu.se
- name: Dave Clarke
  affiliation: Uppsala University
  email: dave.clarke@it.uu.se
- name: Janina Hornbach
  affiliation: Uppsala University
  email: janina.hornbach@fek.uu.se
bibliography: biblio.bib
abstract: |
  An achievement-driven methodology strives to give students more control of their learning with enough flexibility to engage them in deeper learning. (more stuff continues)

include-before: |
  ```{=latex}
  \copyrightyear{2018}
  \acmYear{2018}
  \setcopyright{acmlicensed}
  \acmConference[MODELS '18 Companion]{ACM/IEEE 21th International Conference on Model Driven Engineering Languages and Systems}{October 14--19, 2018}{Copenhagen, Denmark}
  \acmBooktitle{ACM/IEEE 21th International Conference on Model Driven Engineering Languages and Systems (MODELS '18 Companion), October 14--19, 2018, Copenhagen, Denmark}
  \acmPrice{XX.XX}
  \acmDOI{10.1145/3270112.3270118}
  \acmISBN{978-1-4503-5965-8/18/10}

  \begin{CCSXML}
  <ccs2012>
  <concept>
  <concept_id>10010405.10010489</concept_id>
  <concept_desc>Applied computing~Education</concept_desc>
  <concept_significance>500</concept_significance>
  </concept>
  </ccs2012>
  \end{CCSXML}

  \ccsdesc[500]{Applied computing~Education}

  \keywords{gamification, education, software design, UML}
  ```
figPrefix:
  - "Fig."
  - "Figs."
secPrefix:
  - "Section"
  - "Sections"
...
````

This meta-information file sets the following variables in LaTeX:

* `template` refers to the template to use ('mytemplate.tex')
* `documentclass` refers to the LaTeX document class to use (`acmart`)
* `classoption` refers to the options of the class, in this case `sigconf`
* `title` specifies the title of the paper
* `author` is an object that contains other fields such as the `name`, `affiliation`
    and the `email`.
* `bibliography` refers to the file that contains the bibliography ('biblio.bib')
* `abstract` contains the abstract of the paper
* `include-before` this is information that should be included before the actual
    content of the paper, in what is known as the
[preamble](https://www.sharelatex.com/learn/latex/Creating_a_document_in_LaTeX#The_preamble_of_a_document) in LaTeX. I have included
here to show how to generate a computer science paper but you may skip it
* `figPrefix` refers to how to refer to the referenced figures in the document, i.e.
what should be displayed when one refers to the figure `[@fig:scatter-matrix]`.
For example, the current `figPrefix` produces in the example
`The boxes "Enjoy", "Grade" and "Motivation" ([@fig:scatter-matrix])`
the output `The boxes "Enjoy", "Grade" and "Motivation" (Fig. 3)`.
If there are multiple figures, the current setup declares that if should instead display `Figs.`
next to the figure numbers.
* `secPrefix` refers to how to refer to the section when it is referenced from
somewhere in the document (similar to figures above)

Now that the meta-information is set, let's create a `Makefile` that produces
the desired output. This `Makefile` makes use of Pandoc to produce the LaTeX file,
`pandoc-crossref` to produce the cross-references,
`pdflatex` to compile the LaTeX to PDF and
`bibtex` to process the references. The `Makefile` can be found below:

```
all: paper

paper:
	@pandoc -s -F pandoc-crossref --natbib meta.yaml --template=mytemplate.tex -N \
	 -f markdown -t latex+raw_tex+tex_math_dollars+citations -o main.tex main.md
	@pdflatex main.tex &> /dev/null
	@bibtex main &> /dev/null
	@pdflatex main.tex &> /dev/null
	@pdflatex main.tex &> /dev/null

clean:
	rm main.aux main.tex main.log main.bbl main.blg main.out

.PHONY: all clean paper
```

Pandoc uses the following flags:

* `-s` to create a standalone LaTeX document
* `-F pandoc-crossref` to make use of the filter `pandoc-crossref`
* `--natbib` to render the bibliography with `natbib`
  (one can also choose `--biblatex` if so desired)
* `--template` sets the template file to use
* `-N` is used to number the section headings
* `-f` and `-t` specify the conversion *from* and *to* which format. The `-t` usually
  contains the format followed by used Pandoc's extensions. In the example
  we declared `raw_tex+tex_math_dollars+citations` to allow to
use `raw_tex` LaTeX in the middle of the Markdown file,
`tex_math_dollars` to be able to type math formulas as in LaTeX
and `citations` to use [this extension](http://pandoc.org/MANUAL.html#citations).

To generate a PDF from LaTeX, we need to follow the guidelines
[from bibtex](http://www.bibtex.org/Using/) to correctly process the bibliography:

```
@pdflatex main.tex &> /dev/null
@bibtex main &> /dev/null
@pdflatex main.tex &> /dev/null
@pdflatex main.tex &> /dev/null
```

The script contains a `@` in front to ignore the output and we redirect
the file handle of the standard output and error to `/dev/null`, so that
we don't see the output generated from the execution of these commands.

The final result is show below and the repository for the article can be found
[here](https://github.com/kikofernandez/pandoc-examples/tree/master/research-paper):

![](https://github.com/kikofernandez/pandoc-examples/raw/master/research-paper/abstract-image.png)

## Conclusion

In my opinion, research is all about collaboration, dissemination of ideas
and on improving the state of the art in whatever field one happens to
be in. Computer scientists and engineers usually write
their papers using a document system known as LaTeX which
has excellent support for math writing. Researchers from the
social sciences seem to stick to DOCX documents.

When researchers from different communities write a joint paper
they need to discuss in which format they will write the document.
On the one hand, DOCX may not be convenient for engineers
if there is math involved but LaTeX may be troublesome for
researchers that lack any kind of programming background.

With this article I have given good reasons for writing articles
in Markdown, which is an easy-to-use language that can
be used by engineers and social scientists.
