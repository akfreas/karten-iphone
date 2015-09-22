
#Karten iOS App

####Sharable, offline-first flashcard app for iOS


This project was born out of frustration with other flashcard apps that had one or more problems.  Either they did not function well while offline, did not have a good sharing interface and way to share with others, or just had way too many bells and whistles for a simple flashcard app.

I'm not saying this project fixes *any* of the problems above in a way that is 100% user friendly, but it was a lot of fun to make something that was functional enough such that I could use it every day.


####Features

 - Create stacks of flashcards of any category (German, Physics, etc)
 - Share stacks with others and allow them to contribute and improve your content
 - Keep a list of friends that you share flashcards with
 - Add new cards while offline
 - Content is quickly and automatically synchronized when internet is available again
 - Tinder-style left/right swipe to indicate your knowledge of a word
 - Quiz yourself on words you don't know well or all words in your stack

####Screenshots

![screen1](https://s3.amazonaws.com/sashimiblade-github-assets/screen1.png)

![screen2](https://s3.amazonaws.com/sashimiblade-github-assets/screen2.png)

![screen3](https://s3.amazonaws.com/sashimiblade-github-assets/screen3.png)


####Tech

This project is written in Objective-C and Swift and has not been updated yet to Swift 2.0 syntax.  Offline syncing is accomplished using the [CouchbaseLite](https://github.com/couchbase/couchbase-lite-ios) iOS framework (which works very well!).
The iOS app utilizes the [Karten-Server](https://github.com/akfreas/karten-server) web app to serve up the API and handle interaction between Couchbase and the CouchDB server. 

####Setup

Be sure you have the latest version of Cocoapods installed, then run `pod install` in the home directory.  Open the new workspace and build.

You will also need to build the latest CouchbaseLite framework and place it into the Frameworks/CouchbaseLite.framework directory.

####Contributing

Anyone is welcome to contribute!  Just submit a pull request.  If you have questions about the project you can find me on Twitter [@sashimblade](https://twitter.com/sashimiblade). 
