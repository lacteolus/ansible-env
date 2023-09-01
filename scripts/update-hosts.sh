#!/bin/sh

# Script to update /etc/hosts file

echo >> /etc/hosts
cat /scripts/hosts.tmp >> /etc/hosts
