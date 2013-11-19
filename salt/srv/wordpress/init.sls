
/var/www/html/wordpress:
 file.symlink:
  - target: /www_src

wordpress_db:
 mysql_database.present:
  - name: wordpress
 mysql_user.present:
  - name: wordpress
  - password: password
 mysql_grants.present:
  - database: wordpress.*
  - grant: ALL PRIVILEGES
  - user: wordpress
  - host: '%'

get_wordpress:
 cmd.run:
  - name: 'wget http://wordpress.org/latest.tar.gz && tar xvzf latest.tar.gz'
  - cwd: /var/www/html/

get_wp-cli:
 cmd.run:
  - name: 'curl -sS https://raw.github.com/wp-cli/wp-cli.github.com/master/installer.sh | bash'
  - cwd: /home/vagrant/
  - user: vagrant

/usr/local/bin/wp:
 file:
  - symlink
  - target: /home/vagrant/.wp-cli/bin/wp

config_wordpress:
 cmd.run:
  - cwd: /var/www/html/wordpress/
  - name: '/usr/local/bin/wp core config --dbname=wordpress --dbuser=wordpress --dbpass=password'

install_wordpress:
 cmd.run:
  - cwd: /var/www/html/wordpress/
  - name: '/usr/local/bin/wp core install --url=http://192.168.0.10/wordpress --title=development --admin_user=admin --admin_password=password --admin_email=root@localhost' 
