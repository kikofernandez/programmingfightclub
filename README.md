# Prologue

This book provides practical hands-on experience on software design. It extends the content of the course with a direct application of design patterns and software principles in the object-oriented paradigm exploiting the flexibility (or lack off) the type system.

## Who is this book for?

This book is directed to students of any computer science major, young developers, engineers or programmers who have already grasped the idea behind object-oriented and/or functional programming. This book can still be used by those who have knowledge in an object-oriented language.

The reader should already be familiar with the following concepts from object-oriented programming:

- Classes,
- objects,
- inheritance,
- interfaces,
- abstract classes,
- parametric classes
- mixins and traits
- lambdas and closures

For those who just need a quick reminder, I have included a recap chapter that summarises these concepts. If you are not familiar with object-oriented programming, you should first understand the ideas behind this paradigms and come back later to this book.

## What is covered in this book?

This book covers most of the design principles and design patterns used today in industry, necessary for building maintainable and flexible applications. All the principles and design patterns are written in two languages: Java and Python. These languages are already used in production in big companies and are well established. For instance, Pinterest uses Python for their backend operations and Java is widely used everywhere.

The mix of these two languages covers different kinds of type systems, static and dynamic.

**Why multiple languages?**

Each language has its strengths and weaknesses. In this book, I show how to apply the same design pattern by fully exploiting the main strengths of each language.

Choosing a language is an important design decision as languages are tied to a paradigm and a type system, and these cannot be changed. For this reason, it's important to evaluate the way we write a good design and what the type system buys for us. Is it a pain to use the command pattern in Java using lambda notation? Is Python (and its untyped nature) the best way to write large code bases that are resilient to change?

In this book, we do not provide an absolute truth nor do we try to do so, we merely show that the combination of different paradigms and type systems have inherent benefits and drawbacks. You have to work through the examples in the book to find your own truth and comfort zone.

## Organisation

The book is organised in 4 parts. The first part (chapters 1 and 2) puts in perspective what is software design, and recap to object-oriented, as well as the main differences between static and dynamic type systems. The second part introduces software principles to create flexible and maintainable software, known as SOLID and GRASP principles. Part 3 explains, in depth, core design patterns that are grouped into 3 categories: creational, structural and behavioural patterns. The last part builds a Web application using most of the patterns presented in this book.

Each software principle and design pattern is explained in depth: there is a clear and concise explanation of the design pattern (sometimes illustrating a simple simile from the real world), its benefits and drawbacks. Afterwards, the pattern is explained in the context of its type system, I include easy to grasp examples to get you familiar with the language and the design pattern. As mentioned above, for a full example that combines software principles and patterns, you should refer to the last chapter.

### Software requirements

This book contains code written in Java and Python. This section contains the exact versions of the languages used in this book.

#### Java 8

All examples written in this book has been tested using the Oracle JDK 8u111.

Instructions on how to install Java can be found in http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html.

#### Python 3.6

All examples written in this book has been tested for Python 3.6.0.

Instructions on how to install Python 3.6 can be found in https://www.python.org/downloads/.

