# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'

# Read config from config.json file
config = (JSON.parse(File.read('config.json')))

# VM Box
VM_BOX = config['VMBox']

# VM Provider
VM_PROVIDER = config['VMProvider']

# Master nodes params
NUM_CONTROL_NODES = config['controlNodes']['numNodes']  # Number of control nodes
CONTROL_NODE_NAME_PREFIX = config['controlNodes']['namePrefix']  # Numeric suffix is added so final names will be like "control-01", "control-02" etc.
CONTROL_NODE_RAM = config['controlNodes']['ram']  # Memory size
CONTROL_NODE_CPUS = config['controlNodes']['cpus']  # Number of vCPUs

# Worker nodes params
NUM_WORKER_NODES = config['workerNodes']['numNodes']  # Number of controlled nodes
WORKER_NODE_NAME_PREFIX = config['workerNodes']['namePrefix']  # Numeric suffix is added so final names will be like "node-01", "node-02" etc.
WORKER_NODE_RAM = config['workerNodes']['ram']  # Memory size
WORKER_NODE_CPUS = config['workerNodes']['cpus']  # Number of vCPUs

# Network parameters
HOSTS_NETWORK = config['network']['hostsNetwork']  # Private network for hosts
CONTROL_NODES_IP_START = config['network']['controlNodesIpStart']  # Starting IP address for control nodes. Real IP address will be +1
WORKER_NODES_IP_START = config['network']['workerNodesIpStart']   # Starting IP address for worker nodes. Real IP address will be +1

# Ansible config
ANSIBLE_USER_NAME = config['ansible']['user']
ANSIBLE_USER_PASSWORD = config['ansible']['password']

# The "2" in Vagrant.configure configures the configuration version 
# Older styles are supported for backwards compatibility
# Please don't change it unless you know what you're doing
Vagrant.configure("2") do |config|

  # VM Box image
  config.vm.box = VM_BOX

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false

  # Mount local 'scripts' directory from the host to '/scripts' directory in vms
  config.vm.synced_folder "scripts/", "/scripts"

  
  # Provisioning worker nodes
  (1..NUM_WORKER_NODES).each do |i|
    config.vm.define "#{WORKER_NODE_NAME_PREFIX}-0#{i}" do |node|
      node.vm.provider VM_PROVIDER do |v|
        v.gui = true  # Display vms in VMWare Workstation UI
        v.memory = WORKER_NODE_RAM
        v.cpus = WORKER_NODE_CPUS
      end
      # Configure network
      node.vm.hostname = "#{WORKER_NODE_NAME_PREFIX}-0#{i}"
      node.vm.network :private_network, ip: HOSTS_NETWORK + "#{WORKER_NODES_IP_START + i}"

      # Update '/etc/hosts' file
      node.vm.provision "setup-hosts", :type => "shell", :path => "scripts/update-hosts.sh"

      # Create ansible user
      node.vm.provision "create-users", :type => "shell", :path => "scripts/create-users.sh", :args => [ANSIBLE_USER_NAME, ANSIBLE_USER_PASSWORD]
    end
  end


  # Provisioning control nodes
  (1..NUM_CONTROL_NODES).each do |i|
    config.vm.define "#{CONTROL_NODE_NAME_PREFIX}-0#{i}" do |node|
      config.vm.provider VM_PROVIDER do |v|
        v.gui = true  # Display vms in VMWare Workstation UI
        v.memory = CONTROL_NODE_RAM
        v.cpus = CONTROL_NODE_CPUS
        
      end
      # Configure network
      node.vm.hostname = "#{CONTROL_NODE_NAME_PREFIX}-0#{i}"
      node.vm.network :private_network, ip: HOSTS_NETWORK + "#{CONTROL_NODES_IP_START + i}"

      # Update '/etc/hosts' file
      node.vm.provision "setup-hosts", :type => "shell", :path => "scripts/update-hosts.sh"
 
      # Create ansible user
      node.vm.provision "create-users", :type => "shell", :path => "scripts/create-users.sh", :args => [ANSIBLE_USER_NAME, ANSIBLE_USER_PASSWORD]
    
      # Install Ansible
      node.vm.provision "install_ansible", :type => "shell", :path => "scripts/install-ansible.sh"  

      # Generate ssh key for ansible user
      node.vm.provision "create-ssh-key", :type => "shell", :path => "scripts/configure-ssh.sh", :args => [ANSIBLE_USER_NAME, ANSIBLE_USER_PASSWORD, "/scripts/hosts.tmp"]
    
    end
  end
end
