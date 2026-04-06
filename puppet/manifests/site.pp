node 'vik0' {
  include k8s_lab::vik0
}

node 'vik1', 'vik2' {
  include k8s_lab::k8s_node
  # Additional control plane configuration could go here
}

node 'vik3', 'vik4', 'vik5' {
  include k8s_lab::k8s_node
  # Additional worker configuration could go here
}

# Default node configuration
node default {
  include k8s_lab
}
