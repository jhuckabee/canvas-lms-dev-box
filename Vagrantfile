# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box       = 'precise32'
  config.vm.box_url   = 'http://files.vagrantup.com/precise32.box'
  config.vm.host_name = 'canvas-lms-dev-box'

  # Canvas needs symlinks in order to run db:initial_setup -- something coffee script related
  config.vm.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]

  config.vm.customize ["modifyvm", :id, "--memory", 1024]

  config.vm.forward_port 9999, 9999

  config.vm.provision :puppet,
    :manifests_path => 'puppet/manifests',
    :module_path    => 'puppet/modules',
    :options        => [ "--pluginsync" ]
end
