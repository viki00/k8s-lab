class k8s_lab {
  # Base packages
  $base_packages = ['curl', 'vim', 'htop', 'git', 'net-tools', 'iputils-ping', 'ca-certificates']
  package { $base_packages:
    ensure => installed,
  }

  # Ensure time is synchronized
  service { 'systemd-timesyncd':
    ensure => running,
    enable => true,
  }

  # Install and manage Node Exporter (for all nodes)
  package { 'prometheus-node-exporter':
    ensure => installed,
  }

  # Ensure the directory for textfile collector exists
  file { '/var/lib/prometheus/node-exporter':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => true,
  }

  # Configure node_exporter to use the textfile collector
  file { '/etc/default/prometheus-node-exporter':
    ensure  => present,
    content => 'ARGS="--collector.textfile.directory=/var/lib/prometheus/node-exporter"',
    notify  => Service['prometheus-node-exporter'],
    require => Package['prometheus-node-exporter'],
  }

  service { 'prometheus-node-exporter':
    ensure  => running,
    enable  => true,
    require => Package['prometheus-node-exporter'],
  }

  include k8s_lab::automation

  # Kernel tuning for Kubernetes (common to all nodes)
  exec { 'sysctl-ip-forward':
    command => 'sysctl -w net.ipv4.ip_forward=1',
    path    => ['/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    unless  => 'sysctl -n net.ipv4.ip_forward | grep -q 1',
  }

  exec { 'sysctl-bridge-nf-call-iptables':
    command => 'sysctl -w net.bridge.bridge-nf-call-iptables=1',
    path    => ['/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    unless  => 'sysctl -n net.bridge.bridge-nf-call-iptables | grep -q 1',
  }

  exec { 'sysctl-bridge-nf-call-ip6tables':
    command => 'sysctl -w net.bridge.bridge-nf-call-ip6tables=1',
    path    => ['/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    unless  => 'sysctl -n net.bridge.bridge-nf-call-ip6tables | grep -q 1',
  }
}
