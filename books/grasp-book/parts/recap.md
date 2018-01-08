# Object-oriented concepts, revisited

<span class="firstcharacter">I</span>n this chapter we cover basic concepts
from *type theory* as well as common concepts from object-oriented languages.
Apart from these, we cover two concepts that object-oriented languages borrowed
from the functional paradigm: *lambdas* and *closures*.

By the end of this chapter, you should understand:

* difference between static and dynamic type systems,
* classes and objects,
* inheritance,
* interfaces,
* traits and mixins,
* abstract classes,
* parametric classes and
* lambdas and closures



<!-- Among these abstractions, we will remind the reader about important concepts such -->
<!-- as classes, parametric polymorphism (*generics* in Java), interfaces, abstract -->
<!-- classes, mixins and lambdas and closures. -->

<!-- This section covers basic concepts from *type theory* and the object-oriented paradigm. -->

<!-- Today's object-oriented paradigm borrows two concepts from functional programming: lambdas and closures. -->
<!-- During this recap, we will go through the core ideas of object-oriented programming using Java and Python. [^recap-note] -->



## Type systems

A type system assigns types to programming constructs; type systems are a set
of mathematical rules that are applied to a programming language. The main function of a
type system is to remove bugs in software, through a phase known as type checking,
where the compiler assigns types to constructs and builds a sound mathematical model.
Sound means that the type system guarantees that your program
behaves accordingly, always rejecting programs that are illegal according to
the mathematical rules[^oop-lambda-calculus].

[^oop-lambda-calculus]: For more information on these mathematical models, subscribe to the
  [Lambda Calculus for the Working Programmer](/lambda-calculus/toc/) book.

Type checking can happen at compile time or at run time; when the type checking
happens at compile time, we have a statically typed language. If the type checking
happens at runtime, we have a dynamically typed language.
For all purposes in this book, there are only static and dynamic type systems[^oop-type-system-notes].

```java
public class Reader {
  public [String] readingString(String s){ s.toArray(); }
}
```

Java is a statically typed language and would reject the program above at compile time if you
call the method `readingString` with an argument of type `int` (e.g. `reader.readingString(34)`).
This is because the method expects an argument with a `String` type, not an
argument with type `int`.


On the other side, we have dynamic languages such as Python. Most dynamic languages
use *duck typing*. Duck typing means that we do not rely on types to
specify whether the methods of an object exists; call methods on objects
as if they exist and, at runtime, if they do, great, if they don't, the program throws
an error. From another point of view, you are telling the object the behaviour
that it should implement, whether it does or not is another story that you
need to ensure by yourself. Going back to the previous example, now written in Python:

```python
class Reader(object):
  def readingString(s):
    s.toArray()
```

If I have an instance of a `Reader`, I can potentially call `reader.readingString("Test")`
and it will work. However, I can also call `reader.readingString(None)`, and
the program will throw an error at runtime -- `None` does not have a method called `toArray()`.

[^oop-type-system-notes]: In the research literature, there are languages that
  mix static and dynamic type systems but these are outside the scope of the book.

TODO: OVerview of dynamic and static languages!

