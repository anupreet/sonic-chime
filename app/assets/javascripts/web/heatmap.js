$.get( "api/timeline/heatmap.json", function( data ) {
var taxiData = [
 ]
$.each(data, function (index, val) {
	taxiData.push(new google.maps.LatLng(val[0],val[1]));
  });
});
