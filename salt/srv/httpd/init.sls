httpd:
 pkg:
  - installed
 service:
  - running 
  - require:
     - pkg: httpd  
