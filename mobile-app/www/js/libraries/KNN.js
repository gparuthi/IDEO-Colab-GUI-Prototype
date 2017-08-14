//// --------testing
// var matrix = math.matrix([[7, 1], [-2, 3]]);
//console.log(matrix.map(function (value, index, matrix){ return value - 1}));
//console.log(math.multiply(-1 , (matrix)));
// console.log(matrix.subset(math.index([0],_.range(matrix.size()[1]))));



KNN = function(k,distanceType){
	
	if( !(distanceType == 'manhattan' || distanceType== 'euclidean') ) {
		distanceType ='manhattan';
	}

	var matrix = math.matrix([7, 1]);
	var matrix2 = math.matrix([[8, -1],[0,1]]);

	//return a matrix
	var matrix_row = function(matrix,i){
		return math.squeeze(matrix.subset(math.index([i],_.range(matrix.size()[1]))));
	}

	var thereexistsanothermax = function(objec,maxkey,value){
		boooooool = false;
		_.each(objec,function(v,k){
			if(v.val == value && v['label']!=maxkey) {
				boooooool = true;
			}
		});
		
		return boooooool;
	}

	var o = {
		'distance':distanceType,
		'k':k,
		'X': null,
		'y':null,
		'fit' : function(X,y,callback_func){
			this.X = math.matrix(X);
			this.y = y;
			if(callback_func) {
				return callback_func(); 
			}
		},
		'calcDistance' : function(v1,v2){ //public
			var p = null;
			var v = v1;

			if(this.distance == 'manhattan') {
				p = 1; // remember javascript only has floats
			}
			else if(this.distance == 'euclidean') {
				p = 2;
			}
			if(v2){
				v = math.add(v,  math.multiply(-1,v2));
			}

			v = v.map(function(value,index,matrix){ return math.abs(value)});
			z = 0.0;
			v.forEach(function(value,index,matrix){
				z+= math.pow(value,p);
			})
			return math.pow(z,1/p);
		},
		'calcAllDistances' : function(v){
			var arr = [];
			var numrows = this.X.size()[0];

			var i = 0
			while(i < numrows) {
				arr.push(this.calcDistance(v,matrix_row(this.X,i)));
				i+=1
			}
			return arr;
		},
		'predict_row' : function(row){
			var distances = this.calcAllDistances(row);
		
			function compare(a,b) {
			if (a.val < b.val)
			return -1;
			else if (a.val > b.val)
			return 1;
			else
			return 0;
			}
			
			top_k = [];
			for(var i = 0; i<distances.length; ++i)
			{
				if(top_k.length < this.k) {
					top_k.push({val:distances[i],'label':this.y[i]});
					top_k.sort(compare);
				}
				else{
					if(distances[i] < top_k[this.k-1].val){
						top_k.pop();
						top_k.push({val:distances[i],'label':this.y[i]});
						top_k.sort(compare);
					}
				}
			}

			c= {};
			// do majority voting
			for(var i = 0; i < top_k.length; ++i)
			{
				if(_.isUndefined(c[top_k[i]['label']])){
					c[top_k[i]['label']] = 1;
				}
				else{
					c[top_k[i]['label']]++;
				}
			}
			l = [];
			for(key in c) // a bit dangerous, but whatever
			{
				l.push({'label': key, 'val': c[key]});
			}
			// console.log(l);
			maxkey = _.max(l, function(stooge){ return stooge.val; } )['label'];
			maxval = _.max(l, function(stooge){ return stooge.val; } )['val'];
			if( thereexistsanothermax(l,maxkey,maxval) && this.k>1){
				this.k -=1;
				x = this.predict_row(row);
				this.k +=1;
				return x;
			}
			else{
				return maxkey;
			}
		},
		'predict' : function(X_test){ 
			X_test = math.matrix(X_test);
			var numtestrows = X_test.size()[0];
			var i = 0 ;
			var y = _.range(numtestrows);

			while (i < numtestrows) { 
				y[i] = this.predict_row(matrix_row(X_test,i));
				i+=1;
			}
			return y;
		}
	}
	return o;
}


// //testing
// z = KNN(2,'manhattan')
// var X_train = [[0,0],[1,1],[0.1,0.1]];
// var y_train = ['dumb','smart','dumb']
// var X_test = [[.25,.25]];
// console.log(z.fit(X_train,y_train,function(){return z.predict(X_test)} ) );
