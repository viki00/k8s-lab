class k8s_lab::automation {
  # Script to report puppet run results to node_exporter
  file { '/usr/local/bin/puppet_report_metrics.sh':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => @(EOT)
#!/bin/bash
# Parse puppet last run summary and output prometheus metrics
SUMMARY_FILE="/opt/puppetlabs/puppet/public/last_run_summary.yaml"

PROM_FILE="/var/lib/prometheus/node-exporter/puppet_run.prom"
mkdir -p $(dirname $PROM_FILE)

if [ -f "$SUMMARY_FILE" ]; then
    last_run=$(grep "last_run:" "$SUMMARY_FILE" | awk '{print $2}')
    changed=$(grep "changed:" "$SUMMARY_FILE" | head -1 | awk '{print $2}')
    failed=$(grep "failed:" "$SUMMARY_FILE" | head -1 | awk '{print $2}')
    out_of_sync=$(grep "out_of_sync:" "$SUMMARY_FILE" | head -1 | awk '{print $2}')

    cat << EOF > "$PROM_FILE"
# HELP puppet_last_run_timestamp_seconds Timestamp of the last puppet run.
# TYPE puppet_last_run_timestamp_seconds gauge
puppet_last_run_timestamp_seconds $last_run
# HELP puppet_changed_resources_total Number of resources changed in last run.
# TYPE puppet_changed_resources_total gauge
puppet_changed_resources_total ${changed:-0}
# HELP puppet_failed_resources_total Number of resources that failed in last run.
# TYPE puppet_failed_resources_total gauge
puppet_failed_resources_total ${failed:-0}
# HELP puppet_out_of_sync_resources_total Number of resources out of sync in last run.
# TYPE puppet_out_of_sync_resources_total gauge
puppet_out_of_sync_resources_total ${out_of_sync:-0}
EOF
fi
| EOT
  }

  # Systemd service to run puppet apply
  file { '/etc/systemd/system/puppet-apply.service':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => @(EOT)
[Unit]
Description=Apply Puppet Manifests
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
ExecStartPre=/usr/bin/mkdir -p /home/vik/puppet
ExecStart=/opt/puppetlabs/bin/puppet apply --modulepath=/home/vik/puppet/modules /home/vik/puppet/manifests/site.pp
ExecStartPost=/usr/local/bin/puppet_report_metrics.sh

[Install]
WantedBy=multi-user.target
| EOT
  }

  # Systemd timer to run every 4 hours
  file { '/etc/systemd/system/puppet-apply.timer':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => @(EOT)
[Unit]
Description=Run Puppet Apply every 4 hours

[Timer]
OnBootSec=15min
OnUnitActiveSec=4h
RandomizedDelaySec=5min

[Install]
WantedBy=timers.target
| EOT
  }

  service { 'puppet-apply.timer':
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/systemd/system/puppet-apply.timer'],
  }

  # Ensure the node_exporter can read the metrics
  # Assuming prometheus-node-exporter is configured to read from /var/lib/prometheus/node-exporter/
  # We might need to adjust the node_exporter service args if it doesn't.
}
