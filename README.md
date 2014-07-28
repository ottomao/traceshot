Traceshot
=========
Author: **Otto Mao**

Contact: **ottomao@gmail.com**


### Intro
Traceshot is a tool for web developers to evaluate the web page loading performance visually. By taking snapshots periodically, Traceshot will give you a collection of all the snapshots duration the loading process. The test results given by Traceshot will be more reliable and meaningful, since the test is run on a real device with a real network condition.

Besides, Traceshot can be used as a server. In other words, you may establish your own real-device test server for the whole team by using some RESTful API. It is so cool, isn't it ?

### Screenshots
[<img src="http://gtms04.alicdn.com/tps/i4/TB1n6C_FVXXXXXaXpXXCKHiPpXX-2800-1600.png_760x760.jpg" />](http://gtms04.alicdn.com/tps/i4/TB1n6C_FVXXXXXaXpXXCKHiPpXX-2800-1600.png)

### Server Mode

When working as a server, Traceshot can run tasks assigned by its RESTful API.

**Features**

* Traceshot won't do any callback when tasks are finished. You have to fetch the result manually. You may either fetch it by a scheduled task, or just roughly by polling.
* The task result image is transferred as base64, jpg
* Only one task can be dealed at the same time
* There is no concept like task queue in server, you have to implement it on your http client

### RESTful API of server mode

#### basic form
* All the apis are called with this pattern: ```http://SERVER:PORT/?action=ACTION_NAME&paraA=VALUE_A&paraB=VALUE_B``` 
* A sample client written in nodejs can be found in *httpClient_sample_nodejs*

#### query status
* Sample: query whether the test server is busy
* Req: ```http://SERVER:PORT/?action=status```
* Res: ```{"success":true,"isIdle":true}```


##### start a task
* Sample: start a test task with url *http://sample.com?t=1* , screen shot interval *0.2s* , lasts *20s*
* Req: ```http://SERVER:PORT/?action=shot&url=http%3A%2F%2Fsample.com%3Ft%3D1&interval=0.2s&duration=20s```
* Res-success:```
{"success":true,"taskId":1}```
* Res-error:```{"success":false,"reason":"another task is on the fly now"}```

##### stop a task
* Sample: stop the current task
* Req: ```http://SERVER:PORT/?action=stop```
* Res: ```{"success":true,"stoppedTaskId":3}```

##### fetch result
* Sample: fetch the result of lastest test
* Req: ```http://SERVER:PORT/?action=fetch```
* Res: ```{"success":true,"taskId":4,"imgBase64":"data:image\/jpeg;base64,\/9j\/4AAQSk...```
