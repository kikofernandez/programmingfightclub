# Case Study

<div class="figure">
![Family Trip](MEDIA/assets/achievement-art-camera-970203.jpg)
</div>

<p class="para"><span class="dropcaps">W</span>e will use the *Travellers Guide* app case study
to teach you important design concepts and principles. This case study is simple to
understand and makes you think about your design and how things are affected
by your decisions. Create a good design and you will have to do small changes
to accommodate your new requirements or when pivoting based on feedback from your users.

### Travellers Guide application

<p class="para"><span class="dropcaps">T</span>he startup you work for has this
idea of building a travelling social network: a mix of Twitter, TripAdvisor and
Pinterest all in one site. This application is called *Travellers Guide*.

To build this idea, there will be a web server (backend) and a  mobile app (front-end).
The backend is were your logic lives: getting information from database,
handling submission of pictures, resizing algorithm, AI for choosing the most relevant
guide cover, recommendation system, etc. The front-end talks to the server via a REST API,
shows the information on screen, handles cases with poor internet connection,
and syncs with the server. In the examples of this book, we will mainly focus on the backend,
although mobile devices are getting faster and many of the design principles covered
in the book are also well suited for programming mobile devices.

The details of what the application does are:

* Based on your friends recommendations, you get your own personal guides with places to visit,
restaurants, hotels, etc., all based on curated content from people you trust.
These guides don't show the typical and perfect pictures from the owner of the place,
but the ones your friends have uploaded. If there are too many pictures from your friends,
the system selects the best pictures using an AI algorithm and shows these in the cover of
the guide. The comments are limited to 200 characters, making sure recommendations go directly
to the point. Future work will allow any use to post also video comment of no more than 30 seconds.

* Another important feature is to show the location of the places (in a guide) in a map and
pinpoint the exact distance to the place and average time by public transport and walking time.

* All of these features are meaningless unless you can use the app offline. Thus,
the app should work in offline mode and sync with the server once there is internet connection.

* In the beginning, your friends may not yet be part of this platform. If this
is the case, one way to get you started with relevant content from your friends
is to enable the integration with TripAdvisor, where we will import your reviews,
your friends' and also photos from your friends and people you follow.

<!--
Another idea is a publishing site that sells book chapters and whole books. As a user, you can buy a few chapters to see whether the story is interesting and stop reading if you don't find it appealing. Have you ever thought about introductory books from which you know most of the content except one chapter or two. With this platform, you can buy those individual chapters alone and focus on your needs. Start learning smart!

Your team uses an agile methodology, *Scrum*, and there are post-it everywhere with the list of functional features (we will go through the list of non-functional later on).

![](/assets/Scrum_task_board.jpg)
(Image taken by Logan Ingalls, [source](https://commons.m.wikimedia.org/wiki/File:Scrum_task_board.jpg#mw-jump-to-license) )

-->

#### **How to get started?**

More often than not, when given a big task, such as the case study from above,
you may be wondering how you should begin to work on this behemoth task.
My recommendation is to start by identifying classes and build, little by little,
the abstraction layers that your software requires [^1].

One way to identify classes is to look at the *domain model* [^2], since the concepts
from the domain need to be coded in the application. Given the sales pitch above,
you can easily identify the following concepts:

- Lodge (Hotel, apartment, etc)
- Point of interest (POI)
- Restaurant
- Bar
- Nightclub
- Person
- Friend
- Picture
- Video
- Comment
- Review
- Guide
- etc (enough for now)

The domain concepts represent important ideas of our domain. These will be coded
into classes that represent the data layer of our application and contains business
logic that is encapsulated within each of the classes.

We have left out many decisions that we will take in the next chapter.
Feel free to try to break the design principles used in later chapters and find
better design strategies.

[^1]: Code is always in constant flux: it needs to be maintained and improved.
Your design will change too. A good design helps you to create software that is
flexible and as much pain free as possible (with respect to refactorings).

[^2]: This refers to the concepts of the domain in discourse, that is, the entities
and ideas that make up the travelling social network.
