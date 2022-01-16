# WasteLess

## Inspiration
Restaurants, schools, hospitals, and hotels generate approximately 22-33 billion pounds of food waste each year. Although there is a greater focus on food waste within the United States, restaurants still continue to throw 94% of their excess food. That's why we created WasteLess!


## What it does
Instead of tossing leftover food that won't be served the next day, why not donate the surplus to local food banks? Our goal is to connect restaurants, schools, hotels, and more with food banks to prevent daily leftovers from being wasted. Tailoring to the user's needs based on their profile, an institution will have the ability to post information about their food surplus, while individuals will be able to connect to a place with leftover food. When an individual selects a location, they can easily view the address of the food bank along with any supplementary information to make the redistribution process run smoothly. In doing so, we hope to support local food banks by directing excess food traffic towards them. From the business side, we developed an application for organizations that hope to reduce their waste, minimize their carting costs, or simply receive tax incentives. We believe that rescuing restaurant, school, and hotel cuisine should be simple and  seamless, which is exactly what WasteLess aims to do. Join us in supporting food banks and reducing food waste.

## How we built it
WasteLess was developed utilizing Google's open source framework Flutter along with HTML, Objective-C, Ruby, Swift, and Kotlin. After the user verifies their credentials on our login page, the home page provides information on how to post or locate an institution with excess food. We used the Google Maps API to display pinpoints of restaurants, hotels, and schools nearby the user based on their location and a pinpoint based on their specified search. Within the business side, we utilized Google Cloud's Firebase Realtime Database to store each of the restaurants, hotels, and schools' informational posts.

## Challenges we ran into
For the majority of us, this was our first hackathon, so challenges were bound to arise. 

It was also our first time ever working with Firebase and Flutter, giving way to a steep learning curve. Especially since Flutter utilizes Dart, a language brand new to us, it took some time to adjust and understand its functionality. Besides Flutter, we had some trouble understanding how Firebase Cloud Messaging worked, so we spent a lot of time understanding the API's features. Along with learning new platforms and skills, we had trouble linking Google Cloud with our application to allow the client and server to communicate with one another. While one way notifications were a start, we later configured a database with Firebase Realtime Database to permit a two-way communication stream. 

## Accomplishments that we're proud of
We are proud of our map's viewability and interactivity with markers noting institutions with excess food along with location tracking to direct individuals to local areas. We also spent a great deal of time making sure that our application can be comfortably viewed on both Android and iOS devices. In addition, we are proud of our simple interface that allows users to post and search in our application based on their needs. 

## What we learned
As mentioned earlier, we learned how to utilize Firebase's Realtime Database to store organization information, Flutter to develop the application, and navigation and routing. We enjoyed learning about and implementing Google Cloud's features into our project and hope to continue learning more in the future.

## What's next for WasteLess
We hope to make a more accessible user interface with features based on each user's individual needs. We hope to bring our application to life by working with UCSC dining halls, local restaurants downtown, farmer's markets, and later expanding into Santa Cruz County.
