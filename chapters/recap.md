# Recap

This section covers basic concepts from the object oriented and functional
paradigms. More conretely, by the end of the chapter you should be familiar with
the following concepts from object-oriented programming in Java and Python:

- Classes,
- objects,
- inheritance,
- interfaces,
- abstract classes and
- parametric classes

and the following concepts from functional programming in Clojure and Haskell:

- Anonymous functions / lambdas,
- high-order functions,
- parametric functions,
- algebraic data types,
- multi-functions
- immutability
- recursion

Keep in mind that some languages have features that do not exist in other languages.
For instance, algebraic data types exist in Haskell not in Clojure and
parametric classes exist in Java but not in Python. In the former case,
algebraic data types cannot be fully build in Clojure due to its dynamic typing
nature -- Clojure cannot typecheck the difference between data types and data values
(we'll explain what this means later on). In the latter case, parametric functions
do not make sense for Python due to, again, its dynamic nature. If you got the
feeling that this does not make sense and you cannot follow, everything will be
explain with examples soon when we cover these basic concepts.
Let's begin!

## Object-oriented concepts

The concepts covered in this section are shown in Java and Python.

*Note: Clojure is an impure language that mixes the functional programming
concepts with the object-oriented paradigm. In the remaning chapters,
we omit using the object-oriented capabilities of Clojure, since the objective
is to learn the main benefits that each language brings to the table.*

### Classes

Classes describe the state and behaviour of an object. The state of a class
lives in its attributes while the behaviour is expressed via its methods.
Let's start with a typical example and work on it with in the next concepts:

Idea:
Let's model a dog, who has as state her alertness and her behaviour is to bark
only when she is startled. As owner, you can check if the dog is startled or relaxed.

**Java**

The class `Dog` has as state a *private* attribute `alert`. This means that
the attribute is not accesible from outside the class. To get the attribute
outside the class you use *getters* and *setters* methods which only get the
data from the attribute and set the data in the attribute. The constructor
of the class creates a new `Dog` and sets its state to some default value.
This is represented in the Example 3.1.1.1.

```java
class Dog {
  // state of the Dog
  private boolean alert;

  // constructor
  public Dog(){
    this.alert = false;
  }

  // getter method
  public boolean getAlert(){
    return this.alert;
  }

  // setter method
  public void setAlert(boolean newAlert){
    this.alert = newAlert;
  }

  // behaviour
  public void bark(){
    if (this.alert) {
      System.out.println("Woof Woof");
    }
  }
}
```

*Example 3.1.1.1. Introductory example to Java*

**Python**

The class `Dog` has as state the attribute `alert`, defined inside the `__init__`
method (constructor in Python). This method also declares that it accepts
an extra argument `alert` that, if not provided, has the default value `False`.
Python doesn't have the `private` keyword available in Java and everything is
public by default. However, there is a convention that attributes that has a leading
underscore are to be considered private.
To avoid exposing the internal state and allow easy access to attributes,
Python provides a special syntax for
getters and setters that wrap the attribute into a function with that very
same name. For instance, the getter for the `alert` attribute declares
a method with the `@property` on top of it. The body of the method just
fetches the attribute. Setters work in the same way, except that they
are annotate it contains the name of the attribute followed by the `setter`
word, e.g. `@alert.setter` for the `alert` setter method.

```python
class Dog:
  def __init__(self, alert=False):
    self.alert = alert

  @property
  def alert(self):
    return self.__alert

  @alert.setter
  def alert(self, new_alert):
    self.__alert = new_alert

  def bark(self):
    if self.__alert is True:
      println("Woof Woof")
```

*Example 3.1.1.2 Introductory example to Python*

### Objects

Objects represent instances of the class at runtime. An object gets the default
state defined by their constructor and the behaviour defined in the class
that it instantiates.

**Java**

To create an object:
```java
Dog dog = new Dog();
```

This calls on the constructor of the `Dog` class that sets the `alert` state
to `false`. If the dog tries to bark nothing will happen:

```java
dog.bark()
```

The dog can bark when we update its attribute `alert` with the setter defined
in the `Dog` class.

```java
dog.setAlert(true);
dog.bark();
// prints "Woof Woof"
```

**Python**

### Inheritance

### Interfaces

### Abstract classes

### Parametric classes


## Functional concepts

### Anonymous functions / lambdas

### Immutability

### High-order functions

### Parametric functions

### Algebraic data types

### Multi-functions
