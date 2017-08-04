# Prologue - Fight Club

This book was originally written for the course Advanced Software Design, imparted at Uppsala University by Kiko Fernandez-Reyes, and provides a practical hands-on experience on software design. It extends the content of the course with a direct application of design patterns and software principles in the object-oriented paradigm, exploiting the type system.

## Who is this book for?

This book is directed to students of any computer science major, young developers, engineers or programmers who have already grasped the idea behind object-oriented programming.

The reader should already be familiar with the following concepts from object-oriented programming:

- Classes,
- objects,
- inheritance,
- interfaces,
- abstract classes,
- parametric classes
- mixins and traits
- lambdas and closures

*Lambdas* and *closures* belong to functional programming but they have become ubiquitous in the object-oriented paradigm too.

For those in need of a quick reminder, I have included a recap chapter that summarises these concepts. If you are not familiar with object-oriented programming, you should first understand the ideas behind this paradigm and come back later to this book.

## What is covered in this book?

This book covers most of the design principles and design patterns used today in industry, necessary for building *maintainable* and *flexible* applications. All the principles and design patterns are written in two languages: Java and Python. These languages are already used in production in big companies and are well established. For instance, Pinterest uses Python for their backend operations and Java is widely used everywhere.

The mix of these two languages covers two different type systems with strong typing: static and dynamic.

**What does it mean to have a static or dynamic type system?**

Any programming language falls into one of two categories: static or dynamic. A language with a static type system needs typing annotations, which are heavily used by the compiler to catch errors at compile time. A dynamically typed language does not need these annotations and can infer its type from the way you use it; this usually leads to higher productivity than a statically typed language at the expense of runtime errors -- in a dynamic language, the type system is too "weak" to prevent errors that would have been caught by a statically typed language.

Each language has its strengths and weaknesses. In this book, I show how to apply the same design pattern by fully exploiting the main strengths of each language. In a typed language, you use polymorphism to guarantee that the object that you interact with satisfies its expected behaviour, while in a dynamic language you can enforce the behaviour without committing to specific type.

Choosing a language is *already* an important *design decision* as languages are tied to a paradigm and a type system, and these cannot be changed. For this reason, it's important to evaluate the language features and what the type system buys for us. For example:
- Is it a pain to use all the typing annotations in Java for what you get in return?
- Is Python (and its dynamic nature) the best way to write large code bases that are resilient to change?

In this book, we do not provide an absolute truth nor do we try to do so; we show that static and dynamic type systems have inherent benefits and drawbacks. You have to work through the examples and exercises to find your own truth and comfort zone.

## Organisation

The book is organised in 4 parts. The first part (chapters 1 and 2) puts in perspective what is software design, why design patterns are important and described the case study that we are going to build and refer to throughout the book. The second part introduces software principles to create flexible and maintainable software, known as GRASP and SOLID principles. Part 3 explains, in depth, core design patterns that are grouped into 3 categories: *creational*, *structural* and *behavioural* patterns. The last part builds a Web application using most of the patterns presented in this book.

For each design pattern, there is a clear and concise explanation of the design pattern (sometimes illustrating a simple simile from the real world), its benefits and drawbacks. Afterwards, the pattern is explained, we include easy to grasp examples to get you familiar with the language and the design pattern. As mentioned above, for a full example that combines software principles and patterns, you should refer to the last chapter.

## Software requirements

This book contains code written in Java and Python. This section contains the exact versions of the languages used in this book.

### Java 8

All examples written in this book has been tested using the Oracle JDK 8u111.

Instructions on how to install Java can be found in http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html.

### Python 3.6

All examples written in this book has been tested for Python 3.6.0.

Instructions on how to install Python 3.6 can be found in https://www.python.org/downloads/.

