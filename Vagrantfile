# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  #Change BOXNAME to what your vagrant box is called 
  config.vm.box = "BOXNAME"

  #Set this to what you want the VM hostname to be
  config.vm.hostname = "VMNAME"


  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # You can change this to anything you want, just make sure it matches in the wordpress.sls file 
  config.vm.network :private_network, ip: "192.168.0.10"

  # This is needed for the salt-minion, the first argument is relative the directory where 
  # your Vagrantfile is located 
  config.vm.synced_folder "salt/srv/", "/srv/salt"

  # This is so we can work on wordpress files on the host. 
  # The second argument will need to match up with the file.symlink target setting in the wordpress 
  # salt state file. 
  config.vm.synced_folder "src", "/www_src"

  # Salt-Stack configuration. The location of the minion.conf file is relative to where 
  # your Vagrantfile is located. 
   config.vm.provision :salt do |salt|
	salt.minion_config = "salt/minion.conf"
	salt.run_highstate = true
	salt.verbose = true
   end 
end
