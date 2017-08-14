<raindetails>
  <div>
  <dialog id={fid} class="mdl-dialog">
    <h4 class="mdl-dialog__title">Rain</h4>
    <div class="mdl-dialog__content">
      <svg id="rainchart" class="chart" ></svg>
    </div>
    <div class="mdl-dialog__actions">
      <button type="button" onclick={showAlternativesClick} class="mdl-button">Alternative Routes</button>
      <button type="button" class="mdl-button close">Close</button>
    </div>
  </dialog>
  </div>
  <script>
  var self = this
  raindialogTag = this
  self.time = "3:25 pm"

  self.fid = "raindialog"
  self.data = [4, 8, 15, 16, 23, 42];

    this.on("mount", ()=>{

      self.loadChart()

      var dialog = document.querySelector("#"+self.fid);
      rainndialog = dialog
      
      if (! dialog.showModal) {
        dialogPolyfill.registerDialog(dialog);
      }
      
      dialog.querySelector('.close').addEventListener('click', function() {
        dialog.close();
      });

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
      self.threshold = 0.65

      var y = d3.scaleLinear()
          .domain([0, d3.max(data)])
          .range([0, height-charttop]);

     chart = d3.select("#rainchart")
        .attr("width", width )
        .attr("height", height);

      chart.selectAll("g").remove()

      

      var bar = chart.selectAll("g")
        .data(data)
        .enter().append("g")
        .attr("fill","#02B8AF")
        .attr("transform", function(d, i) { 
          var x = i * barWidth 
          return "translate(" + x + "," + charttop + ")"; 
        });

      bar.append("rect")
      .attr("y", function(d) { return 0; })
      .attr("height", function(d) { return y(d); })
      .attr("fill", d=>{
        if (d>self.threshold)
          return "red"
      })
      .attr("width", barWidth - 1);

      d3.select("#rainchart")
        .selectAll("div")
          .data(data)
        .enter().append("div")
          .style("width", function(d) { return d * 10 + "px"; })
          .text(function(d) { return d; });

      // current time
      var walkInfo = chart.append("g")
      .attr("transform", function() { 
          return "translate(" + 14 * barWidth + "," + 10 + ")"; 
        })
      walkInfo.append("text")
        .text(function(d) { return "| "+ self.time })
        .attr("font-size","10px");

      walkInfo.append("rect")
      .attr("x", 0)
      .attr("y", "3px")
      .attr("width", function(d) { return 2 * barWidth + "px"})
      .attr("height", function(d) { return 5; })
      .attr("fill", d=>{
          return "#E59C00"
      })

      // dashed line

      chart.append("g")
      .attr("transform", function() { 
          return "translate(" + 0 + "," + (y(self.threshold)+charttop) + ")"; 
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
      raindialog.showModal()
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
  </style>
</raindetails>