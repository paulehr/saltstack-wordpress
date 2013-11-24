# This is top level state file for salt, this determines what state files get loaded to what machines

base:
  '*':
   - base
   - php
   - mysql
   - httpd
   - wordpress
   - wp-dev 
