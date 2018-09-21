# Introduction

<div class="figure">
![\ ](MEDIA/assets/art-artist-artistic-316465.jpg)
</div>

<p class="para"><span class="dropcaps">Y</span>ou worked hard for over a year in the next billion dollar web app in a small startup: the CEO, Johan, seems happy that the product is (almost) feature complete; the designer, Anders, is happy with the UX and graphics and the CTO, Pontus, just wants to press the red button and release the product. You tell them to wait 10 more minutes, the unit tests, integration tests and system tests are still running. Adding tests was a long battle with management because it slowed down the project quite a lot, but you are a good engineer and tests will catch many errors.</p>

- Ding, ding, ding (sound)

You look at the screen, all 142 tests are green! You tell Pontus to push the red button; deployment scripts start, your software is being installed on all the AWS servers the company could afford, a few databases with replication for faster reads and a single leader for the writes, load balancers, reverse proxies for serving static data and another bunch of instances running your application. After a few minutes, the deployment is a success, your baby is ALIVE and by tomorrow morning all Swedish newspapers will feature your product.

The next day comes, you try the app and observe that the system is just f****** slow. Connections time out and you observe in your monitoring tools that the server is not processing that many requests. *What the hell is going on!?*

The CTO thinks that it is the reusable query function that receives lambdas, updates a bunch of fields from different objects and saves them into the database as a single transaction. To guarantee that those transactions are atomic, someone in the team introduced a lock. You check if the lock has been released. If your intuition is right, you will fix the code, add the test that should have covered that case and be *presto* in 5 min.

There is one problem though, the code does not have a well-defined structure, and a lambda captures the lock — someone had to try out lambdas, they are cool — so you have no way of releasing the lock after the lambda call. I will repeat this to sink in: *the lambda captures the lock*, *the lock was not passed as a parameter*. You also observe some `if`-condition statement that releases the lock only in the `else` branch, but you do not understand why only in the `else` condition. You realise that, if someone had explained to your team mate that a lambda should never mutable state, the maintainability of the code would be much easier. The pattern is simple:

1. grab the lock
2. call a lambda function
3. unlock

The code follows below:

```
def complex_query(lock, fn, *args, **kwargs):
  lock.acquire()
  fn(args, kwargs)
  lock.release()
```

Shit, if only your team mate had used a better design...

#### **How did you end up in this situation?** {-}

You considered the functional requirements and the architecture but you failed to create a good design. The hype of new features seemed like a silver bullet; everyone in the team uses them. The problem is to understand when to use the new features and how they affect your design.

<div class="figure">
![Code Quality [[^xkcd]]](https://imgs.xkcd.com/comics/code_quality.png)
</div>
[^xkcd]: Image from https://xkcd.com/1513/

Young developers and engineers (who have just finished their degree) can read APIs, look on stackoverflow.com and find a solution to most problems. However, good engineers write code that exhibits good software qualities, such as code that is flexible and maintainable.
This book will introduce you to design principles for creating a flexible and maintainable code.

## Software Design

**Software design** is the process of **finding a satisfactory solution to a problem**.

Many books explain software design with a focus on one language and assume that this knowledge can be extrapolated to other languages and paradigms. But the type system influences the implementation of the design patterns. For example, most dynamically typed languages have the notion of mixins, while these (mostly) do not exist in statically typed languages.

After coding for over 10 years, teaching a course on Advanced Software Design at Uppsala University (Sweden), and doing (still working on it) a PhD on Programming Languages, I believe that one of the strongest points of any language is its type system. It is not the same to use a statically typed language with a strong type system (e.g. Haskell), than to program in a dynamic and more flexible language. For instance, the dynamic language Clojure introduced *transducers*. Transducers can be coded in statstatically typed languages but its implementation is much more difficult to code.

Our approach in this book will be practical, focusing and taking advantage of the type system (and its restrictions). Then, this knowledge can be extrapolated to other languages — we have built a common understanding of how the type system interplays with the language.

Throughout the book, we show different approaches to solving the same problem using a static and a dynamic language. You will learn to take advantage of each of the languages constructs when to use them and when to avoid them.

Type systems influence the available language constructs. For this reason, the book introduces a visual modelling language, known as *Unified Modelling Language* (UML). UML expresses the design idea and each language provides its own implementation.

## What is a good design?

A good design is one that can deal with change.

As a software engineer/developer, think about a piece of code that today is a car, tomorrow is a submarine and the next day is a tank. This happens because it is just code, anyone can update it and is not set in stone, ever.

There are many ways to solve a problem and, more often than not, there exist well-study common solutions. These well-documented solutions receive the name of design principles and design patterns and they exist for all kinds of paradigms. In this book, we will focus on object-oriented design principles.

## Design principles

Design principles are guidelines to separate responsibilities among classes, and to compose software out of smaller pieces. This book covers the *General responsibility assignment software principles* (*GRASP principles*), which includes:

* Controller,
* Creator,
* Indirection,
* Information expert,
* High cohesion,
* Low coupling,
* Polymorphism,
* Protected variation and,
* Pure fabrication

*Enjoy the ride!*
