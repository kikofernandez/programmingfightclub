# Object-oriented concepts revisited

<p class="para"><span class="dropcaps">I</span>n this chapter we go through basic concepts
from object-oriented languages and two concepts that object-oriented languages borrowed
from the functional paradigm: *lambdas* and *closures*.
We cover these concepts in a static language, Java, and in a dynamic language, Python.</p>

By the end of this chapter, you should understand:

* classes and objects,
* inheritance,
* interfaces,
* mixins,
* abstract classes,
* parametric classes and
* lambdas and closures

If you are already familiar with object-oriented programming in Java and Python,
you can go ahead and move on to the next chapter. If you would like to review
a few concepts, jump into the one you would like to remember.

## Classes

Classes declare and implement the state and behaviour of an object.
*The state of a class lives in its attributes while the behaviour is expressed via its methods*.
A class that hides its attributes with a `private` access modifier
protects its internal state from other
classes. The only way to update the internal state is via method calls on the object.
Method calls *represent the behaviour of the object*.

As a general advice, you should not expose the internal state of your class to others;
you should expose your behaviour. If followed, you will build
abstractions that are easy to use and
understand. For example, when using the `Future` API from Java 8, you do not have to think about the
possible locks that may exist in the internal representation of a `CompletableFuture` instance, you
just use it according to its defined behaviour, i.e. public methods.

### Getters and setters

Methods that get attributes and set them are called *getters* and *setters*.
Not all classes should have getters and/or setters. As a rule of thumb,
I like to think that mostly domain classes should use them. A domain class
is a class that belongs to the domain that you are modelling.

To see how getters and setters work we introduce an example:
imagine that you are asked to create a restaurant guide application
that shows restaurants nearby with their ratings.

**Java**

The class `Restaurant` has all attributes defined as private (not accessible from outside the class).
The constructor of the class (`public Restaurant(...)`) creates a new `Restaurant` and sets its
state.

To get and set the state of the class we use *getters* and *setters* methods. These are preceded
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
mean that the attribute is private, e.g. the attribute `stars` should be written
`__stars`. If you want the attribute to be public, just remove the double underscore.

Unlike Java, the name of the class is not the constructor[^constructor], but rather
the method `def __init__(self)`. The example above written in Python looks as follows:

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

Let's examine this code in more detail.

The constructor `def __init__(self, stars, street, zipcode, country):` method
takes an explicit instance of itself (`self`) and the remaining arguments which
set its internal state.

Python has a special syntax for getters and setters that wraps the attributes
into a function with that very same name. These functions are called decorators.
For example, the getter for the attribute `stars` is created by declaring a method
with the name of the attribute and the `@property` on top of it.
The body of the method just fetches the attribute.

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
need to be fetched from some remote server. If you did not add the getter and setter,
you would have a class that allows access to its internals and new programmers
can change internal state that should not have been modified.

Let's show a concrete scenario: assume that the application
you are building uses an external API (Google) to fetch data from nearby restaurants and you map
this information to the class below. You copy trustworthy information from the external
API, such as `street`, `zipcode` and `country`. However, the number of `star` ratings
come from what your users think of the restaurant since you are targeting
some specialised audience.
From the external API, your `Restaurant` class partially contains all the values, except
the ratings, which you pull on demand when the user clicks or is nearby a place.
Thanks to the decorator, you can
refer to `restaurant.stars` and the method will transparently handle
if it needs to connect to the server to get the information or if the information is already present from a previous access.

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

Another typical example is adding validation when setting an attribute.
In Example 3.1.1.3, the setter checks that the image file is less than
3 MB and raises an error if the file size is exceeded.

```python
class Restaurant:
  def __init__(image):
    self.__image = image

  ...

  @image.setter
  def image(im):
    threeMB = 3*1024*1024
    if im.size() < threeMB:
      self.__image = im
    else:
      raise Exception("Image file is bigger than 3 MB.")
```

*Example 3.1.1.3 Validation example in Python*

### Static methods and attributes

So far, we have seen that objects have attributes and methods that save information
on a per-instance basis. Java and Python have what is known as static methods
and attributes, which supports saving information at the class level.
This means that we can encapsulate global variables in classes.

The main drawback of class attributes is that they live forever and cannot be garbage collected
since, at any point in time, the code can refer to them. Another drawback is
that they are global variables and, as such, will be difficult to test and
reason about when your software grows.

Let's proceed using as an example a counter that counts the number of
deployed British secret agents.

**Java**

Static attributes save information at the class level, instead of at the instance.
Static methods are commonly used to access static fields. In both cases,
attributes and methods add the `static` annotation, e.g.:

