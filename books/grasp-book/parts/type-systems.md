# Type systems

<span class="firstcharacter">I</span>n this chapter you will learn
what is a type system and
the difference between static and dynamic type systems

A type system *assigns types to programming constructs*. By programming constructs we mean
functions, expressions, statements, variables, etc.
The main function of the
type system is to remove bugs in software, through a phase known as type checking,
where the compiler assigns types to constructs and builds a sound mathematical model.
<!-- Formally, type systems are a set of mathematical rules applied to a programming language. -->
Sound means that the type system guarantees that your program
behaves properly, always rejecting programs that are illegal according to
the mathematical rules[^oop-lambda-calculus].

[^oop-lambda-calculus]: For more information on these mathematical models, subscribe to the
  [Lambda Calculus for the Working Programmer](WEB/lambda-calculus/toc/) book.

Type checking can happen at compile time or at runtime; when the type checking
happens at compile time, we have a statically typed language. If the type checking
happens at runtime, we have a dynamically typed language.
For all purposes in this book, we consider only static and dynamic type systems[^oop-type-system-notes].

[^oop-type-system-notes]: In the research literature, there are languages that
  mix static and dynamic type systems but these are outside the scope of the book.

For example, Java is a statically typed language
and would reject the program below, at compile time, if you
call the method `readingString` with an argument of type `int`,
e.g. `reader.readingString(34)`; this is because the method expects
an argument with a `String` type, not an argument with type `int`.


```java
public class Reader {
  public [String] readingString(String s){ s.toArray(); }
}
```

On the other side, we have dynamic languages such as Python. Most dynamic languages
use *duck typing*. From the pragmatic point of view, duck typing means that
we do not rely on types to specify whether the methods of an object exists: you call methods on objects
as if they exist and, at runtime, if they do, great, if they don't, the program throws
an error. You can look at it from this other point of view: you are telling the object the behaviour
that it should implement, whether it does or not is another story that you
need to ensure yourself. Going back to the previous example, now written in Python:

```python
class Reader(object):
  def readingString(s):
    s.toList()
```

If you have an instance of a `Reader` class, `reader`, you can potentially call `reader.readingString("Test")`
and return a singleton list with the string you passed. However,
you could also call `reader.readingString(True)`, and
the program will throw an error at runtime -- `True` does not have a method called `toList()`.

The following table shows the main and most pragmatic differences between
static and dynamic languages.

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
| * Catches errors at compile time    | * Catches error at runtime               |
+-------------------------------------+------------------------------------------+

Table: Static vs Dynamic type systems from pragmatic point of view.

It is completely normal if you do not fully understand everything mentioned in
this section. As soon as we see examples in the next chapters everything
will be much clear. <!-- If that is the case, please continue ahead and go back to -->
<!-- this section once you have gone through the [Object-oriented reminder](#object-oriented-concepts). -->
