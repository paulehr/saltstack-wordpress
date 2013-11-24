# This state file is used to get the test data into wordpress and install a base theme to develop with

# This plugin is needed to import the official blog test data from wordpress.org
get_wordpress-importer:
 cmd.run:
  - name: '/usr/local/bin/wp plugin install wordpress-importer --activate'
  - cwd: /var/www/html/wordpress

# Download the test data to our root wordpress directory
get_test_data:
 cmd.run:
  - name: 'wget https://wpcom-themes.svn.automattic.com/demo/theme-unit-test-data.xml'
  - cwd: /var/www/html/wordpress

# This has wp-cli import the test data into the blog
load_test_data:
 cmd.run:
  - name: '/usr/local/bin/wp import /var/www/html/wordpress/theme-unit-test-data.xml --authors=skip'
  - cwd: /var/www/html/wordpress

# This downloads and activates a base theme to be used for theme development
get_WP-Flex:
 cmd.run:
  - name: '/usr/local/bin/wp theme install https://github.com/grayghostvisuals/WP-Flex/archive/master.zip --activate'
  - cwd: /var/www/html/wordpress
