Traceshot
=========
Author: **Otto Mao**

Contact: **ottomao@gmail.com**


### Intro
Traceshot is a tool for web developers to evaluate the web page loading performance visually. By taking snapshots periodly, Traceshot will give you a collection of all the snapshots duration the loading process. The test results given by Traceshot will be more reliable and meaningful since the test is run on a real device with a real network condition.

Besides, Traceshot can be used as a server. That is to say, you may establish your own real-device test server for the whole team by using some HTTP api. So cool ,right ?

### Screenshots
Home page

During Test

The summary of loading process give by traceshot

### about server mode

When working as a server , Traceshot can run tasks assigned by its http-client.
Traceshot won't do any callback after tasks are finished. What you have to do is to fetch the result manually. You may either fetch it by a scheduled task, or just simply by polling.

The task result image is transferred as base64.

The API doc is as follows.
#### basic form
All the apis are designed with this pattern: ```Http://server:port/?action=ACTION_NAME&paraA=VALUE_A&paraB=VALUE_B``` 

Here ```action``` is required while other params vary from different action.

#### query status
Sample: 

Res:


##### start a task
Sample:

Res:

##### stop a task
Sample:

Res:

##### fetch result
Sample:

Res:

