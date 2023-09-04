#!/bin/sh

# Script to configure SSH for Ansible on all hosts 
 
# Generate SSH key for Ansible user
sudo su -c "ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa <<< y" $1

# Copy SSH key to all hosts
cat $3 | while read line
do
    h=$(echo $line | awk '{print $2}')
    echo "Copying ssh key to $h host..."
    sudo su -c "sshpass -p $2 ssh-copy-id -o StrictHostKeyChecking=no $h <<< y" $1
done
