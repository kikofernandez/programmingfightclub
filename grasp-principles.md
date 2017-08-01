![](/assets/cover.jpg)# GRASP principles - Fight Club

Before you learn advanced design patterns, it's useful to look at common principles / recommendation rules to guide your design. By following these principles, you will design and write code that's easy to understand, maintain, and refactor.

By the end of this chapter you will have grok these principles and they will become second nature to you. Next, we introduce these principles ( which can be applied to any object-oriented language):
- low coupling,
- high cohesion,
- creator, 
- information expert,
- controller,
- polymorphism, 
- indirection,
- pure fabrication, and 
- protected variation.

There are exercises for each principle at the end of the chapter to help you understand the difference between them.

## Low Coupling

This principle states that a class should only depend on the minimum and required amount of classes, no more and no less. A low coupled class is easy to maintain and refactor because it interacts with a minimum amount of objects. A high coupled class has many dependencies to other objects and has low cohesion, i. e. it is not focused, has too many responsibilities and does too many things.

A low coupled design is easy to change and the changes do not spread across multiple classes. In the beginning of your journey to become a better programmer, it's difficult to acknowledge this principle until you deal with its counterpart, a high coupled bowl of spaghetti code. For this reason, it is much easier to spot a highly coupled design than to identify a low coupled one.

We define coupling as any code that satisfies items in the following list:

- the class has an attribute to another object,
- calls on methods of other objects, 
- inherits from another class,
- implements one or more interfaces, and
- inherits mixins

The reader should notice that there will always exist coupling but, dependencies to stable items are not problematic -- standard library -- because these have been well designed and do not change often. The problem is not coupling per se, but creating a highly coupled design to unstable objects.

The following example shows a poor design for the guides in the case study. Remember that guides contain images, visibility (who can watch the content), title, description, and reviews of restaurants, hotels, pubs, things to do, etc. All of these details are captured in the design below:

```
public class Guide {
  private List<Image> images;
  private List<User> visibility;
  private boolean isPublic;
  private boolean friendsOnly;
  private boolean friendsOfFriends;
  private String title;
  private String description;
  private Map<Restaurant, String> restReview;
  private Map<Hotel, String> hotelReview;

  public Guide(ArrayList<Image> images,
                          ArrayList<User> visibility,
                          boolean isPublic,
                          boolean friendsOnly,
                          ...){
    \\ Initialise method
    ...
  }
}
```
Listing 1.1 Highly coupled `Guide` class

Can you identify some of the problems with this design? Try to sit a few of them before you read the core issues of these design.

The problems with this design are:

* Assuming that `Image` is a class, this design couples images with a guide, but the guide should be personalised to each viewer! 
* the visibility maintains a list of users that can read the guide, this solution does not scale when there are many users; this same field may be used for different visibility settings, which makes the logic more difficult to test and understand as the attribute has different meaning based on other properties,
* The use of multiple, non-overlapping booleans makes the code difficult to follow as you will introduce branches and its related logic in each case,
* Hotels, restaurants and others should be dispatched polymorphously. If this is not the case, try adding a few new entities, e.g. `SushiBar`, and observe how you would need to add specific methods for this place or reuse a method that checks for sushi places and, if any, branches in the method,
* the constructor receives an `ArrayList`, which binds an implementation detail to the list abstraction -- couples the abstraction with an implementation detail

Now, how can we reduce coupling a guide to other elements? The most obvious alternative would be to put less responsibilities in the guide. This reduces coupling to other elements and, as a side effect, keeps the class focus on what it should do, i.e., the class is easy to understand, test, and maintain. An example of this low coupled class is in listing 1.2.

```
public class Guide {
  private List<IImage> images;
  private String title;
  private String description;
  private List<IPointOfInterest> poi;

  public Guide(ArrayList<IImage> images,
                          String title,
                          String description){
    \\ Initialise method
    ...
  }
}

public interface IPointOfInterest {
  public IReview getReview();
  public String getAddress();
  public void showOnMap();
  ...
}
```
Listing 1.2 Loosely coupled `Guide` class

**Exercise**: Given the refactoring above, how does a guide deal with its visibility?

**Exercise**: why do we need so many interfaces?
(Solution: we are coupling to an interface but, interfaces do not expose their implementation, so this coupling is much weaker than a direct class. Furthermore, we use interfaces in instability points. For example, the CEO may add a sushi restaurant as a point of interest and, because you know that in early stages of development things change, try to create a design as loosely coupled add possible)

## High Cohesion

Cohesion refers to the property of staying focus on the responsibilities of the class. A cohesive class does one thing and does it well. Highly cohesive code is focused and, as side effect, doesn't talk to too many objects.

Often, you'll see code that contains many methods, attributes, and seems to contain a lot of logic and magic. This code is building the antipattern known as "The Blob",  which results in a highly coupled code with low cohesion.

(Image of the Blob)

You can observe this antipattern in Listing 1.1. This example shows a`Guide` class who exhibit multiple responsibilities, such as, keeping the data of the class, managing its visibility and each possible point of interest individually. Listing 1.2 shows a more cohesive code, where the guide is responsible for handling its content. This change keeps the class focus on what it does and it's easier to understand because the class doesn't mix different responsibilities.

Whenever you need to evaluate a design, you should feel optimistic, in terms of cohesive code, when:

- code doesn't mix responsibilities,
- has few methods,
- doesn't talk too many objects.

**Dependence relationship**:

*Coupling* and *cohesion* usually go hand in hand, since code with low cohesion is code that does too many things, hence it relies on too many objects.

One way to look at it is to understand coupling as the relation between subsystems (modules and packages) and cohesion as the relation within a subsystem. As we argued before, Listing 1.1 is highly coupled and exhibits low cohesion. Lets look at another example that shows that these two concepts usually go hand in hand:

```
public class Review {
  private String comment;
  private User author;
  private Image image;
  private List<User> friendsToNotify;

  public class Review (User author,
                       String comment,
                       Image image,
                       List<User> notification){
    this.author = author;
    this.comment =comment;
    this.image = image;
    this.friendsToNotify = notification;
  }

  // Getters and setters
  ...
}
```
**Listing 1.3. Review class**

The code in Listing 1.3 is

These figure further shows how a change in one class affects many other classes thus, the code becomes more complex and difficult to maintain.
If we refactor this code, it ends up as listing Yyy, Figure Yy6y.

(Listing Yyy)

(Figure Yy6y)

**Exercise**: given the following code, add the following functionality:

- feature a
- feature b
- feature c

*Reflection*:

- How many classes did you change?
- does it seem like such a design is flexible and easy to refactor?

**Exercise**: Refactor the baseline code from the above exercise to achieve low coupling and high cohesion.
Add more features a, b, and c.

*Reflection*: does it seem like this design is flexible and easy to refactor?

## Creator

This principle is likely overlooked but it plays a crucial role in object-oriented programming; the creator *establishes who is responsible* for creating an object. If you defined it well, your code will exhibit loose coupling and high cohesion; err an you will begin your journey to maintaining spaghetti code.

**Application**: a class `X` is the creator of an object `Y` if any of the following statements are satisfied:

- class `X` initialises object `Y`
- class `X` contains object `Y`
- class `X` closely uses and depends on class `Y`

For instance, *a point of interest* (*POI*) has comments, hence POI is the creator of instances of the `Comment` class. 

**Exercise**: what kind of benefits and drawbacks do I get if `POI` is not the creator of comments?

**Solution**: (in solutions chapter) if comments are always the same, just text, then it makes sense that `POI`is the creator. However, what if I want to support multiple kinds of comments, i.e. video comments, text, or images as à comment? In that case, you are better off injecting the comments as an extra argument to the POI object. -- does this makes sense? POI is always created first and comments are added later on, it's not an initialiser but a method that adds comments.

## Information Expert

Classes have methods that define their responsibility and behaviour. A class exposes its behaviour via methods and its internals should always be opaque. With this basic idea, this principle helps you to identify the behaviour of each class.

A class is responsible for a behaviour if that class contains all the information to carry it out. For example, which object should be responsible for updating the description of a guide? 

a. `User` object

b. `POI` (point of interest) object

c. `LatitudeLongitude` object

d. `Guide` object

This one is easy. Lets consider each option:

