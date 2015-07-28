# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'json'
Vagrant.configure('2') do |config|
  ## Grab a list of roles to run, or default to a basic set
  role = (ENV['ROLE'] || 'test_bdp.yml').gsub(/\.yml/,'')
  target_vm = (ENV['TARGET_VM'] || 'centos')
  target_vm_variant = (ENV['TARGET_VM_VARIANT'] || '7')
  if target_vm == 'centos'
    if target_vm_variant == '7'
      vm_box = 'chef/centos-7.0'
    elsif target_vm_variant == '6'
      vm_box = 'chef/centos-6.5'
    end
  elsif target_vm == 'ubuntu'
    if target_vm_variant == '12.04'
      vm_box = 'chef/ubuntu-12.04'
    end
  else
    raise usage
    exit 1
  end
  target_vm_count = (ENV['TARGET_VM_COUNT'] || 3)

  ## Set memory size and # of cpus from env vars
  config.vm.provider "virtualbox" do |v|
    v.memory = (ENV['VAGRANT_RAM'] || 2048)
    v.cpus = (ENV['VAGRANT_CPU'] || 1)
  end

  ## Set ansible 'extra_vars' and 'tags' from env vars
  extra_vars = Hash.new
  extra_vars = JSON.parse(ENV['EXTRA_VARS']) unless ENV['EXTRA_VARS'].nil?
  extra_vars['ansible_ssh_user'] = 'vagrant'
  extra_vars['os'] = target_vm
  extra_vars['os_variant'] = target_vm_variant
  tags = (ENV['TAGS'] || 'all').split(',')

  ## Generate boxes for each role we feed in!
  i = 0
  ## Construct an array of all hostnames that will be associated
  ## with the role so we can loop over it to build the vms and
  ## feed the array to ansible.groups so it builds the inventory
  ## correctly
  vm_names = Array.new
  (1..target_vm_count).each do |count|
    vm_names.push("bdp-#{target_vm}-#{count}")
  end

  ## Define and spin up the machines
  vm_names.each do |vm_name|
    config.vm.define vm_name do |rolevm|
      rolevm.vm.hostname = vm_name
      rolevm.vm.box = vm_box
      rolevm.vm.network 'private_network', ip: "192.168.50.#{i+100}"
      ## Port Forwards
      ## handoff
      rolevm.vm.network "forwarded_port", guest: 8099, host: "5#{i}099".to_i, auto_correct: true
      # http
      rolevm.vm.network "forwarded_port", guest: 8098, host: "5#{i}098".to_i, auto_correct: true
      # pb
      rolevm.vm.network "forwarded_port", guest: 8087, host: "5#{i}087".to_i, auto_correct: true
      i += 1
      ## If this is the last server in the group, provision all the
      ## machines. This will make the playbooks run in parallel across
      ## all of the vms, which is required when there are group dependencies
      ## in playbooks. This is also how ansible works in the real world.
      config.ssh.insert_key = false
      if vm_name == vm_names[-1]
        rolevm.vm.provision :ansible do |ansible|
          ansible.groups = {
            role => vm_names
          }
          ansible.extra_vars = extra_vars
          ansible.tags = tags 
          ansible.playbook = "#{role}.yml"
          ansible.limit = 'all'
        end
      end
    end
  end
end
