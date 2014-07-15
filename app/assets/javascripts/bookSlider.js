/**
*   calendarWeekHour    Setup a week-hour grid: 
*                           7 Rows (days), 24 Columns (hours)
*   @param id           div id tag starting with #
*   @param width        width of the grid in pixels
*   @param height       height of the grid in pixels
*   @param square       true/false if you want the height to 
*                           match the (calculated first) width
*/
//var cur_bookpage = 1;

function bookSlider(id, width, height, square, readPages, addComments, comments, myFn)
{
	d3.select("#number").append("svg")
		.attr("width",100)
		.attr("height",50)
		//.append("text")
		//.attr("x",5)
		//.attr("y",5)
		//.attr("id","viz")
		//.text("");

	var tip = d3.tip()
		.attr("class",'d3-tip')
		.offset([-10,0])
		//.direction("s")
		.html(function(d) {
			return "<strong style='color:#F09'>Page: </strong> <span style='color:#0F5'>" + d + "</span>";
		});
	var calData = createData(width, height, false);
	//console.log(calData);
	var grid = d3.select(id).append("svg")
		.attr("width", width + 20)
		.attr("height", height + 20)
		//.attr("class", "chart");
	grid.call(tip);
	var row = grid.selectAll(".row")
		.data(calData)
		.enter().append("svg:g")
		//.attr("class", "row");

	var col = row.selectAll(".cell")
		.data(function (d) { return d; })
		.enter().append("svg:rect")
		
		//.attr("class", "cell")
		.attr("x", function(d) { return d.x; })
		.attr("y", function(d) { return d.y; })
		.attr("width", function(d) { return d.width; })
		.attr("height", function(d) { return d.height; })
		.style("fill", function(d){
			return color_me(d.x, d.y, d.width, d.height, readPages, addComments, comments);
		})
		.on('mouseover', function(d) {
			d3.select(this)
			.style('fill', '#0F0');
			x = d3.select(this).attr("x");
			y = d3.select(this).attr("y");
			w = d3.select(this).attr("width");
			h = d3.select(this).attr("height");
			a = Math.ceil(x / w)
			b = Math.ceil(y / h)
			//d3.select("#viz").attr("dy",".35em").text(a + ", "+ b);
			tip.show(a )
		})
		.on('mouseout', function(d) {
			x = d3.select(this).attr("x");
			y = d3.select(this).attr("y");
			w = d3.select(this).attr("width");
			h = d3.select(this).attr("height");
			d3.select(this)
			.style('fill', function(){
				return color_me(x,y,w,h, readPages, addComments, comments);
			});
			tip.hide();
		})
	.on('click', function() {
		x = d3.select(this).attr("x");
		//y = d3.select(this).attr("y");
		w = d3.select(this).attr("width");
		//h = d3.select(this).attr("height");
		//console.log(x);
		//console.log(y);
		//console.log(w);
		a = Math.ceil(x / w);
		//b = Math.ceil(y / h);
		//console.log( a );
		//cur_bookpage = a;
		myFn(a);
		//$('#page').html( 'Salam: '+a);
		//$('#myModal').modal('show');
		//d3.select("#viz").attr("dy",".35em").text(a + ", "+ b);
	})
	//.style("fill", '#FFF')
		//.style("stroke", '#555');
}

function color_me(x, y, w, h, readPages, addComments, comments)
{
	//console.log( comments.length );
	if( addComments )
	{
		if (comments[Math.ceil(x/w)])
			return "black";
		/*i = 0;
		while (i < comments.length)
		{
			if( comments[i] ==  Math.ceil(x/w))
			{
				return "black";
			}
			i++;
		}*/
	}
	if( Math.ceil(x/w) <= readPages )
		return "steelblue";
	return "red";
}
////////////////////////////////////////////////////////////////////////

/**
*   randomData()        returns an array: [
                                            [{id:value, ...}],
                                            [{id:value, ...}],
                                            [...],...,
                                            ];
                        ~ [
                            [hour1, hour2, hour3, ...],
                            [hour1, hour2, hour3, ...]
                          ]

*/
function createData(gridWidth, gridHeight, square)
{
	var data = new Array();
	var gridItemWidth = 1;//gridWidth / 800;
	//var gridItemWidth = gridWidth / 800;
	var gridItemHeight = (square) ? gridItemWidth : gridHeight / 1;
	var startX = gridItemWidth / 2;
	var startY = gridItemHeight / 2;
	var stepX = gridItemWidth;
	var stepY = gridItemHeight;
	var xpos = startX;
	var ypos = startY;
	var newValue = 0;
	var count = 0;

	for (var index_a = 0; index_a < 1; index_a++)
	{
		data.push(new Array());
		for (var index_b = 0; index_b < gridWidth; index_b++)
		//for (var index_b = 0; index_b < 800; index_b++)
		{
			newValue = Math.round(Math.random() * (100 - 1) + 1);
			data[index_a].push({ 
				time: index_b, 
				value: newValue,
				width: gridItemWidth,
				height: gridItemHeight,
				x: xpos,
				y: ypos,
				count: count
			});
			xpos += stepX;
			count += 1;
		}
		xpos = startX;
		ypos += stepY;
	}
	return data;
}