```java
public class SecretAgent {
  private static int numberFieldAgents = 0;

  public SecretAgent() {
    ++numberFieldAgents;
  }

  public static final int getNumberFieldAgents() {
    return numberFieldAgents;
  }
}
```

In this example, we declare `numberFieldAgents` as a `private` and `static`
attribute, so it is only visible within the class and the information is shared
among all `SecretAgent` object instances. To access this data, we declare
a static method that returns the number of fields agents.
You can get this data calling `SecretAgent.getNumberFieldAgents();`.

As a recommendation, all static methods should be `final`.
This is because subclasses can hide static methods of superclasses unless
they are `final`. An example that amy not behave as one would expect:

```java
public class SecretAgent {
  private static int numberFieldAgents = 0;

  public SecretAgent() {
    ++numberFieldAgents;
  }

  public static void getNumberFieldAgents() {
    System.out.println(numberFieldAgents);
  }
}

public class JamesBond {

  public static void getNumberFieldAgents() {
    System.out.println("1");
  }

  public static void main(String[] args) {
    JamesBond jb = new JamesBond();
    SecretAgent.getNumberFieldAgents();
  }
}
```

The result is that the static method from `SecretAgent` is called, even when
one would expect the `JamesBond` static method to be called, since you are doing
the call inside the `JamesBond` class.

To call the method from the `JamesBond` class, you can call `JamesBond.getNumberFieldAgents()`.
However, as you see, you are losing the power of doing a polymorphic call that always
works[^java-subtyping-static]. Therefore, always use `final` static methods.

[^java-subtyping-static]: Considerations of static
subtyping: https://docs.oracle.com/javase/tutorial/java/IandI/override.html

**Python**

Static attributes are declared as attributes of a class, written outside any method.
For instance, we are playing a game and we want to create
characters. We would like to know the total number of shots made by the characters, for which
we create a class `CharacterFactory`, that returns a character.


```python
class CharacterFactory(object):
  shotsOnTarget = 0
```

The attribute `shotsOnTarget` is a class attribute and, unlike in Java, can be accessed
either from an instance of the class or from the class, e.g.

```python
person = CharacterFactory()

person.shotsOnTarget
CharacterFactory.shotsOnTarget
```

We can create multiple characters that shoot to some target:

```python
batman = CharacterFactory()
bond = CharacterFactory()

batman.shotsOnTarget += 1
bond += 5

print(CharacterFactory.shotsOnTarget)
```

We have created a `batman` and `bond` character, they shot `1` and `5` times
to some target and the print line statement shows that the characters shot
a total number of 6 shots.

Static methods are quite a different story and Python has a different approach to static methods:
decorators called `@staticmethod` and `@classmethod`.
More concretely, static methods (`@staticmethod`) are one way to relate functions that could stand alone in
a module, but that the author prefers to keep them in a class.
That means, a *static method* is a function
that does not depend on the instance or class in which it is written into.
For this reason, the signature of a static method does not contain the
the instance's reference `self` nor the common
class reference `cls`[^python-staticmethods].
One of the main reasons for using static methods is to keep the class
*cohesive* (covered in GRASP principles chapter).

[^python-staticmethods]: Reference to Python's static methods: https://docs.python.org/3/library/functions.html#staticmethod

For example, we all know MacGyver can create a bomb with a needle or
stop an acid leak with a chocolate bar. Instead of implementating
every single instance method of what MacGyver can do, we create a static method
that receives a lambda, which contains what MacGyver does, and the arguments
to make it work:

```python
# Class declaration
class MacGyver(object):

  @staticmethod
  def apply(fn, *args, **kwargs):
    return fn(args, kwargs)


# Create lambdas to use by MacGyver
createBombWithNeedle = lambda *args, **kwargs: BombWithNeedle(args, kwargs)
sealAcidWithChocolateBar = lambda *args, **kwargs: SealWithChocolate(args, kwargs)


m = MacGyver()
needle = Needle()
acid = Acid()

m.apply(createBombWithNeedle, needle)
m.apply(sealAcidWithChocolateBar, acid)
```

As you can observe, the static method does not use `self` nor `cls` class. It is
basically a function embedded in the class because it does not make sense for
anyone else to use it, only MacGyver has the ability to do anything.

In contrast, class methods are used to create alternate class constructors
or perform setup computations before creating an actual class. Class methods
allow developers to embed information at the class level, and derived classes
can override them. This is simply not possible using static methods in Java.
Example:

