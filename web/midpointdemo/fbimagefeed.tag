<birdseye>
<div>
    <div class="mdl-cell mdl-cell--4-col" style="text-align: center;">
    <img src="images/mapanimation-slow.gif" style="max-width: 100%">
    <hr>
    <!-- <h3>User's Route</h3> -->
     
    <img src={userImage}>
     
    </div>
</div>
<script>
  var self = this
  this.userImageList = ["images/notif1.jpg","images/notif2.png","images/notif3.jpg","images/notif4.jpg"]
  this.userImage = "images/notif1.jpg"


  this.on("mount", function(){
      setInterval(function(){
        self.userImage = _.shuffle(self.userImageList)[0]
        self.update()
      },4000)
  })
</script>
</birdseye>

<fbimagefeed>
  <div class={selected: isThisSelected(), notselected: !isThisSelected(), feedContainer: true}>
    <h4>{opts.title}</h4>
    <div class="live">
      <i class="Blink fa fa-circle text-danger"></i>&nbsp; LIVE 
    </div>
    <img id={opts.feedid} style="max-height: 400px; max-width: 500px;" onclick={setThisAsSelected} src={imgURL}>
  </div>

<script>
  var self = this
  self.showloading = false
  self.uniqueLoadId = ""

  this.on("mount", function(){
    self.loadImage()     
  })

  loadImage(uniqueLoadId){
    if (uniqueLoadId===self.uniqueLoadId)
      return
    else{
      self.uniqueLoadId = uniqueLoadId
    }
      


    self.showloading = true
    var myImage = document.querySelector('#'+opts.feedid)

    firebase.storage().ref('images').child(opts.imgsrc).getDownloadURL().then(url => {
      // console.log(url);
      fetch(url).then(function(response) {
        return response.blob();
      }).then(function(myBlob) {
        self.blob = myBlob
        var objectURL = URL.createObjectURL(myBlob);
        myImage.src = objectURL
        if (self.isThisSelected())
          self.pushToTensorFlow()
      });

      // self.imgURL = url;

      // firebase.database().ref('/visionresults').limitToLast(1).once("value", function(s){

      // });
      setTimeout(function(){
        self.showloading = false
        self.update()
      }, 1000)

      self.update();
     })
  }

  setThisAsSelected(){
    self.pushToTensorFlow()
    self.parent.selectedFeedId = self.opts.feedid
    self.parent.update()
  }

  pushToTensorFlow(){
    blob = self.blob
    self.parent.setTFInputFeed(self.blob)
  }

  isThisSelected(){
    return self.opts.feedid === self.parent.selectedFeedId
  }
</script>

<style>
  .selected{
    border: #fcb62a;
    border-style: solid;
  }
  .feedContainer {
    text-align: center;
    color: #0ab7ae;
  }

  
  .Blink {
    

      animation: blinker 1.5s cubic-bezier(.5, 0, 1, 1) infinite alternate;  
          color: #ec2c93;
  }

  @keyframes blinker {  
    from { opacity: 1; }
    to { opacity: 0; }
  }
  .notselected{
    opacity: 0.5;
    border:gray;
    border-style: solid;
  }
</style>
</fbimagefeed>

<tweetfeed>
  <div class={selected: isThisSelected(), notselected: !isThisSelected(), feedContainer: true}>
    <h4>{opts.title}</h4>
    <div class=""><i class="Blink fa fa-circle text-danger"></i>&nbsp; LIVE </div>
    <img id={opts.feedid} style="max-height: 400px; max-width: 400px;" onclick={setThisAsSelected} src={imgURL}>
    <div class="mdl-shadow--2dp">
           <div class="mdl-card__title" style="font-size: 30px">
           {text}
           </div>
     </div>
    
  </div>

