saltstack-wordpress
===================


This is a set of configuration files needed for Vagrant to provision a virtual machine with a fully working wordpress development environment using [Salt-Stack](http://www.saltstack.com/community/) and [WP-Cli](http://wp-cli.org/)

### A couple of things to note:

* You have a working knowledge of Vagrant and Virtual Box.

* You do not need a deep understanding of salt-stack. Thisi s a pretty simple configuration and we will be setting it up masterless. If you run into issues, consult their documentation. 

* The salt state configs assume that you will be using a RedHat/CentOS based distro for your vagrant box. You can change the package names to reflect what Linux distribution you will be using. I have it noted in the approriate salt state files. 

* You are using Mac OSX. Vagrant and Virtual Box will working in Windows and Linux, but I set all of this up on a Macbook Pro. 

* This is going to be just used for development purposes only on a local machine. **DO NOT DEPLOY THIS VIRTUAL MACHINE TO A PRODUCTION ENVIRONMENT.** 


### Setup - vagrant-salt 

First, you want to make sure the vagrant box you are using has the latest guest-addons installed. next we will need to install the vagrant-salt plugin. When vagrant provisions a new virtual machine, it will automatically install the salt-stack packages. 


    vagrant plugin install vagrant-salt 


### Setup - Get the files 

Clone the repository to grab all files and the directory structure you will need 

    git clone https://github.com/paulehr/saltstack-wordpress.git

This will create a directory structure like the following

    saltstack-wordpress/
    	Vagrantfile
		src/
    	salt/
			minion.conf
			srv/
				top.sls
				base/
					init.sls
				httpd/
					init.sls
				mysql/
					init.sls
				php/
					init.sls
				wordpress/
					init.sls
				wp-dev/
					init.sls

				

### Setup - Vagrantfile 

Open up the Vagrantfile in a text editor and modify the following options:

    config.vm.box = "BOXNAME"

Change this to the name of the vagrant box you will be using.

    config.vm.hostname = "VMNAME"

Change this to what you want the hostname of the virtual machine to be. 

	config.vm.network :private_network, ip: "192.168.0.10"

This is so we can setup a consistent IP to access the VM with via the host machine. Also note what you set this to as it will need to match one of the settings in the salt state files.

    config.vm.synced_folder "salt/srv/", "/srv/salt"

Here we setup a sync folder between the host and the virtual machine. This is going to be relative to where the Vagrantfile is. If you cloned the repository you will not need to make any changes here. 


    config.vm.synced_folder "src", "/www_src"

This is where your wordpress files will be stored so that both the host and the virtual machine will have access. if you change where this gets mounted in the virtual machine. You will need to make sure you make the change in the salt state file. 

    config.vm.provision :salt do |salt|
            salt.minion_config = "salt/minion.conf"
            salt.run_highstate = true
            salt.verbose = true
    end

Here is the configuration entries for the salt minion. If you cloned the repository you shouldn’t need to make any changes here. This tells us where the minion.conf file is for the salt minion, run salt highstate, and we want verbose turned on.

### Setup - salt/

This directory holds minion.conf and the srv directory which holds all of the salt state files. 

### Setup - salt/minion.conf

The minion.conf is the main configuration file used by the salt minion running in the virtual machine. if you cloned the repository you will not need to make any changes here. However here is what each of the following entries mean:

    file_client: local

This tells the salt minion that it’s masterless and all the configuration and state files will be local. 

    mysql.host: 'localhost'
    mysql.port: 3306
    mysql.user: 'root'
    mtsql.pass: ''
    mysql.db: 'mysql'

This is so that the salt minion can connect to a local MySQL server to execute commands. This will be needed later when we go to install/configure MySQL and Wordpress. 

### Setup - srv/top.sls

This is top level state file for salt, this determines what state files get loaded to what machines. 

**The following configuration files deal with installing and configuring packages, all package names referenced are for RedHat/CentOS based system**

### Setup - base/init.sls

This is to install git and vim-ehanced within the VM. You can add any OS specific extra package you want here. 

### Setup - php/init.sls

This state file installs php, php-mysql and php-xml packages. php-xml is needed for the importer plugin we will be using to import test data into wordpress. 

### Setup - mysql/init.sls

This state file installs mysql-server and insures the daemon is running. It also installs the mysql client, MySQL-python and mysql-connector-python packages. MySQL-python and mysql-connector-python are needed for the salt-minion to talk to the mysql database.

### Setup - httpd/init.sls

This will install httpd and make sure that the httpd deamon is running.

### Setup - wordpress/init.sls

This state file is responsible for setting up the initial wordpress environment. 

    /var/www/html/wordpress:
     file.symlink:
      - target: /www_src

This is the symlink to the virtual box sync folder WP will live in, the target needs to match the directory we specified in the Vagrantfile. 

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

This tells the salt minion to log into the MySQL server and create a wordpress database, user and assign the user privilges to the database. 

    get_wp-cli:
     cmd.run:
      - name: 'curl -sS https://raw.github.com/wp-cli/wp-cli.github.com/master/installer.sh | bash'
      - cwd: /home/vagrant/
      - user: vagrant

This has the salt-minion download and install WP-Cli 

    /usr/local/bin/wp:
     file:
      - symlink
      - target: /home/vagrant/.wp-cli/bin/wp

Symlink's the WP binary to /usr/local/bin so it's in the $PATH

    config_wordpress:
     cmd.run:
      - cwd: /var/www/html/wordpress/
      - name: '/usr/local/bin/wp core config --dbname=wordpress --dbuser=wordpress --dbpass=password'

Tells wp-cli to create our wp-config.php, DB info needs to be the same as above

    install_wordpress:
     cmd.run:
      - cwd: /var/www/html/wordpress/
      - name: '/usr/local/bin/wp core install --url=http://192.168.0.10/wordpress --title=development --admin_user=admin --admin_password=password --admin_email=root@localhost'

This command tells wp-cli to install wordpress, the --url needs to be the same as the IP you set for the
Private IP in the Vagrantfile.

### Setup - wp-dev/init.sls

This state file is used to get the test data into wordpress and install a base theme to develop with

    get_wordpress-importer:
     cmd.run:
      - name: '/usr/local/bin/wp plugin install wordpress-importer --activate'
      - cwd: /var/www/html/wordpress

Tell WP-Cli to grab the wordpress-importer plugin. This plugin is needed to import the official blog test data from wordpress.org

    get_test_data:
     cmd.run:
      - name: 'wget https://wpcom-themes.svn.automattic.com/demo/theme-unit-test-data.xml'
      - cwd: /var/www/html/wordpress

This downloads the test data to be imported. 

    load_test_data:
     cmd.run:
      - name: '/usr/local/bin/wp import /var/www/html/wordpress/theme-unit-test-data.xml --authors=skip'
      - cwd: /var/www/html/wordpress

Here we are telling WP-Cli to import our test data and to skip remapping the authors.

    get_WP-Flex:
     cmd.run:
      - name: '/usr/local/bin/wp theme install https://github.com/grayghostvisuals/WP-Flex/archive/master.zip --activate'
      - cwd: /var/www/html/wordpress

Lastly this goes out and grabs a base theme and activates its within wordpress. You can use what ever theme you want or you can completely remove this block if you are going to be doing other types of development.

### Setup - Provision your vagrant box 

At this point have vagrant provision the box into a vritual machine and within a few minutes you should have a fully functional wordpress development environment. 