# Static methods and attributes

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
