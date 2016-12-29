# Introduction

There is a general misconception in the software industry, specially in many startups,
where you as a developer lose face if you cannot immediately solve a problem.
To those who think like that, I tell you, you are wrong. Writing software is not
just coding lines until you solve the problem or your software "seems" to work,
it's about **making damn sure that your software is well designed**.

## Software Design
<!-- Definition -->
Software design is the process of finding a *satisfactory* solution to a problem.
Before one can start with an implementation there needs to be a clear specification of the problem to solve,
maybe a domain model of the system under design (to get used to the domain jargon),
an (in)formal document that describes the steps necessary to solve the problem
(the Unified Modelling Language can help here with class and sequence diagrams, among others)
and a well-defined architecture.

<!-- Relation to agile methodogies -->
Given the definition above, designing software seems to be completely disjoint from
agile methodologies (e.g. Scrum) where you break user stories into smaller tasks
until everything is clear to the whole team. In Scrum there seems to be
no domain model, not a single static and/or behavioural diagram, no architecture, etc,
just *code what the post-it says*.
However, the post-it tells you **what the problem is** but not **how to solve it!**.
The domain modelling, static and behaviour models and architectural diagrams
are all tools under your belt that may be used if required, even in agile
methodologies.

<!-- Design is all about making decisions -->
Software design is all about making decisions.
Every problem involves taking small and big decisions and these influence the final
outcome of your software. For instance, the "simple" task of choosing a programming language
has a tremendous impact on your software. Choose a
dynamic language and you'll find quite a lot of errors at runtime (even if you use
a test-driven development approach). Other example is choosing between a
object-oriented or a functional language. No matter which one you choose, you can always write the same
piece of software using one paradigm or the other. However, one of them will
bring inherent benefits that have to be otherwise coded in the other approach.


### What is a good design?

<!-- good design == flexible design -->
In general, **a good design is one that can deal with change**. A software engineer
has to think much more abstract than a civil engineer. Let me explain this better:
As a civil engineer, you may have to think about building a bridge that can stand
`X` number of tons and, under any circunstance, it should not fall down. As a software engineer,
you have to think about a piece of code that today is a car, tomorrow is a submarine
and the next day is a tank and this happens because it is just code, anyone can
update it and it is not set in stone, ever.

<!-- intro to design patterns -->
There are many ways to solve a problem and, more often than not, there are common solutions.
Because of this, many problems has been studied for many years and they have a well documented solution.
These well-documented solutions are called **design patterns** and they exist for
all kinds of paradigms. In this book, we will focus on object-oriented and
functional design patterns.

### Design patterns

<!-- definition, adv and disv -->
A design pattern is a well-desgined solution to a common problem.
Design patterns are expressed in a concise and clear format, and they
follow a structure similar to the one below:

- *pattern name*, which is common for everyone for easy understanding
- *concise and well-defined problem*
- *unequivocal solution*
- explicit mention of the *trade-offs of the pattern*

<!--
Should I cover design patterns from ASD? YES

Should I cover UML? ... maybe not!

Introduction to other languages!

Design patterns:
- SOLID vs GRASP
- Design patterns for OOP and/or FP
- Testing to check that it works!
-->
