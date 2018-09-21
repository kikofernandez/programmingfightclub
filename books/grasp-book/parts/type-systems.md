# Type systems

In this chapter you will learn what is a type system and the difference between static and dynamic type systems.

A type system *assigns types to programming constructs*. By programming constructs we mean functions, expressions, statements and variables among others. The main function of the type system is to remove bugs in software through a phase known as type checking. During type checking the compiler assigns types to language constructs and builds a sound mathematical model. Sound means that the type system guarantees rejects programs that are illegal according to the mathematical model [[^oop-lambda-calculus]].

[^oop-lambda-calculus]: For more information on these mathematical models, subscribe to the
  [Lambda Calculus for the Working Programmer](WEB/lambda-calculus/toc/) book.

Type checking can happen at compile time or at run-time; when the type checking happens at compile time, we have a statically typed language. If the type checking happens at run-time, we have a dynamically typed language. For all purposes in this book, we consider only static and dynamic type systems [[^oop-type-system-notes]].

[^oop-type-system-notes]: In the research literature, there are languages that mix static and dynamic type systems but these are outside the scope of the book.

For example, Java is a statically typed language and would reject the program below when the method `readingString` receives an `int` argument (e.g. `reader.readingString(34)`). The method expects a `String` type, not `int` type.

```java
public class Reader {
  public [String] readingString(String s){ s.toArray(); }
}
```

On the other side, we have dynamic languages such as Python. Most dynamic languages use *duck typing*. From the pragmatic point of view, duck typing means that we do not rely on types to specify whether the methods of an object exists: you call methods on objects as if they exist and, at run-time, if they do, great, if they don't, the program throws an error. You can look at it from this other point of view: you are telling the object the behaviour it should implement, and you must ensure this "contract". Going back to the previous example, now written in Python:

```python
class Reader(object):
  def readingString(s):
    s.toList()
```

Let's assume we have a variable named `reader` which is an instance of the `Reader` class. You could make the method call `reader.readingString("Test")` and get back a singleton list. Moreover, you could also call `reader.readingString(True)` and the program would crash at run-time — `True` does not have a method called `toList()`.

The following table shows the main and most pragmatic differences between static and dynamic languages.

+-------------------------------------+------------------------------------------+
|             Static                  |              Dynamic                     |
+=====================================+==========================================+
| * Specify allowed behaviour based   | * Declare behaviour that you expect      |
| on types                            |                                          |
|                                     |                                          |
| * Type annotations ensure that      | * For each method, ensure that you       |
| only constructs that respect the    |   pass  arguments that your declared     |
| types can run                       |   behaviour                              |
|                                     |                                          |
| * Catches errors at compile time    | * Catches error at run-time              |
+-------------------------------------+------------------------------------------+

Table: Static vs Dynamic type systems from a pragmatic point of view.

It is completely normal if you do not fully understand everything mentioned in this section. As soon as we see examples in the next chapters everything will be much clear.