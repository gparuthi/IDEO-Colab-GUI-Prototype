<home>
<!-- Simple header with fixed tabs. -->
<div class="container">

</div>

<script>
  var self = this
  homeTag = self
  self.state = ''

  this.on("mount", function(){
      self.listenToFirebaseRemote()
      self.startClick()
    })

  listenToFirebaseRemote(){
    firebase.database().ref('guiappremote/state/').limitToLast(1).on("value", d=>{
      console.log(d.val())
      self.setState(d.val().state)
    })
  }

  setState(state, data){
    if (!state)
      return
    self.state = state
    if (state.includes('weather')){
      // show rain anomaly true
      if (!self.showrain){
      self.showrain = true
      if(window.hasOwnProperty('cordova')){
        var localNotification = {
                id: 100,
                title: 'GUI Rain Anomaly',
                text: "It's going to rain on your way to Kendal Sq. You can start 15 minutes later to avoid rain ;)"
              }
          cordova.plugins.notification.local.schedule(localNotification);
      }
    }
      
    } else {
      self.showrain = false
    }
    if (state.includes('bus')){
      if (!self.showbus){
      // show rain anomaly true
      self.showbus = true
      if(window.hasOwnProperty('cordova')){
      var localNotification = {
                    id: 100,
                    title: 'GUI MBTA Anomaly',
                    text: "The Red line is delayed 10-15 minutes. Consider an alternative route."
                  }
              cordova.plugins.notification.local.schedule(localNotification);
            }
          }
    } else {
      self.showbus = false
    }
    if (state.includes('crowd')){
      if (!self.showcrowd){
        // show rain anomaly true
        self.showcrowd = true
        if(window.hasOwnProperty('cordova')){
        var localNotification = {
                id: 100,
                title: 'GUI Crowd Anomaly',
                text: "The Kendall Station looks very crowded right now. Hang back 15 minutes to find a train with vacant seats."
              }
          cordova.plugins.notification.local.schedule(localNotification);
      }
      
      }
    } else {
      self.showcrowd = false
    }

    // self.refs.directions.updateLegs()
    appTag.trigger('stateChanged')
  }

  removeState(state){
    console.log(state)
    if (state && self.state.includes(state))
      self.state = self.state.replace(state, '')
    appTag.trigger('stateChanged')
  }

  addState(state){
    console.log("Adding state", state)

    if (state && !self.state.includes(state))
      self.state = self.state.concat("and", state)
    appTag.trigger('stateChanged')
    // self.state.push(state)
    // self.setState(self.state)
  }

  startClick(){
      self.steps=[]
      // self.from = self.refs.fromInput.value
      // self.to = self.refs.toInput.value
      // self.refs.directions.calcRoute(self.from, self.to)
    }
</script>

</home>