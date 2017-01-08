# Prologue

This book was originally written for the course *Advanced Sofware Design* imparted
at Uppsala University by Dave Clarke and Kiko Fernandez-Reyes.
The *Advanced Software Design* course covers much more than the design patterns
shown in this book, but was lacking on hands-on experience and the application of
design patterns in a functional setting. This book hopefully closes that gap.

## Who is this book for?

This book is directed to students of any computer science major and
young developers, engineers or programmers who have already grasped the idea
behind object-oriented and/or functional programming. This book can still be used by
those of you who have knowledge in an object-oriented language or a functional language
althought, to get the most out of it, I would recommend to be familiar with
both paradigms.

The reader should **already** be familiar with / willing to learn on its own the following concepts
from object-oriented programming:

- Classes,
- objects,
- inheritance,
- interfaces,
- abstract classes and
- parametric classes

and the following concepts from functional programming:

- Anonymous functions / lambdas,
- high-order functions,
- parametric functions,
- algebraic data types,
- multi-functions
- immutability

There is a *recap* chapter on these ideas but it was written as a gentle reminder.
You should not expect understading object-oriented or functional programming
just by reading that chapter.


## What is covered in this book?

This book covers design principles and advanced design patterns used today in industry.
All the principles and design patterns covered in this book are written in
four languages: Java, Python, Haskell and Clojure.
<!-- -->
These languages are already used in production in big companies and are
well established. For instance, Boeing uses Clojure in their onboard
diagnostic system, Facebook uses Haskell to prevent spam and phising attacks
in their site, Pinterest uses Python for their backend operations and
Java is widely used everywhere.

The mix of these languages covers two different paradigms (object-oriented and functional
programming) and two different type systems (languages dynamically and
statically typed), shown in Table 1.1.

![](img/Table-Languages.png)

*Tabla 1.1 Relation between paradigm and type system*

**Why multiple languages?**

You should choose the right language for the right job. Choosing a language
is an important design decision as languages are tied to a paradigm and a type system,
and these cannot be changed.
<!--   -->
For instance, Python has some functional features but, all in all,
**Python is an object-oriented language**.

<!-- NOT CLEAR! -->
The main reason for using multiple languages is to **show that different paradigms
and type systems provide benefits and drawbacks in the use of design patterns**.

<!-- ## Organisation -->

<!-- Explain that the book covers the design patterns and needs to list: -->

<!-- - when to use it -->
<!-- - advantages -->
<!-- - disadvantages -->
<!-- - one or more ways of creating the design pattern and its drawbacks -->
<!-- - some UML? -->


## Software requirements

This book contains code written in Java, Python, Clojure and Haskell.
This section contains the exact versions of the languages used in this book.
All code contained in this book can be found at
[https://github.com/kikofernandez/asd-book](https://github.com/kikofernandez/asd-book).

### Java 8

All examples written in this book has been tested using the Oracle JDK 8u111.

Instructions on how to install Java can be found in
[http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html).

### Haskell

All examples written in this book has been tested in GHC 7.10.2.

Instructions on how to install GHC can be found in [https://www.haskell.org/ghc/](https://www.haskell.org/ghc/).

### Clojure

All examples written in this book has been tested for Clojure 1.8.0.

Instructions on how to install Clojure can be found in [http://clojure.org/community/downloads](http://clojure.org/community/downloads).

### Python 3.6

All examples written in this book has been tested for Python 3.6.0.

Instructions on how to install Python 3.6 can be found
in [https://www.python.org/downloads/](https://www.python.org/downloads/).
