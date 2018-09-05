# Inheritance

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
