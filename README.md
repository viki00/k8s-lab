# K8s Lab: Proxmox, Kubernetes & Ansible

This repository contains the infrastructure-as-code (IaC), configuration management, and monitoring setup for a DevOps/SRE/DBA lab environment.

## Project Overview
The lab is built on **Proxmox VE** virtual machines, managed via **Ansible**, and runs a high-availability **Kubernetes** cluster provisioned with **Kubespray**.

### Core Technologies
- **Virtualization:** Proxmox VE
- **Orchestration:** Kubernetes v1.31.9
- **Networking:** Cilium (CNI), MetalLB (LoadBalancer), Ingress-NGINX
- **Storage:** Longhorn (Distributed Block), TrueNAS NFS (Backups)
- **Configuration:** Ansible, Puppet
- **Observability:** Prometheus & Grafana

## Cluster Architecture (as of April 2026)
| Hostname | IP Address | Role | OS |
| :--- | :--- | :--- | :--- |
| **vik0** | 10.0.0.44 | Management (Docker, DNS, Monitoring, Backups) | Ubuntu 24.04 |
| **vik1** | 10.0.0.92 | Control Plane / etcd | Ubuntu 24.04 |
| **vik2** | 10.0.0.194 | Control Plane / etcd | Ubuntu 24.04 |
| **vik3** | 10.0.0.204 | Control Plane / etcd | Ubuntu 24.04 |
| **vik4** | 10.0.0.55 | Worker Node | Ubuntu 24.04 |
| **vik5** | 10.0.0.96 | Worker Node | Ubuntu 24.04 |

## Key Features

### 1. Networking & Load Balancing
- **MetalLB:** Configured with an IP pool (`192.168.1.230 - 192.168.1.250`) to provide `LoadBalancer` services within the local network.
- **Cilium:** Used as the CNI for high-performance networking and security policies.

### 2. Storage & Backups
- **Longhorn:** Provides persistent storage for stateful applications (PostgreSQL, etc.).
- **TrueNAS Integration:** A TrueNAS NFS share (`10.0.0.18:/mnt/bigdata1`) is mounted at `/backup` on the management node.
- **Automated etcd Backups:** Daily snapshots are taken from the control plane and synced to `/backup/etcd/` with a 3-copy retention policy.

### 3. Monitoring & Metrics
- **Prometheus/Grafana:** Full stack monitoring.
- **Puppet Metrics:** Includes a custom Ansible playbook (`ansible-lab/deploy_puppet_metrics.yml`) to export Puppet run summaries into Prometheus via the Node Exporter textfile collector.

## Monitoring & Dashboards
| Service | URL | Purpose |
| :--- | :--- | :--- |
| **Stock Terminal** | [http://stocks.lab](http://10.0.0.231) | Real-time stock charts & signals (Streamlit) |
| **Grafana** | [http://metrics.lab](http://10.0.0.232) | Cluster & Ingestion health |
| **Longhorn** | [http://longhorn.lab](http://10.0.0.230) | Storage management |

### Stock Terminal Features
- **Tickers:** AAPL, AMZN, AX, AZN, F, GE, GEHC, GEV, GOOGL, NSC, NVDA, QQQ, SBUX, VOO, **MSFT, SPY, TSLA** (Recently Added).
- **Time Ranges:** Selectable via dropdown: 6h, 12h, 24h, 3d, 7d, 30d, 60d, 90d, 6mo.
- **Indicators:** Candlestick charts, SMA 50, SMA 200, and RSI (14-period).
- **Signal Logic (Buy/Sell/Hold):** Automated signals based on trend (SMA) and momentum (RSI).

### Stock Signal Logic
The Stock Lab Terminal generates automated signals based on a combination of Trend and Momentum indicators:

1. **BUY (Bullish):** 
   - **Trend:** Current Price is above the 50-period Simple Moving Average (SMA50).
   - **Momentum:** Relative Strength Index (RSI) is below 60 (indicating it's not yet overbought).
   - **Context:** If SMA200 is available, SMA50 must be above SMA200.

2. **SELL (Bearish/Overbought):**
   - **Bearish:** Current Price is below the SMA50 AND SMA50 is below SMA200.
   - **Overbought:** RSI is above 75 (indicating a likely pull-back).

3. **HOLD (Neutral):**
   - Default state when signals are conflicting (e.g., Price is above SMA50 but RSI is very high, or the market is consolidating).

## Stock Pipeline Implementation
The pipeline is deployed in the `pipeline` namespace and consists of:
- **`stock-ingestor`:** A Python deployment using `yfinance` to pull 5-minute data. 
  - **Bootstrap:** On startup, it pulls 60 days of 5m data and 6 months of 1h data for all tickers to ensure immediate historical context.
  - **Pre/Post Market:** Now captures extended hours data (`prepost=True`).
- **`stock-dashboard`:** A Streamlit application providing the frontend UI.
- **`timescaledb`:** PostgreSQL with TimescaleDB extension for efficient time-series storage.

## Repository Structure
- `ansible-lab/`: Ansible playbooks for cluster maintenance.
- `ingest_stocks.py`: The core ingestion logic (deployed via ConfigMap).
- `app.py`: Streamlit dashboard code (deployed via ConfigMap).
- `stock-ingestor.yaml`: K8s deployment for the data pipeline.
- `stock-dashboard.yaml`: K8s deployment for the frontend.
- `grafana.yaml`: Persistent Grafana deployment.
- `monitoring/`: Local dashboard JSON exports.

## Quick Start

### Deploying Puppet Metrics Reporting
To deploy the custom metrics collector to your nodes:
```bash
ansible-playbook -i ansible-lab/inventory ansible-lab/deploy_puppet_metrics.yml
```

### Accessing the Cluster
Ensure your `KUBECONFIG` is set:
```bash
export KUBECONFIG=~/.kube/config
kubectl get nodes
```

---
*Maintained by viki00*