```python
class CharacterFactory(object):
  shotsOnTarget = 0

  @classmethod
  def create(cls):
    return cls()

  @classmethod
  def updateOnTarget(cls):
    cls.shotsOnTarget += 1

  def shoot(self, target): pass

class SecretAgentFactory(CharacterFactory):
  def shoot(self, target):
    super().updateOnTarget()

class PhotographerFactory(CharacterFactory):
  def shoot(self, target):
    super().updateOnTarget()

class CitizenFactory(CharacterFactory):
  pass

target = CitizenFactory.create()
character = SecretAgentFactory.create()
character.shoot(target)

photographer = PhotographerFactory.create()
photographer.shoot(target)
photographer.shoot(target)
```

In the example above, we are playing a game where the character can be a secret
agent, a photographer or a common citizen. Each class has attached information,
`shotsOnTarget`, which displays the total shots made by each possible character.
If we run the example and check the shots on target of the `character` and the
`photographer`, e.g. `character.shotsOnTarget`, we can observe how we keep
track of this information on a per class basis. In the example,
the `character.shotsOnTarget` returns `1` while the `photographer.shotsOnTarget`
returns `2`.

### Constants

Sometimes it is important to be able to set attributes only once.
Java has a special keyword for this, while Python follows a convention.

**Java**

To write a constant attribute, add the `final` annotation to your attribute:

```java
public class SecretAgent {
  public final static String nationality = "British";
  private final String id;
  public SecretAgent(String id){
    this.id = id;
  }
}
```

In the example above, we declare that all secret agents have British nationality
and the `final` keyword prevent us from changing this. Moreover, the constructor
sets the `final` attribute `id` to some value, which cannot be changed after the
secret agent instance is created.

<!-- TODO: -->
<!-- * A `final` class in Java forbids derived classes (subtyping) -->

**Python**

In Python, class-level constants are written all uppercase while
instance-level constants define a getter but no setter so that it cannot be modified externally.
The example from Java, written in Python is:

```python
class SecretAgent
  NATIONALITY = "British"

  def __init__(self, _id):
    self.__id = _id

  @property
  def id(self):
    return self.__id
```

## Objects

If you think of classes as blank templates, objects are the ink in the template.
Classes represent a static view of your software; classes declare attributes and methods, but they are static and have no content. As soon as your software
runs and you create an instance of a class, you are injecting runtime state
to the empty template. *Objects represent the runtime of your program*.

<!-- I could expand on and talk about how to create instances, call methods, access -->
<!-- attributes and so on. I assume that the reader is already familiar with -->
<!-- these details and will proceed with the next concept. -->

## Inheritance

The main use of inheritance is to
create a specialisation (derived class) of a *super* class (type) and take
advantage of the subtyping polymorphism. In a statically typed language,
there is the notion of *variance*, which establishes the relationship
between the *super* and the *derived* types. Dynamic languages cannot make
this static check and do not bother to consider this concept. On the other
hand, Python (not all dynamic languages) has multiple inheritance, which we
explain in the Python section.

**Java**

In a statically typed language, subtyping has three types of variances: covariant, contravariant and invariant.
The variance on return, generics and arguments types explains the relationship
between the super and specialised (derived) type. Covariant refers to the subtyping
relationship established by the programmer, e.g. `Cat` is a subtype of an `Animal` class.
When the relationship is reversed, we call it contravariant. Invariant means
that the types must exactly match. Variances to take into account are:

* overloading return type (covariant),
* generics (contravariant) and,
* overriding method argument's type (invariant)

Let's understand this with examples. First, we look at the super and derived classes:

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

