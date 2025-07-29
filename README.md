# CockroachDB Deployment

This repository demonstrates a **CockroachDB deployment** on **RHEL 9.6 using k3s**, with automated tests for high availability, leader election, load balancing, and backup/restore. It showcases **DevOps**, **distributed systems**, and **database** skills through detailed documentation, automation scripts, and a fintech scenario based on the **PayFast** app.

---

## 📖 Overview

CockroachDB is a cloud-native, distributed SQL database designed for **scalability**, **reliability**, and **strong consistency**—ideal for fintech applications.

### ✅ This project includes:

- 📦 Deployment of a **3-pod CockroachDB cluster** on **RHEL 9.6** using **k3s**
- 🧪 Automated tests for:
  - High Availability (HA)
  - Leader Election
  - Load Balancing
  - Backup and Restore
- 📘 Explanation of **CockroachDB core concepts** (nodes, ranges, Raft, gossip) with **PayFast** examples

---

## 📁 Contents

- `docs/intro.md` — **Introduction to CockroachDB** & fintech relevance  
- `docs/architecture.md` — **Architecture & Core Concepts** with PayFast  
- `docs/deployment-guide.md` — **Step-by-step deployment on RHEL 9.6 (k3s)**  
- `docs/ha-test.md` — **High Availability test**  
- `docs/leader-election-test.md` — **Leader Election test**  
- `docs/load-balancing-test.md` — **Load Balancing test**  
- `docs/backup-restore.md` — **Backup and Restore test**  
- `scripts/` — Shell scripts for automation  
- `k8s/` — Kubernetes manifests for the 3-pod cluster  
- `docs/diagrams/` — Architecture diagrams and Admin UI screenshots  

---

## ⚙️ Setup

### 1. Clone the Repository

```bash
git clone https://github.com/[Your-GitHub-Username]/cockroachdb-fintech-demo
cd cockroachdb-fintech-demo
```

### 2. Deploy the Cluster

```bash
./scripts/deploy-cockroachdb.sh
```

### 3. Access the CockroachDB Admin UI

```bash
kubectl port-forward svc/cockroachdb-public -n cockroachdb 8080:8080
```

Then open [http://localhost:8080](http://localhost:8080) in your browser.

---

## 🚀 Running Tests

```bash
./scripts/ha-test.sh               # High Availability
./scripts/leader-election-test.sh  # Leader Election
./scripts/load-test.sh             # Load Balancing
./scripts/backup-restore.sh        # Backup and Restore
./scripts/cleanup.sh               # Cleanup/reset environment
```

---

## 🖼️ Visuals

- **Cluster Architecture:** `docs/diagrams/cluster-architecture.png`  
- **Raft Consensus:** `docs/diagrams/raft-consensus.png`  
- **Admin UI Screenshots:** `docs/diagrams/admin-ui-screenshots/`

---

## 🧰 Prerequisites

- RHEL 9.6 VM (minimum 3 vCPUs, 8GB RAM)
- Root/sudo privileges
- Internet access

---

## 🤝 Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for contribution guidelines.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
