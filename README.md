GUI
===

Prototype for SmartCity Project about detecting anomalies in people's commute to reduce uncertainty. We used computer vision and other APIs to notify users at the right time. For example, when there are too many people at the subway station and trains are too crowded, we may alert a user who might be thinking about taking the subway. This way users can think about alternative ways like taking an Uber or bike.


## What is this?

1. Mobile App (Cordova)
	- Notifies the user of anomalies
	- Connects to existing APIs:
		- Google Maps API for getting the route information
		- DarkSky API for predictive weather data
		- MBTA API for getting possible alerts for a subway line
	- Uses cordova plugins for
		- running in the background
		- creating notification

2. Tensorflow 
	- The python script works as the image processing backend that counts the number of objects (person, cars, etc.) 
	- The script listens to firebase for any new images. When an image is pushed, it downloads the image and runs tensor-flow object_datection inferencing model (pre-trained). The result is then pushed back to firebase.

3. Dashboard
	- The dashboard acts as a part of the backend. It pipes an input stream of photos (e.g. from camera) to the tensorflow input stream.
	- It visualizes each of the input stream and also the output stream from Tensorflow.

4. Camera app
	- It captures photos using phone's camera and pushes them to Firebase.
	- It can run on any Android Nougat Chrome browser.

5. Remote Controller
	- To manually trigger anomalies on the webapp

## Installation
1. Install Tensorflow ((link)[])
2. Setup Firebase. Get access tokens.
3. Install Cordova and run the app on your phone

## Configuration of API Tokens
1. Edit these files to use your firebase tokens
	- mobile-app www/index.html
	- Dashboard web/midpoint/index.html
	- Camera app web/camera/index.html
	- Tensorflow tensorflow/x.py
2. Edit the mobile app to use your Google Maps, Dark Sky, and MBTA API tokens
	- File x.html


