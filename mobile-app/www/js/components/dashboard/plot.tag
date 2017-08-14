<plot>
	<div id={divid}></div>
	<script>
		var self = this
		self.divid = "p"+self.opts.id+self.opts.filters[0]

		this.on("mount", function(){
			this.parent.on("dataupdate", function(){
				console.log("dataupdated", self.opts);
				self.updatePlot()
			})
		})

		updatePlot(){
			self.data = self.opts.data
			self.filters = self.opts.filters

			if (self.data){
				let plotdata = []

				_.each(self.filters, f=>{
					// console.log(f);
					let flogs = _.filter(self.data, l=>{
						return l.text.indexOf(f)>=0 && l.userId.indexOf(self.opts.id)>=0
					})
					// console.log(flogs.length);
					
					let x = _.pluck(flogs, 'time')
					let y = _.map(flogs, d=>{return plotdata.length+1})
					let texts = _.pluck(flogs, 'text')
					x.unshift(moment(moment()-24*60*60*1000).format()); y.unshift(0); texts.unshift("");
					x.push(moment().format()); y.push(0); texts.push("");

					plotdata.push({
					x : x,
					y : y,
					text: texts,
    				mode: 'markers',
    				name: f
					})

				})

				var adds = self.parent.additionalSources[self.filters[0]]
				if (adds){
					console.log(adds);
					_.each(adds, function(fr){
						
						fr.y = _.map(fr.x, d=>{return plotdata.length+1})
						fr.mode= 'markers'
						console.log("Adding new plot");
						plotdata.push(fr)
					})					
				} else {
					console.log("cant find ", self.filters[0], self.parent.additionalSources);
				}

				

				

				var layout = {
				  title: self.filters[0],
				  height: 300,
				  width: 900,
				  yaxis: {
				      showgrid: false,
				      zeroline: false,
				      showline: false,
				      mirror: 'ticks',
				      showticklabels: false
				    },
				  // l: 0,
			   //    r: 0,
			   //    b: 0,
			   //    t: 0,
			   //    pad: 1
				};
				Plotly.newPlot(self.divid, plotdata, layout, {displayModeBar: showDisplayModeBar});
			}
		}
	</script>
</plot>