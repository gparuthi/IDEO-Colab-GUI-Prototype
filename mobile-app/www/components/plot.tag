<legsviz>
<div>
	<svg id="directionschart" class="chart"></svg>
</div>

<script>
	var self = this
	legsTag = this

	loadData(data){
		self.data = data

		data[data.length-1].last = true

		minHeight = d3.sum(data, d=>{return d.duration+3})/d3.min(data, d=>{return d.duration+3})*80
		var margin = {top: 20, right: 10, bottom: 20, left: 10};
		var width = 320 - margin.left - margin.right,
		    height = 500  - margin.top - margin.bottom;

		if (height < minHeight)
			height = minHeight

		// var height = 400,
		    var barWidth = 100;

		var y = d3.scaleLinear()
		    .domain([0, d3.sum(data, d=>{return d.duration+3})])
		    .range([0, height]);

		var chart = d3.select("#directionschart")
		    .attr("width", width + margin.left + margin.right)
		    .attr("height", height + margin.top + margin.bottom);


	    chart.selectAll("g").remove();


		var bar = chart.selectAll("g")
		    .data(data)
		  .enter().append("g")
		  .attr("fill","#02B8AF")
		    .attr("transform", function(d, i) { 
		    	d.x = margin.left
		    	if (i===0)
		    		return "translate("+d.x+",0)"; 
		    	var h = d3.sum(data.slice(0,i), d=>{return d.duration+3} )
		    	d.y = y(h)
		    	return "translate(" + d.x + "," + d.y + ")"; 
		    });

		bar.append("rect")
		    .attr("width", barWidth-3)
		    .attr("height", d=>{return y(d.duration)})
		    .attr("rx", 6)
    		.attr("ry", 6);

		// console.log(data)

		

		bar.append("text")
		    .attr("x", barWidth/2)
		    .attr("width", barWidth)
		    .attr("y", 15)
		    .style("text-anchor", "middle")
		    .attr("fill", "white")
		    // .attr("dy", ".35em")
		    .text(function(d) { return d.departureTime });

		bar.append("svg:image")
			.attr("x", barWidth/4)
		    .attr("y", 20)

		    .attr("width", barWidth/2)
		    .attr("height", barWidth/2)
		    .attr("xlink:href",d => {
		    	if (d.travelMode === "WALKING")
			    	return "images/Walk_icon.svg"
			    else 
			    	return "images/T_icon.svg"
		    })   
		bar.append("text")
		    .attr("x", barWidth/2)
		    .attr("width", barWidth)
		    .style("text-anchor", "middle")
		    .attr("y", 20 + barWidth/2)
		    .attr("fill", "lightgray")
		    .text(function(d) { return Math.round(d.duration/60) + " mins"; });
		
		bar.append("text")
		    .attr("x", barWidth*2 )
		    .attr("width", barWidth)
		    .style("text-anchor", "middle")
		    .attr("y", 10)
		    .attr("fill", "black")
		    .text(function(d) { return d.instructions.slice(0,25) });

		bar.append("svg:image")
			.attr("x", barWidth*2)
		    .attr("y", 20)

		    .attr("width", barWidth/2)
		    .attr("height", barWidth/2)
		    .attr("xlink:href",d => {
		    	return self.getAnomaly(d)
		    })
		    .on("click", d =>{
		    	self.execAnomalyLink(d)
		    })
		self.update()
	}

	getAnomaly(leg){
		// console.log(leg)
		if (leg.travelMode === "TRANSIT" && homeTag.showcrowd)
			return "images/crowd@2x.png"
		if (leg.travelMode === "WALKING" && homeTag.showrain)
			return "images/weather.png"	
		if (leg.travelMode === "TRANSIT" && homeTag.showbus)
			return "images/bus.png"	
		// if (leg.weather.summary === "Overcast") 
		// return "images/weather.png"
	}
	execAnomalyLink(leg){
		console.log(leg)
		if (leg.travelMode === "TRANSIT" && homeTag.showcrowd)
			visiondialogTag.showModal(leg.arrivalTime.text)
		if (leg.travelMode === "WALKING" && homeTag.showrain)
			raindialogTag.showModal(leg.departureTime)	
		if (leg.travelMode === "TRANSIT" && homeTag.showbus)
			mbtadialog.showModal(leg.departureTime)	
		
		// if (leg.travelMode === "WALKING"){
		// 	visiondialogTag.showModal(leg.arrivalTime.text)
		// 	return 
		// }
		// if (leg.travelMode === "WALKING")
		// 	raindialogTag.showModal(leg.departureTime)
		// if (leg.travelMode === "TRANSIT")
		// 	mbtadialog.showModal(leg.departureTime)
		// if (leg.weather.summary === "Overcast") 
		// return "images/weather.png"
	}
</script>
<style>
	

.chart text {
  /*fill: white;*/
  font: 10px sans-serif;
  text-anchor: end;
}
</style>
</legsviz>