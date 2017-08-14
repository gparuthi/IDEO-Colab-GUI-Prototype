<crowddetails>
  <div>
  <dialog id={fid} class="mdl-dialog">
    <p class="mdl-dialog__title">Crowd at destination</p>
    <div class="live">
      <i class="Blink fa fa-circle text-danger"></i>&nbsp; LIVE 
    </div>
    <div class="mdl-dialog__content">
      <svg id="crowdchart" class="chart" ></svg>
    </div>
    <div class="mdl-dialog__actions">
      <button type="button" onclick={showAlternativesClick} class="mdl-button">Alternative Routes</button>
      <button type="button" class="mdl-button close">Close</button>
    </div>
  </dialog>
  </div>
  <script>
  var self = this
  visiondialogTag = this
  self.time = "3:25 pm"
  self.currentPersonCount = 0
  self.threshold = 3

  self.fid = "crowddialog"
  self.data = [ 2  ,  2.86,  2.22,  1.43,  0.6,  0.72,  0.58,  0.51,  0.21,
        1.04,  1.26,  1.74,  2.25,  0.53,  0.23,  0.44]

    this.on("mount", ()=>{

      self.loadChart()

      var dialog = document.querySelector("#"+self.fid);
      crowddialog = dialog
      
      if (! dialog.showModal) {
        dialogPolyfill.registerDialog(dialog);
      }
      
      dialog.querySelector('.close').addEventListener('click', function() {
        dialog.close();
      });


      firebase.database().ref('visionresults/').limitToLast(1).on("value", d=>{
        
        let objectCounts = _.values(d.val())[0].objects
        console.log(objectCounts)
        if (objectCounts)
          if (objectCounts.person)  
            self.currentPersonCount = objectCounts.person
          else 
            self.currentPersonCount = 0
        

        if (self.currentPersonCount>=self.threshold)
        {
         homeTag.addState('crowd') 
        } else {
          homeTag.removeState('crowd')
        }

        self.loadChart()
        
      })

    })

    showAlternativesClick(){
      window.open("transit://directions?from="+homeTag.from+"&to="+homeTag.to, "_system")
    }

    setData(data){
      self.data = data
      self.loadChart()
    }

    loadChart(){
      var charttop = 20
      var width = 320 ,
        height = 150;
      var data = self.data
      var barWidth = 10
      let threshold = self.threshold

      var y = d3.scaleLinear()
          .domain([0, 4])
          .range([0, height]);
      self.y = y

     chart = d3.select("#crowdchart")
        .attr("width", width )
        .attr("height", height-charttop);

      chart.selectAll("g").remove()

      

      var bar = chart.selectAll("g")
        .data(data)
        .enter().append("g")
        .attr("fill","#02B8AF")
        .attr("transform", function(d, i) { 
          var x = i * barWidth 
          return "translate(" + x + "," + 0 + ")"; 
        });

      bar.append("rect")
      .attr("y", function(d,i) { 
        if (i==10){
          return height - y(self.currentPersonCount)
        } else
          return height - y(d); 

      })
      .attr("height", function(d,i) { 
        if (i==10){
          console.log(y(self.currentPersonCount))
          return y(self.currentPersonCount)
        } else
          return y(d) 
      })
      .attr("fill", (d,i)=>{
        
        if (i==10)
          return "red"
        else
          return "teal"
      })
      .attr("width", barWidth - 1);

      d3.select("#crowdchart")
        .selectAll("div")
          .data(data)
        .enter().append("div")
          .style("width", function(d) { return d * 10 + "px"; })
          .text(function(d) { return d; });

      // current time
      var walkInfo = chart.append("g")
      .attr("transform", function() { 
          return "translate(" + 9 * barWidth + "," + 10 + ")"; 
        })
      walkInfo.append("text")
        .text(function(d) { return "| "+ self.time })
        .attr("font-size","10px");

      // walkInfo.append("rect")
      // .attr("x", 0)
      // .attr("y", "3px")
      // .attr("width", function(d) { return 4 * barWidth + "px"})
      // .attr("height", function(d) { return 5; })
      // .attr("fill", d=>{
      //     return "#E59C00"
      // })

      // dashed line

      chart.append("g")
      .attr("transform", function() { 
          return "translate(" + 0 + "," + (height-y(threshold)) + ")"; 
        })
      .append("line")
      .attr("x2", 25*barWidth)
      .attr("stroke-width", 2)
      .attr("stroke", "black")
      .attr("stroke-dasharray", "5, 5");
    }

    showModal(time){
      self.time = time || self.time
      self.loadChart()
      crowddialog.showModal()
    }
    
  </script>
  <style :scoped>
    .chart div {
      font: 10px sans-serif;
      background-color: steelblue;
      text-align: right;
      padding: 3px;
      margin: 1px;
      color: white;
    }
    .Blink {
      animation: blinker 1.5s cubic-bezier(.5, 0, 1, 1) infinite alternate;  
          color: #ec2c93;
  }
  .live{
    position: absolute;
    right: 10px;
    top: 0px;

  }
  .mdl-dialog__title {
    padding: 24px 24px 0;
    margin: 0;
    font-size: 1rem;
}
  </style>
</crowddetails>