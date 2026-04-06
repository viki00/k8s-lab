# Puppet Lab Provisioning

This directory contains Puppet manifests and modules to provision the `vik0` node and the 5-node K8s cluster nodes (`vik1-5`).

## Structure
- `manifests/site.pp`: Main entry point, maps hostnames to classes.
- `modules/k8s_lab/`: Custom module for the lab.
  - `init.pp`: Base class for all nodes (packages, NTP, node_exporter, sysctl).
  - `vik0.pp`: Configuration for the management node (Docker, DNS, Monitoring).
  - `k8s_node.pp`: Common configuration for all K8s cluster nodes (swapoff, k8s-related packages).

## Usage

### 1. Install Puppet (on vik0 and all nodes)
Run these commands on each node (or use Ansible to do it once):
```bash
wget https://apt.puppet.com/puppet8-release-noble.deb
sudo dpkg -i puppet8-release-noble.deb
sudo apt update
sudo apt install puppet-agent
```

### 2. Apply on vik0
```bash
sudo /opt/puppetlabs/bin/puppet apply --modulepath=/home/vik/puppet/modules /home/vik/puppet/manifests/site.pp
```

### 3. Apply on cluster nodes
You can copy the `puppet` directory to the other nodes and run `puppet apply` there as well.
```bash
for node in vik1 vik2 vik3 vik4 vik5; do
  scp -r /home/vik/puppet $node:/home/vik/
  ssh $node "sudo /opt/puppetlabs/bin/puppet apply --modulepath=/home/vik/puppet/modules /home/vik/puppet/manifests/site.pp"
done
```

## Managed Resources
- **Common**: `curl`, `vim`, `htop`, `git`, `node_exporter`, `sysctl` (ip_forward).
- **vik0**: Docker, CoreDNS (config), Prometheus (config), DNS hosts.
- **K8s Nodes**: Swap disabled, K8s-related packages (`socat`, `conntrack`).
