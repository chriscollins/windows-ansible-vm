#!/bin/bash
#
# Arguments:
#    -c|--copy-hosts Copy the hosts file in the ansible-project directory to the Ansible default hosts file.
#    -s|--ansible-from-source Install Ansible from source, rather than apt-get.

# Constants.
ANSIBLE_PROJECT_HOSTS=/home/vagrant/ansible-project/hosts
ANSIBLE_HOSTS=/etc/ansible/hosts
ANSIBLE_GIT_REPO_URL=git://github.com/ansible/ansible.git
ANSIBLE_SOURCE_INSTALL_PATH=/opt/ansible
SSH_DIR=/home/vagrant/.ssh
SSH_PUBLIC_KEY_PATH=$SSH_DIR/id_rsa.pub

# Install Ansible from source.
function installAnsibleFromSource() {
    echo "Installing Ansible from source..."

    pip install paramiko PyYAML Jinja2 httplib2 six markupsafe

    git clone $ANSIBLE_GIT_REPO_URL --recursive $ANSIBLE_SOURCE_INSTALL_PATH
    cd $ANSIBLE_SOURCE_INSTALL_PATH
    source ./hacking/env-setup
}

# Install Ansible from apt-get.
function installAnsibleFromAptGet() {
    echo "Installing Ansible from apt-get..."

    apt-get install -y python-paramiko python-yaml python-jinja2 python-simplejson
    pip install ansible
}

# Copy the ansible projects file to etc/ansible/hosts for convenience.
function copyAnsibleProjectHosts() {
    if [[ -f $ANSIBLE_PROJECT_HOSTS ]]; then
        echo "Copying ansible-project hosts file to $ANSIBLE_HOSTS..."

        cp $ANSIBLE_PROJECT_HOSTS $ANSIBLE_HOSTS
        chown vagrant:vagrant $ANSIBLE_HOSTS
        chmod 622 $ANSIBLE_HOSTS
    else
        echo "$ANSIBLE_PROJECT_HOSTS was not found, could not copy to $ANSIBLE_HOSTS."
    fi
}

# Main.
copy_ansible_project_hosts=0

echo "Installing apt dependencies..."
apt-get update -qq
apt-get install -y git python-pip

while :; do
    case $1 in
        -c|--copy-hosts)
            copyAnsibleProjectHosts
        ;;
        -s|--ansible-from-source)
            install_ansible_from_source=1
        ;;
        --)
            shift
            break
        ;;
        -?*)
            echo "Invalid option: -$1"
        ;;
        *)
            break
        ;;
    esac

    shift
done

if [[ install_ansible_from_source -eq 1 ]]; then
    installAnsibleFromSource
else
    installAnsibleFromAptGet
fi

echo "Finished."
