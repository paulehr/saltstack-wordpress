get_wordpress-importer:
 cmd.run:
  - name: '/usr/local/bin/wp plugin install wordpress-importer --activate'
  - cwd: /var/www/html/wordpress

get_test_data:
 cmd.run:
  - name: 'wget https://wpcom-themes.svn.automattic.com/demo/theme-unit-test-data.xml'
  - cwd: /var/www/html/wordpress

load_test_data:
 cmd.run:
  - name: '/usr/local/bin/wp import /var/www/html/wordpress/theme-unit-test-data.xml --authors=skip'
  - cwd: /var/www/html/wordpress

get_WP-Flex:
 cmd.run:
  - name: '/usr/local/bin/wp theme install https://github.com/grayghostvisuals/WP-Flex/archive/master.zip --activate'
  - cwd: /var/www/html/wordpress
