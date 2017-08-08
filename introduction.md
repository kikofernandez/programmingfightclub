# Introduction

---

TODO:

- editing

----

You worked really hard for over a year in the next billion dollar web app in a small startup: the CEO, Johan, seems happy that the product is (almost) feature complete, the designer, Anders, is happy with the UX and graphics and the CTO, Pontus, just wants to press the red button and release the product. You tell them to wait 10 more minutes, the unit tests, integration tests and system tests are still running (adding tests was a long battle with everyone because it slowed down the project quite a lot, but you are a good engineer and tests will catch many errors now and in the future).

- Ding, ding, ding (sound)

You look at the screen, all 142 tests are green! You tell Pontus to push the red button; deployment scripts start, your software is being installed on all the AWS servers the company could afford, a few database servers with replication for faster reads and a single leader for the writes, load balancers, reverse proxy servers for serving static data and another bunch of servers running your application. After a few minutes, the deployment is a success, your baby is ALIVE and by tomorrow morning your product will be featured in all the Swedish newspapers (you live in Stockholm, the European capital for startups).

The next day comes, you try the app and observe that the system is just f************** slow. It seems that connections time out and you observe in your monitoring tools that the server is not processing that many requests. What the hell is going on!?

The CTO has the intuition that it could be related to that lock that was introduced for the concurrent writes to the database and it may be as simple as releasing the lock. If his intuition is right, you'll fix the code, add the test that should have covered that case and be presto in 5 min to re-deploy the application.

There is one problem though, the code doesn't have a well defined structure and the lock somehow was passed inside a lambda -- you had to try out lambdas in Java, they are cool -- so you have no way to releasing the lock directly. More over, you are passing a bunch of lambdas and there's no easy way to tell which one has the damn lock! Shit, if only you knew when made sense to use lambdas and all the cool features of the language! .

**How did you end up in this situation?**

You coded a system considering all the functional requirements and the architecture but you failed to create a good design. The hype of new features seemed like a silver bullet and everyone is using them (same thing happens with new frameworks all the time). The problem is understanding when to use those shiny new features and how they affect your design.

## Software Design 

Many books explain software design with focus on one language and assume that this knowledge can be "easily" extrapolated to other languages and/or paradigms. While it is true that you have to start from somewhere, it is also true that as soon as try to put design patterns into practice in another language their explanations may not be easy to follow or may not even make sense, from the language's perspective.

![](https://imgs.xkcd.com/comics/code_quality.png)
(image from https://xkcd.com/1513/)

Our approach in this book is much more practical and can only be extrapolated to other languages once there is a common understanding of how the type system interplays with the most common software design patterns.

For this reason, we are going to cover design patterns from the perspective of different languages and type systems, and we are going to show different approaches to solving the same problem. You will learn to take advantage of each of the language constructs, when to use them and when avoid them.

Before we start, let's do a recap on what software design means:

Software design is the process of finding a satisfactory solution to a problem.

Before one can start with an implementation there needs to be a clear specification of the problem to solve and a good understanding of the domain of the system under design (you can draw a domain model to clarify ideas). You can also write an informal document that describes the steps necessary to solve the problem (class and sequence diagrams can help here) and notes about the expected non-functional requirements, i.e., importing your friends' favourite places cannot block the main thread and should finish in less than 30 seconds.

### Agile methodologies

Given the definition above, designing software seems to be completely disjoint from agile methodologies, e.g. Scrum, where you break user stories into smaller tasks until everything is clear to the whole team. In Scrum there seems to be no domain model, not a single static and/or behavioural diagram, no architecture, etc, just code-what-the-post-it says. There is one problem if this approach is taken literally though: the post-it tells you what the problem is but not how to design it! You, as a software engineer, should look at domain modelling, static and behaviour models and architectural diagrams as tools under your belt that may be used if required, even in agile methodologies.

Software design is all about making decisions.

Every problem involves taking small and big decisions and these influence the final outcome of your software. For instance, the "simple" task of choosing a programming language has a tremendous impact on your software. Choose a dynamic language and you'll find quite a lot of errors at runtime (even if you use a test-driven development approach). Other example is choosing between a object-oriented or a functional language. You can always write the same piece of software using one paradigm or the other. However, one of them will bring inherent benefits while the other one puts some extra burden in your code.

![](https://imgs.xkcd.com/comics/code_quality_2.png)
(Image from http://xkcd.com/1695/)

### What is a good design?

In general, a good design is one that can deal with change.

<!--

A software engineer has to think much more abstract than other engineers, e.g. civil engineer. For instance, as a civil engineer, you may have to think about building a bridge that can stand X number of tons and, under any circumstance fall down.

-->

As a software engineer, you have to think about a piece of code that today is a car, tomorrow is a submarine and the next day is a tank and this happens because it is just code, anyone can update it and it is not set in stone, ever.

There are many ways to solve a problem and, more often than not, there exist well-study common solutions. These well-documented solutions are called design patterns and they exist for all kinds of paradigms. In this book, we will focus on object-oriented design patterns.

## Design patterns

A design pattern is a well-designed solution to a common problem. Design patterns are expressed in a concise and clear format, and they follow a structure similar to the one below:

- pattern name, so that experts can refer to a common pattern
- concise and well-defined problem specification
- unequivocal solution
- trade-offs of the pattern

In this book, we follow this structure together with auxiliary UML class diagrams (explained in later chapters).