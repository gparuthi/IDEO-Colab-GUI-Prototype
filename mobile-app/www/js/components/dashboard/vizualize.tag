

<vizualize>
<div class="container">
<div class="mdl-grid">
	<div class="mdl-cell mdl-cell--12-col"><h3>Hourly Plot</h3></div>
	<div id="tester" class="mdl-cell mdl-cell--12-col"></div>
	<div class="mdl-cell mdl-cell--12-col">
		<h3>Last Image</h3>
		<img src={lastImage}>
	</div>
	<div class="mdl-grid">
		<div class="mdl-cell mdl-cell--12-col"><h3>Hourly Data</h3></div>
		<div class="mdl-cell mdl-cell--3-col" each={v,k in data}>
		<strong>{k}</strong>
			<div each={c, h in v.hourly}>{h} : {c}</div>
		</div>
	</div>
	
	  

	
	
</div>

<script>
vizTag = this
var self = this

self.lastImage = ""

self.m1 = 0.5

getM1(){
	return self.m1
}

this.on("mount", function(){

	firebase.storage().ref('images').child('apple.jpg').getDownloadURL().then(url => {
		console.log(url);
		self.lastImage = url;
		self.update();
	})

	firebase.database().ref('/visionresults').once("value", function(s){
	 d = s.val()
	 data = {}
	 		 _.each(_.values(d), r=>{
	 		 	classes = r.objects
	 		 	_.each(_.pairs(classes), c=>{
	 		 		let className = c[0]
	 		 		if (!data[className])
	 		 			data[className] = {x:[r.timestamp],y:[0], name: className, hourly:{}} 
	 				hour = moment(r.timestamp).format('YYYY-MM-DDTHH')
	 				if (!data[className]['hourly'][hour])
	 					data[className]['hourly'][hour] = 0
	 				data[className]['hourly'][hour]+= c[1]
	 // 		 		data[className]['x'].push(r.timestamp)
	 // 		 		data[className]['y'].push(c[1])
	 		 		// console.log(className, data[className]['hourly'])
	 		 	})
	 		 })

	 		 // groupby hourly
		 _.each(_.keys(data), c=>{
			console.log(c)
			data[c]['x'] = _.map(_.keys(data[c].hourly), t=> {return moment(t).format()})
			data[c]['y'] = _.values(data[c].hourly)
		})

		 TESTER = document.getElementById('tester')
	 	Plotly.plot( TESTER, _.values(data), {margin: { t: 0 } } )
	 	self.update()
	})
	// TESTER = document.getElementById('tester');
	// Plotly.plot( TESTER, [{
	// x: [1, 2, 3, 4, 5],
	// y: [1, 2, 4, 8, 16], name:"1" },{
	// x: [2, 3, 4, 5, 6],
	// y: [1, 2, 4, 8, 16], name:"2" }], {
	// margin: { t: 0 } } );
})

updateVals(d, i){
	self.data[i].value = d
	self.update()
}
	
</script>

<style>
.demo-charts {
	/*background-color: black !important;*/
}
.container {
	width: 100%;
	height: 100%;
	/*background-color: black !important;*/
}

</style>
</vizualize>