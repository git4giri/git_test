# Hygieia Dashboard Setup Notes

>Below listed are some important steps performed and lessons learnt during Hygieia dashboard configuration in `Somerslab` environment.

 1. Current version of Hygieia-2.0 requires *JDK-1.8* and *Maven-3.2.5* to compile and build from source.
 2. Other than bower and gulp it requires Git client to build the UI module.
 3. A MongoDb database should be created with authentication enabled before starting any of the collectors or API.
 4. The UI module should start with admin/root mode. Before starting any of Hygieia modules make sure that the MongoDB is running.
 5. To check mongoDB host and port no.  
 connect to mongoDB => just type mongo and hit enter in console  
then type db.serverCmdLineOpts() and hit enter  You’ll get response like following…   
```json
{
  "argv": [ "/usr/bin/mongod", "-f", "/etc/mongod.conf" ],
  "parsed": {
    "config": "/etc/mongod.conf",
    "net": { "bindIp": "127.0.0.1", "port": 27017 },
    "processManagement": { "fork": true, "pidFilePath": "/var/run/mongodb/mongod.pid"  },
    "storage": { "dbPath": "/var/lib/mongo", "journal": { "enabled": true } },
    "systemLog": { "destination": "file", "logAppend": true, "path": "/var/log/mongodb/mongod.log" }
  },
  "ok": 1
}
```  
>So, here host is 127.0.0.1 and port no is 27017, if it's not specified at all then everything is default.  
>`Default host is localhost/127.0.0.1 and port no is 27017.`  

Create User with Roles in mongoDB
```sh
> use dashboarddb
switched to db dashboarddb
> db.createUser({
... user: "admin",
... pwd: "w3bmast3r",
... roles: ["readWrite", "dbAdmin"]
... })
Successfully added user: { "user" : "admin", "roles" : [ "readWrite", "dbAdmin" ] }
```

This README.md file is displayed on your project page. You should edit this 
file to describe your project, including instructions for building and 
running the project, pointers to the license under which you are making the 
project available, and anything else you think would be useful for others to
know.

We have created an empty license.txt file for you. Well, actually, it says,
"<Replace this text with the license you've chosen for your project.>" We 
recommend you edit this and include text for license terms under which you're
making your code available. A good resource for open source licenses is the 
[Open Source Initiative](http://opensource.org/).

Be sure to update your project's profile with a short description and 
eye-catching graphic.

Finally, consider defining a timeline and work items on the "Current Work" tab 
to give interested developers a sense of your cadence and upcoming enhancements.
