# Object-oriented concepts, revisited

<span class="firstcharacter">I</span>n this chapter you are reminded about basic concepts
from object-oriented languages and two concepts that object-oriented languages borrowed
from the functional paradigm: *lambdas* and *closures*.
We cover these concepts in a static language, Java, and in a dynamic language, Python.

By the end of this chapter, you should understand:

* classes and objects,
* inheritance,
* interfaces,
* traits and mixins,
* abstract classes,
* parametric classes and
* lambdas and closures

If you are already familiar with object-oriented programming,
you can go ahead and move on to the next chapter. If you would like to review
a few concepts, jump in to the one you would like to remember.

## Classes

Classes declare and implement the state and behaviour of an object.
*The state of a class lives in its attributes while the behaviour is expressed via its methods*.
A class that hides its attributes with a `private` access modifier
protects its internal state from other
classes. The only way to update the internal state is via method calls on the object.
Method calls *represent the behaviour of the object*.

As a general advice, you should not expose the internal state of your class to others;
you should expose your behaviour. If followed, this simple advice allows you to build
great abstractions that are easy to use and
understand. For example, when using the `Future` API in Java 8, you do not have to think about the
possible locks that may exist in the internal representation of a `CompletableFuture` instance, you
just use it according to its defined behaviour, i.e. public methods.

#### Getters and setters

Methods that get attributes and set them are called *getters* and *setters*.
Not all classes should have getters and/or setters. As a rule of thump,
I like to think that mostly domain classes should use them. A domain class
is a class that belongs to the domain that you are modelling.
We are going to show how getters and setters work in Java and Python
with the following example: imagine that you are asked to create a restaurant guide application
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

**They encapsulate behaviour**. Today, you only want to retrieve the data but, with this
simple abstraction, you give yourself some flexibility in the future.
For instance, you can easily expand and return cached data that otherwise would
need to be fetched fromsome remote server. If you did not add the getter and setter,
now you have an application that allows access to all their internals and it is much
more difficult to do this update, since you did not encapsulate your behaviour.
Another typical example is adding validation when setting an attribute.

Lets show a concrete scenario: assume that the application
you are building uses an external API (Google) to fetch data of nearby restaurants and you map
this information to the class below. You copy trustworthy information from the external
API, such as `street`, `zipcode` and `country`. However, the number of `star` ratings
come from what your users think of the restaurant, since you are targeting
some specialised audience.
From the external API, your `Restaurant` class partially contains all the values, except
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

The setter method allows you to set your rating in the
restaurant and send this information to the server, so that your friends
know about it.

## Objects

If you think of classes as blank templates, objects are the ink in the template.
Classes represent a static view of your software; classes declare attributes,
and methods, but they are static and have no content. As soon as your software
runs and you create an instance of a class, you are injecting runtime state
to the empty template. *Objects represent the runtime of your program*.

<!-- I could expand on and talk about how to create instances, call methods, access -->
<!-- attributes and so on. I assume that the reader is already familiar with -->
<!-- these details and will proceed with the next concept. -->

## Inheritance

TODO:

* Missing multiple inheritance in Python, a.k.a. mixins

<!-- To explain: -->
<!-- * what is subtyping? -->
<!-- * creates a hierarchy -->
<!-- * should not be used to not repeat the same attributes -->
<!-- * use wisely -->

<!-- Inheritance is a key concept in object-oriented programming, misunderstood -->
<!-- by new developers and recent graduates.  -->
The main use of inheritance is to
create a specialiasion (derived class) of a *super* class (type) and take
advantage of the subtyping polymorphism. In a statically typed language,
there is the notion of *variance*, which establishes the relationship
between the *super* and the *derived* types. Dynamic languages cannot make
this static check and do not bother to consider this concept. On the other
hand, Python (not all dynamic languages) has multiple inheritance, which we
explain in the Python section.

**Java**

In a statically typed language, subtyping has three types of variances: covariant, contravariant and invariant.
The variance on return, generics and arguments types explains the relationship
between the super and specialiased (derived) type. Covariant refers to the subtyping
relationship established by the programmer, e.g. `Cat` is a subtype of an `Animal` class.
When the relationship is reversed, we call it contravariant. Invariant means
that the types must exactly match. Variances to take into account are:

* overloading return type (covariant),
* generics (contravariant) and,
* overriding method argument's type (invariant)

Lets understand this with examples. First, lets look at the super and derived classes:

```java
public class AnimalShelter {
  public Animal getAnimalForAdoption(){ ... }
  public void putAnimal(Animal a) { ... }
}

public class Animal {
  ...
}

public class Cat extends Animal {
  ...
}
```

If I want to create a `CatShelter`, the return type of the method `getAnimalShelter()`
must be covariant. This means that I can return a `Cat` instead of an `Animal`.
Following the same reasoning, overloading a method argument's type is covariant, i.e.
it is type safe to pass a more specialised type to the subclass than the
type in the super class. This is illustrated in the following code, method
`putAnimal(Cat animal)`.


