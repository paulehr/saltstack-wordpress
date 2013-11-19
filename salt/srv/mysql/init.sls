mysql-server:
 pkg:
   - installed
 service.running:
   - require:
     - pkg: mysql-server 
   - names:
     - mysqld

mysql:
 pkg:
  - installed

MySQL-python:
 pkg:
  - installed

mysql-connector-python:
 pkg:
  - installed 
