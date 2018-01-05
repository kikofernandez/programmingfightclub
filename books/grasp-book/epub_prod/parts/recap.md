# Recap

This section covers basic concepts from *type theory* and the object-oriented paradigm.

Today's object-oriented paradigm borrows two concepts from functional programming: lambdas and closures. During this recap, we will go through the core ideas of object-oriented programming using Java and Python. [^recap-note]

By the end of this chapter, you should understand:

* difference between Java's and Python's type systems,
* classes and objects,
* inheritance,
* interfaces,
* traits and mixins, 
* abstract classes,
* parametric classes and 
* lambdas and closures


## Type systems

TODO:

- Talk about the main difference between Java and Python
- duck typing
- weakly typed
- strongly typed

## Object-oriented concepts

We proceed to explain the core ideas of object-oriented programming using examples from the case study.

### Classes

Classes declare and implement the state and behaviour of an object. *The state of a class lives in its attributes while the behaviour is expressed via its methods*. A class that hides its attributes with a `private` access modifier (remember `public`, `protected` and `private`?) protects its internal state from other classes. The only way to update the internal state is via method calls on the object. Method calls *represent the behaviour of the object*. 

As a general advice, you should not expose the internal state of your class to others; you should expose your behaviour. This is what make great abstractions easy to use and understand. For example, when using the `future` API, you do not have to think about the possible locks that may exist in the internal representation of a `CompletableFuture`, you just use it according to its defined behaviour, i.e. public methods.

#### Getters and setters

Methods that get attributes and set them are called *getters* and *setters*.
Let's see a simple example: the `Restaurant` class in your application. A restaurant should
have a number of starts and a well defined location:

**Java**

The class `Restaurant` has all attributes defined as private (not accesible from outside the class).
The constructor of the class (`public Restaurant(...)`) creates a new `Restaurant` and sets its
state.

To get the state outside the class we use *getters* and *setters* methods. These are preceded by the words `get` and `set` following the attributes name,
e.g. `getStars()` (Example 3.1.1.1).

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

Python doesn't have access modifiers and uses (by convention) two underscores to mean that the attribute is private, i.e. the attribute `stars` should be written `__stars`. If you want the attribute to be public, just remove the double underscore. 

Unlike Java, the name of the class is not the constructor[^constructor], but rather the method `def __init__(self)`. The example we wrote above (in Java) is written in Python as follows:

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

The constructor `def __init__(self, stars, street, zipcode, country):` method takes explicitly an instance of itself (`self`) and the remaining arguments.

[^constructor]: this is not technically a constructor, although it is called right after the creation of the object and, for all terms and purposes in this book, it is the same.


Python provides a special syntax for getters and setters that wrap the attribute into a function with that very same name.
For instance, the getter for the `stars` attribute is created by declaring a method with the name of the attribute and the
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

Setters work in the same way, except that they are annotated with the attribute's name followed by the `setter` word, e.g. `@stars.setter` for the `stars` setter method. From now on, we can set the attribute as if we had access to the internal attributes:

```python
restaurant = Restaurant(3. "Lane Street", 75421, "Sweden")
restaurant.stars = 5
```

**Why would we want to use getters and setters like that?**

**They are an abstraction**. Today, you only want to retrieve the data but, with this abstraction, you could be returning cached data that otherwise needs to be fetched from the network.

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
