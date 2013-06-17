# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box       = 'precise32'
  config.vm.box_url   = 'http://files.vagrantup.com/precise32.box'
  config.vm.host_name = 'canvas-lms-dev-box'

  config.vm.customize ["modifyvm", :id, "--memory", 1024]

  config.vm.forward_port 9999, 9999

  config.vm.provision :puppet,
    :manifests_path => 'puppet/manifests',
    :module_path    => 'puppet/modules',
    :options        => [ "--pluginsync" ]
end
