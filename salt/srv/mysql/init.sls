# The following package names for RedHat/CentOS 

# installs mysql and ensures it's started
mysql-server:
 pkg:
   - installed
 service.running:
   - require:
     - pkg: mysql-server 
   - names:
     - mysqld

# This is the mysql client package
mysql:
 pkg:
  - installed

# Needed for Salt to talk to mysql
MySQL-python:
 pkg:
  - installed

# Needed for Salt to talk to mysql 
mysql-connector-python:
 pkg:
  - installed 
