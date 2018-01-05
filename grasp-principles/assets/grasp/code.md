<!--

[Guide|-isPublic: bool; -friendsOnly: bool; -friendsOfFriends: bool; -title: String; -description: String]
[Guide]++-images*>[List<Image>]
[Guide]++-visibility*>[List<User>]
[Guide]<>-restReview>[Map<Restaurant‚String>]
[Guide]<>-hotelReview>[Map<Hotel‚ String>]

![](assets/grasp/GuideUML.png)

-->

<!--

[Guide|-title: String;-description: String]
[Guide]++-images>[List<IImage>]
[Guide]<>-poi->[List<IPointOfInterest>]
[IPointOfInterest|IReview getReview();String getAddress();void showOnMap();]
[List<IPointOfInterest>]<>->[IPointOfInterest]
[IPointOfInterest]^-.-[Hotel| IReview getReview();String getAddress();void showOnMap();]
[IPointOfInterest]^-.-[Restaurant| IReview getReview();String getAddress();void showOnMap();]

![](assets/grasp/LooselyGuideUML.png)

-->

<!--

[Guide|-isPublic: bool; -friendsOnly: bool; -friendsOfFriends: bool; -title: String; -description: String]
[Guide]---html>[HTMLDescription]
[Guide]---markdown>[MarkdownDescription]
[Guide]++-images*>[List<Image>]
[Guide]---socket>[WebSocket]
[List<Image>]->[Image]
[Image]->[Guide]
[List<User>]->[User]
[User]-includedIn-*>[Guide]
[Guide]++-visibility*>[List<User>]
[Guide]<>-restReview>[Map<Restaurant‚String>]
[Guide]<>-hotelReview>[Map<Hotel‚String>]

![](assets/grasp/TheBlob.png)

-->

<!--

[Review|-comment:String; |show(): Image; ...]++image-0..1>[Image]
[Review]<>author-1>[User]
[Review]<>notify-*>[List<User>]

![](assets/grasp/Review.png)

-->

<!--
[Review|show(): List<IDisplayable>; ...]++attachments->[List<IDisplayable>]
[Review]-comment->[IComment]
[Review]<>author-1>[User]
[Review]<>observers->[List<INotifier>]

![](assets/grasp/RefactoredReview.png)

-->

<!--

[Comment]<*-1>[Hotel]
[Comment]<*-1>[Restaurant]
[Comment]image--0..1>[Image]
[Comment]rating->[Rating]

![](assets/grasp/Comment.png)

-->

<!--

[User]++-*>[Guide]
[Guide]<>-*>[POI]
[POI]^-[Restaurant]
[POI]^-[Hotel]
[POI]<>-*>[Comment]
[POI]->[LatitudeLongitude]

![](assets/grasp/UsersGuidePOI.png)

-->

<!--

[GuidesView]->[Routes]
[Routes]-／guide ̸* ->[GuideController]
[Routes]-／comment ̸*->[CommentController]
[Routes]-／user ̸*->[UserController]
[GuideController]->[GuideModel]
[UserController]->[UserModel]
[CommentController]->[CommentModel]

![](assets/grasp/Controller.png)

-->

<!--

[User| -firstName: String; -last name: String; -username: String; -confirmedIdentity: Boolean| boolean login(Password pwd); Image displayImage()]
[User]-.->[Password]
[User]-.->[Image]
[User]->[Email]

![](assets/grasp/UserBorePolymorphism.png)

-->

<!--

[user1: User]->[madrid: Guide]
[user2: User]->[madridCopy: Guide]
[madrid: Guide]coverImage->[elPrado: Image]
[madridCopy: Guide]coverImage->[cibeles: Image]
[madrid: Guide]<>-*>[POI]
[madridCopy: Guide]<>-*>[POI]
[POI]^-[Restaurant]
[POI]^-[Hotel]
[POI]<>-*>[Comment]

![](assets/grasp/IndirectionDuplication.png)

-->

<!--

[user1: User]->[madrid: Guide]
[user2: User]->[madrid: Guide]
[madrid: Guide]coverNanager->[CoverManager]
[CoverManager]images<>-*>[Image]
[madrid: Guide]<>-*>[POI]
[POI]^-[Restaurant]
[POI]^-[Hotel]
[POI]<>-*>[Comment]

![](assets/grasp/IndirectionAfterApplication.png)

-->

<!--

[PaymentAdapter|PaymentAdapter(Paypal); PaymentAdapter(CreditCard); boolean pay(amount);] , [PaymentAdapter] -.-> [Paypal|boolean sendPayment(amount);], [PaymentAdapter] -.-> [CreditCard|boolean creditPayment(amount);]

![](assets/grasp/AdapterPureFabrication.png)

-->

<!--

[;IPayment|;pay();...]
[;IPayment]^-[StripeAdapter]
[;IPayment]^-[PaypalAdapter]
[StripeAdapter]->[;Stripe.Invoice;|pay()]
[PaypalAdapter]->[;Paypal.Payment|sendPayment()]

![](assets/grasp/ProtectedVariation.png)

-->
