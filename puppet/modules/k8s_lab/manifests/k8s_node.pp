class k8s_lab::k8s_node {
  include k8s_lab

  # Common node-level configuration (vik1-5)
  # Ensure some K8s-specific packages
  $k8s_common_packages = ['conntrack', 'socat', 'ebtables', 'ipset']
  package { $k8s_common_packages:
    ensure => installed,
  }

  # Ensure swap is off
  exec { 'disable-swap-now':
    command => 'swapoff -a',
    onlyif  => 'swapon --summary | grep -q "^/"',
    path    => ['/usr/sbin', '/usr/bin', '/sbin', '/bin'],
  }

  file_line { 'disable-swap-fstab':
    ensure => absent,
    path   => '/etc/fstab',
    line   => '/swap.img none swap sw 0 0', # common for Ubuntu
    match  => '^/swap.img',
  }
}
