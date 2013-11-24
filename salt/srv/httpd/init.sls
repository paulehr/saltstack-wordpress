# This will install httpd and make sure that the httpd deamon is running 
# this is the RedHat/CentOS names for the package to be installed

httpd:
 pkg:
  - installed
 service:
  - running 
  - require:
     - pkg: httpd  
