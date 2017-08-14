<screen>
  <div>
    <img if={selectedState === "state1"} src="images/asset_1.png" width="100%" height="100%">
    <img if={selectedState === "state2"} src="images/asset_2.png" width="100%" height="100%">
    <img if={selectedState === "state3"} src="images/asset_3.png" width="100%" height="100%">
    <img if={selectedState === "state4"} src="images/situ-screen.png" width="100%" height="100%">

    <img if={selectedState === "situ1"} src="images/situ-screen.png" width="100%" height="100%">
    <img if={selectedState === "situ2"} src="images/situ-screen2.png" width="100%" height="100%">
    <img if={selectedState === "situ3"} src="images/situ-screen3.png" width="100%" height="100%">
  </div>

  <script>
    var self=this
    screenTag = this

    self.selectedState = "state1"

    changeState(stateId){
      self.selectedState = stateId
      self.update()
    }
  </script>
</screen>

<app>
  <!-- Simple header with fixed tabs. -->
<div class="mdl-layout mdl-js-layout mdl-layout--fixed-header
            mdl-layout--fixed-tabs">

        <screen></screen>
 

</div>

  <script>
    appTag = this
    var self = this
    self.userId  = localStorage.getItem("userId") || "testuser"

    allLogs = {}
    allText = {}
    atags = {}

    self.logs = []
    self.userPreferences = {}

    self.data = [
      { id: "logs", title: "Events" },      
      // { id: "clogs", title: "All Logs" },
      // { id: "devices", title: "devices" },
      { id: "vizualize", title: "vizualize" },
      // { id: "settings", title: "Settings" }
    ]
    self.page = self.data[0]


    this.on("mount", function(){
      // firebase.database().ref('/').once('value',s=> appTag.log("data", s.val()))
      token = "46a6d7385b7db671f0005f5e628405906fa28d84"
      particle = new Particle()
      self.initiateEventStreams()

      route.exec()
    })

    initiateEventStreams(){

      console.log('here1')
      
      particle.getEventStream({ name:'sensor:button', auth: token}).then(function(stream) {
        stream.on('event', function(data) {
          event = data
          console.log("Particle Event: " + event.name, event);
          screenTag.changeState(event.data)
          
        });
      });

      particle.getEventStream({ name:'webapp-controller', auth: token}).then(function(stream) {
        stream.on('event', function(data) {
          event = data
          console.log("WebApp Event: " + event.name, event);
          screenTag.changeState(event.data)
          
        });
      });

    }


    click(e){
      // console.log(e.item);
      route(e.item.id)
    }
    
  

    route(function(id) {
      self.page = self.data.filter(function(r) { return r.id == id })[0] || {}
      self.page.is_active = true
      self.trigger('RouteChanged', self.page)

      self.update()
      if (!id)
        route("logs")
    })
    
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
  body {
    background-color: black !important;
  }
  </style>
  
</app>
