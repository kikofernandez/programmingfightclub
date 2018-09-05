# Classes

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

## Getters and setters

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

### **Why would we want to use getters and setters like that?**

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
