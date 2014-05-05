# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Edit the following configuration values if required.

  use_64_bit = true
  ip = "192.168.111.111"
  copy_ansible_hosts = false
  ansible_project_executable = false

  # End of configuration.

  box_name = use_64_bit ? "precise64" : "precise32"
  config.vm.box = box_name
  config.vm.box_url = "http://files.vagrantup.com/" + box_name + ".box"

  config.vm.define :ansible_controller do |ansible_controller|
    ansible_controller.vm.network :private_network, ip: ip
    ansible_controller.vm.provider :virtualbox do |vb|
      vb.name = "ansible_controller"
    end

    ansible_controller.vm.synced_folder "ansible-project", "/home/vagrant/ansible-project", :mount_options => ansible_project_executable ? nil : ["dmode=777,fmode=666"]

    ansible_controller.vm.provision :shell, :path => "build.sh", :args => copy_ansible_hosts ? "-c" : nil
  end
end
