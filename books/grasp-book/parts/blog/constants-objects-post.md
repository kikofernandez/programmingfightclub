# Constants

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

# Objects

If you think of classes as blank templates, objects are the ink in the template.
Classes represent a static view of your software; classes declare attributes and methods, but they are static and have no content. As soon as your software
runs and you create an instance of a class, you are injecting runtime state
to the empty template. *Objects represent the runtime of your program*.
