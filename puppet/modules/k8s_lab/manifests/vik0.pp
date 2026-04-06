class k8s_lab::vik0 {
  include k8s_lab

  # Ensure Docker is installed and running
  package { 'docker.io':
    ensure => installed,
  }

  package { 'docker-compose-v2':
    ensure => installed,
  }

  service { 'docker':
    ensure  => running,
    enable  => true,
    require => Package['docker.io'],
  }

  # Ensure user 'vik' is in the docker group
  user { 'vik':
    groups     => ['docker'],
    membership => minimum,
    require    => Package['docker.io'],
  }

  # Manage DNS configuration on vik0
  file { '/home/vik/dns/hosts':
    ensure => present,
    source => 'puppet:///modules/k8s_lab/dns_hosts',
    owner  => 'vik',
    group  => 'vik',
    mode   => '0644',
  }

  file { '/home/vik/dns/Corefile':
    ensure => present,
    source => 'puppet:///modules/k8s_lab/Corefile',
    owner  => 'vik',
    group  => 'vik',
    mode   => '0644',
  }

  file { '/home/vik/dns/docker-compose.yml':
    ensure => present,
    source => 'puppet:///modules/k8s_lab/dns_docker-compose.yml',
    owner  => 'vik',
    group  => 'vik',
    mode   => '0644',
  }

  # Manage Monitoring configuration
  file { '/home/vik/monitoring/prometheus.yml':
    ensure => present,
    source => 'puppet:///modules/k8s_lab/prometheus.yml',
    owner  => 'vik',
    group  => 'vik',
    mode   => '0644',
  }

  file { '/home/vik/monitoring/docker-compose.yml':
    ensure => present,
    source => 'puppet:///modules/k8s_lab/monitoring_docker-compose.yml',
    owner  => 'vik',
    group  => 'vik',
    mode   => '0644',
  }

  $dashboards = ['k8s_cluster.json', 'k8s_standard.json', 'node_exporter_full.json']
  $dashboards.each |$dashboard| {
    file { "/home/vik/monitoring/${dashboard}":
      ensure => present,
      source => "puppet:///modules/k8s_lab/${dashboard}",
      owner  => 'vik',
      group  => 'vik',
      mode   => '0644',
    }
  }

  # (Future) Add systemd units to manage docker-compose projects
  # For now, we just manage the configuration files.
}
