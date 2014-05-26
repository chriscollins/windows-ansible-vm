#!/bin/bash
#
# Arguments:
#    -c Copy the hosts file in the ansible-project directory to the Ansible default hosts file.
#

ANSIBLE_PROJECT_HOSTS=/home/vagrant/ansible-project/hosts
ANSIBLE_HOSTS=/etc/ansible/hosts

echo "Installing Ansible..."

apt-get update -qq
apt-get install python-pip python-paramiko python-yaml python-jinja2 python-simplejson -y
pip install ansible

while getopts ":c" opt; do
    case $opt in
        c)
            if [[ -f $ANSIBLE_PROJECT_HOSTS ]]; then
                echo "Copying ansible-project hosts file to $ANSIBLE_HOSTS..."

                cp $ANSIBLE_PROJECT_HOSTS $ANSIBLE_HOSTS
                chown vagrant:vagrant $ANSIBLE_HOSTS
                chmod 622 $ANSIBLE_HOSTS
            else
                echo "$ANSIBLE_PROJECT_HOSTS was not found, could not copy to $ANSIBLE_HOSTS."
            fi
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

echo "Finished."
