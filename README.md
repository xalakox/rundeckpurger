# rundeckpurger

Purge old execution logs from [Rundeck](http://rundeck.org/)

USAGE : 

npm install

if you have coffee installed : 

URL=[http://localhost:4440] PROJECT=[projectname] APIKEY=[apikey] ./rundeckpurger.coffee

if not : 

URL=[http://localhost:4440] PROJECT=[projectname] APIKEY=[apikey] ./rundeckpurger.js


DAYSAGO is optional (it defaults to 7)


You should use this in conjuction with erasing the execution log files in the server (with a crontab or job in the rundeck itself), example : 

find /var/lib/rundeck/logs/rundeck/[projectname]/* -type f -mtime +7 -exec rm {} \;