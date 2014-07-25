var clientUtil = require("./util.js");

/* set server (i.e. the device) url */
clientUtil.setServerUrl("http://10.68.140.153:8080");

/*
	1.shot amazon.com ,shot interval = 0.5s , duration = 6s
	2.query whether the device is busy
*/
setInterval(function(argument) {
	// body...
	clientUtil.startNewTest("http://chaoshi.tmall.com",0.5,2);
	clientUtil.fetchLastestResult();

},3000);