```java
public class CatShelter {
  public Cat getAnimalForAdoption(){ ... }
  public void putAnimal(Cat animal) { ... }
}
```

In contrast, the use of generics uses contravariance subtyping[^java-tutorial-generics].
This means that if `Cat` is a subtype of `Animal` and we refer to a generic
implementation, e.g. `List`, `List<Cat>` is not a subtype of `List<Animal>`.
To understand this, lets look at the following example:

```java
List<Cat> lcat = new ArrayList<Cat>();
List<Animal> lanimal = lcat;
```

I have just aliased the `lcat` variable. If I now add an element to the `Animal`
list:

```java
lanimal.add(new Dog());
```

and get the first cat available from the `lcat` lists (was aliased by the animal lists):

```java
Cat cat = lcat.get(0);
```

I would be treating a `Dog` as if it were a `Cat`. For this reason, Java uses
contravariant generic subtyping.

[^java-tutorial-generics]: [Link to official documentation](https://docs.oracle.com/javase/tutorial/extra/generics/subtype.html)


Overriding the method arguments' types is invariant, although Java allows
*overloaded* methods (coming next). To tell the compiler that you are overriding a method
in a subclass, you use the `@Override` on top of the method:

```java
public class AnimalShelter {
  public Animal getAnimalForAdoption(){ ... }
  public void putAnimal(Animal a) { ... }
}

public class CatShelter {
  @Override
  public Animal getAnimalForAdoption(){ ... }

  @Override
  public void putAnimal(Animal a) { ... }
}
```

If you do not add this notation and change the name of the method `getAnimalShelter()`
in the super class `AnimalShelter`, the compiler would think that the `CatShelter`
defines a method that does not exist in the super class. A good practice is to
always add the `@Override` annotation.

Overloaded methods are method that have the same name but receive different
arguments of types. Java knows which of the methods you are referring to and
uses the right method. For instance, we can overload the method `putAnimal`
from the `CatShelter` class as follows:

```java
public class CatShelter {
  public void putAnimal(Animal a) { ... }
  public void putAnimal(Cat a) { ... }
}
```

Whenever there is a call to the `putAnimal` method, Java uses one or the other
method.

**Python**

Python allows multiple inheritance, in contrast to Java. Before jumping in
the concept of multiple inheritance, we continue with the example given in the
Java section, now written in Python:

```python
class AnimalShelter(object):
  def getAnimalForAdoption():
    ...

  def putAnimal(animal):
    ...

class CatShelter(AnimalShelter):
  def getAnimalForAdoption():
    ...

  def putAnimal(animal):
    ...
```

In this example, the `putAnimal` method in `CatShelter` overrides the parents
method. There is no `@Override` annotation to prevent the error discussed
in the Java section.

Overloading is always given, i.e. the lack of type annotations forbids
overloading methods, since there is no way to know which arguments types
you are passing to the function. If you overide a function by passing
more arguments, the first function is actually deleted and not available anymore.
Example:

```python
def getAnimal(animal):
  return animal

def getAnimal(animal, cat):
  if cat != None:
    return cat
  else:
    return animal
```

If you were to call the function `getAnimal(animal)` (for some instance of `Animal` named `animal`),
Python will throw an error
because the name has been rebound and the function that takes a single argument
does not exist anymore. One way to overcome this is by using default parameters,
i.e. parameters that start with a default value, which can be overriden. Following
the example above, the same function could be rewritten as follows:

```python
def getAnimal(animal, cat=None):
  if cat != None:
    return cat
  else:
    return animal
```

This function can be called with one or two arguments, i.e. `getAnimal(a)`, which
sets the `cat` argument to `None`, by default; at the same time, you can call
`getAnimal(a, c)` which overrides the default value of `cat` by `c`.
This gives Python a lot of flexibility,
although you can also easily misuse it and run into runtime errors.

Multiple inheritance permits a Python class to inherit from multiple classes.
In case there is a method name collision, Python will execute the method
that inherited from the first class, ignoring the second possible method.
Lets take a closer look:

```python
class Photogapher(object):
  def shoot(self):
    return "Click"

class SecretAgent(object):
  def shoot(self):
    return "Bang!"

class JamesBond(Photographer, SecretAgent):
  pass
```

In this example, *James Bond* is a photographer and a secret agent.
When he needs to shoot, `bond.shoot()`, he gets confused and decides to take a last picture before
getting killed. Don't get me wrong, it is useful but you need to use it wisely.

The concept of multiple inheritance brought the semantic concept of mixins,
reviewed later on in this chapter.

## Interfaces

An interface declares the behaviour of your software, implemented in a class;
with the use of interfaces, you create classes that expose that behaviour,
exploited through polymorhism.

## Abstract classes

TODO:

## Parametric classes

TODO:

## Functional concepts

TODO:

## Anonymous functions / lambdas

TODO:

## High-order functions

TODO:

## Parametric functions

TODO:
