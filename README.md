# youlookgood
This is an app to answer our girlfriend/wife's favorite fashion question: "How do I look?".

## How to use this app
There are 4 pages in this app:  
 - home page
 - picture taking page
 - target item marking page
 - analyzing and result page

So it's quite simple.  
 1 .You click "start" button in the home page to start.  
 2. You take a picture of your girlfriend/wife who is trying a new cloth/pents/bag... anything, whatever.
 3. You mark the target item by painting the whole object. The place you paint will be brighter in the result image to make it looks special.  
 4. After you finished marking the target item, and click "submit" button, nothing will be submit to anywhere and you'll go to the result page.  
 5. In the result page, this app will shows a random score and shows the text "You look good" in the result page after a fake analyzing process. Just like what we always do.  

The most important thing:  
The fake analyzing process will take 3~5 secs, so remember to show the result page to your girlfriend/wife right after you click the "submit" button.  
She'll see the analyzing process and see a good result she needs.  
Everyone is happy.  


## Data Privacy
This app will not upload anything from your phone, and it also won't store the picture you take in your device.  
If you need anything from this app, just take a screenshot.  

## Unsolved issue
1. There is a delay when taking a picture:
    - The code I'm using is from flutter official tutorial.
    - This is an interesting issue but I don't have enought time to dig into it at this point.
2. The drawing page could be further optimized:
    - The current approach is separating current path and history paths also set a sampling ratio to not draw every point.
    - Due to the sampling ratio, the path will look a bit rough, not very smooth.
    - Should be a better way to tackle this issue but same I don't have enought time to dig into it at this point. 