It is completely normal if you do not fully understand everything mentioned in
this section. II that is the case, please continue ahead and go back to
this section once you have gone through the [Object-oriented reminder](#object-oriented-concepts).

## Object-oriented concepts

We proceed to explain the core ideas of object-oriented programming using examples from the case study.

### Classes

Classes declare and implement the state and behaviour of an object.
*The state of a class lives in its attributes while the behaviour is expressed via its methods*.
A class that hides its attributes with a `private` access modifier
(remember `public`, `protected` and `private`?) protects its internal state from other
classes. The only way to update the internal state is via method calls on the object.
Method calls *represent the behaviour of the object*.

As a general advice, you should not expose the internal state of your class to others;
you should expose your behaviour. This is what make great abstractions easy to use and
understand. For example, when using the `future` API, you do not have to think about the
possible locks that may exist in the internal representation of a `CompletableFuture`, you
just use it according to its defined behaviour, i.e. public methods.

#### Getters and setters

Methods that get attributes and set them are called *getters* and *setters*.
Let's see a simple example: the `Restaurant` class in your application. A restaurant should
have a number of starts and a well defined location:

**Java**

The class `Restaurant` has all attributes defined as private (not accesible from outside the class).
The constructor of the class (`public Restaurant(...)`) creates a new `Restaurant` and sets its
state.

To get the state outside the class we use *getters* and *setters* methods. These are preceded
by the words `get` and `set` following the attributes name, e.g. `getStars()` (Example 3.1.1.1).

```java
public enum Stars {
  ONE_STAR, TWO_STAR, THREE_STAR,
  FOUR_STAR, FIVE_STAR, ZERO_STAR
}

public class Restaurant {
  // Michelin stars
  private Stars stars;

  private String street;
  private int zipcode;
  private Country country;

  // constructor
  public Restaurant(Stars stars, String street, int zipcode, Country country){
    this.stars = stars;
    this.street = street;
    this.zipcode = zipcode;
    this.country = country;
  }

  // getter method
  public Stars getStars(){
    return this.stars;
  }

  // setter method
  public void setStars(Stars stars){
    this.stars = stars;
  }

  ...
}
```

*Example 3.1.1.1. Introductory example to Java*

**Python**

Python doesn't have access modifiers and uses (by convention) two underscores to
mean that the attribute is private, i.e. the attribute `stars` should be written
`__stars`. If you want the attribute to be public, just remove the double underscore.

Unlike Java, the name of the class is not the constructor[^constructor], but rather
the method `def __init__(self)`. The example we wrote above (in Java) is written in
Python as follows:

```python
class Restaurant:
  def __init__(self, stars, street, zipcode, country):
    self.__stars  = stars
    self.__sttreet = street
    self.__zipcode = zipcode
    self.__country  = country

  @property
  def stars(self):
    return self.__stars

  @stars.setter
  def stars(self, stars):
    self.__stars = stars
```

The constructor `def __init__(self, stars, street, zipcode, country):` method
takes explicitly an instance of itself (`self`) and the remaining arguments.

[^constructor]: this is not technically a constructor, although it is called right after the creation of the object and, for all terms and purposes in this book, it is the same.


Python provides a special syntax for getters and setters that wrap the attribute
into a function with that very same name. For instance, the getter for the `stars`
attribute is created by declaring a method with the name of the attribute and the
`@property` on top of it. The body of the method just fetches the attribute.

```python
    @property
    def stars(self):
      return self.__stars
```

If we had an instance of the `Restaurant` class, you could get the `stars` as follows:

```python
restaurant = Restaurant(3. "Lane Street", 75421, "Sweden")
restaurant.stars
```

Setters work in the same way, except that they are annotated with the attribute's
name followed by the `setter` word, e.g. `@stars.setter` for the `stars` setter method.
From now on, we can set the attribute as if we had access to the internal attributes:

```python
restaurant = Restaurant(3. "Lane Street", 75421, "Sweden")
restaurant.stars = 5
```

**Why would we want to use getters and setters like that?**

**They are an abstraction**. Today, you only want to retrieve the data but, with this
abstraction, you could be returning cached data that otherwise needs to be fetched from
the network.

```python
class Restaurant:
  def __init__(self, stars, street, zipcode, country):
    self.__stars  = stars
    self.__sttreet = street
    self.__zipcode = zipcode
    self.__country  = country
    self.__db = ...
    self.__id = ...

  @property
  def stars(self):
    return self.__stars

  @stars.setter
  def stars(self, stars):
    if self.__db.ready():
      self.__db.update(self.__id, stars)
    else:
      raise
    self.__stars = stars
```

*Example 3.1.1.2 Introductory example to Python*

### Objects

TODO:

### Inheritance

TODO:

### Interfaces

TODO:

### Abstract classes

TODO:

### Parametric classes

TODO:

## Functional concepts

TODO:

### Anonymous functions / lambdas

TODO:

### High-order functions

TODO:

### Parametric functions

TODO:

[^recap-note]: We cannot cover the object-oriented core ideas in depth; the reader should understand this chapter as a quick reminder; if you are not familiar with the notions presented in this chapter, we would recommend the following reading material: Reading material
