# Interfaces

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

In Python, you can encode interfaces in terms of abstract classes, which we cover
in the next blog entry.
