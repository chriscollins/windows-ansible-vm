# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Edit the following configuration values if required.

  use_64_bit = true
  ip = "192.168.111.111"
  copy_ansible_hosts = false
  ansible_project_executable = false
  install_ansible_from_source = true
  private_key_path = nil
  public_key_path = nil

  # End of configuration.

  box_name = use_64_bit ? "precise64" : "precise32"
  config.vm.box = box_name
  config.vm.box_url = "http://files.vagrantup.com/" + box_name + ".box"
  ssh_path = "/home/vagrant/.ssh"

  config.vm.define :ansible_controller do |ansible_controller|
    ansible_controller.vm.network :private_network, ip: ip
    ansible_controller.vm.provider :virtualbox do |vb|
      vb.name = "ansible_controller"
    end

    ansible_controller.vm.synced_folder "ansible-project", "/home/vagrant/ansible-project", :mount_options => ansible_project_executable ? nil : ["dmode=777,fmode=666"]

    if !private_key_path.nil?
      private_key_destination = ssh_path + "/id_rsa"

      ansible_controller.vm.provision :file, source: private_key_path, destination: private_key_destination
      ansible_controller.vm.provision :shell, inline: "chmod 600 " + private_key_destination
    end

    if !public_key_path.nil?
      public_key_destination = ssh_path + "/id_rsa.pub"

      ansible_controller.vm.provision :file, source: public_key_path, destination: public_key_destination
      ansible_controller.vm.provision :shell, inline: "chmod 600 " + public_key_destination
      ansible_controller.vm.provision :shell, inline: "cat " + public_key_destination + " >> " + ssh_path + "/authorized_keys"
    end

    build_args = ""

    if copy_ansible_hosts
      build_args += "--copy-hosts "
    end

    if install_ansible_from_source
      build_args += "--ansible-from-source "
    end

    ansible_controller.vm.provision :shell, :path => "build.sh", :args => build_args
  end
end
