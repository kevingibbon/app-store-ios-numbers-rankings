app-store-ios-numbers-rankings

==============================

Version 1.0 July 17, 2012

Base bones. Got it kinda working. Code is a mess. I will be back :)

![Alt text](http://assets3.pinimg.com/upload/287315651198126405_mOHgHeCU.jpg)

------------------------------

This is a simple app that gives detailed app store information in a very flexible implementation. We try to take the guess work out of the real numbers: downloads, revenue.

The premise behind this app is to use app store reviews to try to gauge how many times an application has been downloaded. A common industry standard is 1 review on the app store equals 400 downloads. This is the default implementation which is configurable in the settings menu.

Free apps revenue numbers are based on an advertising revenue stream, estimating every user has a ltv of $0.15. 

The 'F' or 'P' at the beginning of each row indicate Free vs Paid.

------------------------------

Shortcomings (yes there are many)

1. Accurate downloads? Due to the fact download numbers are hidden, reviews or press releases are the only way to determine how many times an application has been downloaded. Is 1:400 an accurate number? Who knows. Thats why its configurable. 

Do apps that prompt users to review get more downloads/rating? Probably. Do certain categories or passionate apps attract more reviews? Most definitely. 

2. Accurate revenue? Revenue is based on downloads, see above. Another problem are price changes or in-app purchases. Both these are not taken into account.

3. Free app revenue. There is no real way to estimate how much a user is worth. $0.15 ltv is a bit high for some apps, low for others. Also, many apps have 0 advertisements. This is just a best guess.

------------------------------

Notes
1. Please do not start writing to this parse api. If you wish to host your own db, please change the parse api key. 