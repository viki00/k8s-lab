# Lab Environment: Proxmox, Kubernetes & Ansible

This workspace is a DevOps/SRE/DBA lab environment focused on infrastructure as code, container orchestration, and database management.

## Project Context
- **Infrastructure:** Proxmox VE (Virtual Machines)
- **Orchestration:** Kubernetes (K8s)
- **Provisioning/Configuration:** Ansible & Kubespray
- **Networking:** MetalLB for LoadBalancer services
- **Role focus:** High Availability, Observability, Performance Tuning, and Database Reliability.

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
