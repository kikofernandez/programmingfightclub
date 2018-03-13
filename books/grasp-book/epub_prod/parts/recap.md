# Object-oriented concepts, revisited

<span class="firstcharacter">I</span>n this chapter you will learn basic concepts
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
  [Lambda Calculus for the Working Programmer](http://www.programmingfightclub.com/lambda-calculus/toc/) book ().

Type checking can happen at compile time or at run time; when the type checking
happens at compile time, we have a statically typed language. If the type checking
happens at runtime, we have a dynamically typed language.
For all purposes in this book, there are only static and dynamic type systems[^oop-type-system-notes].

[^oop-type-system-notes]: In the research literature, there are languages that
  mix static and dynamic type systems but these are outside the scope of the book.

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
    s.toList()
```

If you have an instance of a `Reader` class, `reader`, you can potentially call `reader.readingString("Test")`
and return a singleton list with the string you passed. However,
you could also call `reader.readingString(True)`, and
the program will throw an error at runtime -- `True` does not have a method called `toList()`.


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
this section. If that is the case, please continue ahead and go back to
this section once you have gone through the [Object-oriented reminder](#object-oriented-concepts).

## Object-oriented concepts

This section is a basic reminder of the main concepts of object-oriented programming
using Java and Python. If you are already familiar with object-oriented programming,
you can go ahead and move to the next chapter. If you would like to review
a few concepts, jump in to the one you would need to remember / clarify.

### Classes

Classes declare and implement the state and behaviour of an object.
*The state of a class lives in its attributes while the behaviour is expressed via its methods*.
A class that hides its attributes with a `private` access modifier
(remember `public`, `protected` and `private`?) protects its internal state from other
classes. The only way to update the internal state is via method calls on the object.
Method calls *represent the behaviour of the object*.

As a general advice, you should not expose the internal state of your class to others;
you should expose your behaviour. This makes great abstractions easy to use and
understand. For example, when using the `Future` API in Java 8, you do not have to think about the
possible locks that may exist in the internal representation of a `CompletableFuture`, you
just use it according to its defined behaviour, i.e. public methods.

#### Getters and setters

Methods that get attributes and set them are called *getters* and *setters*.
As an example, imagine that you have been asked to create a restaurant guide app
that shows restaurants nearby with their ratings.

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
the method `def __init__(self)`. If you write the example above in Python:

[^constructor]: this is not technically a constructor, although it is called right
after the creation of the object and, for all purposes in this book, it is the same.

```python
class Restaurant:
  def __init__(self, stars, street, zipcode, country):
    self.__stars  = stars
    self.__street = street
    self.__zipcode = zipcode
    self.__country  = country

  @property
  def stars(self):
    return self.__stars

  @stars.setter
  def stars(self, stars):
    self.__stars = stars
```

Lets examine this code in more detail.

The constructor `def __init__(self, stars, street, zipcode, country):` method
takes an explicitly instance of itself (`self`) together with the remaining arguments,
setting its internal state.

Python provides a special syntax for getters and setters that wrap the attribute
into a function with that very same name. In Python, these are called decorators.
For instance, the getter for the `stars`
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

which internally calls `self.__stars`.

Setters work in the same way, except that they are annotated with the attribute's
name followed by the `setter` word, e.g. `@stars.setter` for the `stars` setter method.
From now on, we can set the attribute as if we had access to the internal attributes:

```python
restaurant = Restaurant(3. "Lane Street", 75421, "Sweden")
restaurant.stars = 5
```

#### **Why would we want to use getters and setters like that?**

**They are an abstraction**. Today, you only want to retrieve the data but, with this
abstraction, you could be returning cached data that otherwise needs to be fetched from
a database, or some remote server. For instance, lets assume that the mobile application
you are building uses an external API to fetch data from nearby restaurants and, you map
this information to the class below. You use fields such as `street`, `zipcode` and
`country` from the external API, but the `star` rating and `id` come from your application.
Using the external API, your class partially contains all the values, except
the ratings, which you pull on demand, when the user clicks or is nearby a place.
Thanks to the decorator, you can
refer to `restaurant.stars` and the method will transparently handle
if the information already exists from a previous visit or if there is
a need to connect to the server a get the information.

```python
class Restaurant:
  def __init__(self, name, street, zipcode, country, stars=None):
    self.__id = -1
    self.__api = GuideSingleton()
    self.__stars  = stars
    self.__my_rating = None
    self.__street = street
    self.__zipcode = zipcode
    self.__country  = country
    self.__name = name

  @property
  def stars(self):
    if self.__stars:
      return self.__stars
    else:
      self.__stars = self.__api.find_stars(street=this.__street, name=this.__name)

  @stars.setter
  def stars(self, stars):
    self.__my_rating = self.__my_rating
    self.__api.add_rating(self.user.id, self.__id, self.__my_rating)
```

*Example 3.1.1.2 Introductory example to Python*

Even more, now the setter method allows you to set your rating in the
restaurant and send this information to the server, so that your friends
know about it.

### Objects

If you think of classes as blank templates, objects are the ink in the template.
Classes represent a static view of your software. They declare attributes,
and methods, but they are static and have no content. As soon as your software
run and you create an instance of a class, you are injecting runtime state
to the empty template. *Objects represent the runtime of your program*.

I could expand on and talk about how to create instances, call methods, access
attributes and so on. I assume that the reader is already familiar with
these details and will proceed with the next concept.


### Inheritance

Inheritance is a key concept in object-oriented programming, misunderstood
by new developers and recent graduates.

To explain:

* creates a hierarchy
* should not be used to not repeat the same attributes
* use wisely

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
