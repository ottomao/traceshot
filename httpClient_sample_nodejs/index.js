var clientUtil = require("./util.js");

/* set server (i.e. the device) url */
clientUtil.setServerUrl("http://10.68.141.251:8080");

/*
	1.shot amazon.com ,shot interval = 0.5s , duration = 6s
	2.query whether the device is busy
*/
console.log("===start a new task===");
clientUtil.startNewTest("http://ju.taobao.com",0.2,3);
clientUtil.queryStatus();


/*
	1.fetch latest result and save
	2.query the device status
*/
setTimeout(function() {

	console.log("===fetch result===");
	clientUtil.fetchLastestResult();
	clientUtil.queryStatus();

},5 * 1000); 


/* 
	start a task ,and then stop it
	just to test the stop_task api
*/
setTimeout(function(){

	console.log("===test stop_task api===");
	clientUtil.startNewTest("http://www.amazon.com",0.5,10);	
	clientUtil.stopTask();	
	clientUtil.queryStatus();

},7 * 1000);