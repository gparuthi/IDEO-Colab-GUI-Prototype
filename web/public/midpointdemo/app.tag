<app>
  <!-- Simple header with fixed tabs. -->
<div class="container">

  <div class="mdl-grid">
    <div class="mdl-cell mdl-cell--12-col" style="text-align: center;">
      <img src="images/gui_cc.png">
      <hr>
    </div>
    <div class="mdl-cell mdl-cell--3-col" style="text-align: center;">
      <h3>GUI Sensors</h3>
      <fbimagefeed ref="realtimeFeedTag"  feedid="realtime" title="Camera: Realtime Feed" imgsrc="realtime.jpg"></fbimagefeed>
      <tweetfeed ref="event1FeedTag" feedid="summerofhell" title="Social Media: #SummerOfHell" imgsrc="summerofhell.jpg"></tweetfeed>
      <div>
        <!-- <video crossorigin="anonymous" id="videoPlayer_html5_api" class="vjs-tech" preload="none" tabindex="-1" autoplay="" src="blob:https://www.earthcam.com/f68eb703-7c90-49ce-983e-7b97fd2f4624" style="background: url(&quot;//www.earthcam.com/cams/includes/image.php?logo=0&amp;img=2d900e04fb7fe731dd78384d431be953&quot;) 0px 0px no-repeat transparent;"></video> -->
      </div>
    </div>
<!--     <div class="mdl-cell mdl-cell--4-col">
      <fbimagefeed ref="event2FeedTag" feedid="event2" title="Event2 Feed" imgsrc="realtime.jpg"></fbimagefeed>
    </div>
 --> 
    <div class="mdl-cell mdl-cell--9-col" style="text-align: center;">
    <h3>GUI Backend</h3>
      <tfprocessed ref="processedFeedTag" feedid="processed" title="" imgsrc="tf-processed.png"></tfprocessed>
      <h4>{tfresultString}</h4>
    </div>
    <div class="mdl-cell mdl-cell--5-col" style="text-align: center;">
    <birdseye></birdseye>
    </div>
    
  </div>
   

</div>

  <script>
    appTag = this
    var self = this
    self.selectedFeedId = "realtime"
    self.userId  = localStorage.getItem("userId") || "testuser"

    self.lastImage = ""

    self.logs = []
    self.userPreferences = {}
    self.tfresultString = ""


    this.on("mount", function(){
      
        self.setupUpdateTFResult()
      
    })

    setupUpdateTFResult(){
      firebase.database().ref('/visionresults').limitToLast(1).on("value", function(s){
       d = s.val()
       console.log(d)
       self.tfresultString = ""
       _.each(_.pairs(_.values(d)[0].objects), d=>{
         if (self.tfresultString === "")
           self.tfresultString += d[1] + " "  + d[0]
         else 
          self.tfresultString += ", " + d[1] + " "  + d[0]
      })

       self.refs.processedFeedTag.loadImage(JSON.stringify(_.values(d)[0].probabilities))
       self.update()
     })

      firebase.database().ref('/visioninputrealtime').on("value", function(s){
        var d = s.val()
        // console.log('realtime feed updated', d)
        self.refs.realtimeFeedTag.loadImage(JSON.stringify(d))
      })
    }

    log(m, data){
     data = data || {}
     var timestamp = new moment()
     var saveObject = {text: ""+m, time: timestamp.format(), data:data}
     console.log("[LOG]["+timestamp.format("hh:mm")+"] " + m);
     firebase.database().ref('logs/').push().set(saveObject)
    }
    
    checkForMDL(){
      setTimeout(function(){
        componentHandler.upgradeAllRegistered()
        componentHandler.upgradeDom()
        _.each($('.mdl-js-textfield'), function(b){b.MaterialTextfield.checkDirty()})
      }, 100)
      // componentHandler.upgradeDom() // for mdl-lite nav bar update
      
    }

    setTFInputFeed(blob){
      self.refs.processedFeedTag.showloading = true;
      self.refs.processedFeedTag.update()
      firebase.database().ref('/visioninput/tfinput').set({'updated': moment().format(), 'selectedFeedId': self.selectedFeedId})
      // firebase.database().ref('/visioninput/tfinput').set({})
      // firebase.storage().ref('images').child('tf-input.jpg').put(blob).then(function(){
      //   console.log("Successfully Uploaded Image")
        
      // });
    }


  </script>

  <style>
  .strong{
    font-weight: bold;
  } 

  .mdl-layout__tab-bar {
    height: 48px;
  }
  .header{
    color: grey;
    font-size: 8pt;
    margin: 0px;
  }
  .text{

  }
  .logcontainer{
    height: 80vh;
    float:left;
    padding:0 0 0 5px;
    position:relative;
    float:left;
    border-right: 1px #f8f7f3 solid;
    /* background-color: black; */
  }
  .loading{
    position: absolute;
    top:0;
    left: 0;
  }
  body {
    background-color: black !important;
  }
  </style>
  
</app>
