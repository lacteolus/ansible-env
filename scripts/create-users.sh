#!/bin/sh

# Script to create user for Ansible and add permissions

useradd $1
echo $2 | passwd --stdin $1
echo "$1 ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$1
