<directions>
  <div>
    <div if={loaded}>
    <legsviz ref="legsTag">
      </legsviz>
      <p>Start Time: {departureTime.text}, From {leg.start_address}</p>
      
      
      <ul>
        <div onclick={print} each={steps}>
          {duration} | <span if={weather}>{weather.temp}, {weather.summary}</span> | {travelMode} | {instructions}

          <p if={travelMode === "TRANSIT"}>
            <span style="color: {s.transit.line.color}"><img src={s.transit.line.vehicle.local_icon}/> {s.transit.line.name}</span>
            <div class="alerts" if={alerts}>
              <div each={alerts} onclick={print}>[{effect_name}][{severity}][{cause}]{header_text}</div>
            </div>
          </p>

        </div>
      </ul>
      Arrival Time: {arrivalTime.text} at From {leg.end_address}
    </div>
  </div>
  <script>
  var self = this
  directionsTag = this

  self.steps = []
  self.loaded = false

    var directionsDisplay;
    var directionsService = new google.maps.DirectionsService();
    var map;


    print(e){
      console.log(e.item)
    }


    calcRoute(origin, destination) {
      // var selectedMode = document.getElementById('mode').value;
      var request = {
          origin: origin,
          destination: destination,
          // Note that Javascript allows us to access the constant
          // using square brackets and a string value as its
          // "property."
          travelMode: google.maps.TravelMode['TRANSIT']
      };
      console.log(request)
      directionsService.route(request, function(response, status) {
        if (status == 'OK') {
          console.log(response.routes[0].legs)
          leg =  response.routes[0].legs[0]
          steps = leg.steps
          self.departureTime = leg.departure_time
          self.arrivalTime = leg.arrival_time

          self.lastDepartureTime = moment(self.departureTime.value)
          console.log(self.lastDepartureTime)

          self.steps = _.map(steps, s=>{
            console.log(s.instructions, s.duration.text)
            var ret = {s:s,
              departureTime: self.lastDepartureTime.format("LT"),
              arrivalTime: self.arrivalTime,
              travelMode:s.travel_mode, instructions: s.instructions, duration:s.duration.value, startLocation: {lat: s.start_location.lat(), long: s.start_location.lng()}, endLocation: {lat: s.end_location.lat(), long: s.end_location.lng()}}

            self.lastDepartureTime = self.lastDepartureTime.add(s.duration.value/60, "minutes")
            return ret
          })

          _.each(self.steps, function(s){

            forecast
                .latitude(s.startLocation.lat)            
                .longitude(s.startLocation.long)          
                .time(moment(self.departureTime.value).format())             
                .units('ca')                    
                .language('en')                 
                .exclude('minutely,daily')      
                .extendHourly(true)             
                .get()                          
                .then(res => {          
                    s.weather = res
                    self.update()
                })
                .catch(err => {                 
                    console.log(err)
                })
            
            

            if (s.travelMode === "TRANSIT"){
              var route = "Red"
              // console.log(s)
              // if (s.s.transit.line)
              //   if (s.s.transit.line.name.includes("Red")){
              //     route = "Red"
              //   }
              //   if (s.s.transit.line.name.includes("Green")){
              //     route = "Green"
              //   }
              $.getJSON("https://realtime.mbta.com/developer/api/v2/alertsbyroute?api_key=wX9NwuHnZU2ToO7GmGR9uw&route="+route+"&include_access_alerts=true&include_service_alerts=true&format=json", function(d){
                  console.log(d)
                  s.alerts = d.alerts
                  _.each(s.alerts, a =>{ 
                    if (a.effect_name.includes("delay")){
                      homeTag.addState("bus")
                    }
                  })
                  self.update()
                  self.updateLegs()
              })
            }
          })
          // directionsDisplay.setDirections(response);
          self.loaded = true
          self.update()
        }
      });
    }

    updateLegs(){
      if (legsTag)
        legsTag.loadData(self.steps)
    }
    

  </script>
  <style>
    .alerts{
      margin-left: 100px;
      color: gray;
    } 

  </style>
</directions>