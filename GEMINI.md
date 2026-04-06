# Lab Environment: Proxmox, Kubernetes & Ansible

This workspace is a DevOps/SRE/DBA lab environment focused on infrastructure as code, container orchestration, and database management.

## Project Context
- **Infrastructure:** Proxmox VE (Virtual Machines)
- **Orchestration:** Kubernetes (K8s)
- **Provisioning/Configuration:** Ansible & Kubespray
- **Networking:** MetalLB for LoadBalancer services
- **Role focus:** High Availability, Observability, Performance Tuning, and Database Reliability.

## Current Cluster Architecture (as of April 6, 2026)
- **Kubernetes Version:** v1.31.9
- **Nodes Status:** All nodes are currently **Ready**.
- **Inventory:**
  - `vik0` (10.0.0.44): Management Node (Docker, DNS, Monitoring, Backups)
  - `vik1` (10.0.0.92): Control Plane / etcd
  - `vik2` (10.0.0.194): Control Plane / etcd
  - `vik3` (10.0.0.204): Control Plane / etcd
  - `vik4` (10.0.0.55): Worker
  - `vik5` (10.0.0.96): Worker
- **Core Stack:**
  - **CNI:** Cilium
  - **Ingress Controller:** Ingress-NGINX
  - **LoadBalancer:** MetalLB (IP Pool: `192.168.1.230-192.168.1.250`)
  - **Storage:** Longhorn (for K8s), TrueNAS NFS (for backups)
- **Host OS:** Ubuntu 24.04.1 LTS (6.14.0-33-generic)

## Backup & Disaster Recovery (DR)
- **Backup Server:** `vik0` (Management Node)
- **Storage Backend:** TrueNAS NFS (`10.0.0.18:/mnt/bigdata1`) mounted at `/backup`
- **etcd Backups:**
  - **Script:** `/usr/local/bin/etcd-backup.sh`
  - **Target:** Snapshots from `vik1` (10.0.0.92)
  - **Location:** `/backup/etcd/`
  - **Retention:** 3 latest copies (automated rotation)
  - **Schedule:** Daily at 02:00 AM (via `/etc/cron.d/etcd-backup`)
- **Shared Storage:** `/backup` is a shared pool for Postgres, etcd, and other product backups.

## Engineering Standards & Practices

### Infrastructure as Code (IaC)
- **Ansible:** Follow standard role structures. Ensure playbooks are idempotent. Use `ansible-lint` where possible.
- **Kubernetes:** Prefer declarative YAML manifests over `kubectl` imperative commands.
- **Kubespray:** Maintain customizations in `inventory/mycluster/group_vars`.

### Database Management (DBA)
- Prioritize data persistence and backup strategies (e.g., Velero for K8s, native DB backup tools).
- Focus on statefulsets for database deployments in Kubernetes.
- Ensure proper resource limits and PVC configurations for all database workloads.

### SRE & Operations
- **Observability:** Focus on Prometheus/Grafana for monitoring.
- **Automation:** Automate routine tasks using Ansible playbooks.
- **Security:** Follow the principle of least privilege for service accounts and RBAC.

## Guidelines for Gemini
- When proposing changes, consider the impact on the existing Kubespray-managed cluster.
- Always check `ansible-lab/` for existing inventory and host configurations.
- For Kubernetes tasks, assume the context is already set via `~/.kube/config`.
- Provide optimized SQL or database configuration suggestions when relevant to DBA tasks.
