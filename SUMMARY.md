# Infrastructure & Backup Setup Summary
**Date:** April 6, 2026

## 🚀 Accomplishments

### 1. Automated etcd Backup System
- **Script Location:** `/usr/local/bin/etcd-backup.sh`
- **Functionality:** 
  - Authenticates with etcd using copied certificates (CA, Admin cert, and Admin key).
  - Connects to control plane endpoint `10.0.0.92`.
  - Performs a consistent etcd v3 snapshot.
  - **Auto-Rotation:** Keeps exactly the 3 most recent backups to save space while ensuring recovery options.
- **Automation:** Scheduled daily at **02:00 AM** via cron job.

### 2. TrueNAS NFS Integration
- **Mount Point:** `/backup` on `vik0` (Management Node).
- **Backend:** `10.0.0.18:/mnt/bigdata1` (TrueNAS Dataset).
- **Configuration:** Persistent via `/etc/fstab` with optimized NFS options (`timeo=900`, `retrans=5`).
- **Storage Strategy:** Shared storage pool for etcd, PostgreSQL, and future projects.

### 3. Certificate Management
- Securely synchronized etcd certificates from `vik1` to `vik0` to enable remote backup operations.
- Files stored securely in `/etc/ssl/etcd/ssl/`.

## 📂 Current Backup Status
```bash
$ ls -lh /backup/etcd/
total 41M
-rw-r--r-- 1 root root 5.8K Apr  6 11:30 etcd-backup.log
-rw------- 1 root root  14M Apr  6 11:28 etcd-snapshot-2026-04-06-112835.db
-rw------- 1 root root  14M Apr  6 11:30 etcd-snapshot-2026-04-06-113020.db
-rw------- 1 root root  14M Apr  6 11:30 etcd-snapshot-2026-04-06-113021.db
```

---
*Environment: Proxmox VE | Kubernetes v1.31.9 | TrueNAS NFS*