a. If we update the guide description via `this.user.setGuideDescription(newDescription)` it implies that each user has a single guide, otherwise we would not know which guide we are updating. It could also mean that each user may be uniquely identified by its email and its guide. This is a really bad design from the relational point of view, database-wise. When representing the data layer from a NoSQL database this is allowed and I have seen it in use. I do not think this is a good model since, in the database, each record with the the same email is treated independently.

b. A point of interest, such as a view, may be linked to multiple guides. For this reason, similar to above, such a design is non-maintainable.

c. This really does not make sense.

d. We have a winner! The guide instance has all the information to update the guide.

The information expert assigns responsibilities to the classes that have all the information to fulfill the action.

**Exercise**: A user wants to submit a few pictures with a review of her favourite restaurant in Málaga, Spain. Which of the following classes should be the information expert and provide that behaviour? Why?

a. `User` object

b. `Guide` object

c. `Review` object

## Controller

Controller

## Polymorphism

This principle is one of the most important ones in object-oriented programming and the one that makes OOP great at dividing responsibilities between classes.

As we saw in the recap section, this polymorphism refers to classes that implement an interface or inherit from a top class and not to parametric classes, which is also polymorphic on the (opaque or bounded) type variable.

This principle allows classes to specify the same responsibilities via an interface but decouples the behaviour for each type. For instance, in our application, we want to show a special logo on top of the pictures of famous users who have confirmed their identity. A valid design, that does not scale, has a single `User` class with an attribute named `confirmedIdentity`  which sets the flag to true when the user has confirmed its identity. This design works for 2 users, the normal and confirmed users. Tomorrow, Johan (CEO) wants to add a new kind of user who represents a company instead of a person, companies cannot create accounts and they have confirmed its identity. Creating a company's profile as a confirmed user seems wrong and error prone, it makes no sense the attribute `confirmedIdentity` for a company's profile because we know that this will always be true. The current code looks like listing Xxxx.

(Listing Xxxx)

Another design choice is to represent this distinction of different users using an enum attribute. Based on this value, the `displayImage()` method adds logic to check which kind of user you are and how to display the image. You go home thinking that this is a good design, all the logic it's kept in a single method.

The problem with this approach, quite often used by beginners or as a shortcut, is that different classes are encoded within the same single one. This design is not maintainable in the long run because the same class encodes behaviour for different objects. Your design is abstracting at the wrong level.

A better approach is to create a class for each kind of user and dispatch dynamically. This design is easier to maintain because the behaviour is not encoded solely on the method, but on the type. The Figure Yyy shows how to dynamically dispatch based on the type.

**Exercise** Write the code depicted on Figure Yyy.

**Exercise** Write the main class and show that the method performs a dynamic dispatch based on the classes.

**Exercise** Write the code relying on inheritance and another version relying on interfaces. What are the benefits and drawbacks of the design and implementation decisions?

