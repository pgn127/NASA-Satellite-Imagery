# NASA-Satellite-Imagery
This is an iOS app that displays an image sequence of historic satellite imagery from NASA's public data API based on where user drops the pin on the map.
This may be useful for assessing the results of natural disasters, farming or climate change over time.

##App Specification:
This application consists of a map view that allows a user to select a location they would like to view historical satellite imagery for. 
When a user long-presses on the map, a pin is dropped and a "View Location" button appears at the bottom of the screen.
PHOTO HERE OF MAP WITH VIEW LOCATION BUTTON
When this button is tapped, the user is transitioned to a screen that displays a looping image sequence of historical satellite imagery for the latitude and longitude of the pin they dropped on the map.
PHOTO HERE OF IMAGE SEQUENCE

##NASA API
NASA provides developers with a wide range of data to use in their applications. In this application, I use the following endpoint:
https://api.nasa.gov/planetary/earth/imagery

The endpoint requires the following query parameters:
* lat: lattitude of the area the user wishes to survey
* lon: the longitude of the area the user wishes to survey
* date: the date of the image being retrieved
* api_key: REQUIRED. Signing up for an API key at https://api.nasa.gov/index.html#apply-for-an-api-key provides 1000 API requests per hour.

After a GET request is made, NASA returns the data in the form of a JSON string with an image link field

##SatelliteViewController
This view displays the historic satellite imagery for the pin on the previous screen. It displays the corresponding image date for the photo currently being shown. 
7 NASA API requests are made starting at the current date and time of the user's long press, and then going back a month at a time, retrieving a corresponding image.

All data is loaded asynchronously using NSURLSession. A loading indicator is displayed to the user while the data is retrieved from NASA's API.
![Img] (https://raw.github.com/pgn127/iOSMagic8Ball/master/spanishstart.png)


##MapViewController
This view displays the map and drops a pin with a user's long press. Once the pin is dropped, a "View Location" button appears at the bottom of the screen, enabling the user to view the imagery for that location.

