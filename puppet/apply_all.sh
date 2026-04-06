#!/bin/bash
# apply_all.sh: Apply puppet manifests to all lab nodes

# Apply on vik0
echo "Applying puppet on vik0..."
sudo /opt/puppetlabs/bin/puppet apply --modulepath=/home/vik/puppet/modules /home/vik/puppet/manifests/site.pp

# Apply on other nodes
for node in vik1 vik2 vik3 vik4 vik5; do
  echo "-----------------------------------"
  echo "Processing $node..."
  scp -r /home/vik/puppet $node:/home/vik/
  ssh $node "sudo /opt/puppetlabs/bin/puppet apply --modulepath=/home/vik/puppet/modules /home/vik/puppet/manifests/site.pp"
done