<script>
  var self = this
  self.showloading = false
  self.uniqueLoadId = ""

  this.on("mount", function(){
    self.loadImage()     
    setInterval(function(){
      self.loadImage()
    }, 10000)
  })

  self.tweets = [{"text": "This #LIRR platform was a tad crowded #SummerofHell", "image": "images/soh3.jpg", "geo": {"type": "Point", "coordinates": [40.7465, -74.009445]}}, {"text": "Train out of service. #A #Train #summerofhell @MTA #horribleservice @ #highstreet https://t.co/S3pCwiXJ66", "image": "http://pbs.twimg.com/media/DFlVO_7W0AIcJsQ.jpg", "geo": {"type": "Point", "coordinates": [40.7465, -74.009445]}}, {"text": "So #summerofhell continues - just another day with the @MTA https://t.co/cNfieJzGyq", "image": "http://pbs.twimg.com/media/DFIepp6U0AAalO-.jpg", "geo": {"type": "Point", "coordinates": [40.7465, -74.009445]}}, {"text": "The @MTA welcomes me home to New York! #summerofhell https://t.co/iEvYhh8uid", "image": "http://pbs.twimg.com/media/DFGMQhtVoAAk5oj.jpg", "geo": {"type": "Point", "coordinates": [40.7465, -74.009445]}},  {"text": "Long delay at 14th St #summerofhell", "image": "images/soh1.jpg", "geo": {"type": "Point", "coordinates": [40.7465, -74.009445]}}]

  self.tweetIndex = 0
  self.text = ""

  loadImage(){
     self.showloading = true
     var myImage = document.querySelector('#'+opts.feedid)

     var url = self.tweets[self.tweetIndex]['image']
     self.text = self.tweets[self.tweetIndex]['text']
     self.tweetIndex += 1
     appTag.trigger('soh')
     if (self.tweetIndex===self.tweets.length)
        self.tweetIndex=0
     console.log(url)
     fetch(url).then(function(response) {
       return response.blob();
     }).then(function(myBlob) {
       self.blob = myBlob
       var objectURL = URL.createObjectURL(myBlob);
       myImage.src = objectURL
       self.update();
       if (self.isThisSelected()){
        console.log("Pushed!", opts.feedid)
         self.pushToTensorFlow()
       }
       else {
        console.log("Did not push", opts.feedid)
       }
     });

       setTimeout(function(){
         self.showloading = false
         self.update()
       }, 1000)

       
  }

  setThisAsSelected(){
    self.pushToTensorFlow()
    self.parent.selectedFeedId = self.opts.feedid
    self.parent.update()
  }

  pushToTensorFlow(){
    blob = self.blob
    firebase.storage().ref('images').child(opts.feedid+'.jpg').put(blob).then(function(){
        console.log("Successfully Uploaded Image", opts.feedid)
        self.parent.setTFInputFeed(self.blob)
    });
    
  }

  isThisSelected(){
    return self.opts.feedid=== self.parent.selectedFeedId
  }
  </script>

  <style>
    .selected{
      border: #fcb62a;
      border-style: solid;
    }
    .feedContainer {
      text-align: center;
      color: #0ab7ae;
    }
    .Blink {
        animation: blinker 1.5s cubic-bezier(.5, 0, 1, 1) infinite alternate;  
            color: #ec2c93;
    }

    @keyframes blinker {  
      from { opacity: 1; }
      to { opacity: 0; }
    }
    .notselected{
      opacity: 0.5;
      border:lightgray;
      border-style: solid;
    }
    img {
      -webkit-transition: opacity 1s ease-in-out;
      -moz-transition: opacity 1s ease-in-out;
      -o-transition: opacity 1s ease-in-out;
      transition: opacity 1s ease-in-out;
    }
  </style>
</tweetfeed>

<tfprocessed>
  <div class="feedContainer">
    <h4>{opts.title}</h4>
    <img id={opts.feedid} style="width: 600px ;max-height: 600px; max-width: 600px;" src={imgURL}>
  </div>

  <script>
    var self = this
    tftag = this
    self.showloading = false

    this.on("mount", function(){
      self.loadImage()     
    })

    loadImage(){
      self.showloading = true
      var myImage = document.querySelector('#'+opts.feedid)

      firebase.storage().ref('images').child(opts.imgsrc).getDownloadURL().then(url => {
        // console.log(url);
        fetch(url).then(function(response) {
          return response.blob();
        }).then(function(myBlob) {
          self.blob = myBlob
          var objectURL = URL.createObjectURL(self.blob);
          myImage.src = objectURL;
        });

        // self.imgURL = url;

        // firebase.database().ref('/visionresults').limitToLast(1).once("value", function(s){

        // });
        setTimeout(function(){
          self.showloading = false
          self.update()
        }, 1000)

        self.update();
       })
    }
  </script>

  <style>
    .feedContainer {
      text-align: center;
      color: #fcb62a;
    }
  </style>
</tfprocessed>