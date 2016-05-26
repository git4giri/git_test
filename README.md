# Hygieia Dashboard Setup Notes

>Below listed are some important steps performed and lessons learnt during Hygieia dashboard configuration in `Somerslab` environment.

 * Current version of Hygieia-2.0 requires *JDK-1.8* and *Maven-3.2.5* to compile and build from source.
 * Other than bower and gulp it requires Git client to build the UI module.
 * A MongoDb database should be created with authentication enabled before starting any of the collectors or API.
 * The UI module should start with admin/root mode. Before starting any of Hygieia modules make sure that the MongoDB is running.
 * To check mongoDB host and port no.  
connect to mongoDB => just type mongo and hit enter in console  
then type db.serverCmdLineOpts() and hit enter  You’ll get response like following…   
```
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
`Default host is localhost/127.0.0.1 and port no is 27017.`

* Create User with Roles in mongoDB  
```
> use dashboarddb
switched to db dashboarddb
> db.createUser({
... user: "admin",
... pwd: "w3bmast3r",
... roles: ["readWrite", "dbAdmin"]
... })
Successfully added user: { "user" : "admin", "roles" : [ "readWrite", "dbAdmin" ] }
```  
> Create / use a Jenkins API key with access to all jobs for connecting Jenkins job collector.

* The GitHub collector not able to fetch commit info from private repository in GitHub, as there is no option to provide the access credentials to the collector. So we have modified source of github-scm-collector package so that we can specify the access token in the configuration file to access all private repository. 
	- modified class: 
		- DefaultGitHubClient  
	- modified methods: 
		- getCommits(GitHubRepo repo, boolean firstRun)
*	Create a personal access token in GitHub to access all GitHub projects. Login with the corresponding GitHub user and goto `GitHub -> Settings -> Personal access tokens -> Generate new token`. Use this token in dashboard.properties as value of  `github.key`. 
>To get commit details of any private GitHub project just need to add this user to the project as collaborator.

*	To get commit info from Enterprise GitHub at IBM, you just need to follow the same steps to create the token and specify the github.host as github.ibm.com in dashboard.properties.  
>Either the public GitHub or IBM GitHub only one you can specify for github collector.

* The rest api url of Stash/Bitbucket varies instance to instance based on its configuration, for our production Stash the url is `/stash/rest/api/1.0/`. This url needs to specify in the configuration file eg. dashboard.properties.
*	There is no such documentation in Hygieia GitHub, how to pass the Stash/Bitbucket access credential to the collector. So we have modified the source of stash-scm-collector to read the credential details from the configuration file. 
	- modified class: 
		- DefaultBitbucketClient 
	- modified methods:- 
		- getCommits(GitRepo repo, boolean firstRun)  
		- makeRestCall(String url, String userId, String password, String token)  
		
	Now we can specify Stash/Bitbucket credential in the format of “user@password” as value of git.key in dashboard.properties.
*	Jira API Query files names section in sample dashboard.properties file is not required to be modified. Distribution contains string template files with standard Jira API queries. In case the query fails, those query files needs to be updated as required.
*  Jira API Query files contains IDs for various Jira Issue Types and the collector API will fail in case there is mismatch of Issue Type Id in these string template files and your target Jira server. You can retrieve your instance's IssueType name listings via the URI: `https://[your-jira-domain-name]/jira/rest/api/2/issuetype/`  
	It is listed as attribute "name" in the JSON response.
*  In Jira, your instance will have its own custom field created for "sprint" or "timebox" details, which includes a list of information.  This field allows you to specify that data field for your instance of Jira. Note: You can retrieve your instance's sprint data field name via the following URI, and look for a package name “com.atlassian.greenhopper.service.sprint.Sprint”, your custom field name describes the values in this field.  
    `https://[your-jira-domain-name]/jira/rest/api/2/issue/[some-issue-name]`
* Jira API Query files are located in `Hygieia-Distribution-Dir/jira-feature-collector/src/main/resources/jiraapi-queries`. If any of these files are modified, the Jira feature collector has to be rebuilt for the change to take effect.
* In our Jira instance `studio.somerslab.ibm.com/jira` we are following the Story based issue management so we have modified the jira-collector source to fetch all the story as issue and also the estimated story-point of corresponding stories.  
	Here is the list of modified class: method
    - StoryDataClientImpl: updateMongoInfo(List< Issue> currentPagedJiraRs)  
    - JiraDataFactoryImpl: getJiraIssues()     
    - ProjectDataClientSetupImpl: updateObjectInformation()   
    - FeatureDataClientSetupImpl: updateObjectInformation()  
    - TeamDataClientSetupImpl: updateObjectInformation()
* Use Jira Base64-encoded username:password as value of feature.jiraCredential and OAuth 2.0 is not enabled in Jira feature collector yet. So keep related fields commented.
* Various Hygieia collectors may fail to communicate with the respective servers due to SSL handshake error caused by unrecognized SSL certificate. SSL Certificate from respective servers can be imported into default trust store of JRE used to launch the collectors.
>In our case, we have installed following SSL certificates in esl022.somerslab server JRE  
  Jira SSL certificate from ‘https://studio.somerslab.ibm.com/jira’     
  Enterprise GitHub SSL certificate from ‘https://github.ibm.com/’   
  Jenkins SSL certificate from ‘https://esl035.somerslab.ibm.com/jenkins/’

* In the configuration file the issue status mappings must be completed corresponding to respective Jira instance. You can find all available issue status mappings by going to your instance's version of the following API call; Your statuses are listed in the JSON response as "name."  
     `https://[your-jira-domain-name]/jira/rest/api/2/status`  
	Currently, Hygieia only maps to the following 3 status mappings:  to do, doing, and done. So you need to specify which statuses you want put in which category. 
>In our case it’s like…  
   feature.todoStatuses[0]=Open  
   feature.todoStatuses[1]=New  
   feature.todoStatuses[2]=Backlog  
   feature.todoStatuses[3]=Reopened  
   feature.todoStatuses[4]=To Do  
   feature.doingStatuses[0]=In Progress  
   feature.doingStatuses[1]=Blocked  
   feature.doingStatuses[2]=In Development  
   feature.doneStatuses[0]=Done  
   feature.doneStatuses[1]=Completed  
   feature.doneStatuses[2]=Resolved  
   feature.doneStatuses[3]=Complete  
   feature.doneStatuses[4]=Closed  

* We have modified the Hygieia REST API source to show all Jira issue count instead of estimated size and to show all in-progress stories with the story-point instead of epics.  
	- modified class:
		- FeatureServiceImpl
	- modified methods: 
    	- getFeatureEstimates(ObjectId componentId, String teamId)
    	- getEstimate(ObjectId componentId, String teamId, Status status)

22.	We have created a shell script to run our Hygieia instance in esl022 Somers-lab server. Here are some useful notes related to the script.
	1. Login into esl022.somerslab.ibm.com server with sudo/root access.
	2. There are three main commands e.g. start, stop and clear.
	3. In Hygieia we have eight modules, in script we named them like `api, ui, jira, github, stash, jenkins, ucd and sonar`.
	4. To start particular module, follow this command  
        `hygieia start <module-name>`  
           e.g. hygieia start api  
    5. To start all module, follow this command  
        `hygieia start all`
    6. To stop particular module, run this command  
        `hygieia stop <module-name>`  
           e.g. hygieia stop api
    7. To stop all module, run this command  
        `hygieia stop all`
    8. To clear old logs run following command, it’ll delete all logs older than two days.
        `hygieia clear logs`



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
