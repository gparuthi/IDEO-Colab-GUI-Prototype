<controls>
<div class ="container">
  <div class="demo-card-wide mdl-card mdl-shadow--2dp">
        <div class="mdl-card__title">
        Particle States
        </div>
        <div class="mdl-card__supporting-text">
          <button onclick={state1Click}  class="mdl-button mdl-js-button"> <span>green</span></button>
              <button onclick={state2Click}  class="mdl-button mdl-js-button"> <span>yellow</span></button>
              <button onclick={state3Click}  class="mdl-button mdl-js-button"> <span>red</span></button>
              <button onclick={offClick}  class="mdl-button mdl-js-button"> <span>off</span></button>
        </div>
  </div>
  <div class="demo-card-wide mdl-card mdl-shadow--2dp">
        <div class="mdl-card__title">
        Web app
        </div>
        <div class="mdl-card__supporting-text">
          <button onclick={Wsitu1Click}  class="mdl-button mdl-js-button"> <span>situ1</span></button>
              <button onclick={Wsitu2Click}  class="mdl-button mdl-js-button"> <span>situ2</span></button>
              <button onclick={Wsitu3Click}  class="mdl-button mdl-js-button"> <span>situ3</span></button>
        </div>
  </div>
</div>
 

  <script>
    state1Click(){
      particle.callFunction({name:'led', deviceId: '28003b000447333437333039', argument: 'state1' , auth:token})
    }
    state2Click(){
      particle.callFunction({name:'led', deviceId: '28003b000447333437333039', argument: 'state2' , auth:token})
    }
    state3Click(){
      particle.callFunction({name:'led', deviceId: '28003b000447333437333039', argument: 'state3' , auth:token})
    }
    offClick(){
      particle.callFunction({name:'led', deviceId: '28003b000447333437333039', argument: 'off' , auth:token})
    }


    Wsitu1Click(){
      particle.publishEvent({name:'webapp-controller', data: 'situ1' , auth:token})
    }
    Wsitu2Click(){
      particle.publishEvent({name:'webapp-controller', data: 'situ2' , auth:token})
    }
    Wsitu3Click(){
      particle.publishEvent({name:'webapp-controller', data: 'situ3' , auth:token})
    }

  </script>
</controls>

<app>
  <!-- Simple header with fixed tabs. -->
<div class="mdl-layout mdl-js-layout mdl-layout--fixed-header
            mdl-layout--fixed-tabs">
  <header class="mdl-layout__header">
    
    <!-- Tabs -->
    <div class="mdl-layout__tab-bar mdl-js-ripple-effect ">
      <a href={"#"+id} onclick={click} each={data} class={mdl-layout__tab:true, is-active:is_active}>{title}</a>
    </div>
  </header>
  
  <main class="mdl-layout__content">
    <section class="mdl-layout__tab-panel is-active"  id="logs">
      <div class="page-content" hide={page.id != "logs"}>
        <!-- <clogs showeventlabels=true loadfrom="logs"></clogs> -->
        <controls></controls>
      </div>
    </section>
    <!-- <section class="mdl-layout__tab-panel is-active"  id="clogs">
      <div class="page-content" hide={page.id != "clogs"}>
        <clogs loadfrom="clogs"></clogs>
      </div>
    </section>
    <section class="mdl-layout__tab-panel is-active"  id="devices">
      <div class="page-content" hide={page.id != "devices"}>
        <devices></devices>
      </div>
    </section>-->
    <section class="mdl-layout__tab-panel is-active"  id="vizualize">
      <div class="page-content" hide={page.id != "vizualize"}>
        <vizualize></vizualize>
      </div>
    </section> 
  </main>

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
      
      particle.getEventStream({ deviceId:'28003b000447333437333039', auth: token}).then(function(stream) {
        stream.on('event', function(data) {
          event = data
          console.log('event')
          // console.log("Event: " + data.name, event);
          if (event.name == "ButtonDetected"){
            console.log('detected', event)
          }
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