public class CatShelter extends AnimalShelter {
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

Overloaded methods are methods that have the same name but receive different
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

In this example, the `putAnimal` method in `CatShelter` overrides the parent
method. There is no `@Override` annotation to prevent the error discussed
in the Java section.

Overloading is always given, i.e. the lack of type annotations forbids
overloading methods since there is no way to know which arguments types
you are passing to the function. If you override a function by passing
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
i.e. parameters that start with a default value, which can be overridden. Following
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
Let's take a closer look:

```python
    return "Click"
class Photographer(object):
def shoot(self):
  def shoot(self):
    return "Click"

class SecretAgent(object):
  def shoot(self):
    return "Bang!"

class JamesBond(Photographer, SecretAgent):
  pass
```

In this example, *James Bond* is a photographer and a secret agent.
When he needs to shoot, `bond.shoot()`, he gets confused and decides to take a picture before
getting killed. Multiple inheritance is useful but you should use it wisely.

The concept of multiple inheritance brought the semantic concept of mixins.
The basic idea of mixins is to create small classes that cannot work alone
by themselves but, when combined, provide functionality can be reused.
For instance, any secret agent needs to know how to shoot, and play poker.
But a hunter needs to know how to shoot as well. Let's encode this functionality
using mixins:

```python
class ShootMixin(object):

  def __init__(self, probability=0.9):
    self.__probability = 0.9

  @property
  def probability(self):
    return self.__probability

  def shoot(self, person):
    return self.probability - person.hiding()

class PokerMixin(object):
  def pokerFace(self):
    print("Poker face")

class SecretAgent(ShootMixin, PokerMixin):
  pass
```

The mixins `ShootMixin` and `PokerMixin` do not make much sense on their own,
as classes. However, we can combine their behaviour to compositionally build
classes with more advanced behaviour, such as the `SecretAgent` class. This
class inherits these two mixins to provide any secret agent with the ability
to shoot and put a poker face.

## Interfaces

An interface declares the behaviour of your software, whose implementation lives in a class;
with the use of interfaces, your classes expose the behaviour, which is further
exploited by polymorphism. This means more than one class can implement
the interface so that you can interchangeably use one class or another.
Java has interfaces and Python does not need them. This is explained later in this chapter.

**Java**

An interface can be seen as a promise of proper behaviour from any type that
implements it. Since Java 8, interfaces not only declare expected behaviour,
but they can also implement methods as long as the implementation relies
on calling other public methods, great for code reuse. We will look at
James Bond example:

```java
public interface SecretAgentSkills {
  static final float probabilityOnTarget = 0.9;
  public void pokerFace();
  default Damage shoot(Person p) {
    float probability = SecretAgentSkills.probabilityOnTarget - p.hide();
    return new Damage(probability);
  }
}
```

In the example above, we declare that any class that wants to be a secret agent
needs to have a poker face and know how to shoot, and we provide a default implementation
for the *shooting* method, which can potentially be overridden by classes
that implement the interface `SecretAgentSkills`.

**Python**

Interfaces cannot be represented in dynamically typed languages. This is reasonable,
since a dynamic language cannot statically enforce the use of types at the signature
level. Furthermore, duck typing removes the need for interfaces, i.e.
declare the behaviour that you expect and enforce that the arguments you pass
comply with the expected behaviour -- public API.

In Python, you can encode interfaces in terms of abstract classes, which we cover next.

## Abstract classes

Abstract classes are similar to interfaces, except that they may provide
a method implementation. As with interfaces, they represent a contract between
the base class and the derivations of the base class. Abstract classes exist
in Java and Python.

**Java**

TODO:

* abstract classes

**Python**

A declaration [abstract class](https://www.python.org/dev/peps/pep-3119/#rationale)
of an abstract class looks similar to the simple and plain inheritance model. You would
simply import `from abc import ABC` and make classes to inherit from `ABC`.
The benefits of declaring an abstract class lies in the contract that you are creating.
It basically states that any derived class of the abstract class implements the
methods you have declared and no one can use the abstract class because it is incomplete.

Let's look at examples of how you would write a secret agent class and its derivations
without abstract classes and with abstract classes.

```python
class SecretAgent(object):
  def shoot(self, target):
    raise NotImplementedError()

class JamesBond(SecretAgent):
  def shoot(self, target):
    ...

class MrBean(SecretAgent):
  pass
```

Nothing prevents you from creating an instance of `SecretAgent` and trying to `shoot`.
For example, you can create an instance of Mr.Bean and try to shoot, just to
realise that Mr.Bean does not actually know how to shoot:

```python
bean = MrBean()
bean.shoot()
```

In this case, `bean.shoot()` raises the error `NotImplementedError:` inherited
from the `SecretAgent` class. This runtime error happens only when you shoot.
However, if `SecretAgent` is an abstract class, you can use the decorator `@abstractmethod` to enforce
implementation of methods by the derivations of the class. If you do not provide
an implementation, you get a runtime error at instantiation time, instead of
at the actual call of the behaviour. This design catches errors much faster and
make your class hierarchy more understandable and maintanable.

The example above using abstract classes and abstract methods is now defined as:

```python
from abc import ABC, abstractmethod
class SecretAgent(ABC):
  @abstractmethod
  def shoot(self, target):
    raise NotImplementedError()

class JamesBond(SecretAgent):
  def shoot(self, target):
    ...

class MrBean(SecretAgent):
  pass
```

The creation of an instance of Mr.Bean crashes at instantion time, instead of
when calling the shooting method:

```python
bean = MrBean()
```

produces the error `TypeError: Can't instantiate abstract class MrBean with abstract methods shoot`,
forcing you to implement the behaviour of the method. Failing to do so produces
a runtime error as soon as possible, at instantiation time.

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
