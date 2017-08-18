<screen>
  <div>
    <img if={selectedState === "bus"} onclick={clickBus} src="images/app/Transit.svg">
    <img if={selectedState === "weather"} onclick={clickRain} src="images/app/Weather.svg">
    <img if={selectedState === "crowd" || selectedState==='noneandcrowd'} onclick={clickCrowd} src="images/app/crowd_SVG.svg">
    <img if={selectedState.includes("bus") && selectedState.includes("weather") && selectedState.includes("crowd")} src="images/app/weather_crowd_transit.svg">
    <img if={selectedState === "none"} src="images/app/None.svg">
    <img if={selectedState.includes("bus") && selectedState.includes("weather")} src="images/app/weather_transit.svg">
    <img if={selectedState.includes("bus") && selectedState.includes("crowd")} src="images/app/crowd_transit.svg">
    <img if={selectedState.includes("weather") && selectedState.includes("crowd")} src="images/app/weather_crowd.svg">
  </div>

  <script>
    var self=this
    screenTag = this

    self.selectedState = "state1"

    changeState(stateId){
      self.selectedState = stateId
      self.update()
    }

    appTag.on("stateChanged",()=>{
      console.log("state is changed to " + homeTag.state)
      self.selectedState = homeTag.state
      self.update()
    });
    clickBus(){
      mbtadialog.showModal("12:30p")
    }
    clickRain(){
      raindialogTag.showModal("12:30p")
    }
    clickCrowd(){
      visiondialogTag.showModal("12:30p")
    }
  </script>
  <style>
    img{
      width: 100%;
      height: 100%;
    }
  </style>
</screen>


<app>

<div class="mdl-layout mdl-js-layout mdl-layout--fixed-header
            mdl-layout--fixed-tabs">

        <screen></screen>
        <crowddetails></crowddetails>
        <raindetails></raindetails>
        <mbtadetails></mbtadetails>
        <home showeventlabels=true loadfrom="home"></home>

</div>
  <script>
    appTag = this
    var self = this

    codePush = null
    
    self.userId  = localStorage.getItem("userId") || "testuser"
    self.userPreferences = {}

    self.data = [
      { id: "home", title: "Home" },      
      { id: "settings", title: "Settings" }
    ]
    self.page = self.data[0]

    
 
    this.on("mount", function(){
      route.exec()
    })

    click(e){
      // console.log(e.item);
      route(e.item.id)
    }
    
  

    route(function(id) {
      console.log(id)
      self.page = self.data.filter(function(r) { return r.id == id })[0] || {}
      self.page.is_active = true
      self.trigger('RouteChanged', self.page)

      self.update()
      if (!id)
        route("home")
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
  .loading{
    position: absolute;
    top:0;
    left: 0;
  }
  </style>
  
</app>
