# WasteLess

## Inspiration
Restaurants, schools, hospitals, and hotels generate approximately 22-33 billion pounds of food waste each year. Although there is a greater focus on food waste within the United States, restaurants still continue to throw away 94% of their excess food. That's why we created WasteLess!


## What it does
Instead of tossing leftover food that won't be served the next day, why not donate the surplus to locals in need? Our goal is to connect restaurants, schools, hotels, and more with less fortunate community members to prevent daily leftovers from being wasted. Tailoring to the user's needs based on their profile, an institution will have the ability to post information about their food surplus, while individuals will be able to connect to a place with leftover food. When an individual selects a location, they can easily view the address of the food bank along with any supplementary information to make the redistribution process run smoothly. In doing so, we hope to support those in need by directing excess food traffic towards them. From the business side, we developed an application for organizations that hope to reduce their waste, minimize their carting costs, or simply receive tax incentives. We believe that rescuing restaurant, school, and hotel cuisine should be simple and seamless, which is exactly what WasteLess aims to do. Join us in supporting food banks and reducing food waste!

## How we built it
WasteLess was developed utilizing Google's open source frameworks Flutter in connection with Firebase. Built for accessibility in mind, Flutter allowed us to develop a universal application for anyone to use regardless of the device they have. General users are not required to sign in, but distributors are required to create an account to properly access and manage their alerts/publications. Once signed in through Flutter's email/password suite, distributors type in their name and description, where FlutterFire helps uploads the distributor's data (name, description, location, time) to Firebase's Realtime Database. Simultaniously, general users are subscribed to the Flutter database, allowing for users to always have up-to-date information. Users are then shown a map of the closest distributors through Google Maps APIs within the GCloud suite of tools. 

## Challenges we ran into
For the majority of us, this was our first hackathon, so challenges were bound to arise. 

It was also our first time ever working with Firebase and Flutter, giving way to a steep learning curve. Especially since Flutter utilizes Dart, a language brand new to us, it took some time to adjust and understand its functionality. Our initial idea consisted of client devices to sending a message to a server, which would then ping users with notifications. We struggled to find a solid foundation for this backend looking through Flask, GCloud Pub/Sub, and Firebase Cloud Messaging (FCM). A large majority of our time was spent tinkering with FCM, where we came to the unfortunate realization that Flutter + Firebase had yet to implement upstream messages. We slowly migrated towards Firebase's Realtime Databases, which included a subscription feature to continuously update users with new publications. Along with learning new platforms and skills, we had trouble linking Google Cloud with our application to allow the client and server to communicate with one another.

## Accomplishments that we're proud of
Diving into the program development, we were all intimidated by the path ahead of us. We chose to not only learn a "few" new languages, but to do so on most of our first Hackathons. Looking back at the amazing progress we made over the past 37 hours we are nothing but proud of how much we've learned and designed. We were thrilled at how well our map's viewability and interactivity turned out. Some of the things like having markers noting institutions with excess food along and location tracking to direct individuals to local areas were thought to be impossible but ended up integrating smoothly. We also spent a great deal of time making sure that our application can be comfortably viewed on both Android and iOS devices. Last but not least, we are proud of our simple interface that allows users to post and search in our application based on their needs.

## What we learned
As mentioned earlier, we learned how to utilize Firebase's Realtime Database to store organization information, Flutter to develop the application, and navigation and routing from Google Maps APIs. We enjoyed learning about and implementing Google Cloud's features into our project and hope to continue learning more in the future.

## What's next for WasteLess
We hope to make a more accessible user interface with features based on each user's individual needs. We hope to bring our application to life by working with UCSC dining halls, local restaurants downtown, farmer's markets, and later expanding into Santa Cruz County.
