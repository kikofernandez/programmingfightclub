# Case Study - Fight Club

![](/assets/VWKombi@theBeachbyCarolineGutman640.jpg)

The following case study will be used throughout the book to teach you important design concepts and principles. The reader exercises are also based on this case study.

**Startup idea**

The startup you work for has this idea of building a travelling social network: a mix of Twitter, TripAdvisor and Pinterest all in one site. To build this idea, there will be a web server (backend) and a  mobile app (front-end). The idea is the following:

*Based on your friends recommendations, you get your own personal guides with places to visit, restaurants, hotels, etc., all based on curated content from people you trust. These guides don't show the typical and perfect pictures from the owner of the place, but the ones your friends have uploaded. If there are too many pictures from your friends, the system selects the best pictures using an AI algorithm and shows these in the cover of the guide. The comments are limited to 200 characters, making sure recommendations go directly to the point. Future work will allow any use to post also video comment of no more than 30 seconds.*

*In the beginning, your friends may not yet be part of this platform. To get you started with the most relevant content from your friends, you can enable the integration with TripAdvisor and we will import your reviews, your friends' and also photos from your friends and people you follow.*

*Another important feature is to show the location of the places (in a guide) in a map and pinpoint exactly the distance to the place and average time by public transport and walking time. All of these features are meaningless unless you can use the app offline. Thus, the app should work in offline mode and sync with the server once there is internet connection.*

<!--
Another idea is a publishing site that sells book chapters and whole books. As a user, you can buy a few chapters to see whether the story is interesting and stop reading if you don't find it appealing. Have you ever thought about introductory books from which you know most of the content except one chapter or two. With this platform, you can buy those individual chapters alone and focus on your needs. Start learning smart!
-->

Your team works using an agile methodology, Scrum, and there are post-it everywhere with the list of functional features (we will go through the list of non-functional later on).

[IMAGE]
(Image taken by Logan Ingalls, [source](https://commons.m.wikimedia.org/wiki/File:Scrum_task_board.jpg#mw-jump-to-license) )

**Coding the information**

[^domain]: this refers to the concepts of the domain in discourse, that is, the entities and ideas that make up the travelling social network.

One way to identify classes is to look at the domain model [^domain], since the concepts from the domain need to be coded in the application. Given the sales pitch above, you can easily identify the following concepts:
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

The domain concepts represent important ideas of our domain. These will be coded into classes that represent the data layer of our application and contains business logic that is encapsulated within each of the classes.

We proceed to explain object-oriented programming using examples this domain.