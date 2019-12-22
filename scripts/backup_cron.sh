#!/usr/bin/env bash


##>  Docker compose modification for bind mount
#
#- We can define volume type in the compose file
#
#- bind-mount : method 1 : (Docker will identify bind mount and proceed accordingly)
#- 
#-     volumes:
#-       - tomcat-volume:/opt/tomcat
#-       - bim-home:/var/bimserver/home
#-       - bim-webapps:/var/www/bimserver
#-       - /opt/backups:/opt/backups
#- 	  
#- bind-mount : method 2 : (explicitly mention mount type)
#- 
#-     volumes:
#-       - type: volume
#- 	       source: tomcat-volume
#- 		   target: /opt/tomcat
#-       - type: volume
#- 	       source: bim-home
#- 		   target: /var/bimserver/home
#-       - type: volume
#- 	       source: bim-webapps
#- 		   target:/var/www/bimserver
#- 	     - type: bind
#- 	       source: /opt/backups
#- 		   target: /opt/backups

##> Backup script starts here

#-  Assuming source folder : /var/bimserver/home
#-           target folder : /opt/backups
#-           backup method : tar + gzip
#-           rotate : 2 days

DATE=$(date "+%Y-%m-%d") # date format : YYYY-MM-DD
SOURCE_PATH='/var/bimserver'
BACKUP_PATH='/opt/backups'

cd ${SOURCE_PATH}
tar -czf ${BACKUP_PATH}/bimserver-${DATE}.tar.gz home
if [ $? -ne 0 ]
then
  echo "Failed to create backup"
  exit 1
else 
  echo "Backup created successfully"
fi
find ${BACKUP_PATH} -type f -mtime +2 -exec rm -f {} \;
echo "Cleared older backups"
exit 0