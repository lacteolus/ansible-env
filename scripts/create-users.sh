#!/bin/sh

# Script to create user for Ansible and add permissions

# User and group ids are pre-defined in order to solve mount permissions in Vagrant file
groupadd -g 1234 $1
useradd -u 1234 -g 1234 $1

echo $2 | passwd --stdin $1
echo "$1 ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$1
