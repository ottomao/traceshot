var http         = require("http-request"),
    iosServerUrl;

//set server url
module.exports.setServerUrl = function(url){
	iosServerUrl = url;
}

/*
start a new task
test url : http://www.amazon.com
shot interval : 0.5s
test duration : 10s
*/
module.exports.startNewTest = function(url,interval,duration){
	var testUrl = encodeURIComponent(url);
	http.get( iosServerUrl+'/?action=shot&url=' + testUrl + '&interval=' + interval +'&duration=' + duration , function (err, res) {
		if(err){
			console.log(err);
			console.log("err when connect to the server");
			return;
		}
		var resString = res.buffer.toString();
		console.log(resString);
	});
}

//query status
module.exports.queryStatus = function(){
	http.get( iosServerUrl+'/?action=status', function (err, res) {
		if(err){
			console.log(err);
			console.log("err when connect to the server");
			return;
		}
		var resString = res.buffer.toString();
		console.log(resString);
	});
}

//fetch the latest result and save image
module.exports.fetchLastestResult = function(){
	http.get( iosServerUrl+'/?action=fetch', function (err, res) {
		if(err){
			console.log(err);
			console.log("err when connect to the server");
			return;
		}
		var resString = res.buffer.toString(),
			resJSON   = JSON.parse(res.buffer.toString());	

		if(!err & resJSON.success){
			var	taskId  = resJSON.taskId;

			var base64Data = resJSON.imgBase64.replace(/^data:image\/jpeg;base64,/, ""),
				fileName   = taskId + "_result.jpg";
			require("fs").writeFile(fileName, base64Data, 'base64', function(err) {
				if(err){
					console.log(err);
				}else{
					console.log("saved :" + fileName);
				}
			});
		}else{
			console.log(resString);
		}
	});
}

//stop task
module.exports.stopTask = function(){
	http.get( iosServerUrl+'/?action=stop', function (err, res) {
		if(err){
			console.log(err);
			console.log("err when connect to the server");
			return;
		}
		var resString = res.buffer.toString();
		console.log(resString);
	});
}