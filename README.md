app-store-ios-numbers-rankings

==============================

Version 1.0 July 17, 2012 12:57 AM

Bare bones. Got it kinda working. Code is a mess. I will be back :)

![Alt text](http://assets3.pinimg.com/upload/287315651198126405_mOHgHeCU.jpg)

------------------------------

This is a simple app that gives detailed app store information in a very flexible implementation. I'm trying to take the guess work out of real numbers: downloads, revenue.

The premise behind this app is to use app store reviews to gauge how many times an app has been downloaded. A common industry standard is 1 review on the app store equals 400 downloads. This is the default implementation which is configurable settings.

Free app revenue is based on a advertising revenue stream, estimated ltv of $0.15. 

The 'F' or 'P' at the beginning of each row indicate Free vs Paid.

------------------------------

Shortcomings (yes there are many)

1. Accurate downloads? Download numbers are hidden by Apple, no. of reviews are the only way to best guess how many times an app has been downloaded. Is 1:400 an accurate ratio? Who knows. That's why its configurable. 

Do apps that prompt users to review get more downloads/ratings? Probably. Do certain categories or passionate apps attract more reviews? Most definitely. 

2. Accurate revenue? Revenue is based on downloads, see above. Other problems are price changes and in-app purchases. Both are not taken into account.

3. Free app revenue. There is no real way to estimate how much a user is worth. $0.15 ltv is a bit high for some apps, low for others. Also, many have 0 advertising. This is just a best guess.

------------------------------

Notes

1. Please do not start writing to this parse db. If you wish to host your own db, please change the parse api key. 

------------------------------

Bugs

1. Sort by rankings does not sort by number of ranking. It currently sorts on server side by revenue at 400:1 ratio. Need to add 100, 200, 300, 400 pre-calculated revenue to db and sort based on those.