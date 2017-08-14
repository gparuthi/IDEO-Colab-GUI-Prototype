/*
Copyright 2017 Google Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

'use strict';
var video = document.getElementById('video');
var     canvas = document.getElementById('canvas');
var     photo = document.getElementById('photo');
var     startbutton = document.getElementById('startbutton');

 var width = 320;    // We will scale the photo width to this
  var height = 0;     // This will be computed based on the input stream

var constraints = {
  video: { facingMode: { exact: "environment" } }
};

var video = document.querySelector('video');

function handleSuccess(stream) {
  window.stream = stream; // stream available to console
  video.src = window.URL.createObjectURL(stream);
  setInterval(function(){
    takepicture()
  }, 7000)
}

function handleError(error) {
  console.log('navigator.getUserMedia error: ', error);
}


function clearphoto() {
    var context = canvas.getContext('2d');
    context.fillStyle = "#AAA";
    context.fillRect(0, 0, canvas.width, canvas.height);

    // var data = canvas.toDataURL('image/png');
    // photo.setAttribute('src', data);
  }
  
  // Capture a photo by fetching the current contents of the video
  // and drawing it into a canvas, then converting that to a PNG
  // format data URL. By drawing it on an offscreen canvas and then
  // drawing that to the screen, we can change its size and/or apply
  // other changes before drawing it.

  function takepicture() {
    var context = canvas.getContext('2d');
    height = video.videoHeight / (video.videoWidth/width);
    if (width && height) {
      canvas.width = width;
      canvas.height = height;
      context.drawImage(video, 0, 0, width, height);
      // var data = canvas.toDataURL('image/jpeg');
      uploadPicToFirebase();
    } else {
      clearphoto();
    }
  }



function uploadPicToFirebase(){
	var storageRef = firebase.storage().ref();
	canvas.toBlob(function(blob){
	  // var image = new Image();
	  // image.src = blob;
	  // console.log(blob);
    var filename = "realtime.jpg" //"realtime-"+moment().format()+".jpg"
	  storageRef.child('images/'+filename).put(blob).then(function(){
      pushToFirebase(filename);
      console.log("Successfully Uploaded Image");
    });
	},'image/jpeg', 0.95); 
}

  function pushToFirebase(filename){
    firebase.database().ref('/visioninputrealtime').push().set({timestamp: moment().format(), filename:filename})
  }

navigator.mediaDevices.getUserMedia(constraints).
    then(handleSuccess).catch(handleError);
