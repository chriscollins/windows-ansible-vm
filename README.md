Windows Ansible VM
==================

A Vagrant VM to allow Windows machines to control other machines using Ansible.

[https://github.com/chriscollins/windows-ansible-vm](https://github.com/chriscollins/windows-ansible-vm)

Ansible does not support Windows as the control machine: Whilst various hacks exist to attempt to get Ansible installed on a Window machine and running through Cygwin, I did not have much success with them, so I'm using this an alternative.

Dependencies
------------

* [Virtualbox](https://www.virtualbox.org).
* [Vagrant](http://www.vagrantup.com).
* SSH (comes with [Git](http://git-scm.com)) on your path, or [PuTTy](http://www.chiark.greenend.org.uk/~sgtatham/putty).

Usage
-----

The following commands should be done on the Windows machine:

* `git clone https://github.com/chriscollins/windows-ansible-vm.git`.
* Copy/symlink your Ansible project to the `ansible-project` directory of the Git checkout.  If you don't have an Ansible project yet, you can skip this step.
* `cd windows-ansible-vm`.
* `vagrant up`.  You should now have a new Virtualbox VM, on which Ansible is installed.  If you see any errors to do with 64-bit emulation being unsupported, please see the `use_64_bit` variable in the "Configuration" section below.
* `vagrant ssh` or open a PuTTy connection to `192.168.111.111`.  Your Ansible project should be available at `/home/vagrant/ansible-project/` and you can run your Ansible commands from here.

Configuration
-------------

The defaults should be fine for straightforward projects, but there are a few configuration variables available in the `Vagrantfile`:

* `use_64_bit` Set this to `false` to use a 32-bit VM, rather than a 64-bit machine.  Note: It's worth checking your BIOS virtualisation settings before overriding this, as it may be that your PC is capable of 64-bit emulation, but it is not enabled.

* `ip` The IP of the VM, `192.168.111.111` by default.

* `copy_ansible_hosts` Set this to `true` to copy the Ansible `hosts` file in the root of your `ansible-project` directory to Ansible's default `hosts` file (`/etc/ansible/hosts`).  This allows you to skip specifying your `hosts` file for every Ansible command with the `-i` argument.

* `ansible_project_executable` Set this to `true` to have executable permissions on all files in your `ansible-project` directory, rather than the default `666` Unix permissions.  Note: Permissions on directories that are shared with the host OS (Windows) cannot be changed - `chmod` will have no effect.  This is important, as Ansible attempts to execute `hosts` files that have executable permissions, rather than just reading the hosts from the file.  This allows you to have dynamic `hosts` files, but may not be functionality that you desire.  If you need executable files in your `ansible-project` directory, you may want to also consider setting the `copy_ansible_hosts` option to true: `/etc/ansible/hosts` is not shared with the host OS, so its permissions can be set to be non-executable via `chmod`.
