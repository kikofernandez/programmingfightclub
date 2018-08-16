# Introduction

<div class="figure">
![Introduction](MEDIA/assets/art-artist-artistic-316465.jpg)
</div>

<p class="para"><span class="dropcaps">Y</span>ou worked hard for over a year in the next billion dollar web app in a
small startup: the CEO, Johan, seems happy that the product is (almost) feature
complete; the designer, Anders, is happy with the UX and graphics and the CTO, Pontus,
just wants to press the red button and release the product. You tell them to wait
10 more minutes, the unit tests, integration tests and system tests are still running.
Adding tests was a long battle with management because it slowed down the project
quite a lot, but you are a good engineer and tests will catch many errors in the future.</p>

- Ding, ding, ding (sound)

You look at the screen, all 142 tests are green! You tell Pontus to push the red button;
deployment scripts start, your software is being installed on all the AWS servers the
company could afford, a few databases with replication for faster reads and
a single leader for the writes, load balancers, reverse proxies for serving
static data and another bunch of instances running your application. After a few minutes,
the deployment is a success, your baby is ALIVE and by tomorrow morning your product will
be featured in all the Swedish newspapers (you live in Stockholm, the European capital for startups).

The next day comes, you try the app and observe that the system is just f****** slow.
It seems that connections time out and you observe in your monitoring tools that the
server is not processing that many requests. *What the hell is going on!?*

The CTO has the intuition that it could be related to that reusable query class that
receives lambdas, updates a bunch of fields from different objects and saves them into
the database as a single transaction. There were many things going on there and, to guarantee
those transactions are atomic, someone in the team
introduced a lock. You think that the first thing to check is
if you are *releasing* the lock. If your intuition is right, you'll fix the code,
add the test that should have covered that case and be *presto* in 5 min to re-deploy the application.

There is one problem though, the code doesn't have a well-defined structure and the
lock somehow was passed inside a lambda -- someone had to try out lambdas,
they are cool -- so you have no way of releasing the lock directly after the lambda call.
You decide to look for the lambda that has a lock and does not release it,
even when this method is reused by more than 130 queries (true story of my life).
To your horror, you observe that the things going on in the lambda call are indeed updated
atomically but the rest of the method body in which the lambda is called is not.
It seems like it is time to start refactoring the use of lambdas in those 130 queries.
<!-- Moreover, this method is used for multiple purposes and -->
<!-- you are passing a bunch of lambdas and there's no easy way to tell which one has -->
<!-- the damn lock!  -->
Shit, if only your teammate knew when it made sense to use lambdas and all the
cool features of the language!

#### **How did you end up in this situation?**

You coded a system considering all the functional requirements and the architecture
but you failed to create a good design. The hype of new features seemed like a silver
bullet and everyone in the team was using them (the same thing happens with new frameworks all the time).
The problem is understanding when to use those shiny new features and how they affect your design.

<div class="figure">
![Code Quality](https://imgs.xkcd.com/comics/code_quality.png)
<p>(Image from https://xkcd.com/1513/)</p>
</div>

The image above explains the situation of many self-taught developers (as well
as young developers and engineers who have just finished their degree)
who can read APIs, look on stackoverflow.com and find a solution
to most problems. However, to be a good engineer/developer,
being able to code does not mean that your code exhibits good software qualities,
i.e. that your code is flexible and maintainable.
This book will introduce you to design principles for creating a flexible
and maintainable code.

## Software Design

**Software design** is the process of **finding a satisfactory solution to a problem**.

Many books explain software design with a focus on one language and assume that this
knowledge can be "easily" extrapolated to other languages and/or paradigms. While
it is true that you have to start somewhere, it is also true that as soon as you
try to put the learnt design patterns in another language, their explanations may
not be easy to follow or not make sense at all, from the language's perspective.

After coding for more than 10 years, teaching a course on Advanced Software
Design at Uppsala University (Sweden), and doing (still working on it) a PhD on Programming Languages,
I believe that one of the strongest points of any language is its type system.
It is not the same to use a statically typed language with a strong type system (e.g. Haskell),
than to program in a dynamic and more flexible language. For instance,
the notion of *transducers*, introduced by the dynamic language Clojure,
is attractive to other languages but difficult to implement in a typed language.

Our approach in this book will be practical,
focusing and taking advantage of the type system (and its restrictions).
With this in mind, the knowledge can be extrapolated to
other languages, because we have built a common understanding of how the type system
interplays with the language.

Throughout the book,
<!-- For this reason, we are going to cover design principles from the perspective of -->
<!-- different languages and type systems, and  -->
we show different approaches to solving the same problem using a static and a dynamic language.
You will learn to take advantage of each of the languages
constructs, when to use them and when to avoid them.

Given that each language has different features, we use a visual modelling language
to express the main idea and let each language do their own implementation.
This visual language, called UML (*Unified Modelling Language*), is explained
in later chapters.

<!-- Before one can start with an implementation there needs to be a clear specification -->
<!-- of the problem to solve and a good understanding of the domain of the system under -->
<!-- design (you can draw a domain model to clarify ideas). You can also write an informal -->
<!-- document that describes the steps necessary to solve the problem (class and sequence -->
<!-- diagrams can help here) and notes about the expected non-functional requirements, i.e., -->
<!-- importing your friends' favourite places cannot block the main thread and should finish -->
<!-- in less than 30 seconds. -->

<!-- ### Agile methodologies -->

<!-- Given the definition above, designing software seems to be completely disjoint -->
<!-- from agile methodologies, e.g. Scrum, where you break user stories into smaller -->
<!-- tasks until everything is clear to the whole team. In Scrum, there seems to be no -->
<!-- domain model, not a single static and/or behavioural diagram, no architecture, etc, -->
<!-- just code-what-the-post-it says. There is one problem if this approach is taken literally -->
<!-- though: the post-it tells you what the problem is but not how to design it! You, as a -->
<!-- software engineer, should look at domain modelling, static and behaviour models and -->
<!-- architectural diagrams as tools under your belt that may be used if required, even in -->
<!-- agile methodologies. -->

<!-- Software design is all about making decisions. -->

<!-- Every problem involves taking small and big decisions and these influence the final -->
<!-- outcome of your software. For instance, the "simple" task of choosing a programming -->
<!-- language has a tremendous impact on your software. Choose a dynamic language and you'll -->
<!-- find quite a lot of errors at runtime (even if you use a test-driven development approach). -->
<!-- Other example is choosing between a object-oriented or a functional language. You can always -->
<!-- write the same piece of software using one paradigm or the other. However, one of them will -->
<!-- bring inherent benefits while the other one puts some extra burden in your code. -->

<!-- <div class="figure"> -->
<!-- ![](https://imgs.xkcd.com/comics/code_quality_2.png) -->
<!-- <p>(Image from http://xkcd.com/1695/)</p> -->
<!-- </div> -->

### What is a good design?

In general, a good design is one that can deal with change.

As a software engineer/developer, you have to think about a piece of code that today is a car,
tomorrow is a submarine and the next day is a tank. This happens because it is just
code, anyone can update it and it is not set in stone, ever.

There are many ways to solve a problem and, more often than not, there exist well-study
common solutions. These well-documented solutions are called design principles and design patterns and they
exist for all kinds of paradigms. In this book, we will focus on object-oriented design principles.

### Design principles

Design principles are guidelines to separate responsibilities of different classes and create
software that can be easily composed out of smaller pieces. The design principles
that we cover are known as *GRASP principles*, which stands for
*General responsibility assignment software principles*. In this book,
we cover the *GRASP principles*:

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

<!-- Next chapter: Case Study -->