(Note: this is distinct for Python because there's no interface etc. Think how would you explain it in python)

Python is a dynamic language with a weak type system. This means the language assigns types at runtime, but you as a developer won't get any type error at compilation time. In Python polymorphism is always given and you as developer are in charge of ending that the methods you call exist or you will get a runtime error. As we said, the are no interfaces that we are bound to and python supports what's called duck typing, which is an idea much closer to how things work in real life. Let me show this with an example: you can read articles, news, cereal boxes and anything that has text. In Java you are bound by the type of object you are but in Python you are bound to the behaviour you have. A method call on `newspaper. hasText()` and `cerealBox.hasText()` works in Python independent from their type; Java would make this work only when they belong to the sand type or interface. For this reason, Python is more expressive in this regard, although it sacrifices static typing guarantees and forces the developer to either handle exceptions or crash and burn at runtime if the object on which the program calls the method `hasText()` does not provide such behaviour.

**Exercise** write the code depicted on Figure Yyy in Python. Do not forget to handle exceptional cases.

**Exercise** Write the main class and show that the method performs a dynamic dispatch based on the classes.

## Indirection

Domain objects may end up being coupled to other objects in the first iteration of your design. This principle states that you should create an intermediate object that mediates between these two, hence reducing coupling. 

To the untrained eye, it may seem as if two objects that where coupled, after applying the principle,  are still coupled but to other object. This reasoning is right, except that this indirection breaks the idea of once object having a direct relation to the other one. The layer in between breaks the coupling direction and creates a more flexible design, since the two initially coupled objects do not need to know anything about each other anymore.

An example of this pattern (Figure zzz) is the indirection introduced between a guides and the images that belong to the guides. The idea here is that the same guide is shared among friends and each one of them may potentially see a different cover image. Prior to this principle, your initial solution was to duplicate the guide for each friend and recalculate the cover image for each of them. This solution is redundant, consumes memory, and duplicates data, so an update on one description involves updating all data in all copies of the guide. A better solution is to add a new level of indirection between a guide and its cover image, 'CoverManager`, that knows how to retrieve the best cover image for the calling object. Internally, the manager may have to call the AI algorithm from time to time to update the image, cache it if the same user keeps coming to the same guide and even persist this mapping of guide-cover image in the database if the cover image doesn't change that often.

(Figure zzz)

**Exercise** Following the principles of these chapter, how would you design data persistence of an object from the case study? That is, would you add CRUD (Create, Read, Update and Delete) methods to all domain objects? If so, how would you avoid the coupling introduced by this design?

**Exercise** How would you design the offline mode of your application? That is, how do you deal with low connectivity or no connectivity at all?
Solution: you never assume that there is a connection and instead create an intermediate layer that handles the communication. If the server is unreachable, this layer handles how to proceed. An advanced design pattern that users this idea is the circuit breaker (explained in later chapters)

## Pure Fabrication

The term pure fabrication means to make something up. Use this principle whenever you observe that your domain classes are getting too overloaded, i.e., the start to exhibit high coupling and low cohesion. 

The principle adds a new indirection between two objects that would otherwise be directly connected (coupled). The indirection means adding a new object that mediates the communication between two other entities. This indirection object is not part of the domain and will be a made software concept. Examples of this principle are: object pools, database classes, and pretty much any object that sits in between two domain objects. In terms of design patterns, this principle is observe in the adapter pattern, shown in Figure xyz.

(Figure xyz)

Explain figure.

**Exercise**:Wwhere could this principle be applied in the case study? Why? (There are many valid examples)
Solution: the AI algorithm that inject images to guides. If this was not there, every guide would have the same image for all guides, tying the guide to the images. With the algorithm, the same guide share with friends shows different images based on other friends and connections.
**Exercise**: let's assume that you would like to add a notification system to the mobile app of the case study whenever a friend posts a new comment on one of her guides. What classes would you need to create? Solution: at the very least, you would need a `Notification` class that contains the text and image of the notification and some kind of notification manager that schedules and send notifications to the appropriate parties.

## Protected Variation

This principle is easy to apply and, in practice, requires you to be good at forecasting future pivot points or changes of direction. 

The core idea of this principle is to shield your code in places where you expect changes, let that be via interfaces or other means. For example, if we were to provide special guides that users can buy, we would need to integrate with a payment platform. If you are not sure which one is best, you'll end up picking one and calling their methods where necessary. However, what happens if you see that platform Z has low commissions? You would want to change. ReFactoring may not be so easy because both payment solutions have different libraries with different API. So, you need to change all those specific calls by whatever the new API and workflow mandates. 

One way of solving this problem is via an interface and different classes that implement those methods (Figure XYZ). In this design, you are protecting yourself from future changes. Your concrete classes that implement the interface maintain the workflow and your only job is to create a new concrete class that implements your interface. 

You should apply this pattern to instability points and, specially, when using third party libraries that you don't have previous experience with.

## Pure functions

This principle is not part of the common and well known GRASP principles but, in my experience, you should consider it. Lambdas, closures and pure functions are ubiquitous nowadays. My advice is that you stop using closures that captures mutable state. The main reason is that, at one point or another, you'll benchmark your application and start using parallel capabilities of your computer: task, futures, actors or whatever is the next parallel abstraction. If you encapsulate mutable state in closures, you are building your own coffin for the not so far away future. Things like processing an recognitive computation cannot be used anymore if the object the closure captures is shared between two threads -- unless you can guarantee data race freedom. Data race freedom code is hard to write, maintain and make fast, so using locks may get you out of troubles at the cost of losing horizontal scalability [^horizontal-scalability].

[^horizontal-scalability]: explain