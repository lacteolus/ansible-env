# Set of scripts for deploying local Ansible-managed environment for tests

Creates multiple vms (control and managed nodes) locally. Vms are hosted on Oracle VirtualBox. All machines are pre-configured for Ansible. 

## Software
1. Oracle VirtualBox 7.0.10
2. Hashicorp Vagrant 2.3.7

## Usage

Use `config.json` file to configure deployment according to your needs.


Run `run.ps1` PowerShell script

to CREATE environment and vms:
```
.\run.ps1 create
```

to DESTROY environment and vms:
```
.\run.ps1 destroy
```

to VERIFY environment and get current status:
```
.\run.ps1 verify
```