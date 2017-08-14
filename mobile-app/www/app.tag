
<app>

<div class="mdl-layout mdl-js-layout mdl-layout--fixed-header
            mdl-layout--fixed-tabs">
  <header class="mdl-layout__header">
    
    <!-- Tabs -->
    <div class="mdl-layout__tab-bar mdl-js-ripple-effect ">
      <a href={"#"+id} onclick={click} each={data} class={mdl-layout__tab:true, is-active:is_active}>{title}</a>
    </div>
  </header>
  
  <main class="mdl-layout__content">
    <section class="mdl-layout__tab-panel is-active"  id="home">
      <div class="page-content" hide={page.id != "home"}>
        <crowddetails></crowddetails>
        <raindetails></raindetails>
        <mbtadetails></mbtadetails>
        <home showeventlabels=true loadfrom="home"></home>
      </div>
    </section>
    <section class="mdl-layout__tab-panel is-active"  id="settings">
      <div class="page-content" hide={page.id != "settings"}>
        <settings showeventlabels=true loadfrom="settings"></settings>
      </div>
    </section>
  </main>


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